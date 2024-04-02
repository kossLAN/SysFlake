{
  lib,
  config,
  ...
}: let
  cfg = config.programs.hm.game.mangohud;
in {
  options.programs.hm.game.mangohud = {
    enable = lib.mkEnableOption "mangohud";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      programs.mangohud = {
        enable = true;
        enableSessionWide = true;
        settings = {
          full = true;
          legacy_layout = false;
          gpu_stats = true;
          gpu_temp = true;
          gpu_text = "GPU";
          cpu_stats = true;
          cpu_temp = true;
          gamemode = true;
          core_load = true;
          cpu_color = "2e97cb";
          cpu_text = "CPU";
          io_color = "a491d3";
          vram_color = "ad64c1";
          ram_color = "c26693";
          fps = true;
          engine_color = "eb5b5b";
          gpu_color = "2e9762";
          wine_color = "eb5b5b";
          #fps_limit_method = "late";
          fps_limit = 60;
          frame_timing = 0;
          frametime = true;
          frametime_color = "00ff00";
          media_player_color = "ffffff";
          no_display = true;
          background_alpha = 0.4;
          font_size = 24;

          background_color = "020202";
          position = "top-right";
          text_color = "ffffff";
          round_corners = 5;
          toggle_hud = "Shift_R+F12";
          toggle_logging = "Shift_L+F2";
          upload_log = "F5";
          output_folder = "/home/koss";
        };
      };
    };
  };
}
