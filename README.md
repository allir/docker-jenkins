# docker-jenkins

Jenkins docker image with Docker installed.

## Usage

Docker will need to be installed on the host machine and /var/run/docker.sock should be owned by "docker" group.
If the docker group has a different GID than 999 it can be passed in as an environment variable so the jenkins user will have access to the host's docker engine.

Example:

```bash
docker run -d -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home allir/jenkins
````

Example with passing the docker GID:

```bash
docker run -d -e DOCKER_GID=994 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home allir/jenkins
```
