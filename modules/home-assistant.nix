{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.home-assistant = {
    enable = true;

    # Components required just to get through onboarding + a sane
    # baseline. Add other integrations here as needed.
    extraComponents = [
      "analytics"
      "google_translate"
      "met" # weather, used by onboarding
      "radio_browser"
      "shopping_list"

      "sun"
      "rest" # Useful for Baby Buddy API
      "rest_command"

      # Fast zlib compression for the frontend, recommended by upstream
      "isal"
    ];

    extraPackages =
      python3Packages: with python3Packages; [

        (buildPythonPackage rec {
          pname = "hatch-rest-api";
          version = "1.34.4";
          pyproject = true;
          build-system = [ setuptools ];
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
      (
        (pkgs.runCommand "hatch-custom-component" { } ''
          mkdir -p $out/custom_components/ha_hatch
          cp -r ${
            pkgs.fetchFromGitHub {
              owner = "dahlb";
              repo = "ha_hatch";
              rev = "v1.31.5";
              sha256 = "1f27xyksy49bqj0vfjq2k57gvffya45ip7s8b63389g18h0kpk73";
            }
          }/custom_components/ha_hatch/* $out/custom_components/ha_hatch/
        '')
        // {
          isHomeAssistantComponent = true;
          domain = "ha_hatch";
        }
      )
      (
        (pkgs.runCommand "babybuddy-custom-component" { } ''
          mkdir -p $out/custom_components/babybuddy
          cp -r ${
            pkgs.fetchFromGitHub {
              owner = "jcgoette";
              repo = "baby_buddy_homeassistant";
              rev = "v2.10.0";
              sha256 = "sha256-1zTF3gK1VSQiH3tWmBygabw3pd2SuARxVHjClPlVS28=";
            }
          }/custom_components/babybuddy/* $out/custom_components/babybuddy/
        '')
        // {
          isHomeAssistantComponent = true;
          domain = "babybuddy";
        }
      )
    ];

    config = {
      default_config = { };
      logger = {
        default = "warning";
      };
      babybuddy = {
        host = "http://192.168.86.100";
        port = 8111;
        api_key = "ec7791557f6fa9578a66982ab4deb11e3386a012";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8123 ];
}
