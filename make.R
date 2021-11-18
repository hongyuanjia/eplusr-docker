DICT <- eplusr:::ALL_EPLUS_RELEASE_COMMIT

dockerfile <- function (eplus_ver) {
idx <- DICT[J(eplus_ver), on = "version", which = TRUE]
if (!length(idx)) stop("Invalid version specification")

l <- paste0(
'ARG UPSTREAM=rstudio
ARG UPSTREAM_VER=4.1.0

## Based on rocker/rstudio or rocker/verse Debian-based image
FROM rocker/$UPSTREAM:$UPSTREAM_VER

RUN echo "Using upstream container rocker/$UPSTREAM:$UPSTREAM_VER"

LABEL org.label-schema.license="GPL-2.0" \\
      org.label-schema.vcs-url="https://github.com/hongyuanjia/eplusr-docker" \\
      org.label-schema.vendor="IDEAS Lab, NUS" \\
      maintainer="Hongyuan Jia <hongyuanjia@cqust.edu.cn>"

RUN apt-get update \\
    && apt-get install -y --no-install-recommends \\
        ## Necessary of units packages
        libudunits2-dev \\
        ## Necessary for data.table packages
        zlib1g-dev \\
    ## Install eplusr
    && Rscript -e "install.packages(\'eplusr\', quiet = TRUE, type = \"source\")" \\
    ## Install EnergyPlus
    && Rscript -e "eplusr::install_eplus(\'', eplus_ver, '\', local = TRUE)"')

tag <- if (idx == 1L) "latest" else DICT$version[idx]
writeLines(l, paste0(tag, ".Dockerfile"))
}

lapply(DICT$version, dockerfile)

mat <- DICT[, -"commit"]
mat <- mat[, by = .(eplus_ver = version), {
    is_latest <- .BY$eplus_ver == DICT$version[1L]

    len <- 1L + 1L * is_latest

    file <- sprintf("%s.Dockerfile", c(.BY$eplus_ver, "latest")[c(!is_latest, is_latest)])
    tag <- sprintf("hongyuanjia/eplusr:%s%s", c(.BY$eplus_ver, "latest"[is_latest]), rep(c("-verse", ""), each = len))

    build_args <- sprintf("UPSTREAM=%s\n", rep(c("verse", "rstudio"), each = len))

    list(tag = tag, file = file, build_args = build_args)
}]

writeLines(jsonlite::toJSON(mat, pretty = TRUE), "matrix.json")
