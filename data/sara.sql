-- ============================================================
--  sara_db : everything the portfolio knows about Sara
--  Source: Sara_Bouras_CV_v3. Edit this file to update the site.
--  Every answer on the site is a real SQL query on these tables.
-- ============================================================

-- ---------- PROFILE (who Sara is, one row) ----------
CREATE TABLE profile (
  id             INTEGER PRIMARY KEY,
  name           TEXT,
  photo          TEXT,   -- e.g. 'images/sara.jpg' (NULL = initials)
  headline_en    TEXT,
  headline_fr    TEXT,
  school         TEXT,
  degree_en      TEXT,
  degree_fr      TEXT,
  year_en        TEXT,   -- which year of studies
  year_fr        TEXT,
  specialty_en   TEXT,
  specialty_fr   TEXT,
  city           TEXT,
  languages_en   TEXT,
  languages_fr   TEXT,
  summary_simple_en TEXT, -- who I am, in plain words
  summary_simple_fr TEXT,
  summary_tech_en   TEXT, -- who I am, for engineers and recruiters
  summary_tech_fr   TEXT,
  looking_for_en TEXT,   -- what I'm looking for
  looking_for_fr TEXT,
  roles          TEXT,   -- comma separated: the jobs I'm aiming for
  start_en       TEXT,   -- internship availability
  start_fr       TEXT,
  duration_en    TEXT,
  duration_fr    TEXT,
  where_en       TEXT,
  where_fr       TEXT
);

INSERT INTO profile VALUES
(1, 'Sara Bouras', 'images/sara.jpg',
 'AI & Big Data engineering student', 'Élève-ingénieure en IA & Big Data',
 'HESTIM',
 'State Engineering Degree in Artificial Intelligence & Big Data', 'Cycle Ingénieur d''État en Intelligence Artificielle et Big Data',
 '3rd and final year of the engineering cycle', '3e et dernière année du cycle ingénieur',
 'Artificial Intelligence & Big Data', 'Intelligence Artificielle & Big Data',
 'Casablanca, Morocco',
 'French (fluent), English (fluent), Arabic (native)', 'Français (courant), anglais (courant), arabe (natif)',
 'I''m in my last year of engineering school, studying artificial intelligence and data. I like building things that really work, from the first messy spreadsheet to the final dashboard or app, and explaining them so anyone can understand.',
 'Je suis en dernière année d''école d''ingénieurs, en intelligence artificielle et data. J''aime construire des choses qui marchent vraiment, du premier tableur en désordre jusqu''au tableau de bord ou à l''application finale, et les expliquer pour que tout le monde comprenne.',
 'Final-year AI & Big Data engineering student with solid skills in Data Science, Machine Learning and Business Intelligence, and hands-on end-to-end experience: data collection and cleaning, predictive modelling, deployment and visualisation.',
 'Élève-ingénieure en dernière année IA & Big Data, avec des compétences solides en Data Science, Machine Learning et Business Intelligence, et une expérience concrète de bout en bout : collecte et nettoyage de données, modélisation prédictive, déploiement et visualisation.',
 'An end-of-studies internship (PFE) in data and AI: Data Science, Machine Learning or AI engineering.',
 'Un stage de fin d''études (PFE) en data et IA : Data Science, Machine Learning ou ingénierie IA.',
 'Data Scientist, Machine Learning Engineer, AI Engineer, Data Analyst / BI',
 'February 2027', 'Février 2027',
 '6 months', '6 mois',
 'Casablanca, or anywhere in Morocco', 'Casablanca, ou partout au Maroc');

-- ---------- SOFT SKILLS (each one with proof) ----------
CREATE TABLE soft_skills (
  id       INTEGER PRIMARY KEY,
  skill_en TEXT,
  skill_fr TEXT,
  proof_en TEXT,   -- where you can see it in my work
  proof_fr TEXT
);

INSERT INTO soft_skills VALUES
(1, 'Explaining things simply', 'Expliquer simplement',
 'This whole site: every answer shows its SQL with a plain-words explanation, and every project has a Simple / Technical switch.',
 'Tout ce site : chaque réponse montre son SQL avec une explication simple, et chaque projet a un bouton Simple / Technique.'),
(2, 'Autonomy & initiative', 'Autonomie & initiative',
 'I build complete systems end to end: two decision systems at Sigman, from the input form to the dashboard, and an automated testing app at Royal Air Maroc.',
 'Je construis des systèmes complets de bout en bout : deux systèmes décisionnels chez Sigman, du formulaire de saisie au tableau de bord, et une application de tests automatisés chez Royal Air Maroc.'),
(3, 'Curious, fast learner', 'Curieuse, j''apprends vite',
 'From BI to robotics to AI agents: Power BI, Gazebo and SLAM, LangGraph and MCP, each learned for a real project.',
 'De la BI à la robotique aux agents IA : Power BI, Gazebo et SLAM, LangGraph et MCP, chacun appris pour un vrai projet.'),
(4, 'Fun, captivating pitches', 'Des pitchs vivants et captivants',
 'I turn technical projects into stories people remember. My bridge-monitoring pitch opens with a question, "What if bridges could talk?", then the Morandi bridge collapse, and presents the system as "a doctor for the bridge, 24/7".',
 'Je transforme des projets techniques en histoires dont on se souvient. Mon pitch sur la surveillance des ponts commence par une question, « Et si les ponts pouvaient parler ? », puis l''effondrement du pont Morandi, et présente le système comme « un médecin pour le pont, 24h/24 ».');

-- ---------- ABOUT THIS SITE (why a portfolio made of SQL?) ----------
CREATE TABLE about_site (
  id                 INTEGER PRIMARY KEY,
  question_en        TEXT,
  question_fr        TEXT,
  answer_simple_en   TEXT,
  answer_simple_fr   TEXT,
  answer_tech_en     TEXT,
  answer_tech_fr     TEXT
);

INSERT INTO about_site VALUES
(1, 'Why SQL?', 'Pourquoi du SQL ?',
 'Because data is my job. Instead of telling you "I know SQL", I let you see it: every answer on this site is a real query on a real database. It''s a portfolio you can test, not just read.',
 'Parce que la data, c''est mon métier. Au lieu de te dire « je connais le SQL », je te le montre : chaque réponse sur ce site est une vraie requête sur une vraie base de données. C''est un portfolio qu''on peut tester, pas seulement lire.',
 'The portfolio is the demo. All the content lives in a relational SQLite schema, queried in the browser with sql.js (SQLite compiled to WebAssembly). Every answer shows the exact SQL it ran, so you can judge my SQL directly instead of trusting a skills list.',
 'Le portfolio est la démo. Tout le contenu vit dans un schéma relationnel SQLite, interrogé dans le navigateur avec sql.js (SQLite compilé en WebAssembly). Chaque réponse affiche le SQL exact exécuté, pour juger mon SQL directement au lieu de croire une liste de compétences.'),
(2, 'Why not a normal page?', 'Pourquoi pas une page classique ?',
 'Most portfolios make you scroll through everything. Here you ask about what interests you and get just that, in a few seconds.',
 'La plupart des portfolios te font tout faire défiler. Ici, tu demandes ce qui t''intéresse et tu obtiens juste ça, en quelques secondes.',
 'Query-driven navigation: visitors pull only the rows they need instead of scanning one long page, and the same tables feed the cards, the detail pages and the developer console.',
 'Navigation par requêtes : le visiteur récupère seulement les lignes dont il a besoin au lieu de parcourir une longue page, et les mêmes tables alimentent les cartes, les pages détaillées et la console développeur.'),
