# CLAUDE.md — nix-envs-for-iac

Conference talk (~40 min) for a DevOps audience: **Nix + direnv for
reproducible IaC tooling** — loading a local environment that matches the
expected tooling. Practical focus: Terraform, Terragrunt, Python (e.g. Lambdas);
skills generalize across the SDLC. The repo dogfoods its own thesis — built and
run through a Nix flake + direnv.

Slide count is not predefined — driven by content, set once the full outline
exists.

Design specs:
- Tooling/structure: `docs/superpowers/specs/2026-06-11-nix-envs-for-iac-presentation-design.md`.
- **Content outline (slide beats, the source of truth for authoring):**
  `docs/superpowers/specs/2026-06-11-nix-envs-for-iac-content-outline-design.md`.

## Content outline

**Spine (one takeaway):** *`cd` into any repo and you already have exactly the
right tools — pinned, reproducible, zero setup.*

Arcs (full beats + ~40-min budget in the content-outline doc):

1. Tooling pain → one tool (slides) — tfenv/pyenv/asdf mess vs. nix+direnv; Docker rebuttal; signature diagram.
2. What is Nix (slides) — short; scoped to flakes/per-repo; learning-curve gag (swirl + hangmen + ladders + graveyard).
3. Syntax (slides, +live bonus if time) — `{}` → minimal one-input flake devShell, built via line-focus.
4. direnv in action (**LIVE terminal**) — `cd` → pinned tf/terragrunt/python appear. The money shot. Dogfood `cat .envrc` here.
5. Beyond dev (slides, **no code**) — "not just another tfenv"; same env feeds CI + prod images; name-drop NixOS/home-manager/nix-darwin.
6. Getting started (**LIVE terminal**) — install on Linux/macOS; `nix-shell -p` throwaway env.

Live demos: Arc 4 + 6 only, real terminal, **no fallback**. Every arc opens with
intro slides. **Dogfood thread:** the deck itself runs on the flake + direnv it
describes — surface it (Arc 4 or ending).

## Stack

- **Slidev** deck, theme `seriph`, authored in markdown.
- **pnpm** package manager (`pnpm-lock.yaml` committed → reproducible flake build).
- **Nix flake** for build/run; **direnv** (`.envrc` = `use flake .`) auto-loads the shell.

## Commands

| Goal | Nix (user runs) | Plain (agent smoke-test) |
|------|-----------------|--------------------------|
| Dev server (live reload) | `nix run` | `pnpm install && node node_modules/@slidev/cli/bin/slidev.mjs slides.md` |
| Static HTML export | `nix build` → `result/` | `pnpm install && node node_modules/@slidev/cli/bin/slidev.mjs build slides.md --base ./` |
| Dev shell | `nix develop` | — |

**Jail gotcha — no `/usr/bin/env`.** The agent env lacks `/usr/bin/env`, so any
bin invoked through a `#!/usr/bin/env node` shebang fails with:

```
/usr/bin/env: bad interpreter: No such file or directory
```

`npx slidev` and `pnpm exec slidev` both hit this (they exec the shebang). And
pnpm's `node_modules/.bin/slidev` is a **shell-script shim** (not a JS symlink
like npm's), so `node node_modules/.bin/slidev` fails with a JS `SyntaxError`.
**Invoke the real JS entry directly:**
`node node_modules/@slidev/cli/bin/slidev.mjs …`. (Under real nix `/usr/bin/env`
exists, so the flake's `pnpm exec slidev` is fine — this only bites the agent.)

`pnpm-lock.yaml` is committed (the flake build reads it). Don't commit
`package-lock.json`.

First `nix build` fails and prints the real `pnpmDeps` hash — replace
`pkgs.lib.fakeHash` in `flake.nix`, rebuild, then commit `flake.nix` +
`pnpm-lock.yaml` together.

## Layout

- `deck.md` — shared deck body: title slide + one `src:` block per section.
  All flavors render this same content.
- `slides.md` / `slides-<flavor>.md` — per-flavor entries: headmatter only
  (differing `title` + `flavor` key) with `hide: true`, then a single
  `src: ./deck.md` slide. The flake auto-discovers `slides-<flavor>.md` as
  `nix run .#<flavor>`; adding a flavor = adding one such file, no flake edit.
  Never put `src:` inside the headmatter block itself — headmatter keys would
  override every imported slide's own frontmatter.
- `pages/` — one markdown file per section. Keep files small/focused (reliable
  LLM edits). `00-template.md` is the pattern reference; delete once real
  sections exist.
- `snippets/` — real `.tf` / `.nix` / `.envrc` files, transcluded into slides via
  `<<< @/snippets/<file> <lang> {lines}`. Single-source, syntax-valid.
- `components/` — custom Vue, only when a slide truly needs it (rare).
- `public/` — images / static assets.

## Slidev gotchas

**Static asset `src` in slide HTML.** Use `:src="'/file.svg'"` (Vue binding),
not `src="/file.svg"` (plain attribute). Plain `src` triggers Vite's asset
pipeline, which tries to resolve the path on the filesystem and fails with
`resolves outside of Vite server.fs.allow`. The binding form is a runtime URL,
so Vite ignores it and the browser fetches it from `public/` normally.

## Authoring conventions

- **Interactivity is deliberately minimal:** `v-click` reveal, step code
  highlighting (`​```hcl {1|3-5|all}`), and fade transitions
  (`transition: fade-out`). **No** flying/spinning motion, **no** hand-written JS
  unless a single slide genuinely requires a Vue component.
- **Demo is live** over Zoom screen-share (real terminal). No recorded casts.
- Add a section: create `pages/NN-name.md`, wire a `src: ./pages/NN-name.md`
  block into `deck.md` (shared by all flavors).

## Status

Scaffold + flake + skeleton done. **Content outline approved** (see Content
outline section above + its spec doc). **Slide prose + snippets + art are TODO** —
`pages/` holds only the template so far.

Read docs/superpowers/plans/2026-06-11-nix-envs-for-iac-slide-authoring.md for slide authoring.

## Deployment (lab project)

This repo is wired as a **lab project** — deployed to the cluster at
**nix-iac.c3c.cz**. Read `lab/SKILL.md` (this user's global lab conventions
skill) for the full picture; summary below.

- `nix build` (default package) still exports the raw static deck to
  `./result`, unchanged from before — that workflow is untouched.
- `nix build .#server` builds a small Go binary
  (`cmd/nix-flakes-with-iac/main.go`) that embeds the static export
  (spliced in via the flake's `srcWithStatic`) and serves it, plus
  `/livez` + `/readyz` for k8s probes. This is the only reason a `go.mod`
  exists in an otherwise-Slidev repo.
- `nix build .#container-amd64` / `.#container-arm64` — OCI images.
- `nix run .#push` — multi-arch push to
  `docker.io/docksee/lukas-cech-nix-flakes-with-iac`.
- `.gitea/workflows/build.yaml` — CI: builds + pushes on every `main` push
  and every tag, then bumps `image.tag` in the sibling chart repo
  `git.c3c.cz/lukas-cech/nix-flakes-with-iac-chart` (`values.yaml`).
  **No staging environment** for this project (explicit user decision) —
  every push is a production deploy, unlike the lab default of a
  staging/production split.
- Remotes: `origin` → `git@git.c3c.cz:lukas-cech/nix-flakes-with-iac.git`
  (gitea, primary). `public` → the original GitHub repo, kept as a mirror.
