{ pkgs
, ...
}:
{
  extensions = with pkgs.vscode-extensions; with pkgs.vscode-marketplace; [

    # -------- Nix Language Support  ------------
    bbenoist.nix # Nix language syntax highlighting
    jnoortheen.nix-ide # Enhanced Nix IDE features
    arrterian.nix-env-selector # Nix environment selector
    b4dm4n.nixpkgs-fmt

    ## -------- HTML, JS and TS Development ------------
    esbenp.prettier-vscode # Code formatting
    christian-kohler.npm-intellisense # NPM intellisense
    prisma.prisma # Prisma ORM support
    usernamehw.errorlens # Useful Error Lensing
    liamhammett.inline-parameters # By far the best extension out there
    yoavbls.pretty-ts-errors #  FIXME this works not in r/o filesystem
    # be5invis.vscode-custom-css        # Custom CSS and JS for VSCode -- needed to disable default errors
    # better-ts-errors.better-ts-errors
    dsznajder.es7-react-js-snippets # Snippets for React, Javascript, ...
    ms-vscode.vscode-typescript-next # latest Typescript features
    clinyong.vscode-css-modules # Better CSS Modules support
    # wix.vscode-import-cost          # shows import cost -- takes way too much CPU cycles
    christian-kohler.path-intellisense # Path Intellisense
    meganrogge.template-string-converter
    vincaslt.highlight-matching-tag
    bradlc.vscode-tailwindcss
    zardoy.ts-essential-plugins

    ## -------- C++/C/CMake --------
    ms-vscode.cpptools-extension-pack
    jeff-hykin.better-cpp-syntax

    ## -------- RUST --------------
    dustypomerleau.rust-syntax
    rust-lang.rust-analyzer
    #serayuzgur.crates --> migrated to dependi.io
    fill-labs.dependi
    njpwerner.autodocstring

    ## -------- ISABELLE --------
    makarius.isabelle # Official Makarius Isabelle Extension, integrated into the current version of the IDE



    # --------- GIT --------------
    mk12.better-git-line-blame # lightweight and better than gitlens



    # -------- GENERAL ---------
    james-yu.latex-workshop # Latex Support
    tamasfe.even-better-toml # Good for TOML
    mkhl.direnv # Shell Integration for direnv
    github.copilot
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode.remote-explorer
    streetsidesoftware.code-spell-checker
    streetsidesoftware.code-spell-checker-german
    gruntfuggly.todo-tree
    edwinhuish.better-comments-next
    crystal-spider.jsdoc-generator # JSDoc Generator

    shd101wyy.markdown-preview-enhanced
    kshetline.ligatures-limited
    mechatroner.rainbow-csv # different colors for different columns
    albert.tabout # easy tabout from quotes and brackets
    # brandonkirbyson.vscode-animations
    vscode-icons-team.vscode-icons

    # turbo language server
    vercel.turbo-vsc

  ];

  userSettings = {
    "betterTypeScriptErrors.prettify" = true;
    "extensions.experimental.affinity" = {
      "better-ts-errors.better-ts-errors" = 1;
    };

    "jsdoc-generator" = {
      "author" = "Nico Burkholder";
      "dateFormat" = "YYYY-MM-DD";
    };


    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";
    "nix.serverSettings" = {
      "nil" = {
        "formatting" = {
          "command" = [ "nixfmt" ];
        };
      };
    };


    "cssModules.pathAlias" = {
      "@styles" = "\${workspaceFolder}/src/styles";
    };
    "cSpell.enabledFileTypes" = {
      "*" = true;
      "markdown" = true;
      "nix" = false;
    };

    "reactSnippets.settings.prettierEnabled" = false;

    # to use christian-kohler path-intellisense
    "typescript.suggest.paths" = false;
    "javascript.suggest.paths" = false;

    # default formatter: prettier
    "editor.defaultFormatter" = "esbenp.prettier-vscode";

    "npm-intellisense.scanDevDependencies" = true;
    "npm-intellisense.showBuildInLibs" = true;

    "cSpell.language" = "en,de-de";
    "cSpell.userWords" = [
      "Nico"
      "Burkholder"
    ];

    "docthis.includeDescriptionTag" = true;
    "docthis.inferTypesFromNames" = true;
    "docthis.includeAuthorTag" = true;
    "docthis.authorName" = "Nico Burkholder";
    "docthis.includeDateTag" = true;

    "editor.guides.bracketPairs" = true;
  };
}

