{
  description = "Hackman";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    pyproject-nix = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, pyproject-nix }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs [
        "x86_64-linux"
      ];

      pythonAttr = "python3";

      pkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
      pythonFor = forAllSystems (system:
        let
          pkgs = pkgsFor.${system};
          python = pkgs.${pythonAttr}.override {
            self = python;

            packageOverrides = final: prev: {
              mote =
                let
                  pname = "mote";
                  version = "0.0.4";
                in
                final.buildPythonPackage {
                  inherit pname version;
                  src = final.fetchPypi {
                    inherit pname version;
                    hash = "sha256-fymJkGs+N8apMdivcKmHnyzwZX75eCMYax6TJFQt69k=";
                  };
                  nativeBuildInputs = [ final.setuptools ];
                  propagatedBuildInputs = [ final.pyserial ];
                };
            };

          };
        in
        python);

      project = pyproject-nix.lib.project.loadPoetryPyproject {
        projectRoot = ./.;
      };

    in
    {
      packages =
        forAllSystems
          (
            system:
            let
              pkgs = pkgsFor.${system};
              python = pythonFor.${system};
            in
            {
              default = python.pkgs.buildPythonApplication (project.renderers.buildPythonPackage { inherit python; });
            }
          );

      devShells =
        forAllSystems
          (
            system:
            let
              pkgs = pkgsFor.${system};
              python = pythonFor.${system};
              pythonEnv = python.withPackages (project.renderers.withPackages { inherit python; });
            in
            {
              default = pkgs.mkShell {
                packages = [ pythonEnv ];
              };
            }
          );

    };
}
