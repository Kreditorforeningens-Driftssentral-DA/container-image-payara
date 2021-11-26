# https://mvnrepository.com/artifact/fish.payara

# Payara ONLY supports Java LTS versions (8,11,17)
# https://blog.payara.fish/why-payara-platform-only-supports-lts-versions-of-jdk
ARG BASE_IMAGE="azul/zulu-openjdk-debian:11"
#ARG BASE_IMAGE="azul/zulu-openjdk-debian:17-jre"

FROM ${BASE_IMAGE}

# 6.2021.1.Alpha1
ARG PAYARA_VERSION="5.2021.9"
ARG PAYARA_ADMIN_SECRET="Admin123"
ARG EXTRA_LOCALES="nb_NO"

# Override at runtime, if required. Example:
#   * TZ="Europe/Oslo"
#   * LC_ALL="nb_NO.ISO-8859-1"
ENV LC_ALL="C" \
    JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=85.0 -XX:InitialRAMPercentage=85.0 -XX:+ExitOnOutOfMemoryError"

ENV PAYARA_VERSION="${PAYARA_VERSION}" \
    DOMAIN_NAME="payara" \
    PAYARA_USER="payara" \
    ADMIN_USER="admin" \
    PAYARA_DIR="/opt/payara"

ENV CONFIG_DIR="${PAYARA_DIR}/config" \
    SCRIPT_DIR="${PAYARA_DIR}/scripts" \
    DEPLOY_DIR="${PAYARA_DIR}/deploy" \
    PATH_ADMIN_SECRET="${PAYARA_DIR}/secret.txt"

ENV PATH_PREBOOT_COMMANDS="${CONFIG_DIR}/preboot-commands.asadmin" \
    PATH_POSTBOOT_COMMANDS="${CONFIG_DIR}/postboot-commands.asadmin"

# Administration
# 4848 for Admin.
# 9009 for JAVA_DEBUGGER.
EXPOSE 4848 9009

# Applications
# 8080 for HTTP Instance.
# 8181 for HTTP_SSL.
EXPOSE 8080 8181

# Other
# 7676 for JMS.
# 3700 for IIOP.
# 3820 for IIOP_SSL.
# 3920 for IIOP_MUTUALAUTH.
# 8686 for JMX_ADMIN.
# 6666 for OSGI_SHELL.
# 4900 for Hazelcast DAS.
# 5900 for Hazelcast Start.
#EXPOSE 7676 3700 3820 3920 8686 6666 4900 5900

# ADD CUSTOM LOCALE(S)
RUN set -ex \
  && for PREFIX in ${EXTRA_LOCALES};do sed -i "/${PREFIX}/s/^# \?//g" /etc/locale.gen;done \
  && locale-gen \

# INSTALL EXTRA PACKAGES
RUN set -ex \
  && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get update \
  && apt-get -qqy install --no-install-recommends  apt-utils > /dev/null 2>&1 \
  && apt-get -qqy install --no-install-recommends tar unzip curl gosu dumb-init \
  && apt-get autoclean

# PAYARA USER CONFIGURATION
RUN set -ex \
  && useradd --system \
     --comment "Payara User" \
     --home-dir ${PAYARA_DIR} --no-create-home \
     --user-group \
     ${PAYARA_USER}

# DOWNLOAD & EXTRACT PAYARA
RUN set -ex \
  && curl --output /tmp/payara.zip --fail --silent --show-error --location --retry 5 --connect-timeout 5 https://repo1.maven.org/maven2/fish/payara/distributions/payara/${PAYARA_VERSION}/payara-${PAYARA_VERSION}.zip \
  && unzip -qq -d /tmp /tmp/payara.zip \
  && mv /tmp/payara$(echo ${PAYARA_VERSION}|awk -F. '{print $1}') ${PAYARA_DIR} \
  && rm -rf ${PAYARA_DIR}/glassfish/domains/** \
  && rm -rf /tmp/payara.zip

# CONFIGURE PAYARA PASSWORD
RUN set -ex \
  && touch ${PATH_ADMIN_SECRET} \
  && printf "%s\n%s\n" "AS_ADMIN_PASSWORD=" "AS_ADMIN_NEWPASSWORD=${PAYARA_ADMIN_SECRET}" > ${PATH_ADMIN_SECRET} \
  && ${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} create-domain --nopassword=true ${DOMAIN_NAME} \
  && ${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} change-admin-password --domain_name=${DOMAIN_NAME} \
  && printf "%s\n" "AS_ADMIN_PASSWORD=${PAYARA_ADMIN_SECRET}" > ${PATH_ADMIN_SECRET}

# CUSTOMIZE PAYARA
RUN set -ex \
  && ${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} start-domain ${DOMAIN_NAME} \
  && ${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} enable-secure-admin \
  && ${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} create-jvm-options "\-Dlogback.configurationFile=${CONFIG_DIR}/logback.xml" \
  && for JVM_OPTION in $(${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} list-jvm-options|grep -E "Xm[sx]");do \
       ${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} delete-jvm-options ${JVM_OPTION}; \
     done \
  && ${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} stop-domain --kill=true ${DOMAIN_NAME} \
  && chown -R ${PAYARA_USER}:${PAYARA_USER} ${PAYARA_DIR}

COPY ["docker-entrypoint.sh","/usr/local/bin/docker-entrypoint.sh"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
