// =========================================================
//  Query Sara · app logic
//  1. Load the SQL database (data/sara.sql) into the browser
//  2. Turn a question or a button into a SQL query
//  3. Run it and show the answer + a simple explanation
// =========================================================
(function () {
  'use strict';

  const SQL_LIB = 'lib/';
  const AI_URL = String(window.QUERY_SARA_AI || '').trim(); // set in js/config.js
  let db = null;
  let asking = 0; // number of the latest answer shown, so a slow AI reply can't replace a newer screen
  const state = { lang: 'en', theme: 'dark', dev: false, current: null };

  // ---------- small helpers ----------
  const $ = (s, r = document) => r.querySelector(s);
  const $$ = (s, r = document) => [...r.querySelectorAll(s)];
  const T = (k) => (I18N[state.lang][k] ?? I18N.en[k] ?? k);
  const fill = (s, o) => s.replace(/\{(\w+)\}/g, (m, k) => (o[k] ?? ''));
  const esc = (v) => String(v ?? '').replace(/[&<>"']/g, (c) =>
    ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  // pick the column in the current language: L(row, 'title') -> row.title_en or row.title_fr
  const L = (row, base) => row[`${base}_${state.lang}`] ?? row[`${base}_en`] ?? row[base] ?? '';

  // give each item in a list its position (--i) so the CSS can animate them one after another
  const stagger = (root = document) => $$('.chips, .cards, .schema-grid, .steps, .detail-grid, .stack, .cert-grid', root)
    .forEach((list) => [...list.children].forEach((el, i) => el.style.setProperty('--i', i)));

  // Run SQL and get back { columns, rows: [ {col: value} ] }
  function runSQL(sql) {
    const out = db.exec(sql);
    if (!out.length) return { columns: [], rows: [] };
    const { columns, values } = out[0];
    return { columns, rows: values.map((v) => Object.fromEntries(columns.map((c, i) => [c, v[i]]))) };
  }

  // ---------- the buttons ("presets") ----------
  const PRESETS = {
    why:        { sql: 'SELECT * FROM about_site;', view: 'about_site', label: 'chip_why' },
    profile:    { view: 'profile', label: 'chip_profile', sqls: ['SELECT * FROM profile;', 'SELECT * FROM soft_skills;'] },
    projects:   { sql: 'SELECT * FROM projects;', view: 'projects', label: 'chip_projects' },
    experience: { sql: 'SELECT * FROM internships ORDER BY start_date DESC;', view: 'internships', label: 'chip_experience' },
    education:  { sql: 'SELECT * FROM education;', view: 'education', label: 'chip_education' },
    skills:     { sql: 'SELECT * FROM skills;', view: 'skills', label: 'chip_skills' },
    certs:      { view: 'certs_page', label: 'chip_certs', sqls: ['SELECT * FROM certifications;', 'SELECT * FROM course_certificates ORDER BY completed DESC;'] },
    fun:        { sql: 'SELECT * FROM fun_facts;', view: 'fun_facts', label: 'chip_fun' },
    contact:    { sql: 'SELECT * FROM contact;', view: 'contact', label: 'chip_contact' }
  };
  const TABLE_TO_PRESET = {
    profile: 'profile', soft_skills: 'profile', about_site: 'why', course_certificates: 'certs',
    projects: 'projects', project_details: 'projects', project_stack: 'projects',
    internships: 'experience', education: 'education', skills: 'skills',
    certifications: 'certs', fun_facts: 'fun', contact: 'contact'
  };

  // Clickable rows that open a detail page. Each kind = a main table, a detail table, a stack table.
  const DETAIL = {
    project: {
      table: 'projects', details: 'project_details', stack: 'project_stack', key: 'project_id',
      order: 'id', back: 'projects', backLabel: 'back_projects', navLabel: 'project_nav',
      prevLabel: 'prev_project', nextLabel: 'next_project', title: (r) => L(r, 'title'),
      // [title key, column, has simple/tech versions, extra class]
      sections: [['sec_problem', 'problem', true], ['sec_how', 'how', true], ['sec_value', 'value', true, 'd-value'], ['sec_status', 'status', false]]
    },
    internship: {
      table: 'internships', details: 'internship_details', stack: 'internship_stack', key: 'internship_id',
      order: 'start_date DESC', back: 'experience', backLabel: 'back_experience', navLabel: 'internship_nav',
      prevLabel: 'prev_internship', nextLabel: 'next_internship', title: (r) => r.company,
      sections: [['sec_company', 'about', false], ['sec_mission', 'mission', true], ['sec_work', 'work', true],
        ['sec_value', 'value', true, 'd-value'], ['sec_results', 'results', false]]
    }
  };

  // the query behind a detail page: the row + its detail card, then its tools
  function detailQuery(kind, id, mode = 'simple') {
    const d = DETAIL[kind];
    id = Number(id);
    return {
      view: 'detail', kind, id, mode,
      sqls: [
        `SELECT * FROM ${d.table} JOIN ${d.details} ON ${d.details}.${d.key} = ${d.table}.id WHERE ${d.table}.id = ${id};`,
        `SELECT * FROM ${d.stack} WHERE ${d.key} = ${id};`
      ]
    };
  }

  // ---------- question -> SQL (simple keyword rules; the AI comes later) ----------
  function questionToQuery(text) {
    const t = text.toLowerCase();
    if (/\b(drop|delete|truncate|supprime)/.test(t)) return { egg: true };
    if (/\bwhy\b.*\b(sql|database|db)\b|pourquoi.*\b(sql|base)|text.to.sql|how (does|did) (this|the|your) (site|portfolio|website)|comment (marche|fonctionne) (ce|le) site|can i break|casser/.test(t)) return { ...PRESETS.why };
    if (/who is|qui est|about (her|sara)|à propos|a propos|profil|introduce|présente|presente|looking for|cherche|recherche|dispon|available|availability|stage de fin|end.of.studies|soft.?skill|qualit|personalit|hire|recrut|embauch/.test(t)) return { ...PRESETS.profile };
    if (/etudafrik/.test(t)) return detailQuery('project', 4);
    if (/briefing/.test(t)) return detailQuery('project', 5);
    if (/\bbridges?\b|\bponts?\b|infrastructur|morandi/.test(t)) return detailQuery('project', 6);
    if (/royal|\bram\b/.test(t)) return detailQuery('internship', 2);
    if (/sigman/.test(t)) return detailQuery('internship', 1);
    if (/selenium|test/.test(t)) return { sql: "SELECT * FROM internships WHERE tools LIKE '%Selenium%';", view: 'internships' };
    if (/python/.test(t) && /intern|stage|exp|work|job/.test(t)) return { sql: "SELECT * FROM internships WHERE tools LIKE '%Python%';", view: 'internships' };
    if (/python/.test(t)) return { sql: "SELECT * FROM projects WHERE tags LIKE '%Python%';", view: 'projects' };
    if (/power ?bi|dax|bi\b|business intelligence|dashboard|tableau de bord/.test(t)) return { sql: "SELECT * FROM internships WHERE tools LIKE '%Power BI%';", view: 'internships' };
    if (/llm|agent|langgraph|langchain|chatbot|g[ée]n[ée]rative/.test(t)) return { sql: "SELECT * FROM projects WHERE tags LIKE '%LLM%';", view: 'projects' };
    if (/robot|earthquake|séisme|seisme|yolo|vision|capstone|pfe/.test(t)) return { sql: "SELECT * FROM projects WHERE tags LIKE '%Robotics%';", view: 'projects' };
    if (/iot|security|sécurité|securite|intrusion|hack|cyber/.test(t)) return { sql: "SELECT * FROM projects WHERE tags LIKE '%Security%';", view: 'projects' };
    if (/machine learning|\bml\b|model|modèle|modele/.test(t)) return { sql: "SELECT * FROM projects WHERE tags LIKE '%Machine learning%';", view: 'projects' };
    if (/react|web|site|platform|plateforme/.test(t)) return { sql: "SELECT * FROM projects WHERE tags LIKE '%React%';", view: 'projects' };
    if (/\b(ai|ia)\b|intelligence|artificial|artificielle/.test(t)) return { sql: "SELECT * FROM projects WHERE tags LIKE '%AI%';", view: 'projects' };
    if (/certif|coursera|ibm|oracle/.test(t)) return { ...PRESETS.certs };
    if (/stud|étud|etud|school|école|ecole|educat|formation|degree|diplôme|diplome|hestim|bac/.test(t)) return { ...PRESETS.education };
    if (/language|langue|speak|parle|french|english|arab/.test(t)) return { sql: "SELECT * FROM skills WHERE category_en = 'Languages';", view: 'skills' };
    if (/proj|built|construit|made|fait/.test(t)) return { ...PRESETS.projects };
    if (/exp|intern|stage|work|travail|job/.test(t)) return { ...PRESETS.experience };
    if (/skill|compét|compet|good at|fort|tools|outils|know|stack|tech/.test(t)) return { ...PRESETS.skills };
    if (/fun|anecdote|fact|hobby|secret|cach/.test(t)) return { ...PRESETS.fun };
    if (/contact|email|mail|linkedin|github|reach|joindre/.test(t)) return { ...PRESETS.contact };
    return null;
  }

  // ---------- preferences (remembered in this browser) ----------
  function loadPrefs() {
    try {
      const p = JSON.parse(localStorage.getItem('querySaraPrefs') || '{}');
      if (p.lang === 'en' || p.lang === 'fr') state.lang = p.lang;
      if (p.theme === 'dark' || p.theme === 'light') state.theme = p.theme;
      else if (window.matchMedia && matchMedia('(prefers-color-scheme: light)').matches) state.theme = 'light';
      if (!p.lang && (navigator.language || '').startsWith('fr')) state.lang = 'fr';
    } catch (e) { /* storage not available: use defaults */ }
  }
  function savePrefs() {
    try { localStorage.setItem('querySaraPrefs', JSON.stringify({ lang: state.lang, theme: state.theme })); } catch (e) { }
  }

  // ---------- theme & language ----------
  function applyTheme() {
    document.documentElement.dataset.theme = state.theme;
    $('#themeBtn').setAttribute('aria-label', T(state.theme === 'dark' ? 'to_light' : 'to_dark'));
  }

  function applyLang() {
    document.documentElement.lang = state.lang;
    $$('[data-i18n]').forEach((el) => { el.textContent = T(el.dataset.i18n); });
    $$('[data-i18n-placeholder]').forEach((el) => { el.placeholder = T(el.dataset.i18nPlaceholder); });
    $$('[data-i18n-aria]').forEach((el) => { el.setAttribute('aria-label', T(el.dataset.i18nAria)); });
    $$('[data-lang]').forEach((b) => b.setAttribute('aria-pressed', String(b.dataset.lang === state.lang)));
    $('#homeBtn').setAttribute('aria-label', T('home'));
    $('#cvLink').href = T('cv_file'); // English or French CV, following the language switch
    applyTheme();
    if (db) { renderSchema(); setStatus('online'); }
    if (state.current) renderAnswer();
  }

  function setStatus(s) {
    $('#statusText').textContent = T('status_' + s) + (s === 'online' && AI_URL ? T('status_ai') : '');
  }

  // ---------- the "What's inside my database" panel ----------
  // tables that only feed the detail pages: still in the database (and the developer console), just not shown here
  const HIDDEN_TABLES = ['course_certificates', 'about_site', 'soft_skills', 'project_details', 'project_stack', 'internship_details', 'internship_stack'];

  function renderSchema() {
    const tables = runSQL("SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY rowid;").rows
      .map((r) => r.name).filter((t) => !HIDDEN_TABLES.includes(t));
    $('#tableCount').textContent = `${tables.length} ${T('tables')}`;
    $('#schemaGrid').innerHTML = tables.map((t) => {
      const cols = [...new Set(runSQL(`PRAGMA table_info(${t});`).rows
        .map((c) => c.name.replace(/_(en|fr)$/, ''))
        .filter((c) => c !== 'id'))];
      const secret = t === 'fun_facts';
      const count = secret ? '?' : runSQL(`SELECT COUNT(*) AS n FROM ${t};`).rows[0].n;
      const body = secret
        ? `<p>${esc(T('hidden_table'))}</p>`
        : `<span class="t-cols">${cols.slice(0, 4).map((c) => `<span>${esc(c)}</span>`).join('')}</span>`;
      return `<button type="button" class="table-card${secret ? ' secret' : ''}" data-preset="${TABLE_TO_PRESET[t] || ''}">
        <span class="t-head"><span class="t-name">${esc(t)}</span><span class="muted">${count} ${esc(T(count === 1 ? 'row' : 'rows'))}</span></span>
        ${body}
      </button>`;
    }).join('');
    stagger($('#schemaGrid').parentNode);
  }

  // ---------- the number tiles on the home page: real COUNTs, counting up ----------
  const STATS = {
    projects: 'SELECT COUNT(*) AS n FROM projects;',
    internships: 'SELECT COUNT(*) AS n FROM internships;',
    certifications: 'SELECT COUNT(*) AS n FROM certifications;'
  };

  function renderStats() {
    const still = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;
    $$('[data-count]').forEach((el) => {
      const sql = STATS[el.dataset.count];
      if (!sql) return;
      const n = runSQL(sql).rows[0].n;
      el.closest('[data-preset]').title = sql;
      if (still || !window.requestAnimationFrame) { el.textContent = n; return; }
      const start = performance.now() + 400, length = 900;
      const tick = (now) => {
        const p = Math.min(1, Math.max(0, (now - start) / length));
        el.textContent = Math.round(n * (1 - Math.pow(1 - p, 3)));
        if (p < 1) requestAnimationFrame(tick);
      };
      requestAnimationFrame(tick);
    });
  }

  // ---------- asking ----------
  function askPreset(key) {
    const p = PRESETS[key];
    if (p) showAnswer({ ...p });
  }

  // Visitors' questions go to the AI, which writes the SQL. The keyword rules stay as a backup
  // (AI not set up, offline, or a bad answer) and for the detail pages, which they open instantly.
  // The suggestion chips always have a rule, so they skip the AI: they keep working even if it is down.
  async function askQuestion(text, { demo = false, suggested = false } = {}) {
    text = text.trim();
    if (!text) return;
    const rule = questionToQuery(text);
    const instant = rule && (rule.egg || rule.view === 'detail' || suggested);
    if (AI_URL && db && !demo && !instant) {
      showAnswer({ thinking: true, question: text });
      const mine = asking;
      try {
        const q = await askAI(text);
        if (mine === asking) showAnswer(q, true);
        return;
      } catch (err) {
        console.warn('AI unavailable, using keyword rules instead:', err);
        if (mine !== asking) return;
      }
    }
    if (!rule) return showAnswer({ unknown: true, question: text });
    showAnswer({ ...rule, question: text, source: demo ? 'demo' : 'rules' });
  }

  // ---------- text-to-SQL: the AI writes the query, the browser runs it ----------
  const CARD_VIEWS = ['course_certificates', 'about_site', 'profile', 'soft_skills', 'projects', 'internships', 'education', 'skills', 'certifications', 'fun_facts', 'contact'];

  const AI_TIMEOUT = 8000; // a slow or stuck AI: give up and use the keyword rules

  async function askAI(text) {
    const ctrl = new AbortController();
    const timer = setTimeout(() => ctrl.abort(), AI_TIMEOUT);
    const res = await fetch(AI_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ question: text, lang: state.lang }),
      signal: ctrl.signal
    }).finally(() => clearTimeout(timer));
    if (!res.ok) throw new Error(`AI answered ${res.status}`);
    const a = await res.json();
    // if the AI left one language empty, show the other one rather than nothing
    for (const k of ['explain', 'reply']) {
      a[k + '_en'] = a[k + '_en'] || a[k + '_fr'] || '';
      a[k + '_fr'] = a[k + '_fr'] || a[k + '_en'] || '';
    }
    if (!a.sql) return { unknown: true, question: text, source: 'ai', reply_en: a.reply_en, reply_fr: a.reply_fr };
    let sql = readOnly(a.sql);
    if (!sql) throw new Error('AI wrote something that is not a SELECT: ' + a.sql);
    // these small tables are shown as one whole page: a WHERE would only hide parts of it
    const whole = viewFor(sql);
    if (['profile', 'soft_skills', 'about_site'].includes(whole)) sql = `SELECT * FROM ${whole};`;
    runSQL(sql); // throws if the SQL is broken, so we fall back to the rules
    return { sql, view: viewFor(sql), question: text, source: 'ai', explain_en: a.explain_en, explain_fr: a.explain_fr };
  }

  // exactly one SELECT (or WITH … SELECT), nothing else
  function readOnly(sql) {
    const s = String(sql).trim().replace(/;\s*$/, '');
    if (!s || s.includes(';') || !/^(select|with)\b/i.test(s)) return null;
    return s + ';';
  }

  // "SELECT * FROM projects …" can be shown as cards; anything else is shown as a table
  function viewFor(sql) {
    const m = sql.match(/^\s*SELECT\s+\*\s+FROM\s+(\w+)/i);
    return m && CARD_VIEWS.includes(m[1]) && !/\bJOIN\b/i.test(sql) ? m[1] : 'table';
  }

  function showAnswer(q, isAIReply = false) {
    if (!db && !q.unknown && !q.egg) return;
    if (!isAIReply) asking++;
    state.current = q;
    $('#homeView').hidden = true;
    $('#answerView').hidden = false;
    $('#miniAskForm').hidden = false;
    renderAnswer();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function goHome() {
    state.current = null;
    $('#answerView').hidden = true;
    $('#homeView').hidden = false;
    $('#miniAskForm').hidden = true;
    $('#askInput').value = '';
  }

  // ---------- SQL on several lines: one clause per line, one statement per block ----------
  // (subqueries in brackets stay on one line, text in quotes is never touched)
  function formatSQL(sql) {
    let depth = 0;
    return String(sql).split(/('[^']*')/).map((part) => {
      if (part.startsWith("'")) return part;
      return part.replace(/\s+/g, ' ')
        .replace(/\(|\)|;\s*|\s+(FROM|WHERE|(?:LEFT |INNER )?JOIN|ORDER BY|GROUP BY|HAVING|LIMIT|UNION(?: ALL)?|AND|OR)\b/gi, (m, kw) => {
          if (m === '(') { depth++; return m; }
          if (m === ')') { depth--; return m; }
          if (m[0] === ';') return ';\n\n';
          if (depth) return m;
          return (/^(AND|OR)$/i.test(kw) ? '\n  ' : '\n') + kw;
        });
    }).join('').trim();
  }

  // ---------- SQL syntax colors ----------
  function highlight(sql) {
    return sql.split(/('[^']*')/).map((part) => {
      if (part.startsWith("'")) return `<span class="str">${esc(part)}</span>`;
      return esc(part)
        .replace(/\b(SELECT|FROM|JOIN|ON|WHERE|LIKE|ORDER BY|DESC|ASC|AND|OR)\b/g, '<span class="kw">$1</span>')
        .replace(/(<span class="kw">(?:FROM|JOIN)<\/span>\s+)(\w+)/g, '$1<span class="tbl">$2</span>')
        .replace(/;/g, '<span class="punct">;</span>');
    }).join('');
  }

  // ---------- "How did this work?" ----------
  function explain(sql) {
    const table = (sql.match(/FROM\s+(\w+)/i) || [])[1] || '';
    const where = (sql.match(/LIKE\s+'%(.+?)%'/i) || sql.match(/=\s*'(.+?)'/) || [])[1];
    const order = /ORDER BY/i.test(sql);
    const shelf = T('shelf_' + table);

    const sentence = fill(T('ex_intro'), { shelf })
      + (where ? fill(T('ex_intro_where'), { w: where }) : '')
      + (order ? T('ex_intro_order') : '')
      + T('ex_librarian');

    const steps = [['SELECT *', T('ex_select')], [`FROM ${table}`, fill(T('ex_from'), { shelf })]];
    if (where) steps.push([/LIKE/i.test(sql) ? `WHERE … LIKE '%${where}%'` : `WHERE … = '${where}'`, fill(T('ex_where'), { w: where })]);
    if (order) steps.push(['ORDER BY start_date DESC', T('ex_order')]);

    return explainHTML(sentence, steps);
  }

  function explainDetail(kind, id) {
    const d = DETAIL[kind];
    return explainHTML(fill(T('ex_detail'), { id, shelf: T('shelf_' + d.table) }), [
      ['SELECT *', T('ex_select')],
      [`JOIN ${d.details}`, T('ex_join')],
      [`WHERE ${d.table}.id = ${id}`, T('ex_one')],
      [`FROM ${d.stack}`, T('ex_stack')]
    ]);
  }

  function explainHTML(sentence, steps) {
    return `<p>${esc(sentence)}</p>
      <div class="steps">${steps.map(([c, s]) => `<div class="step"><code>${esc(c)}</code><span>= ${esc(s)}</span></div>`).join('')}</div>`;
  }

  // the dark box at the top of every answer: what you asked + the real SQL + "How did this work?"
  function queryPanel(asked, sql, count, explanation, source) {
    const badge = source ? `<span class="badge badge-${source}">${source === 'ai' ? '✦ ' : ''}${esc(T('badge_' + source))}</span>` : '';
    return `<div class="query-panel">
        <div class="q-top">
          <p>${esc(T('you_asked'))} <strong>${esc(asked)}</strong> · ${esc(T('db_ran'))}</p>
          <span class="q-meta">${badge}<span class="mono muted small">${count} ${esc(T(count === 1 ? 'row_returned' : 'rows_returned'))}</span></span>
        </div>
        <pre class="code">${highlight(formatSQL(sql))}</pre>
        <button type="button" class="explain-toggle" aria-expanded="false" aria-controls="explainBox">
          ${esc(T('how'))}
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" aria-hidden="true"><path d="M6 9l6 6 6-6"/></svg>
        </button>
        <div class="explain" id="explainBox" hidden>${explanation}</div>
      </div>`;
  }

  // ---------- the answer screen ----------
  function renderAnswer() {
    const q = state.current;
    const box = $('#answerView');

    if (q.egg) {
      box.innerHTML = `
        <div class="query-panel"><pre class="code">${highlight('DROP TABLE sara;')}</pre></div>
        <div class="message egg"><h2>${esc(T('egg_title'))}</h2><p>${esc(T('egg_text'))}</p></div>
        ${nextBlock()}`;
      return stagger(box);
    }
    if (q.thinking) {
      box.innerHTML = `
        <div class="query-panel thinking">
          <div class="q-top">
            <p>${esc(T('you_asked'))} <strong>${esc(q.question)}</strong></p>
            <span class="badge badge-ai">✦ ${esc(T('ai_thinking'))}</span>
          </div>
          <pre class="code" aria-busy="true"><span class="kw">SELECT</span> <span class="ghost"></span><span class="caret"></span></pre>
        </div>`;
      return;
    }
    if (q.unknown) {
      const fromAI = q.source === 'ai' && L(q, 'reply');
      box.innerHTML = `
        <div class="message"><p class="muted">${esc(T('you_asked'))} “${esc(q.question)}”</p>
          <h2>${esc(T(fromAI ? 'offtopic_title' : 'unknown_title'))}</h2><p>${esc(fromAI ? L(q, 'reply') : T('unknown_text'))}</p></div>
        ${nextBlock()}`;
      return stagger(box);
    }

    if (q.view === 'certs_page') {
      box.innerHTML = renderCertsPage(q);
      return stagger(box);
    }
    if (q.view === 'about_site') {
      box.innerHTML = renderWhy(q);
      return stagger(box);
    }
    if (q.view === 'profile') {
      box.innerHTML = renderProfile(q);
      return stagger(box);
    }
    if (q.view === 'detail') {
      box.innerHTML = renderDetail(q);
      return stagger(box);
    }

    const res = runSQL(q.sql);
    const asked = q.label ? T(q.label) : q.question;

    box.innerHTML = `
      ${queryPanel(asked, q.sql, res.rows.length, q.source === 'ai' ? explainHTML(L(q, 'explain'), []) : explain(q.sql), q.source)}
      ${res.rows.length ? renderRows(q.view, res.rows, res.columns) : `<div class="message"><p>${esc(T('no_rows'))}</p></div>`}
      ${relatedBlock(q.view, q.sql)}
      ${nextBlock()}`;
    stagger(box);
  }

  // A search on projects also looks in the internships (and the other way round),
  // so "Python" shows every place she used it, not half of them.
  const RELATED = {
    projects: { view: 'internships', title: 'also_internships',
      sql: (w) => `SELECT * FROM internships WHERE tools LIKE '%${w}%' OR id IN (SELECT internship_id FROM internship_stack WHERE tool LIKE '%${w}%') ORDER BY start_date DESC;` },
    internships: { view: 'projects', title: 'also_projects',
      sql: (w) => `SELECT * FROM projects WHERE tags LIKE '%${w}%' OR id IN (SELECT project_id FROM project_stack WHERE tool LIKE '%${w}%');` }
  };

  function relatedBlock(view, sql) {
    const r = RELATED[view];
    const w = (String(sql).match(/LIKE\s+'%([^'%]+)%'/i) || [])[1];
    if (!r || !w) return '';
    const res = runSQL(r.sql(w));
    if (!res.rows.length) return '';
    return `<h2 class="section-title">${esc(fill(T(r.title), { w }))}</h2>
      ${renderRows(r.view, res.rows, res.columns)}`;
  }

  // ---------- one project or internship, in detail ----------
  function renderDetail(q) {
    const d = DETAIL[q.kind];
    const r = runSQL(q.sqls[0]).rows[0];
    const stack = runSQL(q.sqls[1]).rows;
    if (!r) return `<div class="message"><p>${esc(T('no_rows'))}</p></div>${nextBlock()}`;
    const title = d.title(r);

    // previous / next row (wraps around; with only two rows, just show the other one)
    const all = runSQL(`SELECT * FROM ${d.table} ORDER BY ${d.order};`).rows;
    const at = all.findIndex((x) => x.id === r.id);
    const prev = all[(at - 1 + all.length) % all.length];
    const next = all[(at + 1) % all.length];
    const navBtn = (x, label, dir) => `<button type="button" data-detail="${q.kind}" data-id="${x.id}">
        <span class="muted small">${dir === 'prev' ? '← ' : ''}${esc(T(label))}${dir === 'next' ? ' →' : ''}</span><strong>${esc(d.title(x))}</strong>
      </button>`;
    const nav = all.length < 2 ? '' : `<nav class="detail-nav" aria-label="${esc(T(d.navLabel))}">
        ${prev.id !== next.id ? navBtn(prev, d.prevLabel, 'prev') : ''}${navBtn(next, d.nextLabel, 'next')}
      </nav>`;

    // sections: either a simple + a technical version, or one text for both modes
    const body = (col, both) => both
      ? `<p class="simple">${esc(L(r, col + '_simple'))}</p><p class="tech">${esc(L(r, col + '_tech'))}</p>`
      : `<p>${esc(L(r, col))}</p>`;
    const section = (n, key, html, cls = '') => `<section class="d-sec ${cls}">
        <h3><span class="d-num">${String(n).padStart(2, '0')}</span>${esc(T(key))}</h3>${html}
      </section>`;
    const tools = stack.map((s) => `<li>
        <span class="s-head"><strong>${esc(s.tool)}</strong><span class="s-layer">${esc(L(s, 'layer'))}</span></span>
        <span class="s-why">${esc(L(s, 'why'))}</span>
      </li>`).join('');
    const sections = d.sections.map(([key, col, both, cls], i) => section(i + 1, key, body(col, both), cls)).join('')
      + section(d.sections.length + 1, 'sec_stack', `<ul class="stack">${tools}</ul>`, 'd-stack');

    return `
      ${queryPanel(title, q.sqls.join('\n'), 1 + stack.length, explainDetail(q.kind, r.id))}
      <article class="detail" data-mode="${q.mode === 'tech' ? 'tech' : 'simple'}">
        <div class="detail-top">
          <button type="button" class="back-btn" data-preset="${d.back}">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M19 12H5"/><path d="M11 6l-6 6 6 6"/></svg>
            ${esc(T(d.backLabel))}
          </button>
          ${levelSwitch(q.mode)}
        </div>
        ${q.kind === 'project' ? projectHero(r) : internshipHero(r, stack.length)}
        ${r.demo ? demoBlock(r) : ''}
        <div class="detail-grid">${sections}</div>
        ${nav}
      </article>`;
  }

  // ---------- certifications: the main ones, then every course certificate ----------
  function renderCertsPage(q) {
    const main = runSQL(q.sqls[0]).rows;
    const courses = runSQL(q.sqls[1]).rows;
    const explanation = explainHTML(T('ex_certs'), [
      ['SELECT * FROM certifications', T('ex_certs_main')],
      ['FROM course_certificates', T('ex_certs_courses')],
      ['ORDER BY completed DESC', T('ex_order')]
    ]);
    return `
      ${queryPanel(T('chip_certs'), q.sqls.join('\n'), main.length + courses.length, explanation, q.source)}
      <h2 class="section-title">${esc(T('cert_main'))}</h2>
      ${renderRows('certifications', main)}
      <h2 class="section-title">${esc(T('cert_courses'))} <span class="mono small muted">${courses.length}</span></h2>
      ${certGallery(courses)}
      ${nextBlock()}`;
  }

  function monthYear(ym) {
    const [y, m] = String(ym).split('-');
    return m ? `${T('months')[Number(m) - 1]} ${y}` : y;
  }

  function certGallery(rows) {
    return `<div class="cert-grid">${rows.map(certCard).join('')}</div>`;
  }

  function certCard(r) {
    const picture = r.image
      ? `<button type="button" class="cert-img" data-cert-img="${esc(r.image)}" data-cert-title="${esc(r.title)}" data-cert-verify="${esc(r.verify_url || '')}" aria-label="${esc(T('cert_view'))}: ${esc(r.title)}">
           <img src="${esc(r.image)}" alt="${esc(r.title)}" loading="lazy">
         </button>`
      : `<div class="cert-img cert-placeholder" aria-hidden="true">
           <span class="ph-issuer">${esc(r.issuer)}</span>
           <span class="ph-kind">${esc(T('cert_kind'))}</span>
           <span class="ph-title">${esc(r.title)}</span>
         </div>`;
    const action = r.verify_url
      ? `<a class="card-link" href="${esc(r.verify_url)}" target="_blank" rel="noopener">${esc(T('cert_verify'))} ↗</a>`
      : `<span class="muted small">${esc(T('cert_pending'))}</span>`;
    return `<article class="cert">
        ${picture}
        <div class="cert-body">
          <span class="row-label">${esc(r.issuer)} · ${esc(monthYear(r.completed))}</span>
          <h3>${esc(r.title)}</h3>
          ${action}
        </div>
      </article>`;
  }

  function openCert(el) {
    const dlg = $('#certDialog');
    $('#certDialogImg').src = el.dataset.certImg;
    $('#certDialogImg').alt = el.dataset.certTitle;
    $('#certDialogTitle').textContent = el.dataset.certTitle;
    const verify = $('#certDialogVerify');
    verify.hidden = !el.dataset.certVerify;
    verify.href = el.dataset.certVerify || '#';
    verify.textContent = T('cert_verify') + ' ↗';
    $('#certDialogClose').textContent = T('cert_close');
    if (dlg.showModal) dlg.showModal(); else dlg.setAttribute('open', '');
  }

  // ---------- why is this portfolio made of SQL? ----------
  function renderWhy(q) {
    const res = runSQL(q.sql);
    if (!res.rows.length) return `<div class="message"><p>${esc(T('no_rows'))}</p></div>${nextBlock()}`;
    const explanation = q.source === 'ai' ? explainHTML(L(q, 'explain'), []) : explain(q.sql);
    const sections = res.rows.map((r, i) => `<section class="d-sec${i === 0 ? ' d-value d-wide' : ''}">
        <h3><span class="d-num">${String(i + 1).padStart(2, '0')}</span>${esc(L(r, 'question'))}</h3>
        <p class="simple">${esc(L(r, 'answer_simple'))}</p>
        <p class="tech">${esc(L(r, 'answer_tech'))}</p>
      </section>`).join('');
    return `
      ${queryPanel(q.label ? T(q.label) : q.question, q.sql, res.rows.length, explanation, q.source)}
      <article class="detail why" data-mode="${q.mode === 'tech' ? 'tech' : 'simple'}">
        <div class="detail-top">
          <h2>${esc(T('why_title'))}</h2>
          ${levelSwitch(q.mode)}
        </div>
        <div class="detail-grid">${sections}</div>
        <div class="why-try">
          <p class="muted small">${esc(T('why_try'))}</p>
          <div class="chips">
            <button type="button" class="chip" data-question="DROP TABLE sara;">DROP TABLE sara;</button>
            <button type="button" class="chip" data-question="${esc(T('next_ai'))}">${esc(T('next_ai'))}</button>
            <button type="button" class="chip" id="whyDev">${esc(T('why_dev'))}</button>
          </div>
        </div>
      </article>`;
  }

  // ---------- who is Sara: the profile page ----------
  function renderProfile(q) {
    const sql = q.sqls ? q.sqls[0] : q.sql;
    const r = runSQL(sql).rows[0];
    const skills = runSQL('SELECT * FROM soft_skills;').rows;
    if (!r) return `<div class="message"><p>${esc(T('no_rows'))}</p></div>${nextBlock()}`;
    const shownSQL = q.sqls ? q.sqls.join('\n') : sql;
    const explanation = q.source === 'ai' ? explainHTML(L(q, 'explain'), []) : explainHTML(T('ex_profile'), [
      ['SELECT *', T('ex_select')],
      ['FROM profile', T('ex_profile_from')],
      ['FROM soft_skills', T('ex_profile_skills')]
    ]);
    const initials = String(r.name).split(' ').map((w) => w[0]).join('').slice(0, 2);
    const photo = r.photo ? `<img src="${esc(r.photo)}" alt="${esc(r.name)}">` : `<span>${esc(initials)}</span>`;
    const fact = (label, value) => `<div><dt>${esc(T(label))}</dt><dd>${esc(value)}</dd></div>`;

    return `
      ${queryPanel(T('chip_profile'), shownSQL, 1 + skills.length, explanation, q.source)}
      <article class="detail profile" data-mode="${q.mode === 'tech' ? 'tech' : 'simple'}">
        <div class="profile-hero">
          <div class="avatar">${photo}</div>
          <div class="detail-intro">
            <span class="open-pill"><span class="live-dot" aria-hidden="true"></span>${esc(T('open_to_pfe'))}</span>
            <h2>${esc(r.name)}</h2>
            <p class="role">${esc(L(r, 'headline'))} · ${esc(r.school)}</p>
            <div class="lead">
              <p class="simple">${esc(L(r, 'summary_simple'))}</p>
              <p class="tech">${esc(L(r, 'summary_tech'))}</p>
            </div>
            <div class="profile-actions">
              <a class="details-btn" href="${esc(T('cv_file'))}" download>${esc(T('nav_cv'))}</a>
              <button type="button" class="card-link" data-preset="contact">${esc(T('chip_contact'))}</button>
              ${levelSwitch(q.mode)}
            </div>
          </div>
        </div>

        <div class="detail-grid">
          <section class="d-sec d-value d-wide">
            <h3><span class="d-num">01</span>${esc(T('sec_looking'))}</h3>
            <p>${esc(L(r, 'looking_for'))}</p>
            ${tagsHTML(r.roles)}
            <dl class="facts facts-row">
              ${fact('f_start', L(r, 'start'))}
              ${fact('f_duration', L(r, 'duration'))}
              ${fact('f_where', L(r, 'where'))}
            </dl>
          </section>
          <section class="d-sec">
            <h3><span class="d-num">02</span>${esc(T('sec_studies'))}</h3>
            <dl class="facts facts-plain">
              ${fact('f_school', r.school)}
              ${fact('f_degree', L(r, 'degree'))}
              ${fact('f_year', L(r, 'year'))}
              ${fact('f_specialty', L(r, 'specialty'))}
            </dl>
          </section>
          <section class="d-sec">
            <h3><span class="d-num">03</span>${esc(T('sec_me'))}</h3>
            <dl class="facts facts-plain">
              ${fact('f_based', r.city)}
              ${fact('f_languages', L(r, 'languages'))}
            </dl>
          </section>
          <section class="d-sec d-stack">
            <h3><span class="d-num">04</span>${esc(T('sec_soft'))}</h3>
            <ul class="stack soft">${skills.map((k) => `<li>
                <span class="s-head"><strong>${esc(L(k, 'skill'))}</strong></span>
                <span class="s-why">${esc(L(k, 'proof'))}</span>
              </li>`).join('')}</ul>
          </section>
        </div>
      </article>
      ${nextBlock()}`;
  }

  const lead = (r) => `<div class="lead"><p class="simple">${esc(L(r, 'simple'))}</p><p class="tech">${esc(L(r, 'tech'))}</p></div>`;

  function projectHero(r) {
    const img = r.image
      ? `<img src="${esc(r.image)}" alt="${esc(L(r, 'title'))}">`
      : `<span>${esc(T('add_photo'))}</span>`;
    const link = projectLinks(r, false);
    return `<div class="detail-hero">
        <div class="detail-intro">
          <span class="row-label">projects.id = ${r.id} · ${esc(L(r, 'kind'))}</span>
          <h2>${esc(L(r, 'title'))}</h2>
          ${lead(r)}
          ${tagsHTML(r.tags)}
          ${link ? `<div class="project-links">${link}</div>` : ''}
        </div>
        ${r.demo ? '' : `<div class="detail-img">${img}</div>`}
      </div>`;
  }

  // an interactive demo (like the 3D smart city): the photo is its cover, it loads on click
  const isVideo = (path) => /\.(mp4|webm)$/i.test(path || '');

  function demoBlock(r) {
    if (isVideo(r.demo)) {
      return `<section class="demo demo-video">
          <div class="demo-head">
            <h3><span class="d-num">▶</span>${esc(T('video_title'))}</h3>
          </div>
          <video class="demo-player" src="${esc(r.demo)}"${r.image ? ` poster="${esc(r.image)}"` : ''}
                 controls preload="none" playsinline muted aria-label="${esc(T('video_title'))}"></video>
        </section>`;
    }
    // set inline (not as a CSS variable) so the photo path is read from the page, not from css/
    const poster = r.image ? ` style="background-image: linear-gradient(rgba(20, 14, 10, .25), rgba(20, 14, 10, .65)), url('${esc(r.image)}')"` : '';
    // each demo can have its own labels (demo_title_p3...), the 3D smart city ones are the default
    const DT = (k) => I18N[state.lang][`${k}_p${r.id}`] ?? I18N.en[`${k}_p${r.id}`] ?? T(k);
    // the demo opens in the visitor's language and theme
    const src = `${r.demo}?lang=${state.lang}&theme=${state.theme}`;
    return `<section class="demo">
        <div class="demo-head">
          <h3><span class="d-num">${esc(DT('demo_tag'))}</span>${esc(DT('demo_title'))}</h3>
          <a class="card-link" href="${esc(src)}" target="_blank" rel="noopener">${esc(T('demo_full'))} ↗</a>
        </div>
        <div class="demo-frame">
          <iframe data-src="${esc(src)}" title="${esc(DT('demo_title'))}" allow="fullscreen"></iframe>
          <button type="button" class="demo-cover"${poster}>
            <span class="demo-play">▶ ${esc(DT('demo_start'))}</span>
            <small>${esc(DT('demo_hint'))}</small>
          </button>
        </div>
      </section>`;
  }

  // internships have no photo: the side panel is a small fact sheet instead
  function internshipHero(r, toolCount) {
    const fact = (label, value) => `<div><dt>${esc(T(label))}</dt><dd>${esc(value)}</dd></div>`;
    return `<div class="detail-hero">
        <div class="detail-intro">
          <span class="row-label">internships.id = ${r.id} · ${esc(period(r.start_date, r.end_date))}</span>
          <h2>${esc(r.company)}</h2>
          <p class="role">${esc(L(r, 'role'))}</p>
          ${lead(r)}
          ${tagsHTML(r.tools)}
        </div>
        <dl class="facts">
          ${fact('f_company', r.company)}
          ${fact('f_role', L(r, 'role'))}
          ${fact('f_period', period(r.start_date, r.end_date))}
          ${fact('f_duration', L(r, 'duration') || fill(T('n_months'), { n: months(r.start_date, r.end_date) }))}
          ${fact('f_tools', toolCount)}
        </dl>
      </div>`;
  }

  // any other result (counts, chosen columns…) as a plain table
  function renderTable(columns, rows) {
    return `<div class="result-table"><table>
      <thead><tr>${columns.map((c) => `<th>${esc(c)}</th>`).join('')}</tr></thead>
      <tbody>${rows.map((r) => `<tr>${columns.map((c) => `<td>${esc(r[c])}</td>`).join('')}</tr>`).join('')}</tbody>
    </table></div>`;
  }

  function renderRows(view, rows, columns) {
    if (view === 'table') return renderTable(columns, rows);
    if (view === 'course_certificates') return certGallery(rows);
    const cards = rows.map((r, i) => {
      if (view === 'projects') return projectCard(r, i);
      if (view === 'internships') return internshipCard(r, i);
      if (view === 'skills') return skillCard(r, i);
      if (view === 'education') return simpleCard(r, i, r.school, L(r, 'degree'), L(r, 'period'));
      if (view === 'certifications') return simpleCard(r, i, r.name, L(r, 'about'), r.issuer);
      if (view === 'fun_facts') return simpleCard(r, i, null, L(r, 'fact'));
      if (view === 'soft_skills') return simpleCard(r, i, L(r, 'skill'), L(r, 'proof'));
      if (view === 'contact') return contactCard(r, i);
      return '';
    }).join('');
    return `<div class="cards">${cards}</div>`;
  }

  function tagsHTML(list) {
    return `<div class="tags">${String(list || '').split(',').filter(Boolean)
      .map((t) => `<span class="tag">${esc(t.trim())}</span>`).join('')}</div>`;
  }

  function levelSwitch(mode = 'simple') {
    const tech = mode === 'tech';
    return `<div class="mini-seg" role="group" aria-label="${esc(T('expl_level'))}">
      <button type="button" data-mode="simple" aria-pressed="${!tech}">${esc(T('simple'))}</button>
      <button type="button" data-mode="tech" aria-pressed="${tech}">${esc(T('technical'))}</button>
    </div>`;
  }

  function projectCard(r, i) {
    const img = r.image
      ? `<img src="${esc(r.image)}" alt="${esc(L(r, 'title'))}">`
      : esc(T('add_photo'));
    const link = projectLinks(r, true);
    return `<article class="card card-click" data-mode="simple" data-detail="project" data-id="${r.id}">
      <div class="card-img">${img}${r.demo ? `<span class="card-badge">${esc(isVideo(r.demo) ? T('video_badge') : (I18N[state.lang][`demo_badge_p${r.id}`] ?? T('demo_badge')))}</span>` : ''}</div>
      <div class="card-body">
        <div class="card-meta">
          <span class="row-label">row ${i + 1} · ${esc(L(r, 'kind'))}</span>
          ${levelSwitch()}
        </div>
        <h3>${esc(L(r, 'title'))}</h3>
        <p class="simple">${esc(L(r, 'simple'))}</p>
        <p class="tech">${esc(L(r, 'tech'))}</p>
        ${tagsHTML(r.tags)}
        <div class="card-actions">${detailsBtn('project', r.id)}${link}</div>
      </div>
    </article>`;
  }

  // GitHub + live demo buttons (each only when the project has one)
  function projectLinks(r, short) {
    const gh = r.link
      ? `<a class="card-link link-gh" href="${esc(r.link)}" target="_blank" rel="noopener"><svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"/></svg>${esc(T(short ? 'github' : 'open_project'))}</a>` : '';
    const live = r.live_url
      ? `<a class="card-link link-live" href="${esc(r.live_url)}" target="_blank" rel="noopener"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M10 8.5l5 3.5-5 3.5z" fill="currentColor"/></svg>${esc(I18N[state.lang][`live_demo_p${r.id}`] ?? T('live_demo'))}</a>` : '';
    return gh + live;
  }

  function detailsBtn(kind, id) {
    return `<button type="button" class="details-btn" data-detail="${kind}" data-id="${id}">
        ${esc(T('see_details'))}
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg>
      </button>`;
  }

  // number of months covered, counting both ends: 2025-06 -> 2025-07 = 2
  function months(a, b) {
    const [y1, m1] = String(a).split('-').map(Number);
    const [y2, m2] = String(b).split('-').map(Number);
    return (y2 - y1) * 12 + (m2 - m1) + 1;
  }

  function period(a, b) {
    const f = (d) => { const [y, m] = String(d).split('-'); return `${T('months')[Number(m) - 1]} ${y}`; };
    return `${f(a)} – ${f(b)}`;
  }

  function internshipCard(r, i) {
    return `<article class="card card-click" data-mode="simple" data-detail="internship" data-id="${r.id}"><div class="card-body">
      <div class="card-meta">
        <span class="row-label">row ${i + 1} · ${esc(period(r.start_date, r.end_date))}</span>
        ${levelSwitch()}
      </div>
      <h3>${esc(r.company)}</h3>
      <p><strong>${esc(L(r, 'role'))}</strong></p>
      <p class="simple">${esc(L(r, 'simple'))}</p>
      <p class="tech">${esc(L(r, 'tech'))}</p>
      ${tagsHTML(r.tools)}
      <div class="card-actions">${detailsBtn('internship', r.id)}</div>
    </div></article>`;
  }

  function skillCard(r, i) {
    return `<article class="card"><div class="card-body">
      <span class="row-label">row ${i + 1}</span>
      <h3>${esc(L(r, 'category'))}</h3>
      ${tagsHTML(r.items)}
    </div></article>`;
  }

  function simpleCard(r, i, title, text, label) {
    return `<article class="card"><div class="card-body">
      <span class="row-label">row ${i + 1}${label ? ' · ' + esc(label) : ''}</span>
      ${title ? `<h3>${esc(title)}</h3>` : ''}
      <p>${esc(text)}</p>
    </div></article>`;
  }

  function contactCard(r, i) {
    const val = r.link
      ? `<a class="card-link" href="${esc(r.link)}" target="_blank" rel="noopener">${esc(r.value)}</a>`
      : `<p>${esc(r.value)}</p>`;
    return `<article class="card"><div class="card-body">
      <span class="row-label">row ${i + 1}</span><h3>${esc(r.label)}</h3>${val}
    </div></article>`;
  }

  function nextBlock() {
    const qs = ['next_why', 'next_profile', 'next_ai', 'next_agents', 'next_python', 'next_ram', 'next_certs'];
    return `<div class="next"><p class="muted small">${esc(T('ask_next'))}</p>
      <div class="chips">${qs.map((k) => `<button type="button" class="chip" data-question="${esc(T(k))}">${esc(T(k))}</button>`).join('')}</div>
    </div>`;
  }

  // ---------- developer console ----------
  function runDev(sql) {
    const out = $('#devOut');
    if (!db) return;
    if (!/^\s*(select|pragma|with)\b/i.test(sql)) {
      out.innerHTML = /drop/i.test(sql)
        ? `<p class="err">${esc(T('egg_title'))} ${esc(T('egg_text'))}</p>`
        : `<p class="err">${esc(T('dev_readonly'))}</p>`;
      return;
    }
    try {
      const results = db.exec(sql);
      if (!results.length) { out.innerHTML = `<p>${esc(T('no_rows'))}</p>`; return; }
      out.innerHTML = results.map(({ columns, values }) => `<table>
        <thead><tr>${columns.map((c) => `<th>${esc(c)}</th>`).join('')}</tr></thead>
        <tbody>${values.map((row) => `<tr>${row.map((v) => `<td>${esc(v)}</td>`).join('')}</tr>`).join('')}</tbody>
      </table>`).join('');
    } catch (e) {
      out.innerHTML = `<p class="err">${esc(T('dev_error'))} ${esc(e.message)}</p>`;
    }
  }

  // ---------- events ----------
  function bindEvents() {
    $('#askForm').addEventListener('submit', (e) => { e.preventDefault(); askQuestion($('#askInput').value); });
    $('#miniAskForm').addEventListener('submit', (e) => {
      e.preventDefault(); askQuestion($('#miniAsk').value); $('#miniAsk').value = '';
    });
    $('#homeBtn').addEventListener('click', goHome);

    // the "⋯" menu on phones: opens and closes with its button, closes after a choice, a click outside or Escape
    const setMore = (open) => {
      $('#navMore').classList.toggle('open', open);
      $('#moreBtn').setAttribute('aria-expanded', String(open));
    };
    $('#moreBtn').addEventListener('click', () => setMore(!$('#navMore').classList.contains('open')));
    document.addEventListener('click', (e) => {
      if (!e.target.closest('#moreBtn') && (!e.target.closest('#navMore') || e.target.closest('button'))) setMore(false);
    });
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && $('#navMore').classList.contains('open')) { setMore(false); $('#moreBtn').focus(); }
    });

    // one listener for every button with data-preset / data-question / data-mode
    document.addEventListener('click', (e) => {
      const modeBtn = e.target.closest('.mini-seg [data-mode]');
      if (modeBtn) {
        const card = modeBtn.closest('.card, .detail');
        card.dataset.mode = modeBtn.dataset.mode;
        $$('.mini-seg button', card).forEach((b) => b.setAttribute('aria-pressed', String(b === modeBtn)));
        // remember it on the detail page, so switching language keeps the same mode
        if (card.classList.contains('detail')) state.current.mode = modeBtn.dataset.mode;
        return;
      }

      const preset = e.target.closest('[data-preset]');
      if (preset && preset.dataset.preset) return askPreset(preset.dataset.preset);

      const question = e.target.closest('[data-question]');
      if (question) return askQuestion(question.dataset.question, { suggested: true });

      // a project or internship card (anywhere on it except its links) opens the detail page,
      // keeping the Simple / Technical choice the visitor made on the card
      const item = !e.target.closest('a, .mini-seg') && e.target.closest('[data-detail]');
      if (item) {
        const card = item.closest('.card');
        return showAnswer(detailQuery(item.dataset.detail, item.dataset.id, card ? card.dataset.mode : state.current.mode));
      }

      const certEl = e.target.closest('[data-cert-img]');
      if (certEl) return openCert(certEl);
      // close the certificate view: the close button, or a click on the dark backdrop
      if (e.target.id === 'certDialogClose' || e.target.id === 'certDialog') {
        const dlg = $('#certDialog');
        if (dlg.close) dlg.close(); else dlg.removeAttribute('open');
        return;
      }

      const cover = e.target.closest('.demo-cover');
      if (cover) {
        const frame = cover.parentNode.querySelector('iframe');
        frame.src = frame.dataset.src;
        cover.remove();
        return;
      }

      if (e.target.closest('#whyDev')) {
        if (!state.dev) $('#devBtn').click();
        $('#devPanel').scrollIntoView({ behavior: 'smooth' });
        return;
      }

      const toggle = e.target.closest('.explain-toggle');
      if (toggle) {
        const open = toggle.getAttribute('aria-expanded') !== 'true';
        toggle.setAttribute('aria-expanded', String(open));
        $('#explainBox').hidden = !open;
      }
    });

    $$('[data-lang]').forEach((b) => b.addEventListener('click', () => {
      state.lang = b.dataset.lang; savePrefs(); applyLang();
    }));
    $('#themeBtn').addEventListener('click', () => {
      state.theme = state.theme === 'dark' ? 'light' : 'dark'; savePrefs(); applyTheme();
    });
    $('#devBtn').addEventListener('click', () => {
      state.dev = !state.dev;
      $('#devBtn').setAttribute('aria-pressed', String(state.dev));
      $('#devPanel').hidden = !state.dev;
      if (state.dev) $('#devInput').focus();
    });
    $('#devForm').addEventListener('submit', (e) => { e.preventDefault(); runDev($('#devInput').value); });

    // press "/" to jump to the question box
    document.addEventListener('keydown', (e) => {
      if (e.key !== '/' || /INPUT|TEXTAREA/.test(document.activeElement.tagName)) return;
      e.preventDefault();
      ($('#homeView').hidden ? $('#miniAsk') : $('#askInput')).focus();
    });
  }

  // ---------- live demo: on the first visit, a question types itself and gets answered ----------
  function runDemo() {
    let seen = false;
    try {
      seen = sessionStorage.getItem('querySaraDemo') === '1';
      sessionStorage.setItem('querySaraDemo', '1');
    } catch (e) { /* storage blocked: still run it */ }
    if (seen || (window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches)) return;

    const input = $('#askInput');
    const text = T('ask_placeholder');
    const events = ['pointerdown', 'keydown', 'wheel', 'touchstart'];
    let typed = 0, timer;
    const stop = () => {
      clearTimeout(timer);
      input.classList.remove('demo-typing');
      events.forEach((ev) => removeEventListener(ev, cancel, true));
    };
    // the visitor does anything: stop and give the box back to them
    const cancel = () => { stop(); if (typed < text.length) input.value = ''; };
    events.forEach((ev) => addEventListener(ev, cancel, { capture: true, passive: true }));

    const type = () => {
      if (typed < text.length) {
        input.value = text.slice(0, ++typed);
        timer = setTimeout(type, 45 + Math.random() * 55);
      } else {
        timer = setTimeout(() => { stop(); if (!$('#homeView').hidden) askQuestion(text, { demo: true }); }, 700);
      }
    };
    input.classList.add('demo-typing');
    timer = setTimeout(type, 1500); // let the page finish sliding in first
  }

  // ---------- start ----------
  async function init() {
    loadPrefs();
    applyLang();
    stagger();
    setStatus('loading');
    bindEvents();
    try {
      const SQL = await initSqlJs({ locateFile: (f) => SQL_LIB + f });
      const res = await fetch('data/sara.sql');
      if (!res.ok) throw new Error('sara.sql not found');
      db = new SQL.Database();
      db.exec(await res.text());
      renderSchema();
      try { renderStats(); } catch (e) { console.warn('number tiles:', e); } // never let them break the site
      setStatus('online');
      runDemo();
    } catch (err) {
      console.error(err);
      setStatus('offline');
      $('#schemaGrid').innerHTML = `<p class="small">${esc(T('load_error'))}</p>`;
    }
  }

  init();
})();
