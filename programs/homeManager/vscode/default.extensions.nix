{pkgs,...}:
{
  extensions = with pkgs.vscode-extensions; [
      	# TypeScript/JavaScript/Node Development
				esbenp.prettier-vscode            # Code formatting
				christian-kohler.npm-intellisense # NPM intellisense
				prisma.prisma                     # Prisma ORM support
				
				
				# Nix Language Support
				bbenoist.nix                      # Nix language syntax highlighting
				jnoortheen.nix-ide                # Enhanced Nix IDE features
				arrterian.nix-env-selector        # Nix environment selector
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
    };
  };
}