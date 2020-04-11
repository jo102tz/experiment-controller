FROM openjdk:15-jdk
MAINTAINER Chair of Software Engineering <se2-it@informatik.uni-wuerzburg.de>

COPY source/tools.descartes.dlim.httploadgenerator/target/httploadgenerator.jar .

EXPOSE 24226
EXPOSE 80

CMD java -jar httploadgenerator.jar loadgenerator 
