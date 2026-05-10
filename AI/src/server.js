'use strict';

const fs = require('fs');
const path = require('path');
const express = require('express');

const config = require('./config');
const db = require('./db');
const skills = require('./skills');
const { authMiddleware, checkDts, checkRole } = require('./auth');
const { pickSkill } = require('./router');
const { summarize } = require('./summarizer');
const cache = require('./util/cache');

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
  if (!checkRole(role)) {
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
