{ initial_output ? "DP-2"
}:
{
  input."1386:890:Wacom_One_by_Wacom_S_Pen" = {
    map_to_output = initial_output;
  };

  input."12994:102:2.4G_Wireless_Mouse" =  {
    accel_profile = "flat";
    drag = "enabled";
    pointer_accel =  "-0.5"; # this is the default 
  };
}
