#!/bin/bash
set -e

# Setup base settings
VERBOSE=false
set +u 2>/dev/null || true
(echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections) &>/dev/null || true

# Filter out packages, return if empty
PACKAGES="${*:-}"

[ "$VERBOSE" = true ] && echo "ENV : $PACKAGES"

# Base check: correct install mechanism based on OS
if command -v "apt" &>/dev/null; then
    [ "$VERBOSE" = true ] && echo "apt based"
    PACKING_MECHANISM="apt"
elif command -v "apk" &>/dev/null; then
    [ "$VERBOSE" = true ] && echo "apk based"
    PACKING_MECHANISM="apk"
elif command -v "pacman" &>/dev/null; then
    [ "$VERBOSE" = true ] && echo "pacman based"
    PACKING_MECHANISM="pacman"
fi

# Prepare base-packages
PACKAGES="$PACKAGES curl vim ca-certificates jq"

# Scripts handling
for commands in "/etc/cont-init.d" "/etc/services.d"; do
    if ! ls $commands 1>/dev/null 2>&1; then continue; fi

    # Test each possible command
    COMMAND="nginx"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES nginx"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES nginx"
        [ "$PACKING_MECHANISM" = "pacman" ] && PACKAGES="$PACKAGES nginx"
        # Move nginx to new version
        if ls /etc/nginx 1>/dev/null 2>&1; then mv /etc/nginx /etc/nginx2; fi
    fi

    COMMAND="mount"
    if grep -q -rnw "$commands/" -e "$COMMAND"; then
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES exfat* ntfs* squashfs-tools util-linux"
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES exfatprogs ntfs-3g squashfs-tools fuse lsblk"
    fi

    COMMAND="openvpn"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES coreutils openvpn"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES coreutils openvpn"
        [ "$PACKING_MECHANISM" = "pacman" ] && PACKAGES="$PACKAGES coreutils openvpn"
    fi

    COMMAND="git"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES git"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES git"
        [ "$PACKING_MECHANISM" = "pacman" ] && PACKAGES="$PACKAGES git"
    fi

    COMMAND="jq"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES jq"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES jq"
        [ "$PACKING_MECHANISM" = "pacman" ] && PACKAGES="$PACKAGES jq"
    fi

    COMMAND="yamllint"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES yamllint"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES yamllint"
        [ "$PACKING_MECHANISM" = "pacman" ] && PACKAGES="$PACKAGES yamllint"
    fi

    COMMAND="nmap"
    if grep -q -rnw "$commands/" -e "$COMMAND"; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES nmap nmap-scripts"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES nmap"
    fi

    COMMAND="smbclient"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES samba samba-client ntfs-3g"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES samba smbclient ntfs-3g"
        [ "$PACKING_MECHANISM" = "pacman" ] && PACKAGES="$PACKAGES samba smbclient"
    fi

    COMMAND="sqlite3"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES sqlite"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES sqlite3"
        [ "$PACKING_MECHANISM" = "pacman" ] && PACKAGES="$PACKAGES sqlite3"
    fi

    COMMAND="cifs"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES cifs-utils keyutils"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES cifs-utils keyutils"
        [ "$PACKING_MECHANISM" = "pacman" ] && PACKAGES="$PACKAGES cifs-utils keyutils"
    fi

    COMMAND="ping"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES exfat* ntfs* squashfs-tools util-linux"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES iputils"
    fi

    COMMAND="pip"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES py3-pip"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES pip"
        [ "$PACKING_MECHANISM" = "pacman" ] && PACKAGES="$PACKAGES pip"
    fi

    COMMAND="wget"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apt" ] && PACKAGES="$PACKAGES wget"
        [ "$PACKING_MECHANISM" = "apk" ] && PACKAGES="$PACKAGES wget"
        [ "$PACKING_MECHANISM" = "wget" ] && PACKAGES="$PACKAGES wget"
    fi
done

