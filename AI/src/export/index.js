'use strict';

const { createToken, getToken } = require('./store');
const {
  isExportable,
  buildExcelBuffer,
  exportFilename,
  exportTitle,
} = require('./build-workbook');

function createExportOffer({ dts, user, skill, params, facts, question }) {
  if (!isExportable(skill) || !facts || facts.empty) {
    return null;
  }
  const filename = exportFilename(skill, dts);
  const title = exportTitle(skill);
  const token = createToken({
    dts,
    user: String(user || ''),
    skill,
    params: params || {},
    facts,
    question: String(question || '').slice(0, 500),
    filename,
    title,
  });
  return {
    available: true,
    token,
    filename,
    label: `Download Excel (${filename})`,
    title,
  };
}

async function generateExcelForToken(token, requestUser) {
  const entry = getToken(token);
  if (!entry) {
    const err = new Error('export_token_invalid_or_expired');
    err.status = 404;
    throw err;
  }
  if (entry.user && requestUser && entry.user !== requestUser) {
    const err = new Error('export_forbidden');
    err.status = 403;
    throw err;
  }
  const buffer = await buildExcelBuffer(
    entry.dts,
    entry.skill,
    entry.params,
    entry.facts,
    {
      dts: entry.dts,
      question: entry.question,
      title: entry.title,
    },
  );
  return {
    buffer,
    filename: entry.filename,
    contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  };
}

module.exports = {
  createExportOffer,
  generateExcelForToken,
  isExportable,
};
