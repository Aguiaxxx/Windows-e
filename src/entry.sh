#!/usr/bin/env bash
set -Eeuo pipefail

echo "❯ Starting Windows for Docker v$(</run/version)..."
echo "❯ For support visit https://github.com/dockur/windows"

export DISPLAY=web
export BOOT_MODE=windows

ln -sfn /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html
websockify -D --web /usr/share/novnc/ 8006 localhost:5900 2>/dev/null

cd /run

. reset.sh      # Initialize system
. install.sh    # Get bootdisk
. disk.sh       # Initialize disks
. display.sh    # Initialize graphics
. network.sh    # Initialize network
. boot.sh       # Configure boot
. proc.sh       # Initialize processor
. config.sh     # Configure arguments

trap - ERR

mkdir -p /tmp/emulated_tpm
swtpm socket -t -d --tpmstate dir=/tmp/emulated_tpm --ctrl type=unixio,path=/tmp/emulated_tpm/swtpm-sock --log level=1 --tpm2

info "Booting Windows using $VERS..."

[[ "$DEBUG" == [Yy1]* ]] && set -x
exec qemu-system-x86_64 ${ARGS:+ $ARGS}
