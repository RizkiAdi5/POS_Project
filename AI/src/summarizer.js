'use strict';

const { chat } = require('./deepseek');
const { buildSummarizerMessages } = require('./prompts');

async function summarize({ question, skill, facts, dts, role }) {
  const messages = buildSummarizerMessages({ question, skill, facts, dts, role });
  const { content, usage } = await chat({ messages, jsonMode: false, temperature: 0.3, maxTokens: 1400 });
  return { answer_markdown: content || '', usage };
}

module.exports = { summarize };
