FROM ubuntu:latest
RUN set -e \
    && apt-get update \
    && apt-get -qqy install tini

COPY ./entrypoint.sh .
ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["/entrypoint.sh"]