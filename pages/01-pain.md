# The tool zoo

<template v-if="$slidev.configs.flavor === 'devops' || $slidev.configs.flavor === 'atlas'">

You manage infra. So you install tools. Then you manage the tools.

<v-click>

- `tfenv` — locks Terraform
- `tgenv` — locks Terragrunt
- `tenv` — locks a bunch of IaC tools
- `pyenv` — locks Python
- `asdf` — locks whatever has a plugin, nothing underneath it

</v-click>

</template>

<template v-else>

You manage projects. So you install tools. Then you manage the tools.

<v-click>

- `nvm` — locks Node.js
- `pyenv` — locks Python
- `sdkman` — locks Java/JVM tools
- `gvm` — locks Go
- `asdf` — locks whatever has a plugin, nothing underneath it

</v-click>

</template>


<v-click>

A different lock for every tool. Each configured differently. Each set up by hand, per dev.

</v-click>

<!--
Explain the tool switching
- one project needs A
- other project needs B

Some tools provide additional tools to manage them, some don't

Some of them switch globally, some of them within terminal

Everyone has to install multiple tools to manage the tools

Version drift between people

-> next slide with examples
-->

---

# And it still drifts


<template v-if="$slidev.configs.flavor === 'devops' || $slidev.configs.flavor === 'atlas'">

```text
your laptop   terraform 1.9.5    python 3.11
teammate      terraform 1.9.1    python 3.12
CI runner     terraform latest   python 3.15
```

</template>

<template v-else>

```text
your laptop   node.js 22.1.2    python 3.11
teammate      node.js 22.4.1    python 3.12
CI runner     node.js latest    python 3.15
```

</template>

<v-click>

"Works on my machine" is a versioning bug with a nice cover story.

</v-click>

<!--
Unless all the tooling is configured properly, per-project tooling can still drift.

e.g. pinning TF to 1.9
-->

---

# "Just use Docker"

<v-click>

- Fine for *one* packaged tool or a single build step
- Painful when you want *many* tools, interactively
- Slow inner loop: rebuild, mount, exec, repeat
- Your editor, shell, and creds are suddenly "outside"

</v-click>

<!--
Explain the history

1. used docker

2. Needed composition -> used docker-compose

3. Needed functionality around composition -> used wrapper scripts

4. How do I develop this thing when it's all inside multiple containers?
-->

---
---

<div class="grid grid-cols-2 w-full h-full">

<div class="relative overflow-hidden">
  <img :src="'/tools-vs-nix-zoo.png'" class="absolute inset-0 w-full h-full object-cover" />

<template v-if="$slidev.configs.flavor === 'devops' || $slidev.configs.flavor === 'atlas'">
  <!-- tfenv -> Terraform (cage 1, top-left) -->
  <img :src="'/icons/terraform.svg'" class="absolute" style="left: 13%; top: 16.8%; width: 6%; transform: translate(-50%, -50%);" />
  <!-- tgenv -> Terragrunt (cage 2, top-mid) -->
  <img :src="'/icons/terragrunt.png'" class="absolute" style="left: 50.5%; top: 16.5%; width: 6%; transform: translate(-50%, -50%);" />
  <!-- tenv -> OpenTofu (cage 3, top-right) -->
  <img :src="'/icons/opentofu.svg'" class="absolute" style="left: 86.5%; top: 16.3%; width: 6%; transform: translate(-50%, -50%);" />
</template>
<template v-else>
  <!-- nvm -> Node.js (cage 1, top-left) -->
  <img :src="'/icons/nodejs.svg'" class="absolute" style="left: 13%; top: 16.8%; width: 6%; transform: translate(-50%, -50%);" />
  <!-- sdkman -> Java/JVM (cage 2, top-mid) -->
  <img :src="'/icons/java.svg'" class="absolute" style="left: 50.5%; top: 16.5%; width: 6%; transform: translate(-50%, -50%);" />
  <!-- gvm -> Go (cage 3, top-right) -->
  <img :src="'/icons/go.svg'" class="absolute" style="left: 86.5%; top: 16.3%; width: 6%; transform: translate(-50%, -50%);" />
</template>

  <!-- pyenv -> Python (cage 5, bottom-mid) -->
  <img :src="'/icons/python.svg'" class="absolute" style="left: 48%; top: 43%; width: 7%; transform: translate(-50%, -50%);" />
  <!-- pool swimmer -->
