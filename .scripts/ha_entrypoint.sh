#!/command/with-contenv bashio
# shellcheck shell=bash
set -e
echo "Starting..."

####################
# Starting scripts #
####################

for SCRIPTS in /etc/cont-init.d/*; do
    [ -e "$SCRIPTS" ] || continue
    echo "$SCRIPTS: executing"

    # Ensure permissions
    chown "$(id -u)":"$(id -g)" "$SCRIPTS"
    chmod a+x "$SCRIPTS"

    # Get current shebang, if not available use another
    currentshebang="$(sed -n '1{s/^#![[:blank:]]*//p;q}' "$SCRIPTS")"
    if [ ! -f "${currentshebang%% *}" ]; then
        for shebang in "/command/with-contenv bashio" "/usr/bin/env bashio" "/usr/bin/bashio" "/bin/bash" "/bin/sh"; do if [ -f "${shebang%% *}" ]; then break; fi; done
        sed -i "s|$currentshebang|$shebang|g" "$SCRIPTS"
    fi

    # Start the script
    /./"$SCRIPTS" || echo -e "\033[0;31mError\033[0m : $SCRIPTS exiting $?"

    # Cleanup
    rm "$SCRIPTS"
done

######################
# Starting container #
######################

echo " "
echo -e "\033[0;32mStarting the upstream container\033[0m"
echo " "

# Launch lsio mods
if [ -f /docker-mods ]; then exec /docker-mods; fi
