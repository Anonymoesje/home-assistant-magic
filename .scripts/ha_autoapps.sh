#!/bin/sh
# shellcheck disable=SC2015
set -e

##############################
# Download packages
##############################

PACKAGES="$1"
echo "To install : $PACKAGES"
echo "Before bash"
# Install bash if needed
if ! command -v bash >/dev/null 2>/dev/null; then
    echo "attempt bash"
    (apt-get update && apt-get install -yqq --no-install-recommends bash || apk add --no-cache bash) >/dev/null
fi
echo "Before curl"
# Install curl if needed
if ! command -v curl >/dev/null 2>/dev/null; then
    echo "attempt curl"
    (apt-get update && apt-get install -yqq --no-install-recommends curl || apk add --no-cache curl) >/dev/null
fi
echo "Before wget"
# Install wget if needed
if ! command -v wget >/dev/null 2>/dev/null; then
    echo "attempt wget"
    (apt-get update && apt-get install -yqq --no-install-recommends wget || apk add --no-cache wget) >/dev/null
fi


echo "Before eval"

# Call apps installer script if needed
curl -f -L -s -S "https://raw.githubusercontent.com/Anonymoesje/home-assistant-magic/main/.scripts/ha_automatic_packages.sh" --output /ha_automatic_packages.sh
chmod 777 /ha_automatic_packages.sh
eval /./ha_automatic_packages.sh "${PACKAGES:-}"

echo "Done evaluating"

# Clean
rm /ha_automatic_packages.sh