# Install prepared apps
[ "$VERBOSE" = true ] && echo "installing packages: $PACKAGES"
if [ "$PACKING_MECHANISM" = "apt" ]; then apt-get update >/dev/null; fi
if [ "$PACKING_MECHANISM" = "pacman" ]; then pacman -Sy >/dev/null; fi

for packageList in $PACKAGES; do
    [ "$VERBOSE" = true ] && echo "... $packageList"
    if [ "$PACKING_MECHANISM" = "apt" ]; then
        apt-get install -yqq --no-install-recommends "$packageList" &>/dev/null || (echo "Error: $packageList was not found" && touch /ERROROCCURED)
    elif [ "$PACKING_MECHANISM" = "apk" ]; then
        apk add --no-cache "$packageList" &>/dev/null || (echo "Error: $packageList was not found" && touch /ERROROCCURED)
    elif [ "$PACKING_MECHANISM" = "pacman" ]; then
        pacman --noconfirm -S "$packageList" &>/dev/null || (echo "Error: $packageList was not found" && touch /ERROROCCURED)
    fi
    [ "$VERBOSE" = true ] && echo "... $packageList succesfully executed"
done

# Cleanup
[ "$VERBOSE" = true ] && echo "Cleaning apt cache"
if [ "$PACKING_MECHANISM" = "apt" ]; then apt-get clean >/dev/null; fi

# Replace old nginx directory
if ls /etc/nginx2 1>/dev/null 2>&1; then
    [ "$VERBOSE" = true ] && echo "replace nginx2"
    rm -r /etc/nginx
    mv /etc/nginx2 /etc/nginx
    mkdir -p /var/log/nginx
    touch /var/log/nginx/error.log
fi

# Install micro texteditor
curl https://getmic.ro | bash
mv micro /usr/bin
micro -plugin install bounce
micro -plugin install filemanager

for commands in "/etc/services.d" "/etc/cont-init.d"; do

    if ! ls $commands 1>/dev/null 2>&1; then continue; fi

    if grep -q -rnw "$commands/" -e 'bashio' && [ ! -f "/usr/bin/bashio" ]; then
        [ "$VERBOSE" = true ] && echo "install bashio"
        BASHIO_VERSION="0.15.0"
        mkdir -p /tmp/bashio
        curl -f -L -s -S "https://github.com/hassio-addons/bashio/archive/v${BASHIO_VERSION}.tar.gz" | tar -xzf - --strip 1 -C /tmp/bashio
        mv /tmp/bashio/lib /usr/lib/bashio
        ln -s /usr/lib/bashio/bashio /usr/bin/bashio
        rm -rf /tmp/bashio
    fi

    COMMAND="lastversion"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "install $COMMAND"
        pip install $COMMAND
    fi

    # Install tempio
    if grep -q -rnw "$commands/" -e 'tempio' && [ ! -f "/usr/bin/tempio" ]; then
        [ "$VERBOSE" = true ] && echo "install tempio"
        TEMPIO_VERSION="2021.09.0"
        BUILD_ARCH="$(bashio::info.arch)"
        curl -f -L -f -s -o /usr/bin/tempio "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}"
        chmod a+x /usr/bin/tempio
    fi

    COMMAND="mustache"
    if grep -q -rnw "$commands/" -e "$COMMAND" && ! command -v $COMMAND &>/dev/null; then
        [ "$VERBOSE" = true ] && echo "$COMMAND required"
        [ "$PACKING_MECHANISM" = "apk" ] && apk add --no-cache go npm &&
        apk upgrade --no-cache &&
        apk add --no-cache --virtual .build-deps build-base git go &&
        go get -u github.com/quantumew/mustache-cli &&
        cp "$GOPATH"/bin/* /usr/bin/ &&
        rm -rf "$GOPATH" /var/cache/apk/* /tmp/src &&
        apk del .build-deps xz build-base
        [ "$PACKING_MECHANISM" = "apt" ] && apt-get update &&
        apt-get install -yqq go npm node-mustache
    fi
done

if [ -f /ERROROCCURED ]; then
    exit 1
fi