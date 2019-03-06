#!/bin/sh
APP_NAME="event_manager"

if [ "${DB_MIGRATE}" == "true" ] && [ -f "./bin/${APP_NAME}" ]; then
  echo "[WARNING] Migrating database!"
  ./bin/$APP_NAME command Elixir.Core.ReleaseTasks migrate
fi;
