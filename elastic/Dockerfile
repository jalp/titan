FROM frolvlad/alpine-oraclejdk8
MAINTAINER Schibsted

RUN apk add --update --no-cache wget
ENV ES_PKG_NAME elasticsearch-1.6.2

# Install Elasticsearch.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz --no-check-certificate && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

WORKDIR /elasticsearch

# Adding user.
RUN addgroup -S elasticsearch \
 && adduser -S -g elasticsearch elasticsearch
RUN chown -R elasticsearch:elasticsearch /elasticsearch

# TODO enable those properties when you have bigger size machines
# Heap size defaults to 256m min, 1g max
# Set ES_HEAP_SIZE to 50% of available RAM, but no more than 31g
#ENV ES_HEAP_SIZE=2g

# Additional Java OPTS
#ENV ES_JAVA_OPTS="-Xmx2g -Xms2g"

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config.
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /data

# Define default command.
USER elasticsearch
CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200 9300