FROM maven:3-openjdk-11-slim

ARG PROJ_PKG
ARG PROJ_NAME
ARG MVN_TEMPLATE

ENV PROJ_PKG=${PROJ_PKG:-com.web.example} \
    PROJ_NAME=${PROJ_NAME:-example} \
    MVN_TEMPLATE=${MVN_TEMPLATE:-maven-archetype-webapp}

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

VOLUME ["/exports"]
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["init"]
