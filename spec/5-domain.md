# 5 — Fix the canonical domain

The site is published at `trustable.it` (that is what `static/CNAME` has always
contained, and it is the domain GitHub Pages serves), but `base_url` in
`config.toml` says `https://trustable.ai`. Zola bakes `base_url` into every
absolute URL it emits, so the generated site under `docs/` advertises a domain
that is not the one it is served from:

- `docs/sitemap.xml` lists every page under `https://trustable.ai/...`
- `docs/robots.txt` points crawlers at the `trustable.ai` sitemap
- page `<link rel="canonical">` / Open Graph URLs name `trustable.ai`
- the few content links written as full `base_url` URLs (see `spec/1-site.md`)
  resolve off-domain

Search engines are therefore told the canonical home of the content is a domain
the project does not publish from.

## Change

Set `base_url` in `config.toml` to `https://trustable.it`, then rebuild so
`docs/` is regenerated consistently.

## Out of scope — `trustable-ai` is not a typo

The string `trustable-ai` refers to the **GitHub organisation** of the same
name, which is genuinely spelled that way. It stays untouched everywhere it
appears:

- `generator.py` — fetches `raw.githubusercontent.com/trustable-ai/.github`
- `spec/4-generate.md` — documents that fetch
- `build.sh` — comments describing the catalog source
- starter entries whose `repo` is `https://github.com/trustable-ai/<app>`

Only the bare domain `trustable.ai` is wrong.

## Verification

- `grep -rn 'trustable\.ai' --exclude-dir=.git .` returns nothing (the
  hyphenated org name does not match this pattern).
- `docs/CNAME` still reads `trustable.it`, republished from `static/CNAME`.
- `docs/sitemap.xml` and `docs/robots.txt` name `trustable.it`.
