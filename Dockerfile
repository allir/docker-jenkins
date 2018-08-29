ARG TAG=latest
FROM jenkins/jenkins:$TAG
LABEL maintainer="alli@allir.org"

# Variables
## The docker UID and GID from the host, the DOCKER_GID should match the docker group GID on the host so that the jenkins user can use docker without sudo.
ENV DOCKER_UID 1000 \
    DOCKER_GID 999 \
    DOCKER_GROUP docker

# Install GOSU and the latest Docker CE binaries
USER root
RUN set -ex \
    `# Install Dependencies`\
      && buildDeps='apt-transport-https software-properties-common curl' \
      && apt-get update -qq \
      && apt-get install -qqy --no-install-recommends $buildDeps \
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
      && apt-get remove -qqy --purge --auto-remove $buildDeps \ 
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add jenkins user to docker group
RUN usermod -aG docker jenkins

# Run jenkins after running docker entrypoint script
# Everything runs as root (or last USER directive) gosu is then used in the script
# docker-entrypoint.sh usage: <user> <script> 
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY docker-entrypoint.d/* /etc/docker-entrypoint.d/
RUN chmod u=rx,go= /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh", "jenkins","/sbin/tini","--","/usr/local/bin/jenkins.sh"]
