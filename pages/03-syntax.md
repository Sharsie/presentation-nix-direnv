# Nix syntax — the one thing you need

A **Functional language**

```nix
args: fn
```

<v-click>

Function definition **ALWAYS** takes exactly **ONE** argument

</v-click>

<div v-click="2">

Use `nix repl` to explore

```nix {all|2|3,4}{at:'2'}
$ nix repl
nix-repl> increment = arg: arg + 1
nix-repl> increment 5
6
```
</div>

---

# Nix syntax

<div class="text-sm font-semibold text-indigo-400 mt-1 mb-3">Multi-arg functions chain functions together</div>

```nix {1-3|4|all|2|3,4|none}
fnDef =
  arg1:
  arg2:
    "arg1: ${arg1} | arg2: ${arg2}"
```
<div class="mt-8" v-click="2">

```nix {1|2|3}{at:'3'}
nix-repl> fnDef           # «lambda»
nix-repl> fnDef "🥄"      # «lambda»
nix-repl> fnDef "🥄" "🍨" # "arg1: 🥄 | arg2: 🍨"
```

</div>

<div v-click="4">

_Each `arg:` returns a new function — `fnDef "🥄" "🍨"` chains through both._

This is called **currying**.

</div>

<div v-click="5">

Layout is unimportant

<div class="flex items-center gap-6">
<div class="flex-1">

```nix
fnDef =
  arg1:
    ""
```

</div>
<div class="text-3xl font-bold text-center">=</div>
<div class="flex-1">

```nix
fnDef = arg1: ""


```

</div>
</div>

</div>

---

# Attribute sets

Many functions consume an attribute set as an argument

<v-click>

```nix
{
  tool = "my attribute set";
}
```
</v-click>

<div class="mt-8" v-click="2">

```nix {1|2,3}{at:'3'}
nix-repl> fnDef = arg: "eat ${arg.food} with ${arg.tool}"
nix-repl> fnDef {tool = "🥄"; food = "🍨";}
"eat 🍨 with 🥄"
```

</div>

<v-click at="4">

This concept is important when using nix flakes.

</v-click>

<v-click at="5">

Syntactic sugar

<div class="flex items-center gap-6">
<div class="flex-1">

```nix
{
  nested.attribute = "value";
}
```

</div>
<div class="text-3xl font-bold text-center">=</div>
<div class="flex-1">


```nix
{
  nested = { attribute = "value"; };
}
```

</div>
</div>


</v-click>

<!--
Dealing with position arguments cumbersome, attr sets to the rescue

[click:4] User defines an attribute set for the flake to consume

[click:1] Define nested objects, or change single attributes of large objects
-->
