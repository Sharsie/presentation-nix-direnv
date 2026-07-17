# A real, minimal nix flake

A flake is just an attribute set: you define it, Nix consumes it.

<<< @/snippets/flake-minimal.nix nix {all|4|6-9|all}

<v-after>

One input (nixpkgs), one default output: "hello world" app provided by nix package manager.

</v-after>

<v-click>

```sh
$ nix run
Hello, world!
```

</v-click>

<!--
[click:1] Inputs are generally other flakes. Can be other resources, like binaries if you need to pull something specific in.

Can be a local path

`nixos-unstable` in this example refers to a specific branch of the repo

[click:1] outputs are what the flake gives us, in this case, it provides us with a single hello package - imagine docker running a hello image

[click:2] nix run triggers the default app, apps can have different names, remember it's just another attribute set.
-->

---

# A real, minimal dev environment

<<< @/snippets/flake-devshell.nix nix {6-14|6|7-9|10-13|all|11-12|8}

<div v-click="4">

```sh {1,2|3,4|5,6}{at:'5'}
$ hello
command not found: hello
$ nix develop
Hello from devshell!
$ hello
Hello, world!
```

</div>

<!--
Now creating a shell - devshell to be specific.

Flakes assume that users work with computers.

And they likely need an environemnt. devShells provide that out of the box.

[click:1] mkShell - just a package. Package that consumes 1 argument - an attribute set with settings - package that creates a shell environment.

[click:1] This is where we differ from docker. We can specify any packages to be in our shell

[click:1] and optionally have custom entry scripts
-->
