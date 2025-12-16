#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This repo's installer is meant to run on Fedora Linux."
  echo "You're currently on: $(uname -s)"
  exit 1
fi

if [[ ! -f /etc/os-release ]]; then
  echo "Cannot detect distro: /etc/os-release not found."
  exit 1
fi

source /etc/os-release
if [[ "${ID:-}" != "fedora" ]]; then
  echo "This installer currently targets Fedora. Detected ID=${ID:-unknown}."
  echo "If you want multi-distro support, we can add it."
  exit 1
fi

if command -v dnf >/dev/null 2>&1; then
  sudo dnf -y install ansible-core git || true
elif command -v dnf5 >/dev/null 2>&1; then
  sudo dnf5 -y install ansible-core git || true
else
  echo "Neither dnf nor dnf5 found."
  exit 1
fi

cd "$repo_root/ansible"
exec ansible-playbook -i inventory.ini site.yml