(3, 'Where does AI come in?', 'Et l''IA dans tout ça ?',
 'When you type a question, an AI turns your words into SQL, and my database answers. It''s called text-to-SQL: a real technique companies use so anyone can talk to their data.',
 'Quand tu tapes une question, une IA transforme tes mots en SQL, et ma base répond. Ça s''appelle le text-to-SQL : une vraie technique utilisée par les entreprises pour que tout le monde puisse parler à ses données.',
 'Text-to-SQL with Llama 3.3 70B on Cloudflare Workers AI: a worker sends the model a compact schema summary and gets back structured JSON (the SQL plus explanations in English and French). The browser only runs it if it is a single SELECT; otherwise keyword rules answer instead.',
 'Text-to-SQL avec Llama 3.3 70B sur Cloudflare Workers AI : un worker envoie au modèle un résumé compact du schéma et reçoit un JSON structuré (le SQL et des explications en anglais et en français). Le navigateur ne l''exécute que s''il s''agit d''un seul SELECT ; sinon, des règles par mots-clés répondent.'),
(4, 'Is it real? Can I break it?', 'C''est réel ? Je peux le casser ?',
 'It''s real, and no, you can''t break it: the database runs inside your own browser, so nothing you type changes the original. Even DROP TABLE won''t work. Go ahead, try it.',
 'C''est réel, et non, tu ne peux pas le casser : la base tourne dans ton propre navigateur, donc rien de ce que tu tapes ne modifie l''original. Même DROP TABLE ne marchera pas. Vas-y, essaie.',
 'The whole SQLite database is loaded client-side, there is no server database to attack, the developer console only accepts read-only queries, and the AI worker only answers requests coming from this site.',
 'Toute la base SQLite est chargée côté client, il n''y a pas de base serveur à attaquer, la console développeur n''accepte que des requêtes en lecture seule, et le worker IA ne répond qu''aux requêtes venant de ce site.');

-- ---------- PROJECTS ----------
CREATE TABLE projects (
  id         INTEGER PRIMARY KEY,
  title_en   TEXT,
  title_fr   TEXT,
  kind_en    TEXT,     -- small label on the card (type · date)
  kind_fr    TEXT,
  tags       TEXT,     -- comma separated, used by WHERE tags LIKE '%AI%'
  simple_en  TEXT,     -- "explain like I'm 10" version
  simple_fr  TEXT,
  tech_en    TEXT,     -- technical version for engineers
  tech_fr    TEXT,
  image      TEXT,     -- e.g. 'images/robot.jpg' (NULL = placeholder)
  link       TEXT      -- GitHub repository (NULL = no button)
);

INSERT INTO projects VALUES
(1,
 'Autonomous inspection robot',
 'Robot d''inspection autonome',
 'Capstone · team of 3 · Oct 2026 – now', 'PFE · équipe de 3 · oct. 2026 – en cours',
 'AI, Robotics, Computer vision, Python, Capstone',
 'Inspired by the 2023 Al Haouz earthquake. After an earthquake, buildings can be dangerous to walk into. Our robot goes in first, draws a map, photographs the damage (cracks, debris, a fallen slab), and tells rescuers how serious each one is.',
 'Inspiré du séisme d''Al Haouz en 2023. Après un séisme, entrer dans un bâtiment peut être dangereux. Notre robot y va en premier, dessine une carte, photographie les dégâts (fissures, débris, dalle effondrée) et dit aux secours à quel point chacun est grave.',
 'TurtleBot3 Waffle (LiDAR + camera) in a custom SDF Gazebo world of a damaged building (cracks, debris, leaning slab). My part: the world, SLAM Toolbox mapping (10 m × 10 m, 5 cm/px) and Nav2 autonomous navigation with a waypoint patrol that captures damage photos. Teammates handle damage detection and severity ranking.',
 'TurtleBot3 Waffle (LiDAR + caméra) dans un monde Gazebo SDF d''un bâtiment endommagé (fissures, débris, dalle inclinée). Ma partie : le monde, la cartographie SLAM Toolbox (10 m × 10 m, 5 cm/px) et la navigation autonome Nav2 avec une patrouille qui photographie les dégâts. Mes coéquipières gèrent la détection et le classement par gravité.',
 'images/robot.jpg', 'https://github.com/SiriusRalph/earthquake-inspection-robot'),
(2,
 'Medical multi-agent AI system',
 'Système IA multi-agents médical',
 'AI · Mar – Apr 2026', 'IA · mars – avr. 2026',
 'AI, LLM, Agents, Python, React',
 'Imagine four tiny AI doctors, each with a speciality, talking together to give a patient a first idea of where to go for care.',
 'Imagine quatre petits médecins IA, chacun avec sa spécialité, qui discutent ensemble pour donner au patient une première idée d''où se faire soigner.',
 'Multi-agent AI system (4 specialised agents) simulating a preliminary clinical orientation, orchestrated with LangGraph, clinical tools integrated through MCP. Stack: Python, LangGraph, LangChain, FastAPI, React, Ollama, MCP.',
 'Système d''IA multi-agents (4 agents spécialisés) simulant une orientation clinique préliminaire, orchestré via LangGraph, avec intégration d''outils cliniques via MCP. Stack : Python, LangGraph, LangChain, FastAPI, React, Ollama, MCP.',
 'images/mediagent.jpg', 'https://github.com/SiriusRalph/Projet-agentic-AI'),
(3,
 'IoT hospital intrusion detection',
 'Détection d''intrusions IoT à l''hôpital',
 'Machine learning · Apr 2026', 'Machine learning · avr. 2026',
 'AI, Machine learning, IoT, Security, Python',
 'Hospitals are full of connected devices that hackers could attack. I taught a small computer to notice when something suspicious happens, and it catches 96% of attacks.',
 'Les hôpitaux sont remplis d''appareils connectés que des pirates pourraient attaquer. J''ai appris à un petit ordinateur à repérer quand quelque chose de suspect arrive, et il attrape 96 % des attaques.',
 'IoT intrusion detection on 200,000 CICIoT2023 samples: preprocessing, feature engineering, comparison of 7 classifiers. Optimised decision tree: 88.17% accuracy, 96% recall. Deployed with a real-time Streamlit monitoring dashboard on a Raspberry Pi, with data transmission optimised to save energy.',
 'Détection d''intrusions IoT sur 200 000 échantillons CICIoT2023 : preprocessing, feature engineering, comparaison de 7 modèles. Arbre optimisé : 88,17 % d''accuracy, 96 % de rappel. Déployé avec un dashboard Streamlit de monitoring temps réel sur Raspberry Pi, transmission optimisée pour économiser l''énergie.',
 'images/iot-ids.jpg', 'https://github.com/SiriusRalph/iomt-intrusion-detection'),
(4,
 'Etudafrik: smart study-orientation platform',
 'Etudafrik : plateforme intelligente d''orientation',
 'Web + AI · May 2026', 'Web + IA · mai 2026',
 'AI, Web, Recommendation, React',
 'African students who want to study in Morocco had to search everywhere. Etudafrik puts all the schools in one place, and an AI suggests the ones that fit each student.',
 'Les étudiants africains qui veulent étudier au Maroc devaient chercher partout. Etudafrik met toutes les écoles au même endroit, et une IA propose celles qui correspondent à chaque étudiant.',
 'Web platform centralising Moroccan private schools so African students can search and apply from one interface. Recommendation system using the Grok API based on the student profile; dedicated dashboards for students, schools and admins. Stack: React, TypeScript, Supabase, Grok API.',
 'Plateforme web centralisant les établissements privés marocains pour que les étudiants africains recherchent et candidatent depuis une interface unique. Recommandation via l''API Grok selon le profil ; dashboards étudiants, écoles et admins. Stack : React, TypeScript, Supabase, Grok API.',
 'images/etudafrik.jpg', 'https://github.com/SiriusRalph/etudafrik'),
