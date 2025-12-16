#!/usr/bin/env bash
set -euo pipefail

# Patch VMware Workstation host modules using mkubecek/vmware-host-modules.
#
# Usage:
#   ./install_vmware.sh workstation-17.5.2
#
# Notes:
# - The tag you pass must exist in the upstream repo (ex: workstation-17.x.y).
# - This script only builds/installs kernel modules; you still need VMware installed.

VMWARE_TAG="${1:-}"
if [[ -z "${VMWARE_TAG}" ]]; then
  echo "Usage: $0 <vmware-host-modules-tag>"
  echo "Example: $0 workstation-17.5.2"
  exit 1
fi

tmp_dir="$(mktemp -d -t patch-vmware.XXXXXX)"
trap 'rm -rf "${tmp_dir}"' EXIT

if [[ -f /etc/os-release ]]; then
  source /etc/os-release
fi

if command -v dnf >/dev/null 2>&1; then
  sudo dnf -y install git make gcc kernel-devel "kernel-headers-$(uname -r)" || true
elif command -v dnf5 >/dev/null 2>&1; then
  sudo dnf5 -y install git make gcc kernel-devel "kernel-headers-$(uname -r)" || true
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y git make gcc linux-headers-"$(uname -r)"
else
  echo "Unsupported distro: need dnf/dnf5 or apt-get."
  exit 1
fi

git clone --depth=1 https://github.com/mkubecek/vmware-host-modules.git "${tmp_dir}/vmware-host-modules"
cd "${tmp_dir}/vmware-host-modules"

# Fetch full tag history so checkout works even with depth=1 clone.
git fetch --tags --force
git checkout "${VMWARE_TAG}"

make
sudo make install

echo "Done. If VMware still fails to start after a kernel update, re-run this script with the correct tag."
