#!/bin/bash
if [ ! -e /opt/solrinstance/instance/start.jar ]; then
	rm /usr/src/lucene-solr/solr/{build.xml,common-build.xml}
	ln -s /opt/solrinstance/build.xml        /usr/src/lucene-solr/solr/
	ln -s /opt/solrinstance/common-build.xml /usr/src/lucene-solr/solr/
	ln -s /opt/solrinstance/instance         /usr/src/lucene-solr/solr/
	cd /usr/src/lucene-solr/solr/
	ant instance
fi
solr start -f -d /opt/solrinstance/instance

