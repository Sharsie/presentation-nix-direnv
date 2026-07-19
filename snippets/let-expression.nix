let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true; # if using unfree packages
  };
in {}
