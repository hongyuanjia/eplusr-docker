ARG UPSTREAM=rstudio
ARG UPSTREAM_VER=4.1.0

## Based on rocker/rstudio or rocker/verse Debian-based image
FROM rocker/$UPSTREAM:$UPSTREAM_VER

RUN echo "Using upstream container rocker/$UPSTREAM:$UPSTREAM_VER"

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/hongyuanjia/eplusr-docker" \
      org.label-schema.vendor="IDEAS Lab, NUS" \
      maintainer="Hongyuan Jia <hongyuanjia@cqust.edu.cn>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ## Necessary of units packages
        libudunits2-dev \
        ## Necessary for data.table packages
        zlib1g-dev \
    ## Install eplusr
    && Rscript -e "install.packages('eplusr', quiet = TRUE, type = "source")" \
    ## Install EnergyPlus
    && Rscript -e "eplusr::install_eplus('9.5.0', local = TRUE)"
