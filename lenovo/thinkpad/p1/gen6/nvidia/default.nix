{ lib, ... }:
{
  imports = [
    ../.
    # Every P1 Gen 6 GPU is Ada Lovelace except the RTX A1000 (Ampere); both
    # generations share the same driver settings.
    ../../../../../common/gpu/nvidia/ada-lovelace
    ../../../../../common/gpu/nvidia/prime.nix
  ];

  hardware = {
    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };
    nvidia = {
      # "Wayland requires kernel mode setting (KMS) to be enabled (Highly
      # Recommended)" per https://wiki.nixos.org/wiki/NVIDIA#Requirements.
      modesetting.enable = lib.mkDefault true;
      prime = {
        intelBusId = lib.mkDefault "PCI:0:2:0";
        nvidiaBusId = lib.mkDefault "PCI:1:0:0";
      };
    };
  };
}
