# PLAN — Generalize the deck for a broader dev audience

## Goal

The `generic` flavor (`slides.md`) should speak to any developer — Node.js, Go,
Python, Java, C++ — with no IaC/DevOps assumptions. The `devops` flavor
(`slides-devops.md`) keeps everything exactly as it is today. Deck form,
imagery, arc structure, and slide count stay the same; only devops-specific
*content* (words, code snippets, icon overlays) gets a generic counterpart.

## Mechanism (already established, reuse it)

All flavors share `deck.md` → `pages/*`. Flavor branching is done inline with:

```html
<template v-if="$slidev.configs.flavor === 'devops' || $slidev.configs.flavor === 'atlas'">
  …devops content (unchanged)…
</template>
<template v-else>
  …generic content…
</template>
```

`atlas` is a devops-audience variant — it keeps following the devops branch
everywhere (except its existing whoami joke). **Generic is always the
`v-else`**, so any future flavor defaults to the generic content.

Rule of thumb per slide: if the devops-specific bit is a throwaway word
(a code comment, a `description =` string), neutralize it for all flavors
instead of duplicating a whole code block. If it's substantive (tool lists,
snippets, icon overlays, demo commands), branch by flavor.

---

## File-by-file changes

### `slides.md` (generic entry)
- `title`: `'Nix + direnv — Modern DevOps framework/approach with TF & IaC'`
  → something stack-neutral, e.g. `'Nix + direnv — reproducible dev
  environments, zero setup'`. The `info` block is already generic.

### `pages/00-whoami.md`
- Currently two branches: `atlas` (joke) and else (devops credibility bullets:
  "IaC and CI/CD setups", "terraform+terragrunt daily"). Split into three:
  - `atlas`: unchanged.
  - `devops`: current bullets, unchanged.
  - else (generic): reworded credibility — same shape, no IaC jargon. E.g.:
    - "20+ years across development and ops — I build the environments other
      teams inherit; when tooling breaks, it breaks on my street"
    - "Daily driver across Python, Go, Node.js and infra tooling — not a
      drive-by opinion"
    - "This very deck runs on the setup I'm about to show you" (keep)
- Keep "DevOps Architect" in the byline — it's his actual title, fine for any
  audience.

### `pages/01-pain.md`
- **Slide 1 (tool zoo list):** already branched. Improve the generic branch —
  drop `tenv` (IaC-specific) and broaden:
  - `nvm` — locks Node.js
  - `pyenv` — locks Python
  - `sdkman` — locks Java/JVM tools
  - `gvm` — locks Go
  - `asdf` — locks whatever has a plugin, nothing underneath it
- **Slide 2 (drift table):** already branched (node/python generic). No change.
- **Slide 3 ("Just use Docker"):** already generic. No change.
- **Slide 4 (zoo vs. snow art) — the icon-overlay work.** Backgrounds
  (`tools-vs-nix-zoo.png`, `tools-vs-nix-snow.png`) stay for both flavors;
  only the overlaid icons/labels change. Wrap each overlay set (not the
  background `<img>`) in the flavor template:
  - devops/atlas branch: current overlays verbatim (terraform, terragrunt,
    opentofu, tenv, tfenv text, tgenv, pyenv, asdf, docker; snow side:
    terraform/terragrunt/opentofu/python/node + nix+direnv sign).
  - generic branch, same cage/guardian slot positions, swapped occupants:
    - cage 1: Node.js icon, guardian `nvm` (text label, same style as the
      current `tfenv` text)
    - cage 2: Java icon, guardian `sdkman` (text label)
    - cage 3: Go icon, guardian `gvm` (text label)
    - cage 5: Python icon, guardian pyenv icon (unchanged)
    - pool: keep the rotated Node.js-in-pool gag or swap for C++ icon —
      pick whichever reads better once rendered; `asdf` text + docker whale
      stay as-is.
    - snow side: nix + direnv sign unchanged; scattered tools become
      node / python / java / go (+ keep the rotated node in the snow).
  - Positions are tied to the background art, so the generic branch reuses the
    same `left/top/width` values — only `src` and labels differ. Accept the
    duplication; it's the established pattern and keeps coordinates editable
    per flavor if icons need nudging.
- **Slide 5 ("One tool to lock them all"):** generic. No change.

### `pages/02-what-is-nix.md`, `pages/03-syntax.md`, `pages/03-flakes.md`
- Already stack-neutral (hello-world, repl, rabbit-hole art, learning curve).
  No changes.

### `pages/04-direnv.md`
- File-tree drawing shows `iac-project/`. Branch the one `<div>` line:
  devops/atlas → `iac-project/`, generic → `my-project/`. Everything else
  stays.

### `pages/04-real-world.md` (biggest change)
- Heading "Flake with IaC tools" → branch: devops keeps it; generic gets
  "Flake with real tools".
