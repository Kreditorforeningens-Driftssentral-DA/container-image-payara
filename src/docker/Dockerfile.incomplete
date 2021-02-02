ARG BASE_IMAGE_NAME="azul/zulu-openjdk"
ARG BASE_IMAGE_VER="11"

# Create server image
FROM ${BASE_IMAGE_NAME}:${BASE_IMAGE_VER}

# Default Payara ports
#  4848 : admin console
#  9009 : debug port (JPDA)
#  8080 : http
#  8181 : https
EXPOSE 4848 9009 8080 8181 2020

# Build-time parameters
ARG BASE_IMAGE_UPGRADE="yes"
ARG PAYARA_VERSION="5.2020.7"
ARG PAYARA_PKG="https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/${PAYARA_VERSION}/payara-${PAYARA_VERSION}.zip"
ARG PAYARA_SHA1="1a25115eb30a95fd7595da58b78b62f7ee0de173"
ARG TINI_VERSION="v0.18.0"

# Image parameters
ENV TIMEZONE           Europe/Oslo
ENV LANGUAGE           nb_NO.ISO-8859-1
ENV BASE_IMAGE_UPGRADE ${BASE_IMAGE_UPGRADE}

# Version parameters
ENV PAYARA_VERSION ${PAYARA_VERSION}
ENV PAYARA_PKG     ${PAYARA_PKG}
ENV PAYARA_SHA1    ${PAYARA_SHA1}
ENV TINI_VERSION   ${TINI_VERSION}

# Payara parameters
ENV HOME_DIR          /opt/payara
ENV PAYARA_DIR        /opt/payara/appserver
ENV SCRIPT_DIR        /opt/payara/scripts
ENV CONFIG_DIR        /opt/payara/config
ENV DEPLOY_DIR        /opt/payara/deployments
ENV PASSWORD_FILE     /opt/payara/passwordFile
ENV POSTBOOT_COMMANDS /opt/payara/config/post-boot-commands.asadmin
ENV PREBOOT_COMMANDS  /opt/payara/config/pre-boot-commands.asadmin
ENV PATH              "${PATH}:${PAYARA_DIR}/bin"
ENV DOMAIN_NAME       production
ENV ADMIN_USER        admin
ENV ADMIN_PASSWORD    admin123
ENV PAYARA_AUTODEPLOY  /kds

# Java parameters
ENV JAVA_TOOL_OPTIONS  -Dfile.encoding=ISO-8859-1 -Duser.language=nb -Duser.country=NO

# Create user
RUN set -eux \
  && groupadd -g 1000 payara \
  && useradd -u 1000 -M -s /bin/bash -d ${HOME_DIR} payara -g payara \
  && echo payara:payara | chpasswd

