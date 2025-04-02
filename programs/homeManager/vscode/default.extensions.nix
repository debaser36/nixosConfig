{pkgs,...}:
{
  extensions = with pkgs.vscode-extensions; with pkgs.vscode-marketplace; [

				# -------- Nix Language Support  ------------
				bbenoist.nix                      # Nix language syntax highlighting
				jnoortheen.nix-ide                # Enhanced Nix IDE features
				arrterian.nix-env-selector        # Nix environment selector

        ## -------- JS and TS Development ------------
        esbenp.prettier-vscode            # Code formatting
				christian-kohler.npm-intellisense # NPM intellisense
				prisma.prisma                     # Prisma ORM support
        usernamehw.errorlens              # Useful Error Lensing

        dsznajder.es7-react-js-snippets   # Snippets for React, Javascript, ...
        ms-vscode.vscode-typescript-next  # latest Typescript features
        clinyong.vscode-css-modules       # Better CSS Modules support
        # wix.vscode-import-cost          # shows import cost -- takes way too much CPU cycles
        christian-kohler.path-intellisense# Path Intellisense

        ## -------- C++/C/CMake --------
        ms-vscode.cpptools-extension-pack

        ## -------- ISABELLE --------
        makarius.isabelle

  ];
  userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
      "nil" = {
        "formatting" = {
          "command" = [ "nixfmt" ];
        };
      };


      "cssModules.pathAlias" = {
          "@styles"= "\${workspaceFolder}/src/styles";
      };

      "reactSnippets.settings.prettierEnabled"= false;

      # to use christian-kohler path-intellisense
      "typescript.suggest.paths" = false;
      "javascript.suggest.paths" = false;

      # default formatter: prettier
      "editor.defaultFormatter"= "esbenp.prettier-vscode";

      "npm-intellisense.scanDevDependencies"= true;
      "npm-intellisense.showBuildInLibs"= true;
    };
  };
}
