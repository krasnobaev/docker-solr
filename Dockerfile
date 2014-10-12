FROM ubuntu:14.04
MAINTAINER Aleksey Krasnobaev <https://github.com/krasnobaev>

ENV DEBIAN_FRONTEND noninteractive

# java setup based on:
# https://registry.hub.docker.com/u/makuk66/docker-oracle-java7/dockerfile/
RUN apt-get update;                                \
    apt-get -y install software-properties-common; \
    add-apt-repository ppa:webupd8team/java;       \
    apt-get update

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# automatically accept oracle license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# install java 8 oracle jdk
# install ant, ivy to compile solr instance
RUN apt-get -y install oracle-java8-installer ant ivy; \
    update-alternatives --display java;
# set the java environment variables for when you "bash -l"
RUN apt-get -y install oracle-java8-set-default; \
    apt-get clean
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# solr setup based on:
# https://registry.hub.docker.com/u/makuk66/docker-solr/dockerfile/
# https://registry.hub.docker.com/u/guywithnose/solr/dockerfile/
ENV SOLR_VER 4.10.1
ENV SOLR_BIN solr-$SOLR_VER
ENV SOLR_SRC solr-$SOLR_VER-src
RUN mkdir -p /opt /var/log/solr
# bug https://github.com/docker/docker/issues/2369
ADD http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/$SOLR_VER/$SOLR_BIN.tgz /opt/
ADD http://archive.apache.org/dist/lucene/solr/$SOLR_VER/$SOLR_SRC.tgz /usr/src/
COPY run.sh     /usr/bin/
COPY svnversion /usr/bin/
RUN tar -C /opt     --extract --file /opt/$SOLR_BIN.tgz;                  \
    tar -C /usr/src --extract --file /usr/src/$SOLR_SRC.tgz;              \
    ln -s /opt/$SOLR_BIN     /opt/solr;                                   \
    ln -s /usr/src/$SOLR_BIN /usr/src/lucene-solr;                        \
    ln -s /opt/solr/bin/*    /usr/bin/;                                   \
    useradd --home /home/solr --create-home --shell /sbin/false           \
        --comment "Solr Server" solr;                                     \
    chown -R solr:solr /opt/* /var/log/solr /usr/src/*;                   \
    chmod 755 /usr/bin/run.sh /usr/bin/svnversion;

USER solr
WORKDIR /usr/src/lucene-solr
RUN ant ivy-bootstrap;    \
    cd solr; ant example;
WORKDIR /home/solr
EXPOSE 8983
CMD ["solr", "start", "-f"]

