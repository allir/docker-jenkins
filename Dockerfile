ARG TAG=2.164.1
FROM jenkins/jenkins:$TAG
LABEL maintainer="alli@allir.org"

# Variables
## The docker UID and GID from the host, the DOCKER_GID should match the docker group GID on the host so that the jenkins user can use docker without sudo.
ENV DOCKER_UID 1000
ENV DOCKER_GID 999
ENV DOCKER_GROUP docker

# Install GOSU and the latest Docker CE binaries
USER root
RUN set -euo pipefail; \
    # Install  Dependencies & Addons
      buildDeps='apt-transport-https software-properties-common' \
      && apt-get update -qq \
      && apt-get install -qqy --no-install-recommends \
        $buildDeps \
        ca-certificates \
        curl \
        jq \
    # Install GOSU
      && apt-get install -y --no-install-recommends \
        gosu \
    # Install Docker CE
      && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - \
      && apt-key fingerprint 0EBFCD88 \
      && add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
         $(lsb_release -cs) \
         stable" \
      && apt-get update -qq \
      && apt-get install -qqy --no-install-recommends docker-ce \
    # Cleanup
      && apt-get remove -qqy --purge --auto-remove $buildDeps \ 
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Run jenkins after running docker entrypoint script
# The entrypoint runs as root (or last USER directive) gosu is then used in the script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u=rx,go= /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