(5,
 'AI Business Briefing',
 'AI Business Briefing',
 'Data + AI · in progress', 'Data + IA · en cours',
 'AI, Data, BI, React',
 'You give it a messy spreadsheet, and it writes you a short summary like a smart assistant: what the numbers prove, what they probably mean, what they can''t tell you, and what to watch next.',
 'Tu lui donnes un tableur en désordre, et il t''écrit un petit résumé comme un assistant malin : ce que les chiffres prouvent, ce qu''ils veulent sans doute dire, ce qu''ils ne peuvent pas dire, et à quoi faire attention.',
 'Tool that turns an Excel/CSV export into a business briefing that separates proven facts (exact KPI deltas), reasoned hypotheses (each backed by its evidence), open questions the data cannot answer, and items to monitor. Human approval before anything is sent. Stack: React, TypeScript, TanStack Start, Vite, shadcn/ui.',
 'Outil transformant un export Excel/CSV en synthèse qui sépare les faits prouvés (écarts de KPI exacts), les hypothèses argumentées (chacune avec sa preuve), les questions auxquelles les données ne répondent pas, et les points à surveiller. Validation humaine avant tout envoi. Stack : React, TypeScript, TanStack Start, Vite, shadcn/ui.',
 'images/briefing.jpg', NULL),
(6,
 'Bridges that talk: smart infrastructure monitoring',
 'Et si les ponts pouvaient parler ? Surveillance intelligente des infrastructures',
 'IoT · PACTE team project · 2025–2026', 'IoT · Projet PACTE en équipe · 2025-2026',
 'IoT, Security, Smart city, Sensors, Raspberry Pi',
 'Bridges can''t tell anyone when they''re in trouble. With my team, we gave them a voice: small sensors listen to the bridge day and night, and raise the alarm before it''s too late.',
 'Les ponts ne peuvent prévenir personne quand ils vont mal. Avec mon équipe, on leur a donné une voix : de petits capteurs écoutent le pont jour et nuit, et donnent l''alerte avant qu''il ne soit trop tard.',
 'IoT system for continuous infrastructure monitoring: MPU6050, SW-420, YL-83 and DHT22 sensors feed a Raspberry Pi that computes a single risk index (IRI) from 0 to 1, with LED, buzzer and screen alerts and a live dashboard. Validated on a miniature city: 3 scenarios, 3 correct classifications.',
 'Système IoT de surveillance continue des infrastructures : capteurs MPU6050, SW-420, YL-83 et DHT22 reliés à un Raspberry Pi qui calcule un indice de risque unique (IRI) de 0 à 1, avec alertes LED, buzzer et écran et un dashboard en direct. Validé sur une ville miniature : 3 scénarios, 3 classifications correctes.',
 'images/bridges.jpg', NULL);

-- Interactive demos: a page (.html) or a video (.mp4) shown inside the project's detail page
ALTER TABLE projects ADD COLUMN demo TEXT;
UPDATE projects SET demo = 'demos/smart-city-3d.html' WHERE id = 6;
UPDATE projects SET demo = 'demos/mediagent.mp4' WHERE id = 2;   -- a video works too
UPDATE projects SET demo = 'demos/briefing.mp4' WHERE id = 5;
UPDATE projects SET demo = 'demos/iot-ids.html' WHERE id = 3;   -- the real decision tree, exported to JavaScript

-- Live demos: a website where you can try the project (NULL = no button)
ALTER TABLE projects ADD COLUMN live_url TEXT;
UPDATE projects SET live_url = 'https://etud-afrik-guide-maroccan-pour-les.vercel.app' WHERE id = 4;
UPDATE projects SET live_url = 'demos/smart-city-3d.html' WHERE id = 6;
UPDATE projects SET live_url = 'demos/iot-ids.html' WHERE id = 3;

-- ---------- PROJECT DETAILS (the page you see when you click a project) ----------
-- One row per project. Every text has a simple and a technical version,
-- in English and French, so the Simple / Technical switch keeps working.
CREATE TABLE project_details (
  project_id        INTEGER PRIMARY KEY REFERENCES projects(id),
  problem_simple_en TEXT,   -- the problem it solves
  problem_simple_fr TEXT,
  problem_tech_en   TEXT,
  problem_tech_fr   TEXT,
  how_simple_en     TEXT,   -- how it works
  how_simple_fr     TEXT,
  how_tech_en       TEXT,
  how_tech_fr       TEXT,
  value_simple_en   TEXT,   -- value proposition: why it matters
  value_simple_fr   TEXT,
  value_tech_en     TEXT,
  value_tech_fr     TEXT,
  status_en         TEXT,   -- results / where the project is today
  status_fr         TEXT
);

INSERT INTO project_details VALUES
(1,
 'After an earthquake, rescuers need to know if a building is safe before going in, but sending a person to check is exactly the dangerous part.',
 'Après un séisme, les secours doivent savoir si un bâtiment est sûr avant d''y entrer, mais envoyer quelqu''un vérifier, c''est justement ça le danger.',
 'Post-earthquake structural assessment means entering unstable buildings with no up-to-date map, which exposes the inspection team to collapse risk.',
 'L''évaluation structurelle après un séisme impose d''entrer dans des bâtiments instables sans carte à jour, ce qui expose l''équipe d''inspection au risque d''effondrement.',
 'The robot uses a laser to draw a map of the building as it moves, then drives by itself to stops in front of each damage and takes a photo. An AI model then recognises the damage, and each one is placed on the map with its severity: low, medium or high.',
 'Le robot utilise un laser pour dessiner la carte du bâtiment en avançant, puis va seul jusqu''à des arrêts devant chaque dégât et prend une photo. Un modèle d''IA reconnaît ensuite le dégât, et chacun est placé sur la carte avec sa gravité : faible, moyenne ou élevée.',
 'ROS 2 Humble on WSL2. The damage is modelled in SDF: cracks are visual-only (camera sees them, LiDAR does not), debris and the slab have collision geometry so they appear on the map. SLAM Toolbox (online async) builds the occupancy grid; a script fills enclosed unknown cells. Nav2 (AMCL, planner, controller, inflation layer) runs on the saved map with tuned params, and a Python patrol script drives to waypoints computed from the world file and saves /camera/image_raw frames for the detection model.',
 'ROS 2 Humble sous WSL2. Les dégâts sont modélisés en SDF : les fissures sont uniquement visuelles (la caméra les voit, pas le LiDAR), les débris et la dalle ont une géométrie de collision pour apparaître sur la carte. SLAM Toolbox (online async) construit la grille d''occupation ; un script remplit les zones inconnues fermées. Nav2 (AMCL, planificateur, contrôleur, inflation) tourne sur la carte sauvegardée avec des paramètres ajustés, et un script Python de patrouille rejoint des waypoints calculés depuis le monde et enregistre les images /camera/image_raw pour le modèle de détection.',
 'The robot takes the risk instead of a person, and gives rescue teams a clear picture of the building before anyone walks in.',
 'Le robot prend le risque à la place d''une personne, et donne aux secours une image claire du bâtiment avant que quelqu''un n''y entre.',
 'Removes humans from the riskiest phase of the inspection and produces a map annotated with detected damage to support go / no-go decisions.',
 'Retire l''humain de la phase la plus risquée de l''inspection et produit une carte annotée des dégâts détectés pour appuyer la décision d''entrer ou non.',
 'In progress (capstone project): the damaged world, the full SLAM map and single-goal Nav2 navigation work (goal SUCCEEDED). The full photo patrol is the current blocker: on a slow machine the simulation runs at about 40% speed, AMCL falls behind and Nav2 loses localisation after about a minute. Next: lighter AMCL, headless Gazebo, shorter patrol runs, then the damage detection model.',
 'En cours (PFE) : le monde endommagé, la carte SLAM complète et la navigation Nav2 vers un objectif fonctionnent (objectif SUCCEEDED). La patrouille photo complète bloque encore : sur une machine lente la simulation tourne à environ 40 % de sa vitesse, AMCL décroche et Nav2 perd la localisation au bout d''une minute. Prochaines étapes : AMCL allégé, Gazebo sans fenêtre, patrouilles plus courtes, puis le modèle de détection des dégâts.'),
(2,
 'When you feel sick, it''s hard to know which kind of doctor to see first, so people often end up in the wrong place and lose time.',
 'Quand on est malade, c''est difficile de savoir quel médecin voir en premier, alors on se retrouve souvent au mauvais endroit et on perd du temps.',
 'Patients often lack guidance for initial care orientation, which misroutes demand and overloads general consultations.',
 'Les patients manquent souvent d''aide pour l''orientation initiale, ce qui disperse la demande et surcharge les consultations générales.',
 'You describe how you feel. Four AI agents, each a specialist, look at your answers, share what they think, and agree on a first suggestion of where to go.',
 'Tu décris ce que tu ressens. Quatre agents IA, chacun spécialiste, regardent tes réponses, partagent leur avis et se mettent d''accord sur une première suggestion.',
 'Four specialised LLM agents run locally through Ollama and are orchestrated as a LangGraph state graph. Clinical tools are exposed to the agents through MCP, and a FastAPI backend serves the React front end.',
 'Quatre agents LLM spécialisés tournent en local via Ollama et sont orchestrés sous forme de graphe d''états LangGraph. Les outils cliniques sont exposés aux agents via MCP, et un backend FastAPI sert le front-end React.',
 'A first, friendly idea of where to get care, at any time, without replacing a real doctor.',
 'Une première idée, simple et rassurante, d''où se faire soigner, à toute heure, sans remplacer un vrai médecin.',
 'Preliminary orientation support with local inference (Ollama), so the models run on the host machine; modular agents and MCP tools make it easy to add new specialities.',
 'Aide à l''orientation préliminaire avec inférence locale (Ollama), les modèles tournant sur la machine hôte ; les agents modulaires et les outils MCP permettent d''ajouter facilement de nouvelles spécialités.',
 'Built March – April 2026. It is a simulation for learning purposes and does not give medical diagnoses.',
 'Réalisé de mars à avril 2026. C''est une simulation à visée pédagogique, qui ne donne pas de diagnostic médical.'),
(3,
 'Hospital devices like monitors and pumps are connected to the network, and a hacker attacking them could put patients in danger.',
 'Les appareils de l''hôpital, comme les moniteurs et les pompes, sont connectés au réseau, et un pirate qui les attaque pourrait mettre les patients en danger.',
 'Internet of Medical Things devices are numerous, resource-constrained and rarely monitored, which makes them an easy entry point for network attacks.',
 'Les objets médicaux connectés sont nombreux, limités en ressources et rarement surveillés, ce qui en fait une porte d''entrée facile pour les attaques réseau.',
 'I showed a computer 200,000 examples of normal traffic and attacks until it learned the difference. Then I put it on a tiny Raspberry Pi computer that watches the network live.',
 'J''ai montré à un ordinateur 200 000 exemples de trafic normal et d''attaques jusqu''à ce qu''il apprenne la différence. Puis je l''ai installé sur un petit ordinateur Raspberry Pi qui surveille le réseau en direct.',
 '200,000 CICIoT2023 samples: preprocessing and feature engineering, then 7 classifiers benchmarked. The optimised decision tree was deployed on a Raspberry Pi with a real-time Streamlit monitoring dashboard, and data transmission was optimised to save energy.',
 '200 000 échantillons CICIoT2023 : preprocessing et feature engineering, puis comparaison de 7 classifieurs. L''arbre de décision optimisé a été déployé sur Raspberry Pi avec un dashboard Streamlit de monitoring temps réel, et la transmission des données a été optimisée pour économiser l''énergie.',
 'It catches 96% of attacks, runs on a cheap little computer, and shows alerts on a simple live screen.',
 'Il attrape 96 % des attaques, tourne sur un petit ordinateur pas cher, et affiche les alertes sur un écran simple, en direct.',
 'High recall (96%) prioritises not missing attacks, which is the metric that matters in a hospital; a lightweight model runs at the edge on low-cost hardware with reduced energy use.',
 'Un rappel élevé (96 %) privilégie le fait de ne rater aucune attaque, la métrique qui compte à l''hôpital ; un modèle léger tourne en edge sur du matériel peu coûteux, avec une consommation réduite.',
 'Done (April 2026): 88.17% accuracy and 96% recall with the optimised decision tree. Try it below: the exact trained tree runs in your browser on real CICIoT2023 traffic.',
 'Terminé (avril 2026) : 88,17 % d''accuracy et 96 % de rappel avec l''arbre de décision optimisé. Essaie-le ci-dessous : l''arbre entraîné tourne tel quel dans ton navigateur sur du vrai trafic CICIoT2023.'),
(4,
 'African students who want to study in Morocco have to visit dozens of school websites, and it''s hard to know which school fits them.',
 'Les étudiants africains qui veulent étudier au Maroc doivent visiter des dizaines de sites d''écoles, et c''est difficile de savoir laquelle leur correspond.',
 'Information on Moroccan private schools is scattered, with no single place where international students can compare programmes and apply.',
 'L''information sur les écoles privées marocaines est dispersée, sans endroit unique où les étudiants internationaux peuvent comparer les formations et candidater.',
 'Students create a profile, browse all the schools in one place and apply from there. An AI reads their profile and suggests the schools that match best. Schools and admins have their own pages to manage everything.',
 'Les étudiants créent un profil, parcourent toutes les écoles au même endroit et candidatent directement. Une IA lit leur profil et propose les écoles les plus adaptées. Les écoles et les admins ont leurs propres pages pour tout gérer.',
 'React + TypeScript front end on a Supabase backend. Student profile data is sent to the Grok API to generate school recommendations. Role-based dashboards for students, schools and admins.',
 'Front-end React + TypeScript sur un backend Supabase. Les données du profil étudiant sont envoyées à l''API Grok pour générer des recommandations d''écoles. Dashboards par rôle : étudiants, écoles et admins.',
 'One website instead of dozens, and an AI advisor that points each student to the right school.',
 'Un seul site au lieu de dizaines, et un conseiller IA qui oriente chaque étudiant vers la bonne école.',
 'A centralised search and application flow for students, plus a recruitment channel and dashboard for schools, with personalised recommendations.',
 'Un parcours de recherche et de candidature centralisé pour les étudiants, plus un canal de recrutement et un dashboard pour les écoles, avec des recommandations personnalisées.',
 'Built in May 2026.',
 'Réalisé en mai 2026.'),
