{
  nixpkgs,
  ...
}:

{
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.hostPlatform.system = "armv6l-linux";
  nixpkgs.buildPlatform.system = "x86_64-linux";
  nixpkgs.overlays = [
    (final: super: {
      # A bit hacky: these EFI-related packages are now included in the base
      # packages for NixOS SD card images but don't compile for armv6l-linux
      # They aren't necessary on the Raspberry Pi 1 anyhow, so we replace them
      # with empty directories
      efibootmgr = super.emptyDirectory;
      efivar = super.emptyDirectory;

      # The Linux kernel fixes here are adapted from a snippet by Rodney
      # Lorrimar on the NixOS Discourse forum:
      # https://discourse.nixos.org/t/nixos-on-raspberry-pi-zero-w/38018/34
      linuxKernel = super.linuxKernel // {
        packages = super.linuxKernel.packages // {
          # Disable drivers which fail to build under nixpkgs
          linux_rpi1 = super.linuxKernel.packages.linux_rpi1.extend (
            kfinal: ksuper: {
              kernel = (
                ksuper.kernel.override (originalArgs: {
                  features = {
                    efiBootStub = false;
                  };
                  kernelPatches =
                    (originalArgs.kernelPatches or [ ])
                    ++ super.lib.trace "using linux_rpi1 with config patch" [
                      {
                        name = "disable-broken-div64";
                        patch = null;
                        structuredExtraConfig = with final.lib.kernel; {
                          # pwm-rp1
                          PWM_RP1 = no;
                          # i2c-designware-core
                          I2C_DESIGNWARE_CORE = no;
                          I2C_DESIGNWARE_SLAVE = no;
                          I2C_DESIGNWARE_PLATFORM = no;
                          I2C_DESIGNWARE_PCI = no;
                          # rp1-cfe  Raspberry Pi PiSP Camera Front End
                          VIDEO_RP1_CFE = no;
                        };
                      }
                    ];
                })
              );
            }
          );
        };
      };
      makeModulesClosure =
        oldArgs:
        super.makeModulesClosure (
          oldArgs
          // {
            allowMissing = true;
          }
        );
    })
  ];
}
