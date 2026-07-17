---
layout: two-cols-header
---

# Multi arch & Multi system

::left::

<div class="mr-1">

```nix {all|13,16|all}
{
  description = "IaC dev environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";


  outputs = {
    self,
    nixpkgs

  }:

    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        # config
      };
    };
}
```

</div>

::right::

<div v-click="2" class="ml-1">

```nix {4,9|11,19|13,16|all}{at:'3'}
{
  description = "IaC dev environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils
  }:
    flake-utils.lib.eachDefaultSystem ( system:
    let
      pkgs = import nixpkgs { system = system; };
    in
    {
      devShells.default = pkgs.mkShell {
        # config
      };
    });
}

```

</div>

<!--
[click:2] Numtide

Organization that manages a lot of unofficial nix components and packages

[click] eachDefaultSystem is a function that consumes a function

It then calls the function with the system argument
-->
