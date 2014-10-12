IMAGENAME = krasnobaev/solr
CONTAINERNAME = solr4-java8
INSTANCE = solrinstance
DATA = $(INSTANCE)-data

all: build startdata startimage
stop: stopimage stopdata

# WORK WITH IMAGE
build:
	docker build -t $(IMAGENAME) .

rebuild:
	docker build --no-cache=true -t $(IMAGENAME) .

startimageexample:
	docker run -dt --name $(CONTAINERNAME) -p 8983:8983 $(IMAGENAME)

startimage:
	docker run -dt --volumes-from $(DATA) --name $(CONTAINERNAME) \
		-p 8983:8983 $(IMAGENAME) run.sh

stopimage:
	docker stop $(CONTAINERNAME)
	docker rm $(CONTAINERNAME)

startimagebash:
	docker run -it --rm --volumes-from $(DATA) --name $(CONTAINERNAME) \
		-p 8983:8983 $(IMAGENAME) /bin/bash

restartimage: stop run

enterimage:
	docker-enter $(CONTAINERNAME)

# WORK WITH DATA
startdata:
	docker run -dt --name $(DATA) -v /opt/solrinstance busybox
	docker run -it --rm --volumes-from $(DATA)                            \
		-v $(shell pwd)/${INSTANCE}:/tmp/${INSTANCE} ubuntu               \
		sh -c 'cp -a /tmp/${INSTANCE}/* /opt/solrinstance/;      \
			useradd solr; chown -R solr:solr /opt/solrinstance'

stopdata:
	docker stop $(DATA)
	docker rm $(DATA)

restartdata: stopdata startdata

enterdata:
	docker-enter $(DATA)

