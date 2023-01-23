# Docker Alpine Squid

[![Software License](https://img.shields.io/badge/license-MIT-informational.svg?style=flat)](LICENSE)
[![Pipeline Status](https://gitlab.com/op_so/docker/alpine-squid/badges/main/pipeline.svg)](https://gitlab.com/op_so/docker/alpine-squid/pipelines)

A [Squid](http://www.squid-cache.org/) Docker image:

* **lightweight** image based on Alpine Linux only 8 MB,
* multiarch with support of **amd64** and **arm64**,
* **non-root** container user,
* **automatically** updated by comparing SBOM changes,
* image **signed** with [Cosign](https://github.com/sigstore/cosign),
* an **SBOM attestation** added using [Syft](https://github.com/anchore/syft),
* available on **Docker Hub** and **Quay.io**.

[![GitLab](https://shields.io/badge/Gitlab-informational?logo=gitlab&style=flat-square)](https://gitlab.com/op_so/docker/alpine-squid) The main repository.

[![Docker Hub](https://shields.io/badge/dockerhub-informational?logo=docker&logoColor=white&style=flat-square)](https://hub.docker.com/r/jfxs/alpine-squid) The Docker Hub registry.

[![Quay.io](https://shields.io/badge/quay.io-informational?logo=docker&logoColor=white&style=flat-square)](https://quay.io/repository/ifxs/alpine-squid) The Quay.io registry.

## Running the squid proxy

```shell
docker run -d --rm --name squid -p 3128:3128 jfxs/alpine-squid
```

or

```shell
docker run -d --rm --name squid -p 3128:3128 quay.io/ifxs/alpine-squid
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

Docker latest tag is [--VERSION--](https://gitlab.com/op_so/docker/alpine-squid/-/blob/main/Dockerfile) and contains:

--SBOM-TABLE--

Details are updated on [Dockerhub Overview page](https://hub.docker.com/r/jfxs/alpine-squid) when an image is published.

## Versioning

The Docker tag is defined by the Squid version used and an increment to differentiate build with the same Squid version:

```text
<squid_version>-<increment>
```

Example: 5.7.0-003

## Signature and attestation

[Cosign](https://github.com/sigstore/cosign) public key:

```shell
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEa3yV6+yd/l4zh/tfT6Tx+zn0dhy3
BhFqSad1norLeKSCN2MILv4fZ9GA6ODOlJOw+7vzUvzZVr9IXnxEdjoWJw==
-----END PUBLIC KEY-----
```

The public key is also available online: <https://gitlab.com/op_so/docker/cosign-public-key/-/raw/main/cosign.pub>.

To verify an image:

```shell
cosign verify --key cosign.pub $IMAGE_URI
```

To verify and get the SBOM attestation:

```shell
cosign verify-attestation --key cosign.pub --type spdxjson $IMAGE_URI | jq '.payload | @base64d | fromjson | .predicate'
```

## Authors

* **FX Soubirou** - *Initial work* - [GitLab repositories](https://gitlab.com/op_so)

## License

This program is free software: you can redistribute it and/or modify it under the terms of the MIT License (MIT). See the [LICENSE](https://opensource.org/licenses/MIT) for details.
