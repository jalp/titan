#!/usr/bin/env bash

BIN=./bin
SLEEP_INTERVAL_S=2
# Cassandra configuration
CASSANDRA_STARTUP_TIMEOUT_S=60
# Elastisearch configuration
ELASTICSEARCH_PORT_9200_TCP_ADDR="elasticsearch"
ELASTICSEARCH_PORT_9200_TCP_PORT=9200
ELASTICSEARCH_STARTUP_TIMEOUT_S=60

# wait_for_startup friendly_name host port timeout_s
wait_for_startup() {
    local friendly_name="$1"
    local host="$2"
    local port="$3"
    local timeout_s="$4"

    local now_s=`date '+%s'`
    local stop_s=$(( $now_s + $timeout_s ))
    local status=

    echo -n "Connecting to $friendly_name ($host:$port)"
    while [ $now_s -le $stop_s ]; do
        echo -n .
        $BIN/checksocket.sh $host $port >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo " OK (connected to $host:$port)."
            return 0
        fi
        sleep $SLEEP_INTERVAL_S
        now_s=`date '+%s'`
    done

    echo " timeout exceeded ($timeout_s seconds): could not connect to $host:$port" >&2
    return 1
}

wait_for_startup Cassandra \
	$CASSANDRA_PORT_9160_TCP_ADDR \
	$CASSANDRA_PORT_9160_TCP_PORT \
	$CASSANDRA_STARTUP_TIMEOUT_S || {
	return 1
}

wait_for_startup Elasticsearch \
	$ELASTICSEARCH_PORT_9200_TCP_ADDR \
	$ELASTICSEARCH_PORT_9200_TCP_PORT \
	$ELASTICSEARCH_STARTUP_TIMEOUT_S || {
   return 1
}

sed -i "s/host: localhost/host: 0.0.0.0/g" conf/gremlin-server/gremlin-server.yaml
sed -i "s/titan-berkeleyje-server.properties/titan-cassandra-es-server.properties/g" conf/gremlin-server/gremlin-server.yaml
sed -i "s/channelizer: org.apache.tinkerpop.gremlin.server.channel.WebSocketChannelizer/channelizer: org.apache.tinkerpop.gremlin.server.channel.HttpChannelizer/g" conf/gremlin-server/gremlin-server.yaml

# Creating the backing file and modifying properties to use ours
cp conf/titan-cassandra-es.properties conf/gremlin-server/titan-cassandra-es-server.properties
sed -i "s/storage.backend=cassandrathrift/storage.backend=cassandra/g" conf/gremlin-server/titan-cassandra-es-server.properties
sed -i "s/storage.hostname=127.0.0.1/storage.hostname=$CASSANDRA_PORT_9160_TCP_ADDR/g" conf/gremlin-server/titan-cassandra-es-server.properties
sed -i "s/client-only=true/client-only=false/g" conf/gremlin-server/titan-cassandra-es-server.properties
sed -i "s/index.search.hostname=127.0.0.1/index.search.hostname=$ELASTICSEARCH_PORT_9200_TCP_ADDR/g" conf/gremlin-server/titan-cassandra-es-server.properties
echo "gremlin.graph=com.thinkaurelius.titan.core.TitanFactory" >> conf/gremlin-server/titan-cassandra-es-server.properties

$BIN/gremlin-server.sh conf/gremlin-server/gremlin-server.yaml