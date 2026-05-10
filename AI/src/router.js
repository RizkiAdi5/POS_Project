'use strict';

const skills = require('./skills');
const { chat } = require('./deepseek');
const { buildRouterMessages } = require('./prompts');

function safeParse(jsonText) {
  try {
    return { ok: true, value: JSON.parse(jsonText) };
  } catch (e) {
    return { ok: false, error: e.message };
  }
}

async function pickSkill({ question }) {
  const messages = buildRouterMessages({
    skillCatalog: skills.listForRouter(),
    question,
  });
  const { content } = await chat({ messages, jsonMode: true, temperature: 0, maxTokens: 300 });
  const parsed = safeParse(content);
  if (!parsed.ok) {
    return { skill: 'none', params: {}, reason: 'router_invalid_json', raw: content };
  }
  const v = parsed.value || {};
  const name = String(v.skill || 'none');
  const skill = skills.get(name);
  if (!skill) {
    return { skill: 'none', params: {}, reason: v.reason || 'unknown_skill' };
  }
  const params = (v.params && typeof v.params === 'object') ? v.params : {};
  return { skill: name, params, reason: String(v.reason || '').slice(0, 200) };
}

module.exports = { pickSkill };
