ARG TAG=latest
FROM jenkins/jenkins:$TAG
LABEL maintainer="alli@allir.org"

# Variables
## GOSU Version to install
## The docker group GID from the host, this can be set when it's not 999 on the host
ENV GOSU_VERSION 1.10
ENV DOCKER_GID 999
ENV DOCKER_GROUP docker

# Install GOSU and the latest Docker CE binaries
USER root
RUN set -ex \
    `# Install Dependencies`\
    && apt-get update -qq \
    && apt-get install -qqy --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common \
    `# Install GOSU` \
    && apt-get install -y --no-install-recommends \
      gosu \
    `# Install Docker CE` \
    && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - \
    && apt-key fingerprint 0EBFCD88 \
    && add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
        $(lsb_release -cs) \
        stable" \
    && apt-get update -qq \
    && apt-get install -qqy docker-ce \
    `# Cleanup` \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add jenkins user to docker group
RUN gpasswd -a jenkins docker

# Run jenkins after running docker entrypoint script
# Everything runs as root (or last USER directive) gosu is then used in the script
# docker-entrypoint.sh usage: <user> <script> 
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY docker-entrypoint.d/* /etc/docker-entrypoint.d/
RUN chmod u=rx,go= /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh", "jenkins","/sbin/tini","--","/usr/local/bin/jenkins.sh"]
