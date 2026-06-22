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
const { runWrite } = require('./db');
const { createExportOffer, generateExcelForToken } = require('./export');
const { isExportable } = require('./export/build-workbook');
const { isExportRequest } = require('./util/export-request');

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

async function runSkillCached({ dts, skillName, params }) {
  const skill = skills.get(skillName);
  if (!skill) throw new Error(`unknown_skill:${skillName}`);
  const cacheKey = cache.makeKey(['skill', dts, skill.name, params]);
  let facts = cache.get(cacheKey);
  let cached = !!facts;
  if (!facts) {
    facts = await skill.run({ dts, params: params || {} });
    cache.set(cacheKey, facts, skill.cacheTtlSec);
  }
  facts = await withCurrency(dts, facts);
  return { skill, facts, cached };
}

async function buildExportChatResponse({ dts, user, skillName, params, facts, cached, question, t0 }) {
  const exportOffer = createExportOffer({
    dts,
    user: String(user || ''),
    skill: skillName,
    params: params || {},
    facts,
    question,
  });
  if (!exportOffer) {
    return null;
  }
  const title = exportOffer.title || skillName;
  return {
    ok: true,
    skill_used: skillName,
    params: params || {},
    facts,
    answer_markdown:
      `Here is your Excel download for **${title}**. Use the button below — the link expires in about 20 minutes.`,
    export: exportOffer,
    followups: [],
    cached,
    latency_ms: Date.now() - t0,
  };
}

app.post('/dashboard/alerts', authMiddleware, async (req, res) => {
  const t0 = Date.now();
  const { dts, user, role } = req.body || {};

  if (!checkDts(dts)) {
    return res.status(400).json({ error: 'dts_not_allowed', allowed: config.db.allowedDts });
  }
  if (!checkAdminRole(role)) {
    return res.status(403).json({ error: 'role_not_allowed' });
  }

  try {
    const { facts, cached } = await runSkillCached({ dts, skillName: 'detect_anomalies', params: {} });
    res.json({
      ok: true,
      alerts: facts.alerts || [],
      alert_count: facts.alert_count || 0,
      cached,
      latency_ms: Date.now() - t0,
    });
  } catch (e) {
    logEvent({ kind: 'dashboard_alerts_error', user, dts, error: e.message });
    return res.status(500).json({ error: 'alerts_failed', detail: e.message });
  }
});

app.post('/dashboard/briefing', authMiddleware, async (req, res) => {
  const t0 = Date.now();
  const { dts, user, role } = req.body || {};

  if (!checkDts(dts)) {
    return res.status(400).json({ error: 'dts_not_allowed', allowed: config.db.allowedDts });
  }
  if (!checkAdminRole(role)) {
    return res.status(403).json({ error: 'role_not_allowed' });
  }

  try {
    const briefingRun = await runSkillCached({ dts, skillName: 'daily_briefing', params: {} });
    const anomalyRun = await runSkillCached({ dts, skillName: 'detect_anomalies', params: {} });

    const mergedFacts = {
      ...briefingRun.facts,
      active_alerts: anomalyRun.facts.alerts || [],
      alert_count: anomalyRun.facts.alert_count || 0,
    };

    const answer = await summarize({
      question: 'Daily business briefing for the overview dashboard.',
      skill: 'daily_briefing',
      facts: mergedFacts,
      dts,
      role,
      mode: 'briefing',
    });

    const out = {
      ok: true,
      briefing_markdown: answer.answer_markdown,
      alerts: anomalyRun.facts.alerts || [],
      alert_count: anomalyRun.facts.alert_count || 0,
      cached: briefingRun.cached && anomalyRun.cached,
      latency_ms: Date.now() - t0,
    };

    logEvent({ kind: 'dashboard_briefing', user, dts, alert_count: out.alert_count, cached: out.cached, latency_ms: out.latency_ms });
    res.json(out);
  } catch (e) {
    logEvent({ kind: 'dashboard_briefing_error', user, dts, error: e.message });
    return res.status(500).json({ error: 'briefing_failed', detail: e.message });
  }
});

