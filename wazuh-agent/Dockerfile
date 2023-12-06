# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
ARG BUILD_VERSION
FROM $BUILD_FROM

# Prevent S6 from failing by increasing wit-time
ENV S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_SERVICES_GRACETIME=0 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 

# Execute during the build of the image
ARG TEMPIO_VERSION BUILD_ARCH
RUN \
    curl -sSLf -o /usr/bin/tempio \
    "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}"

# Copy root filesystem
COPY rootfs /
