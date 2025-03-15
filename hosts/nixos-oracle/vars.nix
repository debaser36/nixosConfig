{
  hostname = "nixos-oracle"; 
  architeture = "aarch64-linux";

  default_user = 
  {
    username = "nico";
    home = "/home/nico";
  };

  public_sshKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDpMfwYqx4t5IHaR+qMX+mrQ9PcFMJY3Seg2B2+5akwCrQrp8I7meVL17bqUPYyU0rf44FjEysc5Yc1WMUfAVp4+IRpM+ZhG1YX1E0C+sI0ItLAHTlZCpRYJmIRyxoiDlsxAO+LVMiNDcBixF1j9YTtGG7SUrhmt/IW3VMRrG6OjE7I8LvMAJV1wUoPTDPZzqTgRaRf0+0PbFLkZ5WGYYMM0q3H0Do+a9UKSwFPN8jXne46ZSe8PaKD7F8BxReXzbHh2CYIbxlf8r34/5vgV1VkiEQ5FW21CJPQ8kQ6wrYi14QiIeRu/aIROhgfDIo4XV9b/ZUP0EoYAjlpl5+zQxrx ssh-key-2025-03-11"  ; # Replace with your SSH public key.
  locale = "de_DE.UTF-8";
  timezone = "Europe/Berlin";

}
