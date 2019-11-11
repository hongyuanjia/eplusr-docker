# eplusr-docker

Dockerfiles for working with [EnergyPlus](https://energyplus.net/) and R

[![CircleCI](https://circleci.com/gh/hongyuanjia/eplusr-docker.svg?style=svg)](https://circleci.com/gh/hongyuanjia/eplusr-docker)
[![license](https://img.shields.io/badge/license-GPLv2-blue.svg)](https://opensource.org/licenses/GPL-2.0)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

## Overview

image                                                 | description                                              | size                                                                                                             | metrics                                                                                            | build status
----------------                                      | -----------------------------------------                | ------                                                                                                           | -------                                                                                            | --------------
[eplusr](https://hub.docker.com/r/hongyuanjia/eplusr) | R with eplusr installed & EnergyPlus specified installed | [![](https://images.microbadger.com/badges/image/hongyuanjia/eplusr.svg)](https://microbadger.com/images/hongyuanjia/eplusr) | [![](https://img.shields.io/docker/pulls/hongyuanjia/eplusr.svg)](https://hub.docker.com/r/hongyuanjia/eplusr) | [![](https://img.shields.io/docker/automated/hongyuanjia/eplusr.svg)](https://hub.docker.com/r/hongyuanjia/eplusr/builds)

This repository provides contains Dockerfiles for working with EnergyPlus in R
via [eplusr](cran.r-project.org/package=eplusr) package, based on
[rocker/rstudio:latest](https://hub.docker.com/r/rocker/rstudio) container.

## Quickstart

    docker run --rm -p 8787:8787 -e PASSWORD=yourpasswordhere hongyuanjia/eplusr

Users can include the version tag of EnergyPlus, e.g.
`hongyuanjia/eplusr:9.1.0`, and use the default `latest` tag, e.g.
`hongyuanjia/eplusr` for the most up-to-date EnergyPlus. Currrently, the lowest
supported version is `v8.3.0`.

Visit <http://localhost:8787> in your browser and log in with username `rstudio` and
the password you set. **NB: Setting a password is now REQUIRED.** Container
will error otherwise.

## Common configuration options:

### Install a different version of EnergyPlus

Sometime you may want to install another version of EnergyPlus along side with
current EnergyPlus you are specified. There are two ways to do so:

* If you want
  EnergyPlus to be installed into the default location using
  [eplusr::install_eplus()](https://hongyuanjia.github.io/eplusr/reference/install_eplus.html),
  you have to give the root permissions when you run the container by passing
  `ROOT=TRUE`:

    docker run -d -p 8787:8787 -e ROOT=TRUE -e PASSWORD=yourpasswordhere hongyuanjia/eplusr

* If you do not want to give the root permission, an alternative way is to
  download the version of EnergyPlus you want using `eplusr::download_eplus()`
  and manually install it following the
  [instructions](https://energyplus.net/installation-linux).

### Bypassing the authentication step

**Warning: use only in a secure environment**. Do not use this approach on an
AWS or other cloud machine with a publicly accessible IP address.

Simply set the environmental variable `DISABLE_AUTH=true`, e.g.

```
docker run --rm \
  -p 127.0.0.1:8787:8787 \
  -e DISABLE_AUTH=true \
  hongyuanjia/eplusr
```

Navigate to <http://localhost:8787> and you should be logged into RStudio as
the `rstudio` user without needing a password.

## More help

See the
[rocker/rstudio](https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/)
container and the Wiki for additional documentation in the
[rocker](https://github.com/rocker-org/rocker) project: <https://github.com/rocker-org/rocker/wiki>

## License

The Dockerfiles in this repository is licensed under the GPL 2 or later.

## Trademarks

RStudio is a registered trademark of RStudio, Inc. The use of the trademarked
term RStudio and the distribution of the RStudio binaries through the images
hosted on [hub.docker.com](https://registry.hub.docker.com/) has been granted by
explicit permission of RStudio. Please review [RStudio's trademark use
policy](http://www.rstudio.com/about/trademark/) and address inqueries about
further distribution or other questions to
[permissions@rstudio.com](emailto:permissions@rstudio.com).
