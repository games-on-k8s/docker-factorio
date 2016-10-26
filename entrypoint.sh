#!/bin/bash
# This script was heavily inspired by:
# https://github.com/zopanix/docker_factorio_server
set -e
echo '      ___         ___           ___                       ___           ___                       ___     '
echo '     /  /\       /  /\         /  /\          ___        /  /\         /  /\        ___          /  /\    '
echo '    /  /:/_     /  /::\       /  /:/         /  /\      /  /::\       /  /::\      /  /\        /  /::\   '
echo '   /  /:/ /\   /  /:/\:\     /  /:/         /  /:/     /  /:/\:\     /  /:/\:\    /  /:/       /  /:/\:\  '
echo '  /  /:/ /:/  /  /:/~/::\   /  /:/  ___    /  /:/     /  /:/  \:\   /  /:/~/:/   /__/::\      /  /:/  \:\ '
echo ' /__/:/ /:/  /__/:/ /:/\:\ /__/:/  /  /\  /  /::\    /__/:/ \__\:\ /__/:/ /:/___ \__\/\:\__  /__/:/ \__\:\'
echo ' \  \:\/:/   \  \:\/:/__\/ \  \:\ /  /:/ /__/:/\:\   \  \:\ /  /:/ \  \:\/:::::/    \  \:\/\ \  \:\ /  /:/'
echo '  \  \::/     \  \::/       \  \:\  /:/  \__\/  \:\   \  \:\  /:/   \  \::/~~~~      \__\::/  \  \:\  /:/ '
echo '   \  \:\      \  \:\        \  \:\/:/        \  \:\   \  \:\/:/     \  \:\          /__/:/    \  \:\/:/  '
echo '    \  \:\      \  \:\        \  \::/          \__\/    \  \::/       \  \:\         \__\/      \  \::/   '
echo '     \__\/       \__\/         \__\/                     \__\/         \__\/                     \__\/    '

# Setting initial command
factorio_command="/opt/factorio/bin/x64/factorio --server-settings /opt/factorio/server-settings.json"

# Populate server-settings.json
SERVER_SETTINGS=/opt/factorio/server-settings.json
python3 /opt/gen_config.py > ${SERVER_SETTINGS}

echo "###"
echo "# Generated server-settings.json"
echo "###"
cat ${SERVER_SETTINGS}

if [ -z $FACTORIO_RCON_PORT ]
then
  factorio_command="$factorio_command --rcon-port ${FACTORIO_RCON_PORT:-27015}"
  echo "###"
  echo "# RCON port is '${FACTORIO_RCON_PORT}'"
  echo "###"
fi

if [ -z $FACTORIO_RCON_PASSWORD ]
then
  FACTORIO_RCON_PASSWORD=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c16)
  echo "###"
  echo "# RCON password is '${FACTORIO_RCON_PASSWORD}'"
  echo "###"
  factorio_command="${factorio_command} --rcon-password ${FACTORIO_RCON_PASSWORD}"
fi

# TODO Adding this because of bug, will need to be removed once bug in factorio is fixed
cd /opt/factorio/saves
# Handling save settings
save_dir="/opt/factorio/saves"
if [ -z $FACTORIO_SAVE ]
then
  if [ "$(ls --hide=lost\+found ${save_dir})" ]
  then
    echo "###"
    echo "# Taking latest save"
    echo "###"
    ls -l --hide=lost\+found ${save_dir}
  else
    echo "###"
    echo "# Creating a new map [save.zip]"
    echo "###"
    /opt/factorio/bin/x64/factorio --create save.zip
  fi
  factorio_command="${factorio_command} --start-server-load-latest"
else
  factorio_command="${factorio_command} --start-server ${FACTORIO_SAVE}"
fi
echo "###"
echo "# Launching Game"
echo "###"
# Closing stdin
exec 0<&-
exec ${factorio_command}
