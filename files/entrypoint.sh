#!/bin/sh
echo "Launching OmegA server..."

echo "Copying default configs..."
    cp /opt/openarena/default-configs/* /opt/openarena/baseoa/

if [ "$(ls -A /opt/openarena/configs)" ]; then
    echo "Copying custom configs..."
    cp /opt/openarena/configs/* /opt/openarena/baseoa/
fi

if [ -z "${SERVER_ARGS}" ]; then
    echo "No additional server arguments found; running default Deathmatch configuration."
    SERVER_ARGS="+exec server_ffa.cfg"
fi

if [ -z "${SERVER_MOTD}" ]; then
    SERVER_MOTD="Welcome to my OmegA server!"
fi

if [ -z "${ADMIN_PASSWORD}" ]; then
    ADMIN_PASSWORD=$(cat /dev/urandom | head -c${1:-32} | base64)
    echo "No admin password set; defaulting to ${ADMIN_PASSWORD}."
fi

OMGDED_BIN="/usr/lib/omega-engine/omgded"

echo "Command line:"
echo '${OMGDED_BIN} +seta rconPassword "${ADMIN_PASSWORD}" +g_motd "${SERVER_MOTD}" +exec common.cfg ${SERVER_ARGS}"'

${OMGDED_BIN} \
    +set fs_basepath /opt/openarena \
    +seta rconPassword "${ADMIN_PASSWORD}" \
    +g_motd "${SERVER_MOTD}" \
    +exec common.cfg \
    ${SERVER_ARGS}
