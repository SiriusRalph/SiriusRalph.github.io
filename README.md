# Query Sara 🤎

A portfolio you explore by **asking**, not by scrolling.
Everything about me lives in a small SQL database, and every answer on the site is a real query.

## How to open it (in VS Code)

1. Open this folder in VS Code (**File → Open Folder…**).
2. Install the extension **Live Server** (by Ritwick Dey) from the Extensions tab.
3. Right-click `index.html` → **Open with Live Server**.

The site opens in your browser and refreshes every time you save a file.

> Why Live Server? The site reads `data/sara.sql`. Browsers block that when you just double-click `index.html`, so we need a tiny local server.

## What's in the folder

| File | What it does |
|------|--------------|
| `index.html` | The page structure (top bar, home, answer screen, developer console) |
| `css/style.css` | All the design. Colors are at the top: change `--accent` to change the brown |
| `js/i18n.js` | Every sentence of the site, in English and French |
| `js/app.js` | The brain: loads the database, turns questions into SQL, shows answers |
| `js/config.js` | Where you paste the address of your AI worker |
| `ai/` | The AI worker (text-to-SQL). Setup steps in `ai/README.md` |
| `data/sara.sql` | **Your database.** Edit this to update your portfolio |
| `lib/` | sql.js, the engine that runs SQLite inside the browser. Don't touch it |

## How to update your info

Open `data/sara.sql`. All the info comes from my CV: `cv/Sara_Bouras_CV.pdf` (French) and `cv/Sara_Bouras_CV_EN.pdf` (English).
The "Download CV" buttons give the English or French one, following the EN / FR switch.
When the CV changes, update the PDFs in `cv/` and the rows in `sara.sql`.

Clicking a project opens its detail page. That page reads two more tables:
`project_details` (the problem, how it works, why it matters, results, each in a simple and a technical version, EN + FR)
and `project_stack` (one row per tool, with what it does in the project). Add a row to both when you add a project.
Internships work the same way with `internship_details` (the company, the mission, what I did, why it mattered, what I delivered)
and `internship_stack`.

To add a photo to a project: put the image in an `images/` folder and set the `image` column,
for example `'images/robot.jpg'`.

## Features

- Ask in plain words: **an AI writes the SQL query** (text-to-SQL), with the keyword rules as a backup
- A live demo on the first visit: a question types itself and gets answered
- Click the buttons, or click any project / internship for its detail page
- The real SQL query is shown, with a **"How did this work?"** explanation
- **Simple / Technical** switch on every project
- **EN / FR** and **dark / light** mode (remembered by the browser)
- **Developer mode**: a real read-only SQL console
- Hidden `fun_facts` table and a `DROP TABLE` easter egg

## Next steps

- [ ] Complete the placeholders in `data/sara.sql`
- [ ] Add project photos
- [ ] Put it online (GitHub Pages)
- [ ] Deploy the AI worker (see `ai/README.md`)
