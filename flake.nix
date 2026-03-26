{
  description = "Build Raspberry Pi 1 NixOS image";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  outputs =
    { self, nixpkgs }:
    {
      nixosConfigurations.rpi1 = nixpkgs.lib.nixosSystem {
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
          ./cross-compile-fixes.nix
          ./system.nix
        ];
      };
      images.rpi1 = self.outputs.nixosConfigurations.rpi.config.system.build.sdImage;
    };
}
