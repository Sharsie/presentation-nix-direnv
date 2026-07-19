# Try it in 60 seconds

Install Nix (Determinate Systems installer — flakes on by default):

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

<v-click>

Linux, macOS, WSL. Uninstall is clean.

</v-click>



<!--
Flakes not enabled by default using official installer
Also nix command

Talk about experimental features and how all of internet uses flakes
-->

---

# Multi-user vs Single-user install

Determinate Systems installer assumes multi-user setup.

- It requires sudo.
- Use if at all possible.
- Creates users and a group for nix build jobs

<v-click>

<hr class="my-4 border-t opacity-20">

Watch out for pre-existing user ID and group ID conflicts.

You can modify these with args to the `install` script, e.g.

```bash
--nix-build-user-id-base 375 --nix-build-group-id 375
```

</v-click>

<v-click>

<hr class="my-4 border-t opacity-20">

## No `sudo`? No problem.

- Single-user installation is officially supported on Linux
- Unofficially supported on macOS by me at [deck.c3c.cz/nix-macos-rootless](https://deck.c3c.cz/nix-macos-rootless)

</v-click>

<v-click>

macOS version is a hack, but works. Follow the instructions. Seriously.

</v-click>

<!--
Mention what multi-user does - build users, read-only filesystem, daemon

Stress that where possible, multi-user is THE WAY.

Quickly touch on Mac Dynamic Libraries and path rewriting.
-->

---

# The other half: `direnv`

```bash
nix profile add nixpkgs#direnv
```

<v-click>

Hook it into your shell (`.bashrc` / `.zshrc`):

```bash
eval "$(direnv hook bash)"   # or zsh, fish, ...
```

</v-click>

<v-click>

More at [direnv.net](https://direnv.net)

</v-click>

<!--
Nix alone gets you `nix develop`. direnv is what makes it automatic on `cd`.

Hook goes at the very end of the rc file, after prompt setup.
-->

---
layout: center
class: text-center
---

# Live

```bash
nix shell nixpkgs#cowsay nixpkgs#lolcat
```

<div class="opacity-60 mt-4">a throwaway env — no flake, no commitment</div>

<v-click>

Need a specific version?

```bash
nix shell "github:nixos/nixpkgs/51e2b64e"#cowsay nixpkgs#lolcat
```

</v-click>

<v-click>

Want to run this deck?

```bash
nix run "github:Sharsie/presentation-presentation-nix-direnv"
```

</v-click>

<!--
LIVE TERMINAL.
  nix shell nixpkgs#{cowsay,lolcat}
  cowsay "locked tools, zero setup" | lolcat
  exit   ->   gone, nothing installed globally.
Point: prototyping is instant; a flake just makes it permanent + shareable.

[click] Pin the nixpkgs revision that has it — and mix revisions freely in one shell:

Can be the only reason you use nix. Just for throwaway envs.

Replaces docker for throwaway tooling — any package, no prebuilt images.

[click] Deck run: first run builds the whole deck, takes a few minutes
-->
