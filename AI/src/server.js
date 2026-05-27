'use strict';

const fs = require('fs');
const path = require('path');
const express = require('express');

const config = require('./config');
const db = require('./db');
const skills = require('./skills');
const customerSkills = require('./skills/customer');
const { authMiddleware, checkDts, checkAdminRole, checkCustomerRole } = require('./auth');
const { pickSkill } = require('./router');
const { pickCustomerSkill } = require('./router-customer');
const { summarize } = require('./summarizer');
const { summarizeCustomer } = require('./summarizer-customer');
const cache = require('./util/cache');
const { withCurrency } = require('./util/currency');
const { createExportOffer, generateExcelForToken } = require('./export');

const app = express();
app.use(express.json({ limit: '64kb' }));

const logDir = path.isAbsolute(config.logging.dir)
  ? config.logging.dir
  : path.join(__dirname, '..', config.logging.dir);
try { fs.mkdirSync(logDir, { recursive: true }); } catch (_) {}
const logPath = path.join(logDir, 'conversations.jsonl');

function logEvent(obj) {
  try {
    fs.appendFile(logPath, JSON.stringify({ ts: new Date().toISOString(), ...obj }) + '\n', () => {});
  } catch (_) {}
}

app.get('/health', async (_req, res) => {
  res.json({ ok: true, skills: skills.ALL.map((s) => s.name), allowed_dts: config.db.allowedDts });
});

app.get('/skills', authMiddleware, (_req, res) => {
  res.json({ skills: skills.listForRouter() });
});

app.post('/chat', authMiddleware, async (req, res) => {
  const t0 = Date.now();
  const { question, dts, user, role } = req.body || {};

  if (typeof question !== 'string' || !question.trim()) {
    return res.status(400).json({ error: 'question_required' });
  }
  if (!checkDts(dts)) {
    return res.status(400).json({ error: 'dts_not_allowed', allowed: config.db.allowedDts });
  }
  if (!checkAdminRole(role)) {
    return res.status(403).json({ error: 'role_not_allowed' });
  }

  const safeQuestion = String(question).slice(0, 2000);

  let routed;
  try {
    routed = await pickSkill({ question: safeQuestion });
  } catch (e) {
    const detail = e && e.message ? e.message : 'unknown';
    const upstream = e && e.body ? String(e.body).slice(0, 400) : null;
    logEvent({ kind: 'router_error', user, dts, error: detail, upstream });
    return res.status(502).json({ error: 'router_failed', detail, upstream });
  }

  if (routed.skill === 'none') {
    const msg = "I can answer questions about e-menu sales, orders, menu items, customers, and tables. Pick one of the suggestions below or rephrase your question.";
    logEvent({ kind: 'no_skill', user, dts, question: safeQuestion, reason: routed.reason });
    return res.json({
      ok: true,
      skill_used: 'none',
      params: {},
      facts: null,
      answer_markdown: msg,
      followups: [
        { label: 'Sales today', question: 'What is the e-menu sales today?' },
        { label: 'Top items this month', question: 'Top 10 menu items this month.' },
        { label: 'Compare weeks', question: 'Compare this week vs last week.' },
        { label: 'Cancellations', question: 'Cancellations in the last 7 days.' },
        { label: 'Peak hours', question: 'Peak ordering hours in the last 14 days.' },
        { label: 'Tables status', question: 'What is the current status of all tables?' },
      ],
      latency_ms: Date.now() - t0,
    });
  }

  const skill = skills.get(routed.skill);
  const cacheKey = cache.makeKey(['skill', dts, skill.name, routed.params]);
  let facts = cache.get(cacheKey);
  let cached = !!facts;

  if (!facts) {
    try {
      facts = await skill.run({ dts, params: routed.params });
      cache.set(cacheKey, facts, skill.cacheTtlSec);
    } catch (e) {
      logEvent({ kind: 'skill_error', user, dts, skill: skill.name, error: e.message });
      return res.status(500).json({ error: 'skill_failed', skill: skill.name, detail: e.message });
    }
  }

  facts = await withCurrency(dts, facts);

  let answer;
  try {
    answer = await summarize({ question: safeQuestion, skill: skill.name, facts, dts, role });
  } catch (e) {
    const detail = e && e.message ? e.message : 'unknown';
    const upstream = e && e.body ? String(e.body).slice(0, 400) : null;
    logEvent({ kind: 'summarizer_error', user, dts, skill: skill.name, error: detail, upstream });
    return res.status(502).json({ error: 'summarizer_failed', detail, upstream });
  }

  const out = {
    ok: true,
    skill_used: skill.name,
    params: routed.params,
    facts,
    answer_markdown: answer.answer_markdown,
    followups: Array.isArray(skill.followups) ? skill.followups.slice(0, 4) : [],
    cached,
    latency_ms: Date.now() - t0,
  };

  const exportOffer = createExportOffer({
    dts,
    user: String(user || ''),
    skill: skill.name,
    params: routed.params,
    facts,
    question: safeQuestion,
  });
  if (exportOffer) {
    out.export = exportOffer;
  }

  logEvent({
    kind: 'chat',
    user,
    dts,
    role,
    question: safeQuestion,
    skill: skill.name,
    params: routed.params,
    cached,
    latency_ms: out.latency_ms,
  });

  res.json(out);
});

