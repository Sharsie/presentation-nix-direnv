# What is Nix (in a jiffy)

<v-clicks>

- Language
- Package manager
- <span class="opacity-50">OS (NixOS)</span>

</v-clicks>
<div class="mt-8">
<v-click>

- **Declarative** — describe the environment, not the install steps
- **Reproducible** — exact versions by hash, reproducible anywhere
- **Isolated** — no global installs, no version clashes

</v-click>
</div>
<v-click>

That's all you need today.

</v-click>

<!--
nixpkgs - brief explanation of what it is - repository of packages, source of truth for the nix package manager

[click:5] Don't focus on the whole nix ecosystem, it is too large to digest at first
-->

---

# Down the rabbit hole

<div class="grid grid-cols-2 gap-8 items-start pt-4">
<div>

Hey there's something cool up there!

<v-clicks>

AHA!

Huh?

I see...

No... wait

</v-clicks>

<v-click>

**Steep climb. The plateau sits way above where you started.**

</v-click>

</div>
<div class="relative mx-auto" style="height: 420px; aspect-ratio: 1200 / 1550;">

<img v-show="$slidev.nav.clicks < 2" :src="'/slide12-state1.png'" class="absolute inset-0 w-full h-full object-contain transition-opacity duration-300" />

<img v-show="$slidev.nav.clicks >= 2 && $slidev.nav.clicks < 3" :src="'/slide12-state2.png'" class="absolute inset-0 w-full h-full object-contain transition-opacity duration-300" />

<img v-show="$slidev.nav.clicks >= 3 && $slidev.nav.clicks < 4" :src="'/slide12-state3.png'" class="absolute inset-0 w-full h-full object-contain transition-opacity duration-300" />

<img v-show="$slidev.nav.clicks >= 4 && $slidev.nav.clicks < 5" :src="'/slide12-state4.png'" class="absolute inset-0 w-full h-full object-contain transition-opacity duration-300" />

<img v-show="$slidev.nav.clicks >= 5" :src="'/slide12-state5.png'" class="absolute inset-0 w-full h-full object-contain transition-opacity duration-300" />

<img v-show="$slidev.nav.clicks >= 5" :src="'/slide12-figure-confused-overlay.png'" class="absolute transition-opacity duration-300" style="left: 42%; top: 26.5%; width: 6.4%; height: auto;" />

</div>
</div>

<!--
Nix is overwhelming at first.

Don't explore everything, at once.

Focus.
-->

---

# The one ladder we care about

<v-click>

**A flake. Per repo.**

</v-click>

<v-click>

- One file: `flake.nix`
- Committed, versioned alongside the code
- Describes the environment for *this* project

</v-click>

<div class="mt-16">
<v-click>

Ignore everything else the internet tells you about Nix.

</v-click>

<v-click>
For now.
</v-click>
</div>

<!--
When we talk about nix here, we are really talking about nix flakes.

Experimental. For Years. De-facto standard nowdays


[click:4] Set-up stage for the next slides that touch on the complexity.

Why is it important to focus on this one thing.

Own learning process difficulty, wanting to give up.

Upside with AI today.

Close with how powerful tool this is.
- not just projects
- not just environments
- entire systems can be declared, not like ansible
- powerful rollbacks with git and generations
-->

---

<div class="relative w-full h-full overflow-hidden bg-white">
<svg viewBox="0 0 1280 720" class="absolute inset-0 w-full h-full">
<defs>
<linearGradient id="nixFade" x1="90" y1="0" x2="800" y2="0" gradientUnits="userSpaceOnUse">
<stop offset="0%" stop-color="#2f7a3d" />
<stop offset="75%" stop-color="#2f7a3d" />
<stop offset="100%" stop-color="#111111" />
</linearGradient>
</defs>
<text x="640" y="45" text-anchor="middle" style="font-family:sans-serif;font-size:28px;font-weight:bold;" fill="#222">LEARNING CURVE</text>
<!-- axes -->
<line x1="90" y1="670" x2="90" y2="55" stroke="#333" stroke-width="3" />
<polygon points="90,40 82,58 98,58" fill="#333" />
<line x1="90" y1="670" x2="1255" y2="670" stroke="#333" stroke-width="3" />
<polygon points="1270,670 1252,662 1252,678" fill="#333" />
<text transform="translate(38,400) rotate(-90)" text-anchor="middle" style="font-family:sans-serif;font-size:18px;" fill="#333">ABILITY TO DO THINGS</text>
<text x="600" y="705" text-anchor="middle" style="font-family:sans-serif;font-size:18px;" fill="#333">TIME SPENT LEARNING</text>
<!-- windows: thin, low, nearly flat -->
<path d="M90,655 C 400,645 800,610 1140,600" stroke="#111111" stroke-width="3" fill="none" />
<!-- linux: one small jump, flattens a bit above windows, gentle rise (not a dip) at the tail -->
<path d="M90,650 C 300,640 460,630 500,600 L540,556 C 750,538 950,528 1140,516" stroke="#2b6cb0" stroke-width="3" stroke-dasharray="10 7" fill="none" />
<!-- nixos: flat like the others, then fades into ink right as it reaches the swirl art -->
<path d="M90,645 C 350,640 600,635 800,628" stroke="url(#nixFade)" stroke-width="5" fill="none" transform="translate(47, 185) scale(0.485)" />
<!-- nixos continues: picks back up where the swirl's plateau ends, carrying the climb on into the distance -->
<path d="M716,218 C 850,213 1050,208 1240,202" stroke="#2f7a3d" stroke-width="4" fill="none" transform="translate(-10, 355) rotate(-25, 0, 0)" />
<!-- legend -->
<g fill="#222">
<line x1="120" y1="88" x2="158" y2="88" stroke="#111111" stroke-width="3" />
<text x="168" y="93" style="font-family:sans-serif;font-size:17px;">Windows</text>
<line x1="120" y1="118" x2="158" y2="118" stroke="#2b6cb0" stroke-width="3" stroke-dasharray="8 6" />
<text x="168" y="123" style="font-family:sans-serif;font-size:17px;">Linux</text>
<line x1="120" y1="148" x2="158" y2="148" stroke="#2f7a3d" stroke-width="5" />
<text x="168" y="153" style="font-family:sans-serif;font-size:17px;">NixOS</text>
</g>
</svg>
<img :src="'/nixos-mountain.png'" class="absolute inset-0 w-full h-full object-contain pointer-events-none" style="left: 0%; top:0%;transform: scale(0.5)" />
</div>

<!--
How this relates to my own experience
- understanding bits of syntax, parts of declaration
- having no clue about the rest
- giving up
- angry due to own inability
- then it clicks
-->
