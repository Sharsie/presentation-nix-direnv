---
layout: statement
---

# This is not just another tfenv

<v-click>

Version managers stop at your shell.<br>
This definition doesn't.

</v-click>

<!--
or tenv, or pyenv or whatever
-->

---

<div class="relative w-full h-full">

<svg viewBox="0 0 100 100" preserveAspectRatio="none" class="absolute inset-0 w-full h-full">
<defs>
<marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="4" markerHeight="4" orient="auto-start-reverse">
<path d="M0,0 L10,5 L0,10 z" fill="var(--slidev-theme-primary)" />
</marker>
</defs>
<g v-click="1">
<path d="M28,47 C 45,47 45,25 66,25" fill="none" stroke="var(--slidev-theme-primary)" stroke-width="0.4" marker-end="url(#arrow)" />
</g>
<g v-click="2">
<path d="M28,50 L66,50" fill="none" stroke="var(--slidev-theme-primary)" stroke-width="0.4" marker-end="url(#arrow)" />
</g>
<g v-click="3">
<path d="M28,53 C 45,53 45,75 66,75" fill="none" stroke="var(--slidev-theme-primary)" stroke-width="0.4" marker-end="url(#arrow)" />
</g>
</svg>

<div class="absolute flex items-center gap-3 rounded-lg p-4" style="left: 6%; top: 50%; width: 22%; transform: translateY(-50%); border: 1.5px solid var(--slidev-theme-primary);">
  <img :src="'/icons/nix.svg'" class="w-10 h-10 flex-none" />
  <div>
    <div class="font-mono font-bold">flake.nix</div>
    <div class="text-sm opacity-60">one definition</div>
  </div>
</div>

<div class="absolute flex items-center gap-3 rounded-lg p-4" v-click="1" style="left: 68%; top: 25%; width: 26%; transform: translateY(-50%); border: 1.5px solid var(--slidev-theme-primary);">
  <svg viewBox="0 0 24 24" class="w-8 h-8 flex-none" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <rect x="2" y="4" width="20" height="16" rx="2" />
    <path d="M6 9l3 3-3 3" />
    <line x1="11" y1="15" x2="16" y2="15" />
  </svg>
  <div>
    <div class="font-mono font-bold">Dev Shell</div>
    <div class="text-sm opacity-60">your laptop</div>
  </div>
</div>

<div class="absolute flex items-center gap-3 rounded-lg p-4" v-click="2" style="left: 68%; top: 50%; width: 26%; transform: translateY(-50%); border: 1.5px solid var(--slidev-theme-primary);">
  <svg viewBox="0 0 24 24" class="w-8 h-8 flex-none" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M18.178 8c5.096 0 5.096 8 0 8-5.095 0-7.133-8-12.739-8-4.744 0-4.744 8 0 8 5.606 0 7.644-8 12.739-8z" />
  </svg>
  <div>
    <div class="font-mono font-bold">CI Job</div>
    <div class="text-sm opacity-60">your pipeline</div>
  </div>
</div>

<div class="absolute flex items-center gap-3 rounded-lg p-4" v-click="3" style="left: 68%; top: 75%; width: 26%; transform: translateY(-50%); border: 1.5px solid var(--slidev-theme-primary);">
  <img :src="'/icons/docker.svg'" class="w-8 h-8 flex-none" />
  <div>
    <div class="font-mono font-bold">Prod Image</div>
    <div class="text-sm opacity-60">your image</div>
  </div>
</div>

</div>

<!--
[click] build shells on user computers

[click] build apps in pipelines

[click] build images, OCI compliant, that can run as any other image you are used to
-->

---

# One step further: whole machines

<v-click>

The same package set that fills a shell can define an entire system.

</v-click>

<v-click>

## System configuration

- **NixOS** — the operating system
- **nix-darwin** — the same idea, on macOS
- **home-manager** — your user environment

</v-click>

<v-click>

Each of those is its own talk. Today: just know the door is there.

</v-click>
