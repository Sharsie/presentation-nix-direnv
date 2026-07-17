let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true; # terraform is unfree
  };
in {}
