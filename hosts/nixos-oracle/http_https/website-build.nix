{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "Unhalteproblem.de_Website";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "debaser36";
    repo = "unhalteproblem.de";
    rev = "main"; # Or specific commit/tag


    #    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    sha256 = "sha256-ASMi+s1Q4JG0Kph2XAZBK+aEJ/1qd710EYPBg9u3N5Y=";
    #sha256 = "sha256-ht/PTroA26IwlVEyy9kUWu7ksHoWfaPbimVdIoavwS4=";
    #sha256 = "sha256-dXyXhRtNpTHxH4zpaVsJkxTtCUbUB/d5P8a66p91PIM=";
    #sha256 = "sha256-WQXMCAWrQ9GKTGLpnIRy/KaPk6pcAixKtiGoyHFmDw4=";
    #sha256 = "sha256-GdBLZUby/xmSZ4aD0MHg2EjsFjtqNorD18uCegga1sY=";
    #sha256 = "sha256-ZRaA55zcvNU2Oly2ToCWK60MUIOOsfo470xxaXFxJcE=";
    #sha256 = "sFP0kpBAPMbAlMxpgFv9RxXVsfU7N3i0n/MEOS8ZLKs=";
  };

  buildInputs = with pkgs; [
    nodejs
    pkgs.pnpm.configHook
  ];

  pnpmDeps = pkgs.pnpm.fetchDeps {

    inherit pname version src;

    fetcherVersion = 1;
    #hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    hash = "sha256-7x0FARVhcMkYpdQErpdWwHy6i6nzyczFtUzbaDBCxQg=";
    #hash = "sha256-U9zy5vDqFagh8Uu0W5SBqP9g9zWITUXKvB6sOqpKggc=";
    #hash = "sha256-V5Aeq/FGBv04BHJA4PVBrSp7C58UU6nrqDOppm/8WoY=";
    #hash = "sha256-L9YP+kixiwW2DsuI46evKmW9AbbcxhNHJ0PWOleqwKg=";
    #hash = "sha256-0Xz8l6OE0yZAxQE6SYS5Oj/CfKci2SttUWZQpa++9FA=";
    #hash = "sha256-8lelLqJWQET99xUtrYNnZxGxTGlDZdZqV6vhuPnDjGk=";
    #hash = "sha256-rwY5UY1TvITkCLSumu7QVrEaIv+OCFs1n6WrVpwPJ+Y=";
    #hash = "sha256-9fce7wssWM8odpD3Cmg2PRjl149FlO80WOWwNAZBaTU=";
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
