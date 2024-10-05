let
  backup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMw1hLInzGOHV+b0TNmQbl0HHR4cabnZjPdbXcqkSNk";
  cerebrite = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDvg58shvVbIlXIpUV9chtflXmbq51uCMTpdYoKbcftD";
  galahad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZglP92ZxsqI4wRzGR/A3kEQIQPB94pwysihwo9bT+E";
  dahlia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJUoY3UNSi4RTM9Fja5gM5/k3z5AoqMSQOVdL7HaHqY";

  systems = [backup cerebrite galahad dahlia];
in {
  # Wireguard Keys
  "av0client1.age".publicKeys = systems;
  "av0preshared.age".publicKeys = systems;

  "tailscale.age".publicKeys = systems;
}
