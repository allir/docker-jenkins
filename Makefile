all: image lts_image

image: Dockerfile
	@docker build . --build-arg TAG=latest -t allir/jenkins:latest

lts_image: Dockerfile
	@docker build . --build-arg TAG=lts -t allir/jenkins:lts
