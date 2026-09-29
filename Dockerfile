FROM --platform=linux/amd64 rocker/shiny:4.6

RUN install2.r --error shinydashboard shinyWidgets DT

COPY . /srv/adampartsfinder
RUN chown -R shiny:shiny /srv/adampartsfinder/data

USER shiny
EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/srv/adampartsfinder', port = 3838, host = '0.0.0.0')"]
