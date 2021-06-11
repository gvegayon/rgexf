build:
	docker build -t uscbiostats/aphylo:release -f Dockerfile . && \
		docker build -t uscbiostats/aphylo:devel -f Dockerfile.dev .
push: build
	docker push uscbiostats/aphylo:release && \
		docker push uscbiostats/aphylo:devel
