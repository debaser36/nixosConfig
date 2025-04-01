{swayConfig?(import ./swayConfigDefault.nix)}:
{
  home.sessionVariables = {
			WLR_RENDERER="gles2";
			WLR_RENDERER_ALLOW_SOFTWARE="1";
	};
  wayland.windowManager.sway={
    enable=true;
    checkConfig=false;
    wrapperFeatures.gtk = true;

    config = swayConfig;

  };
}