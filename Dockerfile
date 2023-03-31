FROM rocker/shiny:4.2.0
ENV RENV_CONFIG_REPOS_OVERRIDE https://packagemanager.rstudio.com/cran/latest

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  gdal-bin \
  git \
  libcurl4-gnutls-dev \
  librasqal3-dev \
  libraptor2-dev \
  libfontconfig1-dev \
  libfreetype6-dev \
  libfribidi-dev \
  libgdal-dev \
  libgeos-dev \
  libgit2-dev \
  libharfbuzz-dev \
  libicu-dev \
  libjpeg-dev \
  libnode-dev \
  libpng-dev \
  libproj-dev \
  librdf0-dev \
  libsqlite3-dev \
  libssl-dev \
  libtiff-dev \
  libudunits2-dev \
  libxml2-dev \
  make \
  pandoc \
  zlib1g-dev \
  && apt-get clean
COPY shiny_renv.lock renv.lock
RUN Rscript -e "install.packages(c('remotes', 'renv'))"
RUN Rscript -e "remotes::install_github('nickmckay/lipdR')"
RUN Rscript -e "renv::restore(exclude = 'lipdR')"
WORKDIR /home/R
COPY R .
EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/home/R')"]
