#!/usr/bin/env bash
# WHAT: https://github.com/payara/Payara/issues/2267
# Place file in ${SCRIPT_DIR}/init.d/
echo 127.0.0.1 `cat /etc/hostname` >> /etc/hosts
