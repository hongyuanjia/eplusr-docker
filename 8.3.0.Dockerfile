ARG UPSTREAM=rstudio

## Based on rocker/rstudio or rocker/verse Debian-based image
FROM rocker/$UPSTREAM:latest

ARG UPSTREAM
RUN echo "Using upstream container rocker/$UPSTREAM:latest"

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/hongyuanjia/eplusr-docker" \
      org.label-schema.vendor="IDEAS Lab, NUS" \
      maintainer="Hongyuan Jia <hongyuan.jia@bears-berkeley.sg>"

## Environment variable for EnergyPlus
ENV EPLUS_VER ${EPLUS_VER:-8.3.0}
ENV EPLUS_SHA ${EPLUS_SHA:-6d97d074ea}
ENV EPLUS_FILE EnergyPlus-$EPLUS_VER-$EPLUS_SHA-Linux-x86_64.sh
ENV EPLUS_URL https://github.com/NREL/EnergyPlus/releases/download/v$EPLUS_VER/$EPLUS_FILE

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ## Necessary of units packages
        libudunits2-dev \
        ## Necessary for data.table packages
        zlib1g-dev \
    ## Download EnergyPlus
    && wget -q -P /tmp/ $EPLUS_URL \
    ## Install EnergyPlus
    && chmod +x /tmp/$EPLUS_FILE \
    && echo "y\r" | /tmp/$EPLUS_FILE \
    ## Clean
    && rm -f /tmp/EPLUS_FILE \
    ## Install eplusr
    && Rscript -e "install.packages('eplusr', quiet = TRUE)"
