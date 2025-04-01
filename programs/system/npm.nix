{
  programs.npm = {
			enable = true;
			npmrc = ''
        init-license=MIT
        audit=false
        fund=false
        init-type=module
        prefer-offline=true
        progress=false
        prefix=~/.npm-global
		'';
	};
}