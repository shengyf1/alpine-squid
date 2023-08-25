# hadolint ignore=DL3007
FROM alpine:latest

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

ENV container docker

LABEL maintainer="FX Soubirou <soubirou@yahoo.fr>" \
    org.opencontainers.image.title="alpine-squid" \
    org.opencontainers.image.description="A lightweight automatically updated alpine squid image" \
    org.opencontainers.image.authors="FX Soubirou <soubirou@yahoo.fr>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.url="https://hub.docker.com/r/jfxs/alpine-squid" \
    org.opencontainers.image.source="https://gitlab.com/op_so/docker/alpine-squid" \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.created=${BUILD_DATE}

COPY files/uid-entrypoint.sh /usr/local/bin/

# hadolint ignore=DL3018
RUN apk --no-cache add ca-certificates squid tzdata \
    && chmod 755 /usr/local/bin/uid-entrypoint.sh \
    && mkdir -p /etc/squid/conf.d /var/log/squid /var/cache/squid \
    && chgrp -R 0 /var/log/squid /var/cache/squid \
    && chmod -R g=u /etc/passwd /var/log/squid /var/cache/squid \
    && sed -i '1s;^;include /etc/squid/conf.d/*.conf\n;' /etc/squid/squid.conf

ENV TZ=UTC

COPY files/squid-docker.conf /etc/squid/conf.d/

ENTRYPOINT ["uid-entrypoint.sh"]

USER 10010
EXPOSE 3128
CMD ["squid", "-N"]
