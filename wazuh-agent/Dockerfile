ARG BUILD_FROM
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-c"]

# Default ENV
ENV \
    LANG="C.UTF-8" \
    DEBIAN_FRONTEND="noninteractive" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_SERVICES_READYTIME=50

COPY rootfs/ /

ARG CONFIG_LOCATION="/config/addons_config"
ARG MODULES="00-banner.sh 01-custom_script.sh 00-global_var.sh"

# Automatic modules download
ADD "https://raw.githubusercontent.com/Anonymoesje/home-assistant-magic/main/.scripts/ha_automodules.sh" "/ha_automodules.sh"
RUN chmod 744 /ha_automodules.sh && /ha_automodules.sh "$MODULES" && rm /ha_automodules.sh

# Manual apps
ENV PACKAGES="curl gpg wget wazuh-agent"

# Automatic apps & bashio
ADD "https://raw.githubusercontent.com/Anonymoesje/home-assistant-magic/main/.scripts/ha_autoapps.sh" "/ha_autoapps.sh"
RUN chmod 744 /ha_autoapps.sh && /ha_autoapps.sh "$PACKAGES" && rm /ha_autoapps.sh

# Add entrypoint
ENV S6_STAGE2_HOOK=/ha_entrypoint.sh
ADD "https://raw.githubusercontent.com/Anonymoesje/home-assistant-magic/main/.scripts/ha_entrypoint.sh" "/ha_entrypoint.sh"

# Entrypoint modifications
ADD "https://raw.githubusercontent.com/Anonymoesje/home-assistant-magic/main/.scripts/ha_entrypoint_modif.sh" "/ha_entrypoint_modif.sh"
RUN chmod 777 /ha_entrypoint.sh /ha_entrypoint_modif.sh && /ha_entrypoint_modif.sh && rm /ha_entrypoint_modif.sh

ENTRYPOINT [ "/usr/bin/env" ]
CMD [ "/ha_entrypoint.sh" ]