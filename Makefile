RUN=docker run -d --env-file
TAG=runner-image
UBUNTU=cd ubuntu-python-suite && docker build --tag
VARS=vars.txt

build:
	${UBUNTU} ${TAG}-py3.4.10 --build-arg PYTHON_VERSION=3.4.10 .
	${UBUNTU} ${TAG}-py3.5.3  --build-arg PYTHON_VERSION=3.5.3 .
	${UBUNTU} ${TAG}-py3.6.13 --build-arg PYTHON_VERSION=3.6.13 .
	${UBUNTU} ${TAG}-py3.7.10 --build-arg PYTHON_VERSION=3.7.10 .

prune:
	yes | docker container prune 
	yes | docker image prune

run:
	${RUN} ${VARS} runner-image-py3.4.10
	${RUN} ${VARS} runner-image-py3.5.3
	${RUN} ${VARS} runner-image-py3.6.13
	${RUN} ${VARS} runner-image-py3.7.10
	${RUN} ${VARS} runner-raspbian-stretch

stop:
	docker stop `docker ps -a -q`
