{
  description = "Nix + direnv for reproducible IaC tooling — conference talk (Slidev deck)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodejs = pkgs.nodejs_22;
        pnpm = pkgs.pnpm_9;

        # Static HTML export of the deck (`slidev build`).
        deck = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "nix-envs-for-iac";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [
            nodejs
            pnpm
            pkgs.pnpmConfigHook
          ];

          # First `nix build` will fail and print the real hash — replace
          # pkgs.lib.fakeHash with it, then rebuild. (Agent cannot run nix.)
          pnpmDeps = pkgs.fetchPnpmDeps {
            inherit (finalAttrs) pname version src;
            inherit pnpm;
            fetcherVersion = 3;
            hash = "sha256-e0i5lzhGag0N470nxkLOlvcpGxZ7vJH6lbMdOTfFWyA=";
          };

          buildPhase = ''
            runHook preBuild
            pnpm exec slidev build slides.md --base ./
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            cp -r dist $out
            runHook postInstall
          '';
        });

        # Version policy: tagged build wins, otherwise rev-<shortRev>, otherwise
        # rev-<dirtyShortRev> when the worktree has uncommitted changes. We never
        # fall back to a literal "dev" — `scripts/push.sh` refuses anything that
        # looks like an unresolved version so we don't pollute the registry with
        # ambiguous tags.
        version =
          self.tag or (
            if self ? shortRev then
              "rev-${self.shortRev}"
            else if self ? dirtyShortRev then
              "rev-${self.dirtyShortRev}"
            else
              "no-version"
          );

        # Slidev's nav bar (prev/next/overview/fullscreen) is opacity-0 until
        # hovered, so first-time visitors of the public site have no visible
        # cue that navigation exists. Injected into the publicly served copy
        # only — `nix run` (live presenting) keeps the default
        # invisible-until-hover behavior. The selector targets the bar's
        # wrapper div in Slidev's play page; :not(.right-0) skips the
        # persistent full-width variant used on vertical/mobile screens,
        # which must not be re-centered.
        publicNavCss = builtins.replaceStrings [ "\n" ] [ " " ] ''
          .bottom-0.left-0.opacity-0[class~="hover:opacity-100"]
            {opacity:.8!important}
          .bottom-0.left-0.opacity-0[class~="hover:opacity-100"]:hover,
          .bottom-0.left-0.opacity-0[class~="hover:opacity-100"]:focus-within
            {opacity:1!important}
          .bottom-0.left-0.opacity-0[class~="hover:opacity-100"]:not(.right-0)
            {left:50%!important;transform:translateX(-50%)}
        '';

        # Splice the static deck export into the Go server's embed directory so
        # the served site always matches the source tree being built.
        srcWithStatic = pkgs.runCommand "presentation-nix-direnv-src" { } ''
          cp -r ${./.} $out
          chmod -R u+w $out
          rm -rf $out/cmd/presentation-nix-direnv/static
          mkdir -p $out/cmd/presentation-nix-direnv/static
          cp -r ${deck}/* $out/cmd/presentation-nix-direnv/static/

          sed -i \
            's#</head>#<style>${publicNavCss}</style></head>#' \
            $out/cmd/presentation-nix-direnv/static/index.html
        '';

        nativeGoarch = if builtins.match "aarch64-.*" system != null then "arm64" else "amd64";

        # Build the Go server binary for a specific OS/architecture.
        mkBinary =
          {
            goos ? "linux",
            goarch,
          }:
          pkgs.buildGoModule {
            pname = "presentation-nix-direnv";
            inherit version;
            src = srcWithStatic;
            vendorHash = null; # stdlib-only; set to a real hash once you add deps
            subPackages = [ "cmd/presentation-nix-direnv" ];

            env.CGO_ENABLED = 0;

            preBuild = ''
              export GOOS=${goos}
              export GOARCH=${goarch}
              # Keep Go telemetry out of $HOME so non-sandboxed builds don't
              # leak /homeless-shelter/.config/go/telemetry to the host.
              export GOTELEMETRYDIR="$TMPDIR/go-telemetry"
              export GOTELEMETRY=off
              mkdir -p "$GOTELEMETRYDIR"
            '';

            # Normalize native-compiled output layout with cross-compiled.
            # See https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/module.nix
            postBuild = nixpkgs.lib.optionalString (pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform) ''
              (
                dir=$GOPATH/bin/''${GOOS}_''${GOARCH}
                if [[ -n "$(shopt -s nullglob; echo $dir/*)" ]]; then
                  mv $dir/* $dir/..
                fi
                if [[ -d $dir ]]; then
                  rmdir $dir
                fi
              )
            '';

            ldflags = [
              "-s"
              "-w"
              "-X main.version=${version}"
            ];

            # Cross-compiled binaries can't run; rely on `go test ./...` locally.
            doCheck = false;

            meta = {
              description = "Nix + direnv for reproducible IaC tooling — conference talk (Slidev deck)";
              mainProgram = "presentation-nix-direnv";
            };
          };

        # Minimal OCI image for a specific architecture.
        mkContainer =
          { goarch, ociArch }:
          pkgs.dockerTools.buildLayeredImage {
            name = "presentation-nix-direnv";
            tag = version;
            architecture = ociArch;
            compressor = "none";

            contents = pkgs.buildEnv {
              name = "image-root";
              paths = [
                (mkBinary { inherit goarch; })
                pkgs.cacert
              ];
              pathsToLink = [
                "/bin"
                "/etc/ssl"
              ];
            };

            config = {
              # Run as nobody:nogroup. The image carries no /etc/passwd; this is
              # a numeric UID:GID, which is what kubernetes consumes anyway.
              # Required for clusters enforcing PodSecurityAdmission restricted.
              User = "65534:65534";
              Cmd = [ "/bin/presentation-nix-direnv" ];
              Env = [
                "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
                "PORT=8080"
              ];
              ExposedPorts = {
                "8080/tcp" = { };
              };
            };
          };

        # Deck flavors are auto-discovered: slides.md → `nix run`,
        # slides-<flavor>.md → `nix run .#<flavor>`. Adding a flavor is just
        # adding the entry file; no flake change needed.
        deckEntries =
          let
            files = builtins.attrNames (builtins.readDir ./.);
            toEntry =
              f:
              let
                m = builtins.match "slides-(.+)\\.md" f;
              in
              if f == "slides.md" then
                [
                  {
                    name = "default";
                    value = f;
                  }
                ]
              else if m != null then
                [
                  {
                    name = builtins.head m;
                    value = f;
                  }
                ]
              else
                [ ];
          in
          builtins.listToAttrs (builtins.concatMap toEntry files);

        # Live-reload dev server for a given deck flavor (entry file).
        mkDevApp = entry: {
          type = "app";
          program = toString (
            pkgs.writeShellScript "slidev-dev" ''
              set -euo pipefail
              export PATH="${nodejs}/bin:${pnpm}/bin:$PATH"
              pnpm install --frozen-lockfile
              exec pnpm exec slidev ${entry} "$@"
            ''
          );
        };

        # Multi-arch push wrapper. Runs scripts/push.sh under a shell with
        # nix, crane, and git on PATH. Always invoke via `nix run .#push`.
        pushScript = pkgs.writeShellApplication {
          name = "presentation-nix-direnv-push";
          runtimeInputs = with pkgs; [
            nix
            crane
            git
          ];
          text = ''
            exec "${toString ./scripts/push.sh}" "$@"
          '';
        };
      in
      {
        # nixfmt-tree ships a fixed treefmt.toml baked into the nix store
        # (its --config-file is hardcoded), so a project-level treefmt.toml
        # would be ignored. Wrap it instead, adding an exclude for
        # snippets/ — those files are hand-formatted teaching examples,
        # transcluded verbatim into slides via <<< @/snippets/<file>.
        formatter = pkgs.writeShellApplication {
          name = "nixfmt-tree-wrapped";
          runtimeInputs = [ pkgs.nixfmt-tree ];
          meta.mainProgram = "nixfmt-tree-wrapped";
          text = ''
            exec treefmt --excludes 'snippets/**' --excludes 'demos/**' "$@"
          '';
        };

        packages = {
          # nix build  → static deck in ./result
          default = deck;

          # nix build .#server → Go binary that serves the deck + /livez /readyz
          server = mkBinary { goarch = nativeGoarch; };

          container-amd64 = mkContainer {
            goarch = "amd64";
            ociArch = "amd64";
          };
          container-arm64 = mkContainer {
            goarch = "arm64";
            ociArch = "arm64";
          };

          push = pushScript;
        };

        # nix run → live-reload dev server (slides.md); nix run .#<flavor> →
        # same for slides-<flavor>.md (see deckEntries).
        apps = builtins.mapAttrs (_: mkDevApp) deckEntries // {
          # nix run .#push → multi-arch push to docker.io/docksee/lukas-cech-presentation-nix-direnv
          push = {
            type = "app";
            program = "${pushScript}/bin/presentation-nix-direnv-push";
          };
        };

        # nix develop → slidev + go toolchain. Paired with .envrc/direnv.
        devShells.default = pkgs.mkShell {
          packages = [
            nodejs
            pnpm
            pkgs.go
            pkgs.gopls
            pkgs.gotools
            pkgs.go-tools
          ];
        };
      }
    );
}
