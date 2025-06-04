{ pkgs, }:
{
  sddm-astronaut-theme = pkgs.stdenv.mkDerivation {
    pname = "sddm-astronaut-theme";
    version = "1.0";
    src = pkgs.fetchFromGitHub {
      owner = "Keyitdev";
      repo = "sddm-astronaut-theme";
      rev="master";
      hash="";
    };

    buildInputs = [];
    buildPhase = '' '';
    installPhase = '' 
      mkdir -p $out/sddm_themes
    '';
  };
}
