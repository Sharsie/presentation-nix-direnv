---
theme: seriph
title: 'Nix + direnv — Modern DevOps framework/approach with TF & IaC'
favicon: '/favicon.svg'
info: |
  ## Nix + direnv for reproducible dev environments
  Stop maintaining README setup sections. Every repo carries
  its own pinned toolchain — loaded the moment you enter it.
transition: fade-out
mdc: true
# Presenter mode (and its /presenter /overview /notes /entry routes) exists
# only in the dev server (`nix run`) used for live presenting — it is compiled
# out of `slidev build`, so the public static/server deployments can't reach it.
presenter: dev
flavor: generic
# This slide is headmatter-only and hidden; the whole deck body (title slide +
# sections) is imported below, so every slides-<flavor>.md shares one source.
# Keep only flavor-varying keys (title, flavor) different between entry files.
# Don't put `src` in THIS block — headmatter keys would then override every
# slide's own frontmatter down the import chain.
hide: true
---

---
src: ./deck.md
---
