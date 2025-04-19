{
  startup = [
    {
      command="nohup firefox &";
      always = false;
    }
    {
      command="nohup element-desktop &";
      always = false;
    }
    {
      command="nohup thunderbird &";
      always = true;
    }
  ];
}