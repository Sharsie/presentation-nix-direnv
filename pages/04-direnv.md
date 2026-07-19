# Enter `direnv` — The Automation

One file in the repo root:

<div class="font-mono text-base leading-8 opacity-90 mt-4">
<style scoped>
div {
  line-height: 1;
}
</style>
<template v-if="$slidev.configs.flavor === 'devops' || $slidev.configs.flavor === 'atlas'">
<div>iac-project/</div>
</template>
<template v-else>
<div>project/</div>
</template>
<div>├── flake.nix</div>
<div class="text-indigo-400 font-bold">└── .envrc</div>
</div>

<div class="mt-6" v-click>

`.envrc` contains:

<<< @/snippets/.envrc bash

</div>

<v-click>

`cd` in → direnv loads the flake's devShell into your shell.<br>
`cd` out → it's gone. No activate, no deactivate.

</v-click>

<!--
direnv separate from nix, can be used without nix, improves our lives, significantly

You can install direnv with nix

[click:2] Installed as a hook into your shell, e.g. `.zshrc`, `.profile`
-->
