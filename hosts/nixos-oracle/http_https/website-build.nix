{ pkgs, lib ? pkgs.lib }:

pkgs.stdenv.mkDerivation rec {
  pname = "Unhalteproblem.de_Website";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "debaser36";
    repo = "unhalteproblem.de";
    rev = "main";  # Or specific commit/tag
    sha256 = "sFP0kpBAPMbAlMxpgFv9RxXVsfU7N3i0n/MEOS8ZLKs=";
		};

  buildInputs = with pkgs; [
    nodejs
    pkgs.pnpm.configHook
  ];

	pnpmDeps = pkgs.pnpm.fetchDeps  {
		
		inherit pname version src;
		hash = "sha256-rwY5UY1TvITkCLSumu7QVrEaIv+OCFs1n6WrVpwPJ+Y=";
	};

  postBuild = ''
    # Build the web service
    pnpm build
  '';


  installPhase = ''
		set -x
    mkdir -p $out
    cp -r services/web/dist/* $out/
  '';
}