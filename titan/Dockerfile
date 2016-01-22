FROM frolvlad/alpine-oraclejdk8
MAINTAINER Schibsted

ENV TITAN_VERSION 1.0.0
RUN apk add --update --no-cache wget unzip bash

RUN wget http://s3.thinkaurelius.com/downloads/titan/titan-$TITAN_VERSION-hadoop1.zip
RUN unzip titan-$TITAN_VERSION-hadoop1.zip && \
rm titan-$TITAN_VERSION-hadoop1.zip && \
mv titan-$TITAN_VERSION-hadoop1 /titan

WORKDIR /titan
ADD configure.sh .

VOLUME ["/data", "/config", "/scripts"]

EXPOSE 8182 8184

CMD ["/bin/bash", "-e", "configure.sh"]