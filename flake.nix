{
  description = "Unified blackhole file with base extensions.";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }: {
    nixosModule = { config, ... }:
      with nixpkgs.lib;
      let
        cfg = config.networking.bossnetBlackHole;
        alternatesList = (if cfg.blockFakenews then [ "fakenews" ] else []) ++
                         (if cfg.blockGambling then [ "gambling" ] else []) ++
                         (if cfg.blockPorn then [ "porn" ] else []) ++
                         (if cfg.blockSocial then [ "social" ] else []);
        alternatesPath = "alternates/" + builtins.concatStringsSep "-" alternatesList + "/";
      in
      {
        options.networking.bossnetBlackHole = {
          enable = mkEnableOption "Use KhulnaSoft's blackhole file as extra blackhole.";
          blockFakenews = mkEnableOption "Additionally block fakenews blackhole.";
          blockGambling = mkEnableOption "Additionally block gambling blackhole.";
          blockPorn = mkEnableOption "Additionally block porn blackhole.";
          blockSocial = mkEnableOption "Additionally block social blackhole.";
        };
        config = mkIf cfg.enable {
          networking.extraBlackhole =
            builtins.readFile (
              "${self}/" + (if alternatesList != [] then alternatesPath else "") + "blackhole"
            );
        };
      };
  } // flake-utils.lib.eachDefaultSystem
    (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            python3
            python3Packages.flake8
            python3Packages.requests
          ];
        };
      }
    );
}