app.get('/export/excel', authMiddleware, async (req, res) => {
  const token = String(req.query.token || '').trim();
  const user = String(req.query.user || '').trim();
  const role = String(req.query.role || '').trim();

  if (!token) {
    return res.status(400).json({ error: 'token_required' });
  }
  if (!checkAdminRole(role)) {
    return res.status(403).json({ error: 'role_not_allowed' });
  }

  try {
    const { buffer, filename, contentType } = await generateExcelForToken(token, user);
    res.setHeader('Content-Type', contentType);
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    res.send(Buffer.from(buffer));
  } catch (e) {
    const status = e.status || 500;
    const detail = e.message || 'export_failed';
    logEvent({ kind: 'export_error', user, token: token.slice(0, 8), error: detail });
    return res.status(status).json({ error: detail });
  }
});

const CUSTOMER_NO_SKILL_MSG =
  'I can help with the menu, recommendations, your order status, and how to pay. Pick a suggestion below or ask in your own words.';

const CUSTOMER_FOLLOWUPS = [
  { label: 'Budget dishes', question: 'What affordable dishes are on the menu?' },
  { label: 'Opening hours', question: 'What are the restaurant opening hours?' },
  { label: 'No nuts', question: 'I am allergic to nuts — what can I eat?' },
  { label: 'My order', question: 'Where is my order right now?' },
  { label: 'Popular dishes', question: 'What are the most popular dishes right now?' },
  { label: 'How to pay', question: 'How do I pay my bill?' },
];

app.post('/chat/customer', authMiddleware, async (req, res) => {
  const t0 = Date.now();
  const { question, dts, user, role, context } = req.body || {};

  if (typeof question !== 'string' || !question.trim()) {
    return res.status(400).json({ error: 'question_required' });
  }
  if (!checkDts(dts)) {
    return res.status(400).json({ error: 'dts_not_allowed', allowed: config.db.allowedDts });
  }
  if (!checkCustomerRole(role)) {
    return res.status(403).json({ error: 'role_not_allowed' });
  }

  const safeQuestion = String(question).slice(0, 2000);
  const safeContext = (context && typeof context === 'object') ? context : {};

  let routed;
  try {
    routed = await pickCustomerSkill({ question: safeQuestion });
  } catch (e) {
    const detail = e && e.message ? e.message : 'unknown';
    logEvent({ kind: 'customer_router_error', user, dts, error: detail });
    return res.status(502).json({ error: 'router_failed', detail });
  }

  if (routed.skill === 'none') {
    logEvent({ kind: 'customer_no_skill', user, dts, question: safeQuestion, reason: routed.reason });
    return res.json({
      ok: true,
      skill_used: 'none',
      params: {},
      facts: null,
      answer_markdown: CUSTOMER_NO_SKILL_MSG,
      followups: CUSTOMER_FOLLOWUPS,
      latency_ms: Date.now() - t0,
    });
  }

  const skill = customerSkills.get(routed.skill);
  const cacheKey = cache.makeKey(['customer', dts, skill.name, routed.params, safeContext.order_id || 0]);
  let facts = cache.get(cacheKey);
  let cached = !!facts;

  if (!facts) {
    try {
      facts = await skill.run({ dts, params: routed.params, context: safeContext });
      cache.set(cacheKey, facts, skill.cacheTtlSec);
    } catch (e) {
      logEvent({ kind: 'customer_skill_error', user, dts, skill: skill.name, error: e.message });
      return res.status(500).json({ error: 'skill_failed', skill: skill.name, detail: e.message });
    }
  }

  let answer;
  try {
    answer = await summarizeCustomer({
      question: safeQuestion,
      skill: skill.name,
      facts,
      dts,
      context: safeContext,
    });
  } catch (e) {
    const detail = e && e.message ? e.message : 'unknown';
    logEvent({ kind: 'customer_summarizer_error', user, dts, skill: skill.name, error: detail });
    return res.status(502).json({ error: 'summarizer_failed', detail });
  }

  const out = {
    ok: true,
    skill_used: skill.name,
    params: routed.params,
    facts,
    answer_markdown: answer.answer_markdown,
    followups: Array.isArray(skill.followups) ? skill.followups.slice(0, 4) : [],
    cached,
    latency_ms: Date.now() - t0,
  };

  logEvent({
    kind: 'customer_chat',
    user,
    dts,
    role,
    question: safeQuestion,
    skill: skill.name,
    order_id: safeContext.order_id || null,
    cached,
    latency_ms: out.latency_ms,
  });

  res.json(out);
});

app.use((err, _req, res, _next) => {
  // eslint-disable-next-line no-console
  console.error('unhandled', err);
  res.status(500).json({ error: 'internal' });
});

const server = app.listen(config.http.port, config.http.host, () => {
  // eslint-disable-next-line no-console
  console.log(`AI Business Analyst listening on http://${config.http.host}:${config.http.port}`);
});

function shutdown() {
  // eslint-disable-next-line no-console
  console.log('shutting down...');
  server.close(async () => {
    await db.shutdown();
    process.exit(0);
  });
  setTimeout(() => process.exit(0), 5000).unref();
}
process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
