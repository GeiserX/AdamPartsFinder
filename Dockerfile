FROM openanalytics/r-base
MAINTAINER Sergio Fernández "acsdesk@protonmail.com"

RUN R -e "install.packages(c('shiny', 'shinydashboard', 'shinyWidgets'), repos='https://cloud.r-project.org/')"

RUN mkdir -p /root/adampartsfinder
COPY . /root/adampartsfinder
  
VOLUME /root/adampartsfinder/data ## To improve read/write speeds on this directory

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/root/adampartsfinder', port = 3838, host = '0.0.0.0')"]

# docker build -t acsdesk/adampartsfinder .
# 

## To see shiny logs -- docker logs [container-name]
## To know container-name -- docker ps (last column)
## To stop all running containers -- docker stop $(docker ps -a -q)
## To remove all running containers -- docker rm $(docker ps -a -q)
## To remove all images -- docker rmi $(docker images -q)