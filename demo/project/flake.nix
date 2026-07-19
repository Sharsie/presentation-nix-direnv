{
  description = "dev environment";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = {
    self,
    flake-utils,
    nixpkgs
  }: flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = import nixpkgs {
        system = system;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.nodejs_22
          pkgs.python312
          pkgs.go
        ];
      };
    }
  );
}
