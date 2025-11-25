{ pkgs, lib, config, ... }: 
let
  android-composition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "13.0";
    toolsVersion = "26.1.1";
    platformToolsVersion = "35.0.1";
    buildToolsVersions = [ "30.0.3" "31.0.0" "34.0.0" ];
    includeEmulator = true;
    emulatorVersion = "34.2.16";
    platformVersions = [ "28" "29" "30" "31" "32" "33" "34" "35" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.10.2" ];
    includeNDK = true;
    ndkVersions = ["25.1.8937393"];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [ "extras;google;gcm" ];
  };
in
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    ANDROID_HOME = "${android-composition.androidsdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${android-composition.androidsdk}/libexec/android-sdk";
  };
}