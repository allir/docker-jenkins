TAG="alpine"
BUILDFILE="Dockerfile.alpine"
default: Dockerfile
	@docker build . -f $(BUILDFILE) --build-arg TAG=$(TAG) -t allir/jenkins:$(TAG)

all: latest lts alpine lts-alpine 

latest: Dockerfile
	@docker build . --build-arg TAG=latest -t allir/jenkins:latest

alpine: Dockerfile
	@docker build . -f Dockerfile.alpine --build-arg TAG=alpine -t allir/jenkins:alpine

lts: Dockerfile
	@docker build . --build-arg TAG=lts -t allir/jenkins:lts

lts-alpine: Dockerfile
	@docker build . -f Dockerfile.alpine --build-arg TAG=lts-alpine -t allir/jenkins:lts-alpine

