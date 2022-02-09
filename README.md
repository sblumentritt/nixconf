# nixconf - nix-based configurations

An experiment to move to `NixOS` with `flakes` + `home-manager`. Sadly I ran
into a lot problems which are still persistent:

- unable to get encrypted `/boot` and keyfile decryption after Grub
- `home-manager` service failes when `gtk.enable` is true
  - got once xserver problem with bad file descriptor
  - unit dconf.service not found
- awesomewm module `vicious` not available when using `startx`
  - need to pass `--search` with `/nix/store/` paths
- awesomewm cannot get the `XDG_CONFIG_HOME` environment variable
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
