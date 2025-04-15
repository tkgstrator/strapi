.PHONY: build
build:
	docker buildx build --platform linux/arm64,linux/amd64 -t tkgling/strapi:5.12.4 --push .