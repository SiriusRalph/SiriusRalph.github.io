// =========================================================
//  Turns data/sara.sql into a short summary for the AI:
//  every CREATE TABLE (with its comments) + the short values
//  that are useful in a WHERE (tags, tools, companies…).
//  Short = fewer tokens = more free questions per day.
// =========================================================

const MAX_VALUE = 80; // longer texts (descriptions) are left out

export function buildSchema(sqlText) {
  const creates = sqlText.match(/CREATE TABLE[\s\S]*?\n\);/g) || [];
  const columns = {};
  for (const c of creates) {
    const table = c.match(/CREATE TABLE (\w+)/)[1];
    columns[table] = [...c.matchAll(/^\s+(\w+)\s+(?:INTEGER|TEXT)/gm)].map((m) => m[1]);
  }

  // collect the values of every INSERT, column by column
  const values = {};
  for (const m of sqlText.matchAll(/INSERT INTO (\w+)\s*(\(([^)]*)\))?\s*VALUES([\s\S]*?\));\s*$/gm)) {
    const table = m[1];
    const cols = m[3] ? m[3].split(',').map((s) => s.trim()) : columns[table];
    for (const row of tuples(m[4])) {
      row.forEach((v, i) => {
        const col = cols[i];
        if (!col || typeof v !== 'string') return;
        ((values[table] ??= {})[col] ??= new Set()).add(v);
      });
    }
  }

  const hints = [];
  for (const [table, cols] of Object.entries(values)) {
    for (const [col, set] of Object.entries(cols)) {
      const list = [...set];
      if (col.endsWith('_fr') || list.some((v) => v.length > MAX_VALUE)) continue;
      hints.push(`${table}.${col}: ${list.map((v) => JSON.stringify(v)).join(', ')}`);
    }
  }

  const alters = sqlText.match(/^ALTER TABLE .*;$/gm) || [];
  return `${creates.join('\n\n')}\n${alters.join('\n')}\n\n-- Values stored in the short columns (the _fr columns hold the French versions):\n${hints.join('\n')}`;
}

// "(1, 'a', 'it''s', NULL), (2, …)"  ->  [[1, 'a', "it's", null], [2, …]]
function tuples(text) {
  const rows = [];
  let row = null, i = 0;
  while (i < text.length) {
    const ch = text[i];
    if (ch === '(' && !row) { row = []; i++; }
    else if (ch === ')' && row) { rows.push(row); row = null; i++; }
    else if (ch === "'" && row) {
      let s = '';
      i++;
      while (i < text.length) {
        if (text[i] === "'" && text[i + 1] === "'") { s += "'"; i += 2; }
        else if (text[i] === "'") { i++; break; }
        else s += text[i++];
      }
      row.push(s);
    } else if (row && /[\dN-]/.test(ch)) {
      const tok = text.slice(i).match(/^(-?\d+(?:\.\d+)?|NULL)/);
      if (tok) { row.push(tok[1] === 'NULL' ? null : Number(tok[1])); i += tok[1].length; } else i++;
    } else i++;
  }
  return rows;
}
