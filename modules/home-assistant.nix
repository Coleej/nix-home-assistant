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
      "aidot"
      "sun"
      "rest"         # Useful for Baby Buddy API
      "rest_command"

      # Fast zlib compression for the frontend, recommended by upstream
      "isal"
    ];

    extraPackages = python3Packages: with python3Packages; [
      python-aidot
      (buildPythonPackage rec {
        pname = "hatch-rest-api";
        version = "1.34.4";
        src = fetchPypi {
          pname = "hatch_rest_api";
          inherit version;
          sha256 = "1yk001jnhi3kccx7g0yrjjj7sfnwb8c7130vz23j0ih8iaaac498";
        };
        doCheck = false;
        propagatedBuildInputs = [
          aiohttp
          awsiotsdk
        ];
      })
    ];

    customComponents = [
      ((pkgs.runCommand "hatch-custom-component" { } ''
        mkdir -p $out/custom_components/ha_hatch
        cp -r ${pkgs.fetchFromGitHub {
          owner = "dahlb";
          repo = "ha_hatch";
          rev = "v1.31.5";
          sha256 = "1f27xyksy49bqj0vfjq2k57gvffya45ip7s8b63389g18h0kpk73";
        }}/custom_components/ha_hatch/* $out/custom_components/ha_hatch/
      '') // {
        isHomeAssistantComponent = true;
        domain = "ha_hatch";
      })
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
