{ pkgs
, ...
}:
{
  services.greetd.enable = true;
  services.greetd.settings = {
    default_session.command = ''
      			${pkgs.greetd.tuigreet}/bin/tuigreet \
      			--time \
      			--asterisks \
      			--user-menu \
      			--cmd sway
      			'';
  };

  environment.etc."greetd/environments".text = ''
    		sway
    	'';
}
