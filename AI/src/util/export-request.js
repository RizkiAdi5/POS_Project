'use strict';

const EXPORT_WORDS = /\b(excel|xlsx|spreadsheet|workbook|csv|download|export)\b/i;
const FILE_WORDS = /\b(file|report|data|sheet|spreadsheet|excel|xlsx|download|export)\b/i;

function isExportRequest(question) {
  const q = String(question || '').trim();
  if (!q) return false;
  return EXPORT_WORDS.test(q) || (FILE_WORDS.test(q) && /\b(give|send|get|provide|want|need|share)\b/i.test(q));
}

module.exports = { isExportRequest };
