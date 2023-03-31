FROM davidedge/lipd_webapps:lipdBase

COPY shiny_renv.lock renv.lock
RUN Rscript -e "install.packages('shiny')"

ADD . /app

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app')"]
