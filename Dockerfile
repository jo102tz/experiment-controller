FROM picoded/ubuntu-openjdk-8-jdk
MAINTAINER Chair of Software Engineering <se2-it@informatik.uni-wuerzburg.de>

# Install kubectl from Docker Hub.
COPY --from=lachlanevenson/k8s-kubectl:v1.15.10 /usr/local/bin/kubectl /usr/local/bin/kubectl

# Copy script to replace placeholders in context.xml with the environment variables
RUN mkdir controller
RUN apt-get update
RUN apt-get install -y dnsutils
COPY . ./controller/

EXPOSE 8080
EXPOSE 80
EXPOSE 24226

CMD echo "No experiment file provided. Please specify the experiment script to run..."
