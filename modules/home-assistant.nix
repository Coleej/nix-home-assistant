{ config, pkgs, lib, ... }:

{
  services.home-assistant = {
    enable = true;

    # Components required just to get through onboarding + a sane
    # baseline. Add Hatch/AiDot/etc. here later — that's the whole
    # point of doing this declaratively.
    extraComponents = [
      "analytics"
      "google_translate"
      "met"          # weather, used by onboarding
      "radio_browser"
      "shopping_list"
      "tuya"         # Often needed for AiDOT/generic bulbs
      "sun"
      "rest"         # Useful for Baby Buddy API
      "rest_command"

      # Fast zlib compression for the frontend, recommended by upstream
      "isal"
    ];

    config = {
      # Empty attrset = let onboarding create default_config-equivalent
      # sections via the UI. You can move to a fully declarative
      # config {} block later once you know what you want pinned.
      default_config = { };

      http = {
        server_host = "0.0.0.0";
        server_port = 8123;
        # If you'll reach this through a reverse proxy later, add
        # trusted_proxies / use_x_forwarded_for here.
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8123 ];
}
