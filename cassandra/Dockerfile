FROM frolvlad/alpine-oraclejdk8
MAINTAINER Schibsted

ENV CAS_PKG_NAME 2.0.17
RUN apk add --update --no-cache wget

RUN wget --no-check-certificate https://archive.apache.org/dist/cassandra/$CAS_PKG_NAME/apache-cassandra-$CAS_PKG_NAME-bin.tar.gz && \
tar zxvf apache-cassandra-$CAS_PKG_NAME-bin.tar.gz && \
rm apache-cassandra-$CAS_PKG_NAME-bin.tar.gz && \
mv apache-cassandra-$CAS_PKG_NAME /cassandra

# SOLVING error: snappy-1.0.5-libsnappyjava.so: libstdc++.so.6: cannot open shared object file: No such file or directory
RUN wget --no-check-certificate https://snappy-java.googlecode.com/files/snappy-java-1.0.4.1.jar && \
rm /cassandra/lib/snappy-java-1.0.5.jar && \
mv snappy-java-1.0.4.1.jar /cassandra/lib/

WORKDIR /cassandra
RUN sed -i s/-Xss180k/-Xss280k/ conf/cassandra-env.sh

ADD configure.sh .

EXPOSE 7000 7001 7199 9042 9160

CMD ["/bin/sh", "-e", "configure.sh"]