ARG TAG=latest
FROM jenkins/jenkins:$TAG
MAINTAINER alli@allir.org

ENV GOSU_VERSION 1.10
ENV DOCKER_GID 999
ENV DOCKER_GROUP docker

USER root
# Install the latest Docker CE binaries & GOSU
RUN set -ex \
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
    && apt-get purge -y --auto-remove wget \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gpasswd -a jenkins docker

COPY docker-jenkins.sh /usr/local/bin/docker-jenkins.sh
RUN chmod u=rx,go= /usr/local/bin/docker-jenkins.sh

# Entrypoint script will switch to jenkins user with gosu
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/docker-jenkins.sh"]
