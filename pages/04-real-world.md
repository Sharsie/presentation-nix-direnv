---
layout: statement
---

# Real-world example

Combine direnv with nix flakes

<!--
Talk about the presented minimal flakes - that just works

Mention system - and how we've so far only targeted linux and one arch.

In the next slides, IaC will be introduced into the mix.
-->

---

# Flake with IaC tools

<v-switch>
<template #0>

<<< @/snippets/flake-iac.nix nix {17-21|8-14}{at:'0'}

</template>
<template #2>

<<< @/snippets/let-expression.nix nix {1,6}

`let-in` expression allows you to define local variables

<div v-click="3">

Let can precede any expression, e.g. a returned `string`:

```nix
nix-repl> "b is 1"
"b is 1"
nix-repl> let b = "1"; in "b is ${b}"
"b is 1"
```

</div>

</template>
<template #4>

<<< @/snippets/let-expression.nix nix {2|3,4}{at:'5'}

`pkgs` instantiates a local variable -> imports the "package manager".

<div v-click="5">

`nixpkgs` is configured using an attribute set:

- sets the "package manager" system to `x86_64-linux`
- allows unfree packages

</div>

</template>
<template #6>

<div class="flex items-center gap-6">
<div class="flex-1">

```nix
let
  pkgs = import nixpkgs { system = "x86_64-linux"; };
in
pkgs.hello

```

</div>
<div class="text-3xl font-bold text-center">=</div>
<div class="flex-1">

```nix



nixpkgs.legacyPackages."x86_64-linux".hello
```

</div>
</div>

Creating a shortcut. `pkgs` is reused **A LOT**.

<div v-click="7">

```nix {2,4}
  devShells.x86_64-linux.default =
    pkgs.mkShell {
      packages = [
        pkgs.python312 pkgs.opentofu # ...
      ];
    };
```

</div>

<v-click at="8">

<div class="italic text-lg mt-2">

👀 ... and it lets us <span v-mark.circle.orange="7">automate system</span>

</div>

```nix
pkgs = import nixpkgs { inherit system; };
```

</v-click>

</template>
<template #9>

<<< @/snippets/flake-iac.nix nix {15-23}{at:'0'}

</template>
</v-switch>

<!--
Before we get to a live demo a few concepts

packages definition was already seen previously

We took a shortcut with pkgs

[click] New concepts introduced
- let-in
- pkgs instantiation

[click] Deconstructing let-in expression

[click:2] Import is just a built-in function

Talk about how we were passing the 🍨 and 🥄

[click:3] pkgs includes a lot of utility outside of just applications

Writing shell/python scripts

Includes system information

[click] More on that later

[click] This is what we are going to use for the live demo
-->

---
layout: center
class: text-center
---

# Live

```bash
cd ./demo/iac-project
```

<div class="opacity-60 mt-4">terraform · terragrunt · python — locked, instantly</div>

<!--
LIVE TERMINAL

- show terraform -version outside of demo
- cd into the demo dir
- show terraform -version inside the demo
- cat .envrc
- cd out

After demo - mention that the previous examples used hardcoded linux system - set up stage for next slide
-->
