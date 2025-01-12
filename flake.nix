{
  description = "A Nix-flake-based Jupyter development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs =
    { self
    , nixpkgs
    ,
    }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f {
          pkgs = import nixpkgs { inherit system; };
        });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          venvDir = ".venv";
          packages = with pkgs; [ wget poetry python311 ] ++ (with python311Packages; [
            ipykernel
            datasets
            pip
            venvShellHook
            seaborn
            tensorflow
            keras
            matplotlib
            numpy # these two are
            scipy # probably redundant to pandas
            jupyterlab
            pandas
            statsmodels
            scikitlearn

          ]);
        };
      });
    };
}
