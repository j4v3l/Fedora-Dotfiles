#!/usr/bin/env bash
set -euo pipefail

# Restart xdg-desktop-portal for Hyprland.
# Prefer systemd --user units when available; fall back to manual restart.

sleep 1

if command -v systemctl >/dev/null 2>&1; then
  # Don't fail the whole script if units aren't present on a given distro.
  systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP >/dev/null 2>&1 || true
  systemctl --user restart xdg-desktop-portal-hyprland.service xdg-desktop-portal.service >/dev/null 2>&1 && exit 0 || true
fi

# Fallback: kill and relaunch. Avoid hardcoding a single path if possible.
pkill -x xdg-desktop-portal-hyprland >/dev/null 2>&1 || true
pkill -x xdg-desktop-portal-wlr >/dev/null 2>&1 || true
pkill -x xdg-desktop-portal >/dev/null 2>&1 || true

(
  # Common locations across distros.
  for bin in \
    /usr/libexec/xdg-desktop-portal-hyprland \
    /usr/lib/xdg-desktop-portal-hyprland \
    "$(command -v xdg-desktop-portal-hyprland 2>/dev/null || true)"
  do
    [[ -n "${bin}" && -x "${bin}" ]] && exec "${bin}"
  done
  exit 0
) &

sleep 2

(
  for bin in \
    /usr/libexec/xdg-desktop-portal \
    /usr/lib/xdg-desktop-portal \
    "$(command -v xdg-desktop-portal 2>/dev/null || true)"
  do
    [[ -n "${bin}" && -x "${bin}" ]] && exec "${bin}"
  done
  exit 0
) &
