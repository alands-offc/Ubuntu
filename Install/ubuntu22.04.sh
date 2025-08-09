#!/data/data/com.termux/files/usr/bin/bash
set -e

# === Persiapan awal ===
pkg install -y root-repo x11-repo proot xz-utils pulseaudio wget tar
termux-setup-storage

# === Konfigurasi ===
UBUNTU_VERSION="jammy"  # ganti sesuai kebutuhan
FOLDER="ubuntu-fs"
TARBALL="ubuntu-rootfs.tar.gz"
BIN_SCRIPT=".ubuntu"
LAUNCH_CMD="ubuntu"

# === Deteksi apakah rootfs sudah ada ===
if [ -d "$FOLDER" ]; then
    echo "[INFO] Folder $FOLDER sudah ada, skip download."
    FIRST=1
fi

# === Download rootfs jika belum ada ===
if [ "$FIRST" != 1 ]; then
    if [ ! -f "$TARBALL" ]; then
        echo "[INFO] Mengunduh Ubuntu Rootfs..."
        case $(dpkg --print-architecture) in
            aarch64) ARCH_URL="arm64" ;;
            arm*) ARCH_URL="armhf" ;;
            ppc64el) ARCH_URL="ppc64el" ;;
            x86_64) ARCH_URL="amd64" ;;
            *) echo "[ERROR] Arsitektur tidak dikenal!"; exit 1 ;;
        esac
        wget "https://partner-images.canonical.com/core/${UBUNTU_VERSION}/current/ubuntu-${UBUNTU_VERSION}-core-cloudimg-${ARCH_URL}-root.tar.gz" -O "$TARBALL"
    fi

    mkdir -p "$FOLDER"
    echo "[INFO] Mengekstrak Rootfs..."
    proot --link2symlink tar -xf "$TARBALL" -C "$FOLDER" || true
fi

# === Setting awal sistem ===
echo "ubuntu" > "$FOLDER/etc/hostname"
echo "127.0.0.1 localhost" > "$FOLDER/etc/hosts"
echo "nameserver 8.8.8.8" > "$FOLDER/etc/resolv.conf"
mkdir -p "$FOLDER/binds"

# === Perbaikan error group name ===
cat > "$FOLDER/usr/sbin/groupadd" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$FOLDER/usr/sbin/groupadd"

cat > "$FOLDER/usr/sbin/useradd" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$FOLDER/usr/sbin/useradd"

# === Buat script launch ===
cat > "$BIN_SCRIPT" <<- EOM
#!/bin/bash
pulseaudio --start \
    --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
    --exit-idle-time=-1 >/dev/null 2>&1

unset LD_PRELOAD
command="proot --kill-on-exit --link2symlink -0 -r $FOLDER"
if [ -n "\$(ls -A $FOLDER/binds 2>/dev/null)" ]; then
    for f in $FOLDER/binds/*; do . "\$f"; done
fi
command+=" -b /dev"
command+=" -b /dev/null:/proc/sys/kernel/cap_last_cap"
command+=" -b /proc"
command+=" -b /data/data/com.termux/files/usr/tmp:/tmp"
command+=" -b $FOLDER/root:/dev/shm"
command+=" -b /sdcard"
command+=" -w /root"
command+=" /usr/bin/env -i HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin TERM=\$TERM LANG=C.UTF-8 /bin/bash --login"

if [ -z "\$1" ]; then
    exec \$command
else
    \$command -c "\$*"
fi
EOM

termux-fix-shebang "$BIN_SCRIPT"
chmod +x "$BIN_SCRIPT"

# === Shortcut di Termux ===
echo "#!/bin/bash
bash $BIN_SCRIPT" > "$PREFIX/bin/$LAUNCH_CMD"
chmod +x "$PREFIX/bin/$LAUNCH_CMD"

# === Setup default Ubuntu ===
echo 'export PULSE_SERVER=127.0.0.1' >> "$FOLDER/etc/skel/.bashrc"
echo "touch ~/.hushlogin
apt update && apt upgrade -y
apt install -y apt-utils dialog nano
cp /etc/skel/.bashrc ~
rm -f ~/.bash_profile" > "$FOLDER/root/.bash_profile"

clear
echo "[INFO] Instalasi selesai. Ketik '$LAUNCH_CMD' untuk masuk Ubuntu."
