#!/usr/bin/env bash
echo "Hello!"
SCRIPT_DIR=/opt/demo.d
EXAMPLE_FILE=hello_world.txt
mkdir -p ${SCRIPT_DIR}/example.d
touch ${SCRIPT_DIR}/${EXAMPLE_FILE}
ls -lsh /opt
ls -lsh ${SCRIPT_DIR}
echo "Bye!"