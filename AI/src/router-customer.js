'use strict';

const customerSkills = require('./skills/customer');
const { chat } = require('./deepseek');
const { buildCustomerRouterMessages } = require('./prompts-customer');

function safeParse(jsonText) {
  try {
    return { ok: true, value: JSON.parse(jsonText) };
  } catch (e) {
    return { ok: false, error: e.message };
  }
}

async function pickCustomerSkill({ question }) {
  const messages = buildCustomerRouterMessages({
    skillCatalog: customerSkills.listForRouter(),
    question,
  });
  const { content } = await chat({ messages, jsonMode: true, temperature: 0, maxTokens: 300 });
  const parsed = safeParse(content);
  if (!parsed.ok) {
    return { skill: 'none', params: {}, reason: 'router_invalid_json', raw: content };
  }
  const v = parsed.value || {};
  const name = String(v.skill || 'none');
  const skill = customerSkills.get(name);
  if (!skill) {
    return { skill: 'none', params: {}, reason: v.reason || 'unknown_skill' };
  }
  const params = (v.params && typeof v.params === 'object') ? v.params : {};
  return { skill: name, params, reason: String(v.reason || '').slice(0, 200) };
}

module.exports = { pickCustomerSkill };
