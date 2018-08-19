all: build build-lts

build: Dockerfile
	@docker build . --squash --build-arg TAG=latest -t allir/jenkins:latest

build-lts: Dockerfile
	@docker build . --squash --build-arg TAG=lts -t allir/jenkins:lts

