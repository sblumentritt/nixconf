# nixconf - nix-based configurations

> Currently no longer maintained. NixOS approach sounds nice but I don't really
> like the `nix` language and some of my most used application are not up to
> date. I still learned a few new/better things.

An experiment to move to `NixOS` with `flakes` + `home-manager`. Sadly I ran
into a lot problems which are still persistent:

- unable to get encrypted `/boot` and keyfile decryption after Grub
  - `boot.initrd.secrets` fails on creating temp dir
  - same temp dir problem when trying to use `systemd-boot`
- normal paths cannot be used but hardcoding `/nix/store` is ugly
- package collisions meaning development gets complicated
  - e.g. `binutils-wrapper/ld` -> `gcc-wrapper/ld`
  - e.g. `clang-wrapper/c++` -> `gcc-wrapper/ld`

## Manual steps on booted iso

- call `sudo nix-env -iA nixos.git nixos.nixUnstable`
  - `nixUnstable` is needed to use the `flake`
- clone this repo
- call `bootstrap.sh` as root via sudo
- install system via `sudo nixos-install --root /mnt --flake <path-to-repo>/#test`
- reboot and hope every worked :)

## License

The project is licensed under the MIT license. See [LICENSE](LICENSE) for more
information.
