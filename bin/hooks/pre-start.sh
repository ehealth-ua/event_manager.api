#!/bin/sh
# `pwd` should be /opt/event_manager
APP_NAME="event_manager"

if [ "${DB_MIGRATE}" == "true" ]; then
  echo "[WARNING] Migrating database!"
  ./bin/$APP_NAME command "${APP_NAME}_tasks" migrate!
fi;
