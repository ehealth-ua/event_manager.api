#!/bin/sh
APP_NAME="event_manager_web"

if [ "${DB_MIGRATE}" == "true" ]; then
  echo "[WARNING] Migrating database!"
  ./bin/$APP_NAME command Elixir.EventManagerApi.ReleaseTasks seed
fi;