- **New snippet** `snippets/flake-project.nix` — generic twin of
  `flake-iac.nix`: same shape/line count so the step-highlight line ranges
  (`{17-21|8-14}`, `{15-23}`) still land correctly, with packages e.g.
  `pkgs.nodejs_22`, `pkgs.python312`, `pkgs.go`. Keep
  `config.allowUnfree = true;` with comment
  `# some packages are unfree (e.g. vscode, terraform)` so the unfree
  teaching beat survives without terraform context. Verify line numbers after
  writing; adjust highlight ranges per-branch if they drift.
- Branch the two `<<< @/snippets/flake-iac.nix` transclusions and the inline
  `pkgs.python312 pkgs.opentofu # ...` block (generic:
  `pkgs.nodejs_22 pkgs.go # ...`). The let-in/currying teaching flow in
  between is generic — leave it shared.
- **Live demo slide:** branch:
  - devops/atlas: `cd ./demo/iac-project`, tagline
    "terraform · terragrunt · python — locked, instantly" (unchanged).
  - generic: `cd ./demo/my-project`, tagline
    "node · go · python — locked, instantly".
- Presenter notes: extend to cover both demo scripts (`terraform -version`
  vs. `node --version` / `go version`).

### `pages/04-multi-arch.md`
- Only devops-ism is `description = "IaC dev environment"` inside the two
  inline code columns. Neutralize to `"dev environment"` for all flavors
  rather than duplicating two 30-line code blocks for one string.

### `pages/05-beyond-dev.md`
- Heading "This is not just another tfenv" → branch: devops keeps it;
  generic: "This is not just another version manager" (or "…another nvm").
- Arrows diagram (Dev Shell / CI Job / Prod Image) and "whole machines" slide
  are already universal. No change.

### `pages/06-getting-started.md`, `pages/07-end.md`, `pages/08-credits.md`, `pages/00-open.md`
- Already generic (install, direnv hook, cowsay demo, links). No changes.

### `snippets/let-expression.nix`
- Comment `# terraform is unfree` → `# if using unfree packages` (shared by
  both flavors; loses nothing for devops).

### `snippets/flake-iac.nix`, `flake-iac-multiarch.nix`, `flake-minimal.nix`, `flake-devshell.nix`
- Unchanged (first two are now devops-branch-only; last two are shared and
  already generic).

---

## New assets

`public/icons/` additions (official brand SVGs — source from Simple Icons or
the projects' press kits; do **not** generate logos with FLUX):
- `java.svg` (or Duke), `go.svg`, `cpp.svg` (if the pool gag uses it).
- `nvm`, `sdkman`, `gvm` have no usable logos → render as styled text labels,
  same treatment as the existing `tfenv` text div.

No new background art needed — explicitly keeping `tools-vs-nix-zoo.png`,
`tools-vs-nix-snow.png`, rabbit-hole/mountain/swirl art for all flavors.

## New demo directory

`demo/my-project/` — generic twin of `demo/iac-project/`:
- `flake.nix`: multiarch shape (flake-utils, `eachDefaultSystem`), packages
  `nodejs_22`, `python312`, `go`; description "dev environment".
- `.envrc`: `use flake .` (same as existing).
- Commit `flake.lock`; pre-warm (`direnv allow` + `nix develop`) before
  presenting — live demo has no fallback.
- `demo/iac-project/` stays untouched for the devops flavor.

## Docs to touch after implementation

- `CLAUDE.md`: note the generic-vs-devops content split and the new demo dir.
- Content-outline spec
  (`docs/superpowers/specs/2026-06-11-nix-envs-for-iac-content-outline-design.md`):
  short addendum describing the flavor branching, so it stays the source of
  truth.

## Verification

- `pnpm install && node node_modules/@slidev/cli/bin/slidev.mjs build slides.md --base ./`
  (and same for `slides-devops.md`, `slides-atlas.md`) — all three must build.
- Render/eyeball the zoo slide in both flavors — icon slot positions were
  tuned to the art; generic icons may need per-icon nudges.
- Step through 04-real-world in both flavors — confirm highlight line ranges
  still match after the snippet swap.
- `cd demo/my-project && nix develop` — tools actually appear.

## Open decisions (defaults chosen, flag if you disagree)

1. **Neutralize vs. branch trivia:** `IaC dev environment` descriptions and
   the `terraform is unfree` comment are neutralized for *all* flavors
   (devops loses two cosmetic strings). Branching them would double three
   code blocks for no audience value.
2. **Generic tool trio:** node + go + python chosen for the generic snippet
   and demo (broad, fast to `nix develop`). Java (JDK) inflates demo download
   size; it appears on the zoo slide but not in the demo flake.
3. **Zoo pool occupant (generic):** keep the drowning Node.js gag vs. swap in
   C++. Keeping Node is zero-work; decide at render time.
