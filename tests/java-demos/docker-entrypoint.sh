#!/usr/bin/env bash
set -e

echo "Project folder is: ${PROJ_NAME}"

if [ "$1" = 'shell' ]; then
  shift
  set -- /bin/bash

elif [ "$1" = 'init' ]; then
  echo "Initializing project: ${PROJ_NAME}"
  mvn archetype:generate \
    -DgroupId=${PROJ_PKG} \
    -DartifactId=${PROJ_NAME} \
    -DarchetypeArtifactId=${MVN_TEMPLATE} \
    -DinteractiveMode=false
  if [ "$2" = 'archive' ]; then
    tar -czf /exports/${PROJ_NAME}.tar.gz /${PROJ_NAME}
  else
    mv /${PROJ_NAME} /exports
  fi
  exit 0
fi

exec "$@"
