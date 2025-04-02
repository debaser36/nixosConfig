{pkgs,...}:
{
  extensions = with pkgs.vscode-extensions; with pkgs.vscode-marketplace; [
      	# TypeScript/JavaScript/Node Development
				esbenp.prettier-vscode            # Code formatting
				christian-kohler.npm-intellisense # NPM intellisense
				prisma.prisma                     # Prisma ORM support
				
				
				# Nix Language Support
				bbenoist.nix                      # Nix language syntax highlighting
				jnoortheen.nix-ide                # Enhanced Nix IDE features
				arrterian.nix-env-selector        # Nix environment selector

        # Error Lens
        usernamehw.errorlens              # Useful Error Lensing
        dsznajder.es7-react-js-snippets   # Snippets for React, Javascript, ...
        ms-vscode.vscode-typescript-next  # latest Typescript features
        clinyong.vscode-css-modules       # Better CSS Modules support

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
    };
  };
}