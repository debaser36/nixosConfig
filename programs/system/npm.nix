{
  programs.npm = {
    enable = true;
    npmrc = ''
              prefix=''${HOME}/.npm-global
              init-license=MIT
              audit=false
              fund=false
              init-type=module
              prefer-offline=true
              progress=false
      		'';
  };
}
