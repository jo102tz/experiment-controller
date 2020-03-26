FROM ubuntu:latest
MAINTAINER Chair of Software Engineering <se2-it@informatik.uni-wuerzburg.de>

# Install kubectl from Docker Hub.
COPY --from=lachlanevenson/k8s-kubectl:v1.15.10 /usr/local/bin/kubectl /usr/local/bin/kubectl

# Copy script to replace placeholders in context.xml with the environment variables
RUN mkdir controller
COPY . /controller

EXPOSE 8080

CMD echo "No experiment file provided. Please specify the experiment script to run..."
