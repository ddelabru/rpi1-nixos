# rpi1-nixos

A Nix flake for building a NixOS SD card image for the Raspberry Pi 1, which
runs the `armv6l` architecture no longer supported by NixOS / nixpkgs build
infrastructure.

## Configuration notes

Note that the build system for cross-compiling is defined as `x86_64-linux` in
`cross-compile-fixes.nix`. You will want to change this if cross-compiling from
a different platform. A few system configuration details are included in
`system.nix`. You will likely want to customize this for your needs.

## Build/deploy commands

To build the SD card image, from the top level of the flake repo:

```sh
nix build ".#images.rpi1"
```

To deploy the NixOS system configuration to a Raspberry Pi already running some
version of NixOS at local IP4 address `10.0.0.42`, using an SSH key authorized
to access the Pi's `root` user:

```sh
nixos-rebuild --target-host root@10.0.0.42 --flake ".#rpi1" switch
```