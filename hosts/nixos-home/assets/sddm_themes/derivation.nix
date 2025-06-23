{ pkgs, }:

pkgs.stdenv.mkDerivation {
  name = "astronaut-theme";
  pname = "sddm-astronaut-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "master";
    hash = "sha256-JMCG7oviLqwaymfgxzBkpCiNi18BUzPGvd3AF9BYSeo=";
  };

  buildInputs = [ ];
  buildPhase = '' '';
  installPhase = '' 
      mkdir -p $out/share/sddm/themes
      cp -r ./Themes/* $out/share/sddm/themes
    '';
}

