# jfxs / alpine-squid

[![Software License](https://img.shields.io/badge/license-MIT-informational.svg?style=flat)](LICENSE)
[![Pipeline Status](https://gitlab.com/op_so/docker/alpine-squid/badges/main/pipeline.svg)](https://gitlab.com/op_so/docker/alpine-squid/pipelines)
[![Image size](https://op_so.gitlab.io/docker/alpine-squid/docker.svg)](https://hub.docker.com/r/jfxs/alpine-squid )

A [Squid](http://www.squid-cache.org/) Docker image:

* **lightweight** image based on Alpine Linux only 10 MB,
* multiarch with support of **amd64** and **arm64**,
* **non-root** container user,
* **automatically** updated with the [Automated Continuous Delivery of Docker images](https://medium.com/@fx_s/automated-continuous-delivery-of-docker-images-b4bfa0d09f95) pattern.

[![GitLab](https://shields.io/badge/Gitlab-informational?logo=gitlab&style=flat-square)](https://gitlab.com/op_so/docker/alpine-squid) The main repository.

[![Docker Hub](https://shields.io/badge/dockerhub-informational?logo=docker&logoColor=white&style=flat-square)](https://hub.docker.com/r/jfxs/alpine-squid) The Docker Hub registry.

## Getting Started

### Requirements

In order to run this container you'll need Docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Running the squid proxy

```shell
docker run -d --rm --name squid -p 3128:3128 jfxs/alpine-squid
```

The configuration of Squid is the default one, with some additions:

`/etc/squid/squid.conf`

```shell
# Include a folder of config files
include /etc/squid/conf.d/*.conf
```

`/etc/squid/conf.d/squid-docker.conf`

```shell
# Specific configuration for Docker usage
pid_filename none
logfile_rotate 0
access_log stdio:/dev/stdout
cache_log stdio:/dev/stderr
```

### Extend configuration

To add a custom configuration (configuration snippet):

```shell
docker run -d --rm --name squid -v /path/to/your/snippet.conf:/etc/squid/conf.d/snippet.conf -p 3128:3128 jfxs/alpine-squid
```

To completely override the default configuration:

```shell
docker run -d --rm --name squid -v /path/to/your/squid.conf:/etc/squid/squid.conf -p 3128:3128 jfxs/alpine-squid
```

## Built with

Docker latest tag contains:

See versions on [Dockerhub](https://hub.docker.com/r/jfxs/alpine-squid)

Versions of installed software are listed in /etc/VERSIONS file of the Docker image. Example to see them for a specific tag:

```shell
docker run -t jfxs/alpine-squid:5.7.0-1 cat /etc/VERSIONS
```

## Versioning

The Docker tag is defined by the Squid version used and an increment to differentiate build with the same Squid version:

```text
<squid_version>-<increment>
```

Example: 5.7.0-1

## Vulnerability Scan

The Docker image is scanned every day with the open source vulnerability scanner [Trivy](https://github.com/aquasecurity/trivy).

The latest vulnerability scan report is available on [Gitlab Security Dashboard](https://gitlab.com/op_so/docker/alpine-squid/-/security/dashboard/?state=DETECTED&state=CONFIRMED&reportType=CONTAINER_SCANNING).

## Authors

* **FX Soubirou** - *Initial work* - [GitLab repositories](https://gitlab.com/op_so)

## License

This program is free software: you can redistribute it and/or modify it under the terms of the MIT License (MIT). See the [LICENSE](https://opensource.org/licenses/MIT) for details.
