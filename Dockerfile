FROM --platform=linux/amd64 rocker/shiny:4.6

RUN install2.r --error shinydashboard shinyWidgets DT

RUN mkdir -p /root/adampartsfinder
COPY . /root/adampartsfinder

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/root/adampartsfinder', port = 3838, host = '0.0.0.0')"]
