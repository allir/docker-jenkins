# docker-jenkins

Jenkins docker image with Docker installed.

## Usage

Docker will need to be installed on the host machine and /var/run/docker.sock should be owned by "docker" group.
If the docker group has a different GID than 999 it can be passed in as an environment variable so the jenkins user will have access to the host's docker engine.

### Using Docker

Using `docker` to run a new container.

```bash
docker run -d -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home allir/jenkins
````

Example with passing the docker GID:

```bash
docker run -d -e DOCKER_GID=994 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home allir/jenkins
```

### Using Docker-Compose

Using `docker-compose` to run a new "environment". It will be available at <http://localhost:8080/jenkins> by default

```bash
docker-compose up
```

To pass the docker GID to the container a new environment list item needds to be added to `docker-compose.yml`

```yaml
    ...
    environment:
      - JENKINS_OPTS="--prefix=/jenkins"
      - DOCKER_GID="994"
    ...
```
