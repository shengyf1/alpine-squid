# hadolint ignore=DL3006
ARG IMAGE_FROM_SHA
# hadolint ignore=DL3007
FROM jfxs/ci-toolkit:latest as ci-toolkit

# hadolint ignore=DL3006
FROM ${IMAGE_FROM_SHA}

ARG IMAGE_FROM_SHA
ARG SQUID_VERSION
ARG BUILD_DATE
ARG VCS_REF="DEV"

ENV container docker

LABEL maintainer="FX Soubirou <soubirou@yahoo.fr>" \
    org.opencontainers.image.title="alpine-squid" \
    org.opencontainers.image.description="A lightweight automatically updated alpine squid image" \
    org.opencontainers.image.authors="FX Soubirou <soubirou@yahoo.fr>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.version="${SQUID_VERSION}" \
    org.opencontainers.image.url="https://hub.docker.com/r/jfxs/alpine-squid" \
    org.opencontainers.image.source="https://gitlab.com/op_so/docker/alpine-squid" \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.created=${BUILD_DATE}

COPY files/uid-entrypoint.sh /usr/local/bin/
COPY --from=ci-toolkit /usr/local/bin/get-local-versions.sh /usr/local/bin/get-local-versions.sh

# hadolint ignore=DL3018
RUN apk --no-cache add ca-certificates squid tzdata \
    && chmod 755 /usr/local/bin/uid-entrypoint.sh \
    && chmod 755 /usr/local/bin/get-local-versions.sh \
    && mkdir -p /etc/squid/conf.d /var/log/squid /var/cache/squid \
    && chgrp -R 0 /var/log/squid /var/cache/squid \
    && chmod -R g=u /var/log/squid /var/cache/squid \
    && sed -i '1s;^;include /etc/squid/conf.d/*.conf\n;' /etc/squid/squid.conf \
    && /usr/local/bin/get-local-versions.sh -f ${IMAGE_FROM_SHA} -a squid

ENV TZ=UTC

COPY files/squid-docker.conf /etc/squid/conf.d/

ENTRYPOINT ["uid-entrypoint.sh"]

USER 10010
EXPOSE 3128
CMD ["squid", "-N"]
