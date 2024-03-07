{
  description = "tree-sitter-markdown-parser";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, devshell, }:

    flake-utils.lib.eachDefaultSystem
      (system:
       let
          dylibExt = if nixpkgs.lib.hasInfix "darwin" system then "dylib" else "so";  
          overlays = [
            devshell.overlays.default
          ];
          # don't treat pkgs as meaning nixpkgs - treat it as all packages!
          pkgs = import nixpkgs {
            inherit overlays system;
          };
	  # the next two deriviations are just tests to see whether I could fetch the parser into this repo
          markdown-grammar-source = pkgs.fetchFromGitHub {
            owner = "mdeiml";
            repo = "tree-sitter-markdown";
            rev = "28aa3baef73bd458d053b613b8bd10fd102b4405";
            sha256 = "sha256-HSjKYqjrJKPLbdq1UTvk/KnDqsIzVO7k5syCsIpAZpw=";
          };
          markdown-grammar = (pkgs.tree-sitter.buildGrammar {
            language = "markdown";
            version = "0.0.1";
            src = "${markdown-grammar-source}/tree-sitter-markdown";
          });
	  # this is what I'm actually using to build the current parser
          parser = pkgs.stdenv.mkDerivation {
	    name = "parser";
            src = ./tree-sitter-markdown;
            nativeBuildInputs = [pkgs.gcc];
            buildPhase = ''
	      gcc -o parser src/*.c -I./src \
	        -I${pkgs.tree-sitter}/include \
	        ${pkgs.tree-sitter}/lib/libtree-sitter.${dylibExt};
	    '';
	    installPhase = ''
	      mkdir -p $out/bin;
	      cp parser $out/bin/parser;
	    '';
          };
        in
        rec
        {
          packages.markdown-grammar = markdown-grammar;
          packages.grammars = pkgs.tree-sitter.withPlugins (_: [ markdown-grammar ]);
	  packages.default = parser;

          devShells.default = pkgs.devshell.mkShell {
            name = "tree-sitter";
            packages = with pkgs; [
              tree-sitter
            ];
            commands = [
            ];
          };
        });
}
