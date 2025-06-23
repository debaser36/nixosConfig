{ user }:
{
  programs.git = {
    enable = true;
    userName = user.username;
    userEmail = user.email;
  };
}