(5,
 'Business people receive big spreadsheets full of numbers, and finding what really changed takes hours.',
 'Les équipes reçoivent de gros tableurs remplis de chiffres, et trouver ce qui a vraiment changé prend des heures.',
 'Turning raw Excel/CSV exports into an actionable summary is manual and slow, and significant variations are easy to miss.',
 'Transformer des exports Excel/CSV bruts en synthèse exploitable est manuel et lent, et les variations importantes passent facilement inaperçues.',
 'You drop in your file (it stays in your browser until it is analysed). The tool compares this month with last month and writes a briefing in four parts: what the data shows for sure, what it probably means and why, what the data can''t answer, and what to keep an eye on. Nothing is sent until you click "Approve".',
 'Tu déposes ton fichier (il reste dans ton navigateur jusqu''à l''analyse). L''outil compare ce mois-ci au mois dernier et écrit une synthèse en quatre parties : ce que les données montrent à coup sûr, ce que ça veut probablement dire et pourquoi, ce que les données ne peuvent pas dire, et ce qu''il faut surveiller. Rien n''est envoyé avant que tu cliques sur « Approuver ».',
 'The Excel/CSV file is read in the browser and sent to a server function only when analysed, where it is turned into KPI series by period. The tool computes period-over-period deltas, contribution analysis (which product or region drives the change) and a volume vs. price decomposition, then writes a structured briefing: facts, hypotheses each with a "Based on" evidence line, open questions, and metrics to watch. Seven built-in test datasets (volume collapse, price cut, cost squeeze, one product exploding, weekday-only decline, five-day closure, one odd product) are run by a test script to check that each story is found. A human-in-the-loop approval gate controls sending.',
 'Le fichier Excel/CSV est lu dans le navigateur et envoyé à une fonction serveur seulement au moment de l''analyse, où il est transformé en séries de KPI par période. L''outil calcule les écarts d''une période à l''autre, une analyse de contribution (quel produit ou quelle région explique le changement) et une décomposition volume / prix, puis rédige une synthèse structurée : faits, hypothèses chacune avec sa ligne de preuve « Basé sur », questions ouvertes et indicateurs à surveiller. Sept jeux de test intégrés (effondrement des volumes, baisse de prix, pression sur les coûts, un produit qui explose, baisse en semaine seulement, fermeture de cinq jours, un produit atypique) sont passés par un script de test pour vérifier que chaque histoire est bien trouvée. Une validation humaine contrôle l''envoi.',
 'A clear one-page summary in minutes, instead of hours spent reading tables, and it is honest about what it does not know.',
 'Un résumé clair d''une page en quelques minutes, au lieu d''heures passées à lire des tableaux, et honnête sur ce qu''il ne sait pas.',
 'Automated, consistent reporting that surfaces what needs attention, so decisions rely on the data rather than on who had time to read it.',
 'Un reporting automatisé et cohérent qui fait ressortir ce qui demande de l''attention, pour que les décisions reposent sur les données et non sur le temps de lecture de chacun.',
 'Working prototype, still in progress: upload, analysis, the four-part briefing and the approval step run end to end. On the sample sales file it explains a -15% revenue drop as a volume problem, not a price one, and traces half of it to a single product.',
 'Prototype fonctionnel, toujours en cours : dépôt, analyse, synthèse en quatre parties et étape de validation fonctionnent de bout en bout. Sur le fichier de ventes exemple, il explique une baisse de 15 % du chiffre d''affaires par les volumes et non par les prix, et en attribue la moitié à un seul produit.'),
(6,
 'Bridges are only checked a few times a year. In between, nobody knows what rain, water, vibrations or heat are doing to them. In Genoa in 2018, the Morandi bridge collapsed and 43 people died: the bridge was sending signals, but nobody was listening.',
 'Les ponts ne sont inspectés que quelques fois par an. Entre deux visites, personne ne sait ce que la pluie, l''eau, les vibrations ou la chaleur leur font. À Gênes en 2018, le pont Morandi s''est effondré et 43 personnes sont mortes : le pont envoyait des signaux, mais personne ne les écoutait.',
 'Structural monitoring relies on periodic visual inspections, which leave long blind spots: degradation signals such as vibration, tilt, shocks, moisture and thermal stress go unrecorded until the next visit.',
 'La surveillance des ouvrages repose sur des inspections visuelles périodiques, qui laissent de longues zones aveugles : les signaux de dégradation (vibrations, inclinaison, chocs, humidité, contraintes thermiques) ne sont pas enregistrés avant la visite suivante.',
 'Four little sensors act like a doctor for the bridge, 24/7: one feels if it shakes or tilts, one feels sudden shocks, one sees the rain, one checks temperature and humidity. A small computer turns everything into one score from 0 to 1. Green: the bridge is fine. Yellow: keep an eye on it. Red: alarm right now.',
 'Quatre petits capteurs jouent le rôle de médecin du pont, 24h/24 : l''un sent s''il tremble ou penche, l''un sent les chocs brusques, l''un voit la pluie, l''un mesure la température et l''humidité. Un petit ordinateur transforme tout ça en une seule note de 0 à 1. Vert : le pont va bien. Jaune : à surveiller. Rouge : alarme immédiate.',
 'MPU6050 (vibration and tilt), SW-420 (shocks), YL-83 (rain) and DHT22 (temperature and humidity) sensors are read by a Raspberry Pi, which combines them into one risk index (IRI) between 0 and 1. Thresholds: normal below 0.4, moderate from 0.4 to 0.7, critical above 0.7. Alerts go out through an LED, a buzzer and a screen, and a dashboard shows the bridge''s state live.',
 'Les capteurs MPU6050 (vibrations et inclinaison), SW-420 (chocs), YL-83 (pluie) et DHT22 (température et humidité) sont lus par un Raspberry Pi, qui les combine en un indice de risque unique (IRI) entre 0 et 1. Seuils : normal sous 0,4, modéré de 0,4 à 0,7, critique au-delà de 0,7. Les alertes passent par une LED, un buzzer et un écran, et un dashboard montre l''état du pont en direct.',
 'Cheap sensors that watch day and night, so a bridge gets repaired before an accident, not after. And the same idea works for a park, a school, and one day the whole city.',
 'Des capteurs à petit prix qui veillent jour et nuit, pour réparer un pont avant l''accident, pas après. Et la même idée marche pour un parc, une école, et un jour toute la ville.',
 'Low-cost, real-time and preventive: continuous monitoring with inexpensive sensors closes the gap between inspections, and the same architecture scales from one bridge to parks, schools and city-wide infrastructure.',
 'Économique, temps réel et préventif : une surveillance continue avec des capteurs peu coûteux comble le vide entre les inspections, et la même architecture passe d''un pont aux parcs, aux écoles et à toute la ville.',
 'Tested on a miniature city: 3 situations (normal 0.09, moderate 0.55, critical 0.75), 3 correct answers. Team project (PACTE, engineering cycle 2025/2026) with Maryem Trifis, Fatima Ezzahra Bougsissa and Hamza Harakat.',
 'Testé sur une ville miniature : 3 situations (normal 0,09, modéré 0,55, critique 0,75), 3 bonnes réponses. Projet d''équipe (PACTE, cycle ingénieur 2025/2026) avec Maryem Trifis, Fatima Ezzahra Bougsissa et Hamza Harakat.');

-- ---------- PROJECT STACK (one row per tool used in a project) ----------
CREATE TABLE project_stack (
  id         INTEGER PRIMARY KEY,
  project_id INTEGER REFERENCES projects(id),
  tool       TEXT,
  layer_en   TEXT,   -- what part of the project it belongs to
  layer_fr   TEXT,
  why_en     TEXT,   -- what it does here, in plain words
  why_fr     TEXT
);

INSERT INTO project_stack (project_id, tool, layer_en, layer_fr, why_en, why_fr) VALUES
(1, 'ROS 2',        'Robotics framework', 'Framework robotique', 'Connects all the robot''s parts so they can talk to each other.', 'Relie toutes les parties du robot pour qu''elles communiquent.'),
(1, 'Gazebo',       'Simulation',         'Simulation',          'A realistic 3D world where the robot can practise safely.', 'Un monde 3D réaliste où le robot s''entraîne sans danger.'),
(1, 'SLAM Toolbox', 'Mapping',            'Cartographie',        'Builds the map of the building while the robot explores it.', 'Construit la carte du bâtiment pendant que le robot l''explore.'),
(1, 'Nav2',         'Navigation',         'Navigation',          'Plans the route and avoids obstacles.', 'Planifie le trajet et évite les obstacles.'),
(1, 'Python',       'Patrol script',      'Script de patrouille', 'Drives the robot from stop to stop and saves a photo at each one.', 'Conduit le robot d''arrêt en arrêt et enregistre une photo à chacun.'),
(1, 'YOLOv8',       'Computer vision',    'Vision par ordinateur', 'Spots cracks and damage in camera images.', 'Repère les fissures et les dégâts dans les images de la caméra.'),
(1, 'TurtleBot3',   'Robot',              'Robot',               'The robot itself (Waffle model): wheels, a laser and a camera.', 'Le robot lui-même (modèle Waffle) : roues, laser et caméra.'),