app.post('/dashboard/executive', authMiddleware, async (req, res) => {
  const t0 = Date.now();
  const { dts, user, role } = req.body || {};

  if (!checkDts(dts)) {
    return res.status(400).json({ error: 'dts_not_allowed', allowed: config.db.allowedDts });
  }
  if (!checkAdminRole(role)) {
    return res.status(403).json({ error: 'role_not_allowed' });
  }

  try {
    const { skill, facts, cached } = await runSkillCached({ dts, skillName: 'weekly_executive_brief', params: {} });

    const answer = await summarize({
      question: 'Weekly executive brief for the overview dashboard.',
      skill: skill.name,
      facts,
      dts,
      role,
      mode: 'executive',
    });

    const exportOffer = createExportOffer({
      dts,
      user: String(user || ''),
      skill: skill.name,
      params: {},
      facts,
      question: 'Weekly executive brief',
    });

    const out = {
      ok: true,
      answer_markdown: answer.answer_markdown,
      alert_count: facts.alert_count || 0,
      alerts: facts.active_alerts || [],
      cached,
      latency_ms: Date.now() - t0,
    };
    if (exportOffer) out.export = exportOffer;

    logEvent({ kind: 'dashboard_executive', user, dts, cached, latency_ms: out.latency_ms });
    res.json(out);
  } catch (e) {
    logEvent({ kind: 'dashboard_executive_error', user, dts, error: e.message });
    return res.status(500).json({ error: 'executive_failed', detail: e.message });
  }
});

