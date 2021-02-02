#!/usr/bin/env bash
PAYARA_DIR=${PAYARA_DIR}
PAYARA_ARGS=${PAYARA_ARGS}
JVM_ARGS=${JVM_ARGS}
CONFIG_DIR=${CONFIG_DIR}
SCRIPT_DIR=${SCRIPT_DIR}
DEPLOY_DIR=${DEPLOY_DIR}
DEPLOY_PROPS=${DEPLOY_PROPS}
DOMAIN_NAME=${DOMAIN_NAME}
PATH_PREBOOT_COMMANDS=${PATH_PREBOOT_COMMANDS}
PATH_POSTBOOT_COMMANDS=${PATH_POSTBOOT_COMMANDS}
ADMIN_USER=${ADMIN_USER}
PATH_ADMIN_SECRET=${PATH_ADMIN_SECRET}

printf "[INFO] Creating ${CONFIG_DIR}, if missing\n"
mkdir -p ${CONFIG_DIR}
# -----------------------------------------------
# RUN CUSTOM STARTUP SCRIPTS (AS ROOT)
# -----------------------------------------------
printf "[INFO] Creating ${SCRIPT_DIR}/init.d, if missing\n"
mkdir -p ${SCRIPT_DIR}/init.d

printf '#!/usr/bin/env bash\necho "dummy script"\n' > ${SCRIPT_DIR}/init_0_dummy.sh
printf '#!/usr/bin/env bash\necho "dummy script"\n' > ${SCRIPT_DIR}/init.d/dummy.sh

# Execute init-scripts
printf "[INFO] Files in ${SCRIPT_DIR}\n"
find ${SCRIPT_DIR} -maxdepth 1 -type f
for file in ${SCRIPT_DIR}/init_*.sh; do
  printf "[Entrypoint] Running ${file}\n"
  chmod +x ${file}
  . ${file}
done

# Execute other scripts
printf "[INFO] Files in ${SCRIPT_DIR}/init.d"
find ${SCRIPT_DIR}/init.d -maxdepth 1 -type f 
for file in ${SCRIPT_DIR}/init.d/*.sh; do
  printf "[Entrypoint] Running ${file}\n"
  chmod +x ${file}
  . ${file}
done

# -----------------------------------------------
# CREATE BOOT-COMMAND FILES
# -----------------------------------------------
printf "[INFO] Creating pre/post-boot command files, if missing\n"
touch ${PATH_PREBOOT_COMMANDS}
touch ${PATH_POSTBOOT_COMMANDS}

# -----------------------------------------------
# CONFIGURE AUTO-DEPLOYMENT
# -----------------------------------------------
printf "[INFO] Creating deployment directory, if missing\n"
mkdir -p ${DEPLOY_DIR}

# Define function for appending deployments to postboot-command-file
deploy() {
  # Check if input is empty
  if [ -z ${1} ]; then
    printf "Nothing to deploy\n"
    return 0;
  fi

  # Check if command already exists
  if grep -q ${1} ${PATH_POSTBOOT_COMMANDS}; then
    echo "Ignoring already included deployment: ${1}"
  else
    echo "Adding deployment to postboot-command: ${1}"
    echo "deploy ${DEPLOY_PROPS} ${1}" >> ${PATH_POSTBOOT_COMMANDS}
  fi
}

# Check for rar-files/folders to deploy first
printf "[INFO] Deploying rar-files/folders\n"
for deployment in $(find ${DEPLOY_DIR} -mindepth 1 -maxdepth 1 -name "*.rar"); do
  deploy ${deployment}
done

# Check for war, jar, ear-files or directory to deploy (exluding *.rar files/folders)
printf "[INFO] Deploying other files/folders\n"
for deployment in $(find ${DEPLOY_DIR} -mindepth 1 -maxdepth 1 ! -name "*.rar" -a -name "*.war" -o -name "*.ear" -o -name "*.jar" -o -type d); do
  deploy ${deployment}
done

# -----------------------------------------------
# VALIDATE PAYARA COMMAND (DRY-RUN)
# -----------------------------------------------
printf "[INFO] Validating payara command\n"
OUTPUT=`${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} start-domain --dry-run --prebootcommandfile=${PATH_PREBOOT_COMMANDS} --postbootcommandfile=${PATH_PREBOOT_COMMANDS} ${PAYARA_ARGS} ${DOMAIN_NAME}`
OUTPUT_STATUS=${?}
if [ "${OUTPUT_STATUS}" -ne 0 ]
  then
    # Print to stderr & exit
    printf "ERROR-MESSAGE [${OUTPUT_STATUS}]:\n${OUTPUT}\n" >&2
    exit 1
fi

# -----------------------------------------------
# ADD JVM PARAMETERS TO STARTUP-COMMAND
# -----------------------------------------------
printf "[INFO] Appending JVM-parameters to payara command\n"
COMMAND=`echo "${OUTPUT}" | sed -n -e '2,/^$/p' | sed "s|glassfish.jar|glassfish.jar ${JVM_ARGS}|g"`

# Print command, line by line
printf "[INFO] Finalized startup command:\n"
echo "${COMMAND}" | tr ' ' '\n'

# -----------------------------------------------
# START PAYARA
# -----------------------------------------------
printf "[INFO] Starting Payara Server..\n\n"
set -x
set -- ${COMMAND} < ${PATH_ADMIN_SECRET} 

# Run as unprivileged user
if id payara >/dev/null 2<&1; then
  chown -HR payara:root ${PAYARA_DIR}
  chown -HR payara:root ${CONFIG_DIR}
  chown -HR payara:root ${DEPLOY_DIR}
  chown -HR payara:root ${SCRIPT_DIR}
  set -- gosu payara ${@}
fi

exec "${@}"