(2, 'Python',       'Language',           'Langage',             'The language all the agents are written in.', 'Le langage dans lequel tous les agents sont écrits.'),
(2, 'LangGraph',    'Agent orchestration','Orchestration d''agents', 'Decides which agent speaks when, and how they share notes.', 'Décide quel agent parle et quand, et comment ils partagent leurs notes.'),
(2, 'LangChain',    'LLM toolkit',        'Boîte à outils LLM',  'Connects the agents to the AI models and tools.', 'Relie les agents aux modèles d''IA et aux outils.'),
(2, 'Ollama',       'Local LLMs',         'LLM en local',        'Runs the AI models on the computer itself.', 'Fait tourner les modèles d''IA directement sur l''ordinateur.'),
(2, 'MCP',          'Tool protocol',      'Protocole d''outils', 'A standard plug that lets the agents use clinical tools.', 'Une prise standard qui permet aux agents d''utiliser des outils cliniques.'),
(2, 'FastAPI',      'Backend API',        'API backend',         'Carries messages between the website and the agents.', 'Transmet les messages entre le site et les agents.'),
(2, 'React',        'Front end',          'Front-end',           'The website the patient types into.', 'Le site dans lequel le patient écrit.'),

(3, 'Python',         'Language',          'Langage',            'Used to clean the data and train the models.', 'Sert à nettoyer les données et entraîner les modèles.'),
(3, 'CICIoT2023',     'Dataset',           'Jeu de données',     'The 200,000 examples of normal traffic and attacks.', 'Les 200 000 exemples de trafic normal et d''attaques.'),
(3, 'Decision tree',  'Model',             'Modèle',             'The model that beat the 6 others it was compared with.', 'Le modèle qui a battu les 6 autres testés.'),
(3, 'Streamlit',      'Dashboard',         'Dashboard',          'The live screen that shows the alerts.', 'L''écran en direct qui affiche les alertes.'),
(3, 'Raspberry Pi',   'Edge hardware',     'Matériel edge',      'The tiny computer that watches the network.', 'Le petit ordinateur qui surveille le réseau.'),

(4, 'React',        'Front end',          'Front-end',           'The website students and schools use.', 'Le site utilisé par les étudiants et les écoles.'),
(4, 'TypeScript',   'Language',           'Langage',             'JavaScript with safety checks, to avoid bugs.', 'Du JavaScript avec des vérifications, pour éviter les bugs.'),
(4, 'Supabase',     'Backend & database', 'Backend & base de données', 'Stores the schools, students and applications.', 'Stocke les écoles, les étudiants et les candidatures.'),
(4, 'Grok API',     'AI recommendations', 'Recommandations IA',  'The AI that suggests the right schools.', 'L''IA qui propose les bonnes écoles.'),

(5, 'React',        'Front end',          'Front-end',           'The page where you upload your file and read the summary.', 'La page où tu déposes ton fichier et lis le résumé.'),
(5, 'TypeScript',   'Language',           'Langage',             'JavaScript with safety checks, to avoid bugs.', 'Du JavaScript avec des vérifications, pour éviter les bugs.'),
(5, 'TanStack Start', 'Full-stack framework', 'Framework full-stack', 'Runs the pages and the server part that analyses the file.', 'Fait tourner les pages et la partie serveur qui analyse le fichier.'),
(5, 'Vite',         'Build tool',         'Outil de build',      'Starts the app instantly while I build it, and packages it for the web.', 'Lance l''app instantanément pendant que je la construis, et la prépare pour le web.'),
(5, 'shadcn/ui',    'UI components',      'Composants UI',       'Ready-made buttons and cards, styled to match the design.', 'Des boutons et cartes prêts à l''emploi, stylés selon le design.'),
(5, 'Bun',          'Runtime',            'Runtime',             'Installs the packages and runs the test script that checks the 7 datasets.', 'Installe les paquets et lance le script de test qui vérifie les 7 jeux de données.'),

(6, 'Raspberry Pi',      'Edge computer',        'Ordinateur embarqué',   'The small computer that reads the sensors and computes the risk score.', 'Le petit ordinateur qui lit les capteurs et calcule la note de risque.'),
(6, 'MPU6050',           'Vibration & tilt',     'Vibrations & inclinaison', 'Feels if the bridge shakes or tilts.', 'Sent si le pont tremble ou penche.'),
(6, 'SW-420',            'Shock sensor',         'Capteur de chocs',      'Feels sudden knocks.', 'Sent les coups brusques.'),
(6, 'YL-83',             'Rain sensor',          'Capteur de pluie',      'Sees when it rains.', 'Voit quand il pleut.'),
(6, 'DHT22',             'Temperature & humidity', 'Température & humidité', 'Measures the air around the bridge.', 'Mesure l''air autour du pont.'),
(6, 'LED, buzzer & screen', 'Alerts',            'Alertes',               'Raise the alarm on site.', 'Donnent l''alerte sur place.'),
(6, 'Dashboard',         'Live monitoring',      'Suivi en direct',       'Shows the state of the bridge in real time.', 'Montre l''état du pont en temps réel.');

-- ---------- INTERNSHIPS ----------
CREATE TABLE internships (
  id          INTEGER PRIMARY KEY,
  company     TEXT,
  role_en     TEXT,
  role_fr     TEXT,
  start_date  TEXT,   -- 'YYYY-MM'
  end_date    TEXT,
  tools       TEXT,
  simple_en   TEXT,
  simple_fr   TEXT,
  tech_en     TEXT,
  tech_fr     TEXT
);

INSERT INTO internships VALUES
(1, 'Groupe Construlting Sigman',
 'Business Intelligence / Data intern', 'Stagiaire Business Intelligence / Data',
 '2026-05', '2026-07',
 'Power BI, Power Apps, Power Query, DAX, SharePoint, Python, Machine learning',
 'I built two complete systems that help the company decide who to hire and follow its money, from the form people fill in to the final dashboard. I also built a Python model that guesses which job applications will succeed.',
 'J''ai construit deux systèmes complets qui aident l''entreprise à décider qui recruter et à suivre son argent, du formulaire rempli jusqu''au tableau de bord final. J''ai aussi créé un modèle Python qui devine quelles candidatures vont réussir.',
 'Designed and deployed two decision systems (recruitment and treasury): Power Apps input, SharePoint storage, Power BI dashboards. Cleaned heterogeneous Excel data with Power Query/M, built KPIs with DAX, automated refresh via Power BI Service. Logistic regression in Python to predict application success, with class-imbalance handling and feature selection.',
 'Conception et déploiement de deux systèmes décisionnels (recrutement et trésorerie) : saisie Power Apps, stockage SharePoint, visualisation Power BI. Nettoyage de données Excel hétérogènes avec Power Query/M, KPI en DAX, actualisation automatisée via Power BI Service. Régression logistique en Python pour estimer le succès des candidatures, avec traitement du déséquilibre des classes et sélection de variables.'),
(2, 'Royal Air Maroc',
 'Web development & testing intern', 'Stagiaire développement web & testing',
 '2025-06', '2025-07',
 'Python, Selenium, SQLite, HTML, CSS, JavaScript',
 'I built a robot-tester: a web app that clicks through the airline''s website by itself, checks that everything works, and writes a report.',
 'J''ai construit un robot-testeur : une application web qui navigue toute seule sur le site de la compagnie, vérifie que tout marche, et écrit un rapport.',
 'Web app for automated testing with Python, Selenium WebDriver, SQLite, HTML/CSS and JavaScript: select or write scripts, choose the browser, run test scenarios automatically across site pages, with detailed result reporting.',
 'Application web de tests automatisés avec Python, Selenium WebDriver, SQLite, HTML/CSS et JavaScript : sélection ou rédaction de scripts, choix du navigateur, exécution automatique de scénarios sur différentes pages, avec reporting détaillé.');

-- ---------- INTERNSHIP DETAILS (the page you see when you click an internship) ----------
-- One row per internship. about = presenting the company.
-- mission / work / value have a simple and a technical version, in English and French.
CREATE TABLE internship_details (
  internship_id     INTEGER PRIMARY KEY REFERENCES internships(id),
  about_en          TEXT,   -- the company
  about_fr          TEXT,
  mission_simple_en TEXT,   -- the need / what I was asked to do
  mission_simple_fr TEXT,
  mission_tech_en   TEXT,
  mission_tech_fr   TEXT,
  work_simple_en    TEXT,   -- what I actually did
  work_simple_fr    TEXT,
  work_tech_en      TEXT,
  work_tech_fr      TEXT,
  value_simple_en   TEXT,   -- value proposition: why it mattered for the company
  value_simple_fr   TEXT,
  value_tech_en     TEXT,
  value_tech_fr     TEXT,
  results_en        TEXT,   -- what was delivered
  results_fr        TEXT,
  duration_en       TEXT,   -- as written on the CV
  duration_fr       TEXT
);

INSERT INTO internship_details VALUES
(1,
 'Groupe Construlting Sigman is the company where I did my Business Intelligence / Data internship. [ADD: one or two sentences on what the company does and its sector.]',
 'Groupe Construlting Sigman est l''entreprise où j''ai fait mon stage Business Intelligence / Data. [À COMPLÉTER : une ou deux phrases sur l''activité de l''entreprise et son secteur.]',
 'The company followed its hiring and its money in many different Excel files. It needed one clear, reliable place to see what was happening and decide faster.',
 'L''entreprise suivait ses recrutements et son argent dans plein de fichiers Excel différents. Elle avait besoin d''un endroit clair et fiable pour voir ce qui se passe et décider plus vite.',
 'Recruitment and treasury data lived in heterogeneous Excel files, with no single pipeline from data entry to reporting and no automated refresh, so KPIs were slow to produce.',
 'Les données de recrutement et de trésorerie étaient dans des fichiers Excel hétérogènes, sans chaîne unique de la saisie au reporting ni actualisation automatique : les KPI étaient lents à produire.',
 'I built two complete systems, one for hiring and one for money. People fill in a simple form, the answers are saved in one place, and a dashboard updates by itself. I also built a Python model that guesses which job applications are likely to succeed.',
 'J''ai construit deux systèmes complets, un pour le recrutement et un pour l''argent. Les gens remplissent un formulaire simple, les réponses sont rangées au même endroit, et un tableau de bord se met à jour tout seul. J''ai aussi créé un modèle Python qui devine quelles candidatures ont le plus de chances de réussir.',
 'Designed and deployed two end-to-end decision systems (recruitment and treasury): Power Apps forms for data entry, SharePoint for storage, Power BI dashboards on top. Cleaned and reshaped the heterogeneous Excel data with Power Query (M), modelled the KPIs in DAX, and automated refresh through Power BI Service. Trained a logistic regression in Python to predict application success, with class-imbalance handling and feature selection.',
 'Conception et déploiement de deux systèmes décisionnels de bout en bout (recrutement et trésorerie) : formulaires Power Apps pour la saisie, SharePoint pour le stockage, dashboards Power BI pour la visualisation. Nettoyage et restructuration des données Excel hétérogènes avec Power Query (M), modélisation des KPI en DAX, actualisation automatisée via Power BI Service. Régression logistique en Python pour prédire le succès des candidatures, avec traitement du déséquilibre des classes et sélection de variables.',
 'Managers see hiring and money at a glance, always up to date, without anyone copying numbers by hand.',
 'Les responsables voient le recrutement et l''argent d''un coup d''œil, toujours à jour, sans que personne ne recopie les chiffres à la main.',
 'One source of truth from input to dashboard; automated refresh removes manual reporting; the predictive model adds a data-driven signal to recruitment decisions.',
 'Une source de vérité unique de la saisie au dashboard ; l''actualisation automatique supprime le reporting manuel ; le modèle prédictif ajoute un signal basé sur les données aux décisions de recrutement.',
 'Two decision systems (recruitment and treasury) designed and deployed, plus a predictive model for application success. May – July 2026.',
 'Deux systèmes décisionnels (recrutement et trésorerie) conçus et déployés, plus un modèle prédictif du succès des candidatures. Mai – juillet 2026.',
 '3 months', '3 mois'),
(2,
 'Royal Air Maroc is Morocco''s national airline. From its hub in Casablanca it flies to destinations across Africa, Europe, the Middle East and the Americas.',
 'Royal Air Maroc est la compagnie aérienne nationale du Maroc. Depuis son hub de Casablanca, elle dessert l''Afrique, l''Europe, le Moyen-Orient et les Amériques.',
 'An airline website has a lot of pages, and checking by hand that every one of them still works after each change takes a lot of time.',
 'Le site d''une compagnie aérienne a beaucoup de pages, et vérifier à la main qu''elles marchent toutes après chaque changement prend énormément de temps.',
 'Testing the web pages manually was slow and repetitive; the goal was to run test scenarios automatically and keep a clear record of the results.',
 'Tester les pages web à la main était lent et répétitif ; l''objectif était d''exécuter automatiquement des scénarios de test et de garder une trace claire des résultats.',
 'I built a robot-tester. You pick a test or write your own, choose the browser, press start, and the robot clicks through the pages by itself. At the end it writes a report of what worked and what didn''t.',
 'J''ai construit un robot-testeur. Tu choisis un test ou tu écris le tien, tu choisis le navigateur, tu lances, et le robot navigue tout seul sur les pages. À la fin, il écrit un rapport de ce qui marche et de ce qui ne marche pas.',
 'Web app for automated testing: users select existing scripts or write their own, choose the target browser, and launch scenarios that Selenium WebDriver runs across the site''s pages. Python drives the tests, SQLite stores the test data, and an HTML/CSS/JavaScript interface shows a detailed report for each run.',
 'Application web de tests automatisés : l''utilisateur sélectionne des scripts existants ou rédige les siens, choisit le navigateur cible et lance des scénarios exécutés par Selenium WebDriver sur les pages du site. Python pilote les tests, SQLite stocke les données de test, et une interface HTML/CSS/JavaScript affiche un reporting détaillé pour chaque exécution.',
 'Tests that took a long time by hand now run by themselves, and no page gets forgotten.',
 'Les tests qui prenaient longtemps à la main tournent maintenant tout seuls, et aucune page n''est oubliée.',
 'Repeatable, browser-configurable test runs with detailed reporting: regressions are caught faster, and saved scripts can be re-run without rewriting them.',
 'Des exécutions de tests reproductibles, configurables par navigateur, avec un reporting détaillé : les régressions sont détectées plus vite, et les scripts enregistrés se relancent sans être réécrits.',
 'A working automated-testing web app, delivered during a 1.5-month internship (June – July 2025).',
 'Une application web de tests automatisés fonctionnelle, livrée pendant un stage d''un mois et demi (juin – juillet 2025).',
 '1.5 months', '1,5 mois');

-- ---------- INTERNSHIP STACK (one row per tool used during an internship) ----------
CREATE TABLE internship_stack (
  id            INTEGER PRIMARY KEY,
  internship_id INTEGER REFERENCES internships(id),
  tool          TEXT,
  layer_en      TEXT,
  layer_fr      TEXT,
  why_en        TEXT,
  why_fr        TEXT
);

INSERT INTO internship_stack (internship_id, tool, layer_en, layer_fr, why_en, why_fr) VALUES
(1, 'Power Apps',          'Data entry',     'Saisie',              'The simple forms people fill in.', 'Les formulaires simples que les gens remplissent.'),
(1, 'SharePoint',          'Storage',        'Stockage',            'Where all the answers are saved.', 'L''endroit où toutes les réponses sont rangées.'),
(1, 'Power Query',         'Data cleaning',  'Nettoyage',           'Cleans and reshapes the messy Excel files.', 'Nettoie et réorganise les fichiers Excel en désordre.'),
(1, 'DAX',                 'KPIs',           'KPI',                 'The formulas behind every number on the dashboards.', 'Les formules derrière chaque chiffre des tableaux de bord.'),
(1, 'Power BI',            'Dashboards',     'Tableaux de bord',    'The dashboards managers read, refreshed automatically.', 'Les tableaux de bord que lisent les responsables, mis à jour automatiquement.'),
(1, 'Python',              'Prediction',     'Prédiction',          'Used to build the model that predicts which applications succeed.', 'Sert à construire le modèle qui prédit les candidatures qui réussissent.'),
(1, 'Logistic regression', 'Model',          'Modèle',              'The prediction model, tuned to cope with uneven data.', 'Le modèle de prédiction, ajusté pour des données déséquilibrées.'),

(2, 'Python',              'Test engine',    'Moteur de tests',     'Runs the tests and drives the browser.', 'Exécute les tests et pilote le navigateur.'),
(2, 'Selenium WebDriver',  'Browser automation', 'Automatisation du navigateur', 'The "robot" that clicks through the website.', 'Le « robot » qui navigue sur le site.'),
(2, 'SQLite',              'Database',       'Base de données',     'Keeps the test data.', 'Garde les données de test.'),
(2, 'HTML & CSS',          'Interface',      'Interface',           'The pages of the testing app.', 'Les pages de l''application de tests.'),
(2, 'JavaScript',          'Interactivity',  'Interactivité',       'Makes the app react when you choose and launch tests.', 'Fait réagir l''application quand tu choisis et lances des tests.');

-- ---------- EDUCATION ----------
CREATE TABLE education (
  id         INTEGER PRIMARY KEY,
  school     TEXT,
  degree_en  TEXT,
  degree_fr  TEXT,
  period_en  TEXT,
  period_fr  TEXT
);

INSERT INTO education VALUES
(1, 'HESTIM', 'State Engineering Degree in Artificial Intelligence & Big Data', 'Cycle Ingénieur d''État en Intelligence Artificielle et Big Data', 'Oct 2022 – now', 'oct. 2022 – en cours'),
(2, 'Lamartine', 'Baccalaureate in Mathematical Sciences (Option A)', 'Baccalauréat Sciences Mathématiques (Option A)', 'June 2021', 'juin 2021');

-- ---------- SKILLS ----------
CREATE TABLE skills (
  id          INTEGER PRIMARY KEY,
  category_en TEXT,
  category_fr TEXT,
  items       TEXT
);

INSERT INTO skills VALUES
(1, 'Programming',       'Programmation',     'Python, SQL'),
(2, 'Data & ML',         'Data & ML',         'Pandas, NumPy, Matplotlib, Scikit-learn, Machine learning'),
(3, 'AI & LLMs',         'IA & LLM',          'LangGraph, LangChain, Ollama, MCP, YOLOv8'),
(4, 'Web',               'Web',               'React, TypeScript, HTML, CSS, JavaScript, FastAPI'),
(5, 'Databases',         'Bases de données',  'MySQL, MongoDB, Supabase, SQLite'),
(6, 'BI & tools',        'BI & outils',       'Power BI, Power Query, DAX, Power Apps, SharePoint, Excel, GitHub'),
(7, 'Languages',         'Langues',           'French (fluent), English (fluent), Arabic (native)');

-- ---------- CERTIFICATIONS ----------
CREATE TABLE certifications (
  id        INTEGER PRIMARY KEY,
  name      TEXT,
  issuer    TEXT,
  about_en  TEXT,
  about_fr  TEXT
);

INSERT INTO certifications VALUES
(1, 'IBM Data Science Professional Certificate', 'Coursera / IBM',
 'Python and SQL for data science, data cleaning and visualisation, data science methodology, building ML models.',
 'Python et SQL appliqués à la data science, nettoyage et visualisation de données, méthodologie, construction de modèles de ML.'),
(2, 'Machine Learning', 'Coursera',
 'Supervised and unsupervised learning, model evaluation and applied ML best practices.',
 'Apprentissage supervisé et non supervisé, évaluation de modèles et bonnes pratiques de ML appliqué.'),
(3, 'Relational Database Administration (DBA)', 'Coursera / IBM',
 'Running relational databases day to day: creating and managing databases, users and security, backup and recovery, monitoring and performance.',
 'Administrer des bases de données relationnelles au quotidien : création et gestion des bases, utilisateurs et sécurité, sauvegarde et restauration, supervision et performance.'),
(4, 'Project Management', 'Coursera',
 'Project planning, risk management and agile methods.',
 'Planification de projet, gestion des risques et méthodologies agiles.');

-- ---------- COURSE CERTIFICATES (one row per Coursera course certificate) ----------
-- To add one: copy its code from "View certificate" on Coursera, then the image is at
-- images/certs/<CODE>.jpg and the public check is https://coursera.org/verify/<CODE>
CREATE TABLE course_certificates (
  id         INTEGER PRIMARY KEY,
  title      TEXT,
  issuer     TEXT,
  completed  TEXT,   -- 'YYYY-MM'
  verify_url TEXT,   -- public link that proves it's real (NULL = not added yet)
  image      TEXT    -- picture of the certificate (NULL = placeholder)
);

INSERT INTO course_certificates VALUES
(1, 'Project Planning: Putting It All Together', 'Google', '2026-05', 'https://coursera.org/verify/CSYDP2Y3LZVC', 'images/certs/CSYDP2Y3LZVC.jpg'),
(2, 'Machine Learning with Python', 'IBM', '2026-05', 'https://coursera.org/verify/0XKDD6AOCCSH', 'images/certs/0XKDD6AOCCSH.jpg'),
(3, 'Python for Data Science, AI & Development', 'IBM', '2026-01', 'https://coursera.org/verify/7J3KYQAXMI2P', 'images/certs/7J3KYQAXMI2P.jpg'),
(4, 'Data Science Methodology', 'IBM', '2026-01', 'https://coursera.org/verify/W1QSQ9G3NAX0', 'images/certs/W1QSQ9G3NAX0.jpg'),
(5, 'Exploratory Data Analysis for Machine Learning', 'IBM', '2026-01', 'https://coursera.org/verify/JILE23KU0R3Y', 'images/certs/JILE23KU0R3Y.jpg'),
(6, 'Tools for Data Science', 'IBM', '2026-01', 'https://coursera.org/verify/F4AIE4OO5253', 'images/certs/F4AIE4OO5253.jpg'),
(7, 'What is Data Science?', 'IBM', '2025-12', 'https://coursera.org/verify/20N4TEMQVUFX', 'images/certs/20N4TEMQVUFX.jpg'),
(8, 'Relational Database Administration (DBA)', 'IBM', '2025-03', 'https://coursera.org/verify/VEU8EZ31F97M', 'images/certs/VEU8EZ31F97M.jpg');

-- ---------- FUN FACTS (the hidden table) ----------
CREATE TABLE fun_facts (
  id       INTEGER PRIMARY KEY,
  fact_en  TEXT,
  fact_fr  TEXT
);

INSERT INTO fun_facts VALUES
(1, 'Brown is my signature color. Yes, this whole site is brown on purpose.', 'Le marron est ma couleur signature. Oui, tout ce site est marron exprès.'),
(2, 'I speak three languages, and SQL is my fourth.', 'Je parle trois langues, et le SQL est ma quatrième.'),
(3, 'My gift: making complicated things easy to understand. That''s why every answer here has a "How did this work?" button.', 'Mon talent : rendre simple ce qui est compliqué. C''est pour ça que chaque réponse ici a un bouton « Comment ça marche ? ».');

-- ---------- CONTACT ----------
CREATE TABLE contact (
  id     INTEGER PRIMARY KEY,
  label  TEXT,
  value  TEXT,
  link   TEXT
);

INSERT INTO contact VALUES
(1, 'Email',    's.bouras@hestim.ma',              'mailto:s.bouras@hestim.ma'),
(2, 'LinkedIn', 'linkedin.com/in/sara-bouras-733617329', 'https://www.linkedin.com/in/sara-bouras-733617329/'),
(3, 'GitHub',   'github.com/SiriusRalph',          'https://github.com/SiriusRalph'),
(4, 'Location', 'Casablanca, Morocco',             NULL);