app.post('/chat', authMiddleware, async (req, res) => {
  const t0 = Date.now();
  const { question, dts, user, role, force_skill, force_params, context } = req.body || {};

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
  const safeContext = (context && typeof context === 'object') ? context : {};
  const lastSkill = typeof safeContext.last_skill === 'string' ? safeContext.last_skill.trim() : '';
  const lastParams = (safeContext.last_params && typeof safeContext.last_params === 'object')
    ? safeContext.last_params
    : {};

  if (isExportRequest(safeQuestion) && lastSkill && skills.get(lastSkill) && isExportable(lastSkill)) {
    try {
      const { facts, cached } = await runSkillCached({ dts, skillName: lastSkill, params: lastParams });
      const exportResponse = await buildExportChatResponse({
        dts,
        user,
        skillName: lastSkill,
        params: lastParams,
        facts,
        cached,
        question: safeQuestion,
        t0,
      });
      if (exportResponse) {
        logEvent({
          kind: 'chat_export',
          user,
          dts,
          question: safeQuestion,
          skill: lastSkill,
          params: lastParams,
          cached,
          latency_ms: exportResponse.latency_ms,
        });
        return res.json(exportResponse);
      }
    } catch (e) {
      logEvent({ kind: 'export_context_error', user, dts, skill: lastSkill, error: e.message });
    }
  }

  let routed;
  const forcedName = typeof force_skill === 'string' ? force_skill.trim() : '';
  if (forcedName && skills.get(forcedName)) {
    routed = {
      skill: forcedName,
      params: (force_params && typeof force_params === 'object') ? force_params : {},
      reason: 'forced_by_ui',
    };
  } else {
    try {
      routed = await pickSkill({ question: safeQuestion });
    } catch (e) {
      const detail = e && e.message ? e.message : 'unknown';
      const upstream = e && e.body ? String(e.body).slice(0, 400) : null;
      logEvent({ kind: 'router_error', user, dts, error: detail, upstream });
      return res.status(502).json({ error: 'router_failed', detail, upstream });
    }
  }

  if (routed.skill === 'none') {
    const msg = "I can answer questions about e-menu sales, orders, menu items, customers, tables, and forecasts for next week. Pick one of the suggestions below or rephrase your question.";
    logEvent({ kind: 'no_skill', user, dts, question: safeQuestion, reason: routed.reason });
    return res.json({
      ok: true,
      skill_used: 'none',
      params: {},
      facts: null,
      answer_markdown: msg,
      followups: [
        { label: 'Peak hours next week', question: 'What peak ordering hours should we expect next week and when should we add staff?' },
        { label: 'Next week sales', question: 'What e-menu revenue and order count should we expect next week?' },
        { label: 'Sales today', question: 'What is the e-menu sales today?' },
        { label: 'Top items this month', question: 'Top 10 menu items this month.' },
        { label: 'Compare weeks', question: 'Compare this week vs last week.' },
        { label: 'Busiest days', question: 'Which days next week are likely to be busiest for e-menu orders?' },
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

  if (isExportRequest(safeQuestion) && isExportable(skill.name)) {
    const exportResponse = await buildExportChatResponse({
      dts,
      user,
      skillName: skill.name,
      params: routed.params,
      facts,
      cached,
      question: safeQuestion,
      t0,
    });
    if (exportResponse) {
      logEvent({
        kind: 'chat_export',
        user,
        dts,
        question: safeQuestion,
        skill: skill.name,
        params: routed.params,
        cached,
        latency_ms: exportResponse.latency_ms,
      });
      return res.json(exportResponse);
    }
  }

  let answer;
  const summarizeMode = skill.name === 'daily_briefing' ? 'briefing'
    : (skill.name === 'weekly_executive_brief' ? 'executive' : undefined);
  try {
    answer = await summarize({ question: safeQuestion, skill: skill.name, facts, dts, role, mode: summarizeMode });
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

app.post('/xendit/disburse', authMiddleware, async (req, res) => {
  const xenditKey = process.env.XENDIT_SECRET_KEY || '';
  if (!xenditKey) {
    return res.status(500).json({ error: 'XENDIT_SECRET_KEY not configured' });
  }

  // CF10 uppercases JSON keys — normalise
  const body = {};
  for (const [k, v] of Object.entries(req.body || {})) body[k.toLowerCase()] = v;
  const { dts, order_id, gross_amount } = body;

  if (!dts || !order_id || !gross_amount) {
    return res.status(400).json({ error: 'missing_required_fields' });
  }
  if (!checkDts(dts)) {
    return res.status(400).json({ error: 'dts_not_allowed' });
  }

  try {
    // Look up client's bank account and fee config (cross-schema: main.*)
    const accounts = await db.runQuery(dts,
      'SELECT bank_code, account_number, account_name, platform_fee_pct, absorb_gateway_fee FROM main.client_payment_accounts WHERE dts = ? AND is_active = 1 LIMIT 1',
      [dts]
    );
    if (!accounts.length) {
      return res.status(404).json({ error: 'no_bank_account_registered', dts });
    }
    const acct = accounts[0];

    // Fee calculation — Xendit disbursement flat fee IDR 5,000
    const XENDIT_DISBURSE_FEE = 5000;
    const gross = parseFloat(gross_amount);
    const platformFee = Math.round(gross * (parseFloat(acct.platform_fee_pct) / 100));
    const xenditFee = acct.absorb_gateway_fee ? XENDIT_DISBURSE_FEE : 0;
    const disburseAmount = Math.round(gross - platformFee - xenditFee);

    if (disburseAmount <= 0) {
      return res.status(422).json({ error: 'disburse_amount_too_low', disburse_amount: disburseAmount });
    }

    const externalId = `DSB-${dts}-${order_id}-${Date.now()}`;

    // Insert pending disbursement record
    const ins = await runWrite(dts,
      `INSERT INTO main.disbursements
        (dts, order_id, gross_amount, platform_fee, xendit_fee, disburse_amount, status)
       VALUES (?, ?, ?, ?, ?, ?, 'pending')`,
      [dts, order_id, gross, platformFee, xenditFee, disburseAmount]
    );
    const disbursementId = ins.insertId;

    // Call Xendit Disbursement API
    let xenditDisbId = null;
    let finalStatus = 'pending';
    try {
      const xenditRes = await fetch('https://api.xendit.co/disbursements', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ' + Buffer.from(`${xenditKey}:`).toString('base64'),
        },
        body: JSON.stringify({
          external_id: externalId,
          bank_code: acct.bank_code,
          account_holder_name: acct.account_name,
          account_number: acct.account_number,
          description: `Order disbursement ${order_id} for ${dts}`,
          amount: disburseAmount,
        }),
      });
      const xenditData = await xenditRes.json();
      if (xenditRes.ok && xenditData.id) {
        xenditDisbId = xenditData.id;
        finalStatus = xenditData.status ? xenditData.status.toLowerCase() : 'pending';
      } else {
        finalStatus = 'failed';
        logEvent({ kind: 'disburse_xendit_error', dts, order_id, http_status: xenditRes.status, body: JSON.stringify(xenditData).slice(0, 400) });
      }
    } catch (fetchErr) {
      finalStatus = 'failed';
      logEvent({ kind: 'disburse_fetch_error', dts, order_id, error: fetchErr.message });
    }

    // Update disbursement record with Xendit response
    await runWrite(dts,
      'UPDATE main.disbursements SET xendit_disburse_id = ?, status = ? WHERE id = ?',
      [xenditDisbId, finalStatus, disbursementId]
    );

    return res.json({
      ok: finalStatus !== 'failed',
      disbursement_id: disbursementId,
      xendit_disburse_id: xenditDisbId,
      status: finalStatus,
      gross_amount: gross,
      platform_fee: platformFee,
      xendit_fee: xenditFee,
      disburse_amount: disburseAmount,
    });

  } catch (err) {
    logEvent({ kind: 'disburse_error', dts, order_id, error: err.message });
    return res.status(500).json({ error: 'disburse_failed', detail: err.message });
  }
});

app.post('/xendit/invoice', authMiddleware, async (req, res) => {
  const xenditKey = process.env.XENDIT_SECRET_KEY || '';
  if (!xenditKey) {
    return res.status(500).json({ error: 'XENDIT_SECRET_KEY not configured' });
  }
  // CF10 serializes struct keys as UPPERCASE — normalise to lowercase
  const body = {};
  for (const [k, v] of Object.entries(req.body || {})) body[k.toLowerCase()] = v;
  const { external_id, amount, description, currency, success_redirect_url, failure_redirect_url } = body;
  if (!external_id || !amount) {
    return res.status(400).json({ error: 'missing_required_fields' });
  }
  try {
    const xenditRes = await fetch('https://api.xendit.co/v2/invoices', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + Buffer.from(`${xenditKey}:`).toString('base64'),
      },
      body: JSON.stringify({ external_id, amount, description, currency, success_redirect_url, failure_redirect_url }),
    });
    const data = await xenditRes.json();
    res.status(xenditRes.status).json(data);
  } catch (err) {
    res.status(502).json({ error: 'xendit_unreachable', detail: err.message });
  }
});

app.post('/xendit/disburse-batch', authMiddleware, async (req, res) => {
  const xenditKey = process.env.XENDIT_SECRET_KEY || '';
  if (!xenditKey) {
    return res.status(500).json({ error: 'XENDIT_SECRET_KEY not configured' });
  }
  const body = {};
  for (const [k, v] of Object.entries(req.body || {})) body[k.toLowerCase()] = v;
  const { dts, batch_id, amount, bank_code, account_number, account_name } = body;
  if (!dts || !batch_id || !amount || !bank_code || !account_number || !account_name) {
    return res.status(400).json({ error: 'missing_required_fields' });
  }
  if (!checkDts(dts)) {
    return res.status(400).json({ error: 'dts_not_allowed' });
  }
  const externalId = `BATCH-${dts}-${batch_id}-${Date.now()}`;
  try {
    const xenditRes = await fetch('https://api.xendit.co/disbursements', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + Buffer.from(`${xenditKey}:`).toString('base64'),
      },
      body: JSON.stringify({
        external_id:          externalId,
        bank_code:            bank_code,
        account_holder_name:  account_name,
        account_number:       account_number,
        description:          `Batch payout ${batch_id} for ${dts}`,
        amount:               Math.round(parseFloat(amount)),
      }),
    });
    const data = await xenditRes.json();
    if (xenditRes.ok && data.id) {
      logEvent({ kind: 'disburse_batch_ok', dts, batch_id, xendit_id: data.id, amount });
      return res.json({
        ok:                 true,
        xendit_disburse_id: data.id,
        status:             (data.status || 'PENDING').toLowerCase(),
      });
    }
    logEvent({ kind: 'disburse_batch_xendit_error', dts, batch_id, http_status: xenditRes.status, body: JSON.stringify(data).slice(0, 400) });
    return res.status(xenditRes.status || 502).json({ ok: false, error: 'xendit_rejected', detail: data });
  } catch (err) {
    logEvent({ kind: 'disburse_batch_error', dts, batch_id, error: err.message });
    return res.status(500).json({ error: 'disburse_batch_failed', detail: err.message });
  }
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