# Install required packages
RUN set -eux \
  && apt-get update \
  && apt-get install -qy apt-utils \
  && apt-get install -qy wget unzip curl wget jq \
  && rm -rf /var/lib/apt/lists/*

# Custom Commands
RUN set -eux \
  && mkdir -p ${CUSTOM_APPS} \
  && ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo "nb_NO ISO-8859-1" >> /etc/locale.gen \
  && apt-get update && apt-get install -y gnupg2 \
  && apt-get --quiet update \
  && if [ "${BASE_IMAGE_UPGRADE}" = "yes" ]; then apt-get --yes --quiet upgrade ; else echo "Skipping base image updates" ;fi \
  && apt-get --yes --quiet install jq locales tzdata curl wget language-pack-nb \
  && rm -rf /var/lib/apt/lists/* \
  && cd /usr/local/bin \
  && curl -fSL -o promtail.gz "https://github.com/grafana/loki/releases/download/v1.6.1/promtail-linux-amd64.zip" \
  && gunzip promtail.gz \
  && chmod a+x promtail \
  && useradd --system promtail \  
  && dpkg-reconfigure -f noninteractive tzdata \
  && locale-gen 

# Create working directories
RUN set -eux \
  && mkdir -p ${DEPLOY_DIR} \
  && mkdir -p ${CONFIG_DIR} \
  && mkdir -p ${SCRIPT_DIR} \  
  && chown -R payara: ${HOME_DIR} \
  && chown -R payara: ${CUSTOM_APPS}

# Install tini as minimized init system
RUN set -eux \
  && wget  --no-verbose -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
  && wget  --no-verbose -O /tini.asc https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc \
  && wget  --no-verbose -O /tmp/payara-logback-delegation-1.0.0.jar https://repo1.maven.org/maven2/io/github/goodees/payara-logback-delegation/1.0.0/payara-logback-delegation-1.0.0.jar \
  && wget --no-verbose -O /tmp/logstash-logback-encoder.jar https://repo1.maven.org/maven2/net/logstash/logback/logstash-logback-encoder/6.6/logstash-logback-encoder-6.6.jar \
  #&& gpg --batch --keyserver "hkp://p80.pool.sks-keyservers.net:80" --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
  #&& gpg --batch --verify /tini.asc /tini \
  && chmod +x /tini

# Rest of commands are executed as restricted payara user
USER payara
WORKDIR ${HOME_DIR}


# Download and unzip the Payara distribution
RUN wget --no-verbose -O payara.zip ${PAYARA_PKG} \
  && echo "${PAYARA_SHA1} *payara.zip" | sha1sum -c - \
  && unzip -qq payara.zip -d ./ \
  && mv payara*/ appserver \
  && cp -R /opt/payara/appserver/glassfish/domains/domain1  /opt/payara/appserver/glassfish/domains/production \
  && echo "AS_ADMIN_PASSWORD=\nAS_ADMIN_NEWPASSWORD=${ADMIN_PASSWORD}" > /tmp/tmpfile \
  && echo "AS_ADMIN_PASSWORD=${ADMIN_PASSWORD}" >> ${PASSWORD_FILE} \
  && ${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=/tmp/tmpfile change-admin-password --domain_name=${DOMAIN_NAME} \
  && ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} start-domain ${DOMAIN_NAME} \
  && ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} enable-secure-admin \
  && ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} deploy --type osgi /tmp/payara-logback-delegation-1.0.0.jar \
  && ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} create-jvm-options "-Dlogback.configurationFile=/opt/payara/scripts/logback.xml" \
  #&& ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} set-log-attributes "handlers=org.slf4j.bridge.SLF4JBridgeHandler" \
  && for MEMORY_JVM_OPTION in $(${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} list-jvm-options | grep "Xm[sx]"); do \
       ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} delete-jvm-options $MEMORY_JVM_OPTION; \
     done \
  && ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} create-jvm-options '-XX\:+UseContainerSupport:-XX\:MaxRAMPercentage=75' \
  && ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} set-log-attributes com.sun.enterprise.server.logging.GFFileHandler.logtoFile=false \
  && ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} create-jvm-options '-Dfile.encoding=ISO-8859-1:-Duser.language=nb:-Duser.country=NO' \
  && ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} stop-domain ${DOMAIN_NAME} \
  # Cleanup unused files
  && rm -rf \
       /tmp/tmpFile \
       payara.zip \
       ${PAYARA_DIR}/glassfish/domains/${DOMAIN_NAME}/osgi-cache \
       ${PAYARA_DIR}/glassfish/domains/${DOMAIN_NAME}/logs \
       ${PAYARA_DIR}/glassfish/domains/domain1

# Copy docker startup-scripts
COPY --chown=payara:payara bin/*.* ${SCRIPT_DIR}/

# Create directories script-directories for deployment
RUN set -eux \
  && mkdir -p ${SCRIPT_DIR}/init.d \
  && chmod +x ${SCRIPT_DIR}/*

# -- Run non-root customization scripts
RUN set -eux \
  && ${SCRIPT_DIR}/customize_GetDeps.sh

# -- Change password
# TODO: https://mikecroft.io/2017/07/31/change-payara-password.html

ENTRYPOINT ["/tini", "--"]
CMD ${SCRIPT_DIR}/entrypoint.sh
