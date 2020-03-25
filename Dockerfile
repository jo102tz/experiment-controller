FROM ubuntu:latest
MAINTAINER Chair of Software Engineering <se2-it@informatik.uni-wuerzburg.de>

# Install kubectl from Docker Hub.
COPY --from=lachlanevenson/k8s-kubectl:v1.15.10 /usr/local/bin/kubectl /usr/local/bin/kubectl

# Copy script to replace placeholders in context.xml with the environment variables
RUN mkdir scripts
COPY experiment1.sh ./scripts/

EXPOSE 8080

CMD ./scripts/experiment1.sh