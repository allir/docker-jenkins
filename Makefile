default: lts-slim

all: latest lts alpine lts-alpine 

latest: Dockerfile
	@docker build . --build-arg TAG=latest -t allir/jenkins:latest

alpine: Dockerfile.alpine
	@docker build . -f Dockerfile.alpine --build-arg TAG=alpine -t allir/jenkins:alpine

slim: Dockerfile
	@docker build . --build-arg TAG=slim -t allir/jenkins:slim

lts: Dockerfile
	@docker build . --build-arg TAG=lts -t allir/jenkins:lts

lts-alpine: Dockerfile.alpine
	@docker build . -f Dockerfile.alpine --build-arg TAG=lts-alpine -t allir/jenkins:lts-alpine

lts-slim: Dockerfile
	@docker build . --build-arg TAG=lts-slim -t allir/jenkins:lts-slim
