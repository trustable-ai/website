# Spec 16 — Common templates: add-api, add-database, add-page

Branch: `spec-16`

## Goal

Fill the three `TODO` stubs in `trucommon-templates/` with reusable prompt
templates a user can paste into a Trustable app session. They must match the
rules in `trustable-app/openserverless-contract.md` and
`trustable-app/app-agents.md`.

## Files in scope

- `trucommon-templates/add-api.md`
- `trucommon-templates/add-database.md`
- `trucommon-templates/add-page.md`

Format follows the other template dirs: markdown prompt text, `# Step N — …`
headings separated by `---`. No front matter.

## Rules to encode

**Actions (add-api)**
- Names are `action` or `package/action` only; segments start with a letter,
  letters/numbers/hyphens only. Use `v1` for browser APIs.
- Create actions with the OpenServerless MCP action tool. Never edit generated
  `__main__.py`, never touch ZIPs, never run raw `ops action` / `ops ide deploy`.
- Logic in `packages/<package>/<action>/<module>.py`.
- Item routes: parse `__ow_path` tolerantly (suffix forms `123`, `/123`,
  `/<resource>/123`, full path) plus body fallback.
- Browser-opened URLs return real `Content-Type` (`text/html` for printable).
- After a batch of `action_new`: `trustable_runtime_redeploy` once, then
  `trustable_runtime_status`, then `check_openserverless_actions.sh .`.
- Verify with `curl http://localhost:5173/api/my/<package>/<action>`, including
  `PUT`/`DELETE` with the id in the URL; write-then-read-back.

**Database (add-database)**
- `.env` / `.env.production` are immutable — never read or write them.
- Add wiring via the MCP tools: PostgreSQL → `ctx.POSTGRESQL`, Redis →
  `action_add_redis` (`ctx.REDIS` + mandatory `ctx.REDIS_PREFIX` keys),
  MongoDB → `action_add_mongodb` (`ctx.MONGODB_CLIENT`/`ctx.MONGODB`),
  S3 → `action_add_s3` (`ctx.S3_CLIENT`, `ctx.S3_DATA`, bucket-scoped, never
  `list_buckets()`).
- Never hardcode URLs/hosts/users/passwords/ports; never invent `MONGODB_URI`
  etc.; never use `MDB_MCP_CONNECTION_STRING` in app code.
- Schema in `packages/setup/database/`, idempotent + repeatable
  (`IF NOT EXISTS`), seed guarded by a marker, every write commits.
- Service MCP servers are diagnostics only — no schema/seed via
  `postgres_execute_sql`. Run `ops ide setup` after the checker passes.
- Auth: Redis-backed opaque sessions (no JWT). Create the full endpoint set,
  then call `auth_setup` once with all of them.

**Page (add-page)**
- React + Vite under `src/`, assets in `public/`. No backend server, no
  `npm run dev` / `vite` / `ops ide devel`.
- `HashRouter`: logical paths only (`/login`), never `#/login`, never
  `<a href="/...">` for internal navigation.
- Call APIs with relative `/api/my/<package>/<action>` URLs.
- Form controls need stable `id`/`name` and `htmlFor` labels.
- Auth state: update the provider/store before navigating; persist only the
  opaque token; validate it via the `me` endpoint on reload behind an explicit
  loading state; registration logs the user in immediately.
- Validate with `react_validate` (and `react_project_inspect` if the shape is
  unclear), then typecheck/build, then check the route on
  `http://localhost:5173`.

## Plan

1. Write each of the three files as a short step-by-step prompt template with a
   placeholder the user fills in (resource name / database / page name),
   followed by a "Rules" block carrying the constraints above and a
   "Verify" block with the exact commands.
2. Keep the files short — these are prompts, not documentation.
3. Keep each file to the rules that actually apply; `add-database.md` runs to
   ~70 lines because it covers four services plus auth.
4. `trucommon-templates` is a git submodule; commit there, then update the
   pointer in the website repo. No site rebuild is needed (the dir is not
   referenced by `generator.py` or `config.toml`).