<template v-if="$slidev.configs.flavor === 'devops' || $slidev.configs.flavor === 'atlas'">
  <img :src="'/icons/terraform.svg'" class="absolute" style="left: 48%; top: 70%; width: 20%; transform: translate(-50%, -50%) rotate(15deg);" />
</template>
<template v-else>
  <img :src="'/icons/nodejs.svg'" class="absolute" style="left: 48%; top: 70%; width: 20%; transform: translate(-50%, -50%) rotate(15deg);" />
</template>

  <!-- guardians -->
<template v-if="$slidev.configs.flavor === 'devops' || $slidev.configs.flavor === 'atlas'">
  <!-- tenv -->
  <img :src="'/icons/tenv.png'" class="absolute" style="left: 69%; top: 22%; width: 8%; transform: translate(-50%, -50%);" />
  <!--tfenv -->
  <div class="absolute text-center font-mono font-bold" style="left: 10%; top: 23%; color: rgb(50, 62, 138); transform: translate(-50%, -50%);">tfenv</div>
  <!--tgenv -->
  <img :src="'/icons/tgenv.png'" class="absolute" style="left: 34%; top: 13%; width: 7%; transform: translate(-50%, -50%);" />
</template>
<template v-else>
  <!-- gvm -->
  <div class="absolute text-center font-mono font-bold" style="left: 69%; top: 22%; width: 8%; color: rgb(0, 130, 137); transform: translate(-50%, -50%);">gvm</div>
  <!-- nvm -->
  <div class="absolute text-center font-mono font-bold" style="left: 10%; top: 23%; color: rgb(50, 62, 138); transform: translate(-50%, -50%);">nvm</div>
  <!-- sdkman -->
  <div class="absolute text-center font-mono font-bold" style="left: 34%; top: 13%; color: rgb(196, 89, 17); transform: translate(-50%, -50%);">sdkman</div>
</template>

  <!--pyenv -->
  <img :src="'/icons/pyenv.png'" class="absolute" style="left: 32%; top: 52%; width: 7%; transform: translate(-50%, -50%);" />
  <!-- asdf -->
  <div class="absolute text-center font-mono font-bold" style="left: 55%; top: 55%; color: rgb(183,68,184); transform: translate(-50%, -50%) scale(3);">asdf</div>
  <!-- docker -> Docker whale (pool) -->
  <img :src="'/icons/docker.svg'" class="absolute" style="left: 54%; top: 83%; width: 7%; transform: translate(-50%, -50%);" />
</div>

<div class="relative overflow-hidden">
  <img :src="'/tools-vs-nix-snow.png'" class="absolute inset-0 w-full h-full object-cover" />

  <!-- nix + direnv, side by side on the sign -->
  <img :src="'/icons/nix.svg'" class="absolute" style="left: 66%; top: 39.6%; width: 11.5%; transform: translate(-50%, -50%);" />
  <img :src="'/icons/direnv.svg'" class="absolute" style="left: 66.3%; top: 30.5%; width: 9%; transform: translate(-50%, -50%);" />

  <!-- tools -->
<template v-if="$slidev.configs.flavor === 'devops' || $slidev.configs.flavor === 'atlas'">
  <img :src="'/icons/terraform.svg'" class="absolute" style="left: 33%; top:54.8%; width: 6%; transform: translate(-50%, -50%);" />
  <img :src="'/icons/terragrunt.png'" class="absolute" style="left: 40%; top: 56%; width: 6%; transform: translate(-50%, -50%);" />
  <img :src="'/icons/opentofu.svg'" class="absolute" style="left: 26%; top: 54.2%; width: 6%; transform: translate(-50%, -50%);" />
</template>
<template v-else>
  <img :src="'/icons/go.svg'" class="absolute" style="left: 33%; top:54.8%; width: 6%; transform: translate(-50%, -50%);" />
  <img :src="'/icons/java.svg'" class="absolute" style="left: 40%; top: 56%; width: 6%; transform: translate(-50%, -50%);" />
  <img :src="'/icons/nodejs.svg'" class="absolute" style="left: 26%; top: 54.2%; width: 6%; transform: translate(-50%, -50%);" />
</template>
  <img :src="'/icons/python.svg'" class="absolute" style="left: 72%; top: 60%; width: 7%; transform: translate(-50%, -50%);" />
</div>

</div>

<!--
After 5 years dealing with docker and tooling, discovered nix

combined it with direnv for ultimate happiness
-->

---
layout: statement
---

# One tool to lock them all

Declare every tool once in **Nix**.<br>
**direnv** loads it the moment you `cd` in.

<!--
Frees me to work on multiple projects at the same time without thinking about the requirements
-->
