'use strict';

const config = require('./config');

class DeepSeekError extends Error {
  constructor(message, { status, body } = {}) {
    super(message);
    this.name = 'DeepSeekError';
    this.status = status;
    this.body = body;
  }
}

async function chat({ messages, jsonMode = false, temperature = 0.2, maxTokens = 800 }) {
  const url = `${config.deepseek.baseUrl.replace(/\/$/, '')}/chat/completions`;

  const body = {
    model: config.deepseek.model,
    messages,
    temperature,
    max_tokens: maxTokens,
  };
  if (jsonMode) {
    body.response_format = { type: 'json_object' };
  }

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 30000);

  let resp;
  try {
    resp = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${config.deepseek.apiKey}`,
      },
      body: JSON.stringify(body),
      signal: controller.signal,
    });
  } catch (err) {
    clearTimeout(timeout);
    throw new DeepSeekError(`network: ${err.message}`);
  }
  clearTimeout(timeout);

  const text = await resp.text();
  if (!resp.ok) {
    throw new DeepSeekError(`status ${resp.status}`, { status: resp.status, body: text.slice(0, 1000) });
  }

  let data;
  try { data = JSON.parse(text); }
  catch (e) { throw new DeepSeekError('invalid JSON from DeepSeek', { body: text.slice(0, 500) }); }

  const content = data && data.choices && data.choices[0] && data.choices[0].message
    ? data.choices[0].message.content || ''
    : '';

  return { content, usage: data && data.usage };
}

module.exports = { chat, DeepSeekError };
