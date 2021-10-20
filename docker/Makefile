build:
	docker build -t gvegayon/rgexf:latest -f Dockerfile . && \
		docker build -t gvegayon/rgexf:dev -f Dockerfile.dev .

push: build
	docker push gvegayon/rgexf:latest

run:
	docker run --rm -d -p 3624:3624 --name rgexf-docker \
		-e PASSWORD=1231 \
		-v ${PWD}/..:/home/rstudio \
		gvegayon/rgexf:dev
stop:
	docker stop rgexf-docker
