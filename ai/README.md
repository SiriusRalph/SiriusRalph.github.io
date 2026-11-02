# The AI behind the question box (free)

Visitors type anything. An AI reads a summary of my database and writes **one SQL query**.
The website then runs that query itself, in the visitor's browser, and shows the rows.
This is called **text-to-SQL**.

```
visitor's question ──▶ this worker ──▶ the AI writes the SQL ──▶ the browser runs it on sara.sql ──▶ cards
```

It runs on **Cloudflare Workers AI**, free, with an open model (Meta's Llama 3.3 70B).
No API key and no credit card: everything runs inside a tiny Cloudflare server called a "worker".

## Turn it on (about 10 minutes, once)

1. Create a free account on **cloudflare.com** (no card needed).
2. In VS Code, open a terminal in this `ai` folder and run:
   ```bash
   npm install
   npx wrangler login    # opens the browser: click "Allow"
   npx wrangler deploy
   ```
3. `deploy` prints an address like `https://query-sara-ai.<you>.workers.dev`.
   Paste it in `js/config.js`:
   ```js
   window.QUERY_SARA_AI = 'https://query-sara-ai.<you>.workers.dev';
   ```
4. Open the site with Live Server and ask something. The footer says `AI: on`, and answers
   show a **✦ written by AI** badge.

## Good to know

- **Free limit:** the free plan gives 10,000 "neurons" a day, which is about 80 questions.
  After that, the site quietly uses the keyword rules until the next day (reset at 01:00 in Morocco).
  It never breaks and never costs anything.
- **After editing `data/sara.sql`, run `npx wrangler deploy` again**, so the AI knows the new data.
- **When the site is online**, check that its address is in `ALLOWED_ORIGINS` in `wrangler.toml`
  (GitHub Pages is already there), then deploy again. Other websites get refused.
- **Safety:** the website only runs a single `SELECT` query. Anything else the AI might write is
  rejected. And the database lives in the visitor's browser, so nobody can change the real file.
- **Why a summary, not the whole file?** Fewer words sent = more free questions per day.
  `schema.js` builds the summary (table structure + short values like tags and tools) automatically.
- **Want better answers later?** Free open models sometimes write a query that doesn't work
  (the site then falls back to the keyword rules). A paid model like Claude or Grok is more
  accurate; only `worker.js` would need to change.
