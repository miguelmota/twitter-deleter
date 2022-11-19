# Build docker target
docker-build:
	docker build -f Dockerfile -t example/twitter-deleter .

# Tag docker image with latest
docker-image-tag-latest:
	docker tag example/twitter-deleter:latest example/twitter-deleter:latest

# Tag docker image
docker-image-tag:
	$(eval REV=$(shell git rev-parse HEAD | cut -c1-7))
	$(eval BRANCH=$(shell git branch --show-current))
	docker tag example/twitter-deleter:latest example/twitter-deleter:$(REV)
	#docker tag example/twitter-deleter:latest example/twitter-deleter:$(BRANCH)

# Push to registry
docker-registry-push:
	$(eval REV=$(shell git rev-parse HEAD | cut -c1-7))
	$(eval BRANCH=$(shell git branch --show-current))
	docker push example/twitter-deleter:latest
	docker push example/twitter-deleter:$(REV)
	#docker push example/twitter-deleter:$(BRANCH)

# Build docker image and push to registry
docker-build-and-push: docker-build docker-image-tag docker-registry-push

# Tag docker and push to registry
docker-tag-and-push: docker-image-tag docker-registry-push

docker-start:
	docker run --env-file .env example/twitter-deleter
