'use strict';

const { chat } = require('./deepseek');
const { buildCustomerSummarizerMessages } = require('./prompts-customer');

async function summarizeCustomer({ question, skill, facts, dts, context }) {
  const messages = buildCustomerSummarizerMessages({ question, skill, facts, dts, context });
  const { content, usage } = await chat({ messages, jsonMode: false, temperature: 0.4, maxTokens: 900 });
  return { answer_markdown: content || '', usage };
}

module.exports = { summarizeCustomer };
