#!/bin/sh
# shellcheck disable=SC2015
set -e
# Auto resolve packages

PACKAGES="$1"
echo "Packages : $PACKAGES"

# Install missing sources
if ! command -v bash >/dev/null 2>/dev/null; then
    (apt-get update && apt-get install -yqq --no-install-recommends bash || apk add --no-cache bash) >/dev/null
fi
if ! command -v curl >/dev/null 2>/dev/null; then

    (apt-get update && apt-get install -yqq --no-install-recommends curl || apk add --no-cache curl) >/dev/null
fi

# Run installer script
curl -f -L -s -S "https://raw.githubusercontent.com/anonymoesje/home-assistant-magic/master/.scripts/ha-install-packages.sh" --output /install-packages.sh
chmod 777 /ha-install-packages.sh
eval /./ha-install-packages.sh "${PACKAGES:-}"

# Cleanup
rm /ha-install-packages.sh