{ user }:
{
  programs.git = {
    enable = true;
    settings.user.name = user.username;
    settings.user.email = user.email;
  };
}
