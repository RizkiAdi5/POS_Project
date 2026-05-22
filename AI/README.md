# AI Business Analyst (sidecar)

Small Node.js service that powers the admin chatbot. Lives at
`C:\railo\tomcat\webapps\ROOT\AI`. It listens on `127.0.0.1:8088` and is
called from ColdFusion by `latest/ai/aiproxy.cfm`.

## ⚠️ READ THIS FIRST — HTTP exposure

Because this folder sits **inside** the webapp root, Tomcat will serve
every file in it (including `.env`, source code, and `logs/`) as a static
download unless you block it.

Two protections are required and shipped together:

1. `WEB-INF/web.xml` declares a `<security-constraint>` that denies any HTTP
   request to `/AI/*` (and `/ai/*`). After installing it you **must restart
   Tomcat** for the constraint to take effect.
2. `.gitignore` keeps `.env` and `logs/*.jsonl` out of source control.

After Tomcat restart, verify:

```
curl -I http://your-server/AI/.env             # expect 403
curl -I http://your-server/AI/src/server.js    # expect 403
curl -I http://your-server/AI/package.json     # expect 403
```

If any of those return 200, **stop the Node service and fix the constraint
before continuing**. The DeepSeek key and DB password live in `.env`.

(If you ever want maximum safety, move this folder back under `WEB-INF/`,
which Tomcat refuses to serve regardless of config.)

## Architecture

```
admin browser
   |
   v
latest/ai/analyst.cfm   (chat UI, admin-only)
   |  fetch /latest/ai/aiproxy.cfm
   v
latest/ai/aiproxy.cfm   (server-side cfhttp, adds shared secret, forwards dts/role)
   |
   v
Node service: AI/src/server.js  (this folder)  on 127.0.0.1:8088
   |                |
   v                v
DeepSeek API     MySQL (read-only user)
```

The browser never sees the DeepSeek key or the Node URL.

## How a question is answered

1. **Router** (DeepSeek call #1) — picks ONE `skill` and extracts params.
2. **Skill** (Node + SQL) — runs a *predefined* parameterized query, returns
   structured facts. The LLM never writes SQL.
3. **Summarizer** (DeepSeek call #2) — turns the facts JSON into bullet-point
   insight in the admin's language. Constrained to "use only provided facts".

Skills live in `src/skills/` and are auto-registered by `src/skills/index.js`.

## One-time setup

1. Install Node deps:

   ```
   cd C:\railo\tomcat\webapps\ROOT\AI
   npm install
   ```

2. Create the read-only MySQL user (run in MySQL as an admin, replace branch
   list with your real `dts` databases):

   ```sql
   CREATE USER 'ai_ro'@'127.0.0.1' IDENTIFIED BY 'a-strong-password';
   GRANT SELECT ON pos_i.* TO 'ai_ro'@'127.0.0.1';
   -- repeat GRANT SELECT for every branch DB you want exposed
   FLUSH PRIVILEGES;
   ```

3. Copy and edit env (do this from the AI folder so paths are right):

   ```
   copy .env.example .env
   notepad .env
   ```

   Fill `DEEPSEEK_API_KEY`, `DB_PASS`, `ALLOWED_DTS`, `AI_SHARED_SECRET`.

4. Mirror `AI_SHARED_SECRET` in `latest/ai/aiproxy.cfm` (a `<cfset>` near the
   top). It is the shared secret CF sends to Node.

5. Confirm `WEB-INF/web.xml` exists and contains the `<security-constraint>`
   for `/AI/*`. Restart Tomcat. Run the three `curl -I` checks above.

## Run

```
npm start
```

Health check (loopback only):

```
curl http://127.0.0.1:8088/health
```

For development with auto-reload:

```
npm run dev
```

## Running it as a Windows service (optional)

Use `nssm` or Windows Task Scheduler to auto-start `node src/server.js` when
the box boots, with the working directory set to this folder.

## Adding a new skill

1. Create `src/skills/my_skill.js` exporting `{ name, description, params, run }`.
2. Add it to the array in `src/skills/index.js`.
3. Restart the service. The router catalog is built from this list.
