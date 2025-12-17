# Fedora Dotfiles

This is where I'll be placing my Fedora configuration files.

## Hypr All Blue

![Preview 0](./assets/view_0.png)
![Preview 1](./assets/view_1.png)

# Install (revived)

- **Prereq**: your user must have sudo rights (typically be in Fedora's `wheel` group).
  - If you see sudo permission errors, run: `su -c 'usermod -aG wheel YOUR_USER'` and re-login.

- **Recommended**: run the maintained installer (Fedora only):
  - `./autoinstall.sh`
- **Legacy**: the old imperative script still exists, but is no longer the default:
  - `./startup_installation.sh --legacy`

## VMware host modules

If you need to rebuild VMware kernel modules after a kernel update:

- `./install_vmware.sh workstation-17.x.y` (pass the matching tag from `mkubecek/vmware-host-modules`)

## TODO

- [x] Add Ansible support to the project.
- [x] Add `xdg-desktop-portal-hyprland` support (portal restart script + package install).
- [ ] Improve the waybar with Hyprland's waybar patterns.
    - [x] Solve the `wlr/workspaces` not showing (switched to `hyprland/workspaces`).
- [x] Add the picture to show off the results.
- [x] Give a better format to the `startup_installation.sh` file (now delegates to maintained installer).
- [x] Create the autoinstall script.
