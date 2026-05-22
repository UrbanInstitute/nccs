# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

The NCCS (National Center for Charitable Statistics) website — a **Jekyll** site published via GitHub Pages from the `main` branch. There is **no build system** (no Webpack/Vite/Node): the site relies on Jekyll's built-in SCSS support and browser-native ESM. Content authoring uses a mix of Markdown, HTML+Liquid, and **Quarto** (`.qmd`) for richer R-driven pages.

## Common commands

| Task | Command |
|---|---|
| Local dev server | `bundle exec jekyll serve` (or `rake dev`) |
| Local build | `bundle exec jekyll build` (or `rake build`) |
| Clean generated `_site` | `rake clean` |
| Install gems | `bundle install` (delete `Gemfile.lock` first if errors) |
| Render a Quarto page | `quarto render <path>.qmd` (run locally — CI does **not** do this) |

When previewing locally, use the trailing-slash URL: `http://127.0.0.1:4000/nccs/` (the `baseurl` in `_config.yml` requires it).

## Architecture

### Jekyll content model

Three custom collections are configured in `_config.yml`, each with its own default layout (set under `defaults:`):

- `_datasets/` → `dataset` layout (sidebar grid)
- `_resources/` → `resource` layout
- `_stories/` → `story` layout

Layouts live in `_layouts/`, shared partials in `_includes/`, site-wide YAML data in `_data/`, SCSS source in `public/scss/`. Top/footer navigation is driven by the `nav` / `footer_nav` arrays in `_config.yml`, not hard-coded in templates.

### Quarto pipeline (`.qmd` → `.md` → Jekyll HTML)

`_quarto.yml` is configured so Quarto renders `.qmd` files in `_stories/` (and `catalogs/`, which has its own `_quarto.yml`) to GFM Markdown **in place**, alongside `_files/` asset folders. Jekyll then picks up the `.md` and renders the page through the normal layout pipeline. Key consequences:

- **Quarto rendering is a manual local step.** CI (`.github/workflows/build.yml`) only runs `bundle exec jekyll build` — it does **not** invoke `quarto render`. Any change to a `.qmd` must be re-rendered locally and both the `.qmd` and resulting `.html`/`.md` + `_files/` committed together, or the live site keeps the stale output.
- Quarto output targets GFM (no Bootstrap), so Bootstrap-dependent callouts/layout classes won't work in `.qmd` content.
- `.qmd` files are listed under `exclude:` in `_config.yml` so Jekyll ignores them directly.

### Catalogs subsystem (`catalogs/`)

A separate Quarto project (`catalogs/_quarto.yml`) that renders data catalog pages for NCCS S3 datasets (BMF, Core, eFile, Census, NTEEV2). The manifest CSVs (`AWS-*.csv`) are committed to the repo and refreshed manually:

- `catalogs/get-aws-files.R <kind>` rebuilds the manifest by listing S3 prefixes in the public `nccsdata` bucket (requires AWS SSO login and credentials exported to env vars; see `catalogs/README.md` for the full BMF refresh procedure).
- After updating a manifest, re-render the corresponding `catalog-*.qmd` and commit the `.csv`, `.qmd`, `.html`, and `_files/` together.

### Deployment

GitHub Pages serves from `main` directly (no Action publishes the site). The `Build Validation` workflow only verifies that `jekyll build` succeeds on push/PR to `main`/`master`. Activating Pages: Settings → Pages → Deploy from Branch → `main`.

## Content authoring conventions

- Per-collection `readme.md` files inside `_datasets/`, `_resources/`, `_stories/` document the accepted frontmatter fields (these `readme.md`s are gitignored from Jekyll output via `_config.yml` exclude).
- Author/citation frontmatter follows the [Quarto citation](https://quarto.org/docs/authoring/create-citeable-articles.html) shape. Prefer `author.id` referencing an entry in `_data/people.yml` over inlining `name`/`bio`.
