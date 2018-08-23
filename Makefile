all: image lts_image

TAG="latest"
image: Dockerfile
	@docker build . --build-arg TAG=$(TAG) -t allir/jenkins:$(TAG)

lts_image: Dockerfile
	@docker build . --build-arg TAG=lts -t allir/jenkins:lts
