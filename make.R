DICT <- eplusr:::ALL_EPLUS_RELEASE_COMMIT

dockerfile <- function (ver) {
idx <- DICT[J(ver), on = "version", which = TRUE]
if (!length(idx)) stop("Invalid version specification")

l <- paste0(
'ARG UPSTREAM=rstudio

## Based on rocker/rstudio or rocker/verse Debian-based image
FROM rocker/$UPSTREAM:latest

ARG UPSTREAM
RUN echo "Using upstream container rocker/$UPSTREAM:latest"

LABEL org.label-schema.license="GPL-2.0" \\
      org.label-schema.vcs-url="https://github.com/hongyuanjia/eplusr-docker" \\
      org.label-schema.vendor="IDEAS Lab, NUS" \\
      maintainer="Hongyuan Jia <hongyuan.jia@bears-berkeley.sg>"

## Environment variable for EnergyPlus
ENV EPLUS_VER ${EPLUS_VER:-', DICT$version[idx], '}
ENV EPLUS_SHA ${EPLUS_SHA:-', DICT$commit[idx], '}
ENV EPLUS_FILE EnergyPlus-$EPLUS_VER-$EPLUS_SHA-Linux-x86_64.sh
ENV EPLUS_URL https://github.com/NREL/EnergyPlus/releases/download/v$EPLUS_VER/$EPLUS_FILE

RUN apt-get update \\
    && apt-get install -y --no-install-recommends \\
        ## Necessary of units packages
        libudunits2-dev \\
        ## Necessary for data.table packages
        zlib1g-dev \\
    ## Download EnergyPlus
    && wget -q -P /tmp/ $EPLUS_URL \\',
if (ver == "9.1.0") {
'
    # Fix EnergyPlus installation
    # see https://github.com/NREL/EnergyPlus/issues/7256
    # and https://github.com/hongyuanjia/eplusr/pull/193
    && sed -i \'47s/^/ori_install_directory=${install_directory}\\ninstall_directory=${install_directory}\\/${package_name}\' /tmp/$EPLUS_FILE \\
    && sed -i \'80s/163/164/\' /tmp/$EPLUS_FILE \\
    && sed -i \'89s/^/install_directory=${ori_install_directory}\' /tmp/$EPLUS_FILE \\'
} else if (numeric_version(ver) > 9.1) {
'
    # Fix EnergyPlus installation
    # see https://github.com/NREL/EnergyPlus/issues/7256
    # and https://github.com/hongyuanjia/eplusr/pull/193
    && sed -i \'70s/install_directory=${install_directory}\\/${package_name}\' /tmp/$EPLUS_FILE \\'
}, '
    ## Install EnergyPlus
    && chmod +x /tmp/$EPLUS_FILE \\
    && echo "y\\r" | /tmp/$EPLUS_FILE \\
    ## Clean
    && rm -f /tmp/EPLUS_FILE \\
    ## Install eplusr
    && Rscript -e "install.packages(\'eplusr\', quiet = TRUE)"')

tag <- if (idx == 1L) "latest" else DICT$version[idx]
writeLines(l, paste0(tag, ".Dockerfile"))
}

lapply(DICT$version, dockerfile)
