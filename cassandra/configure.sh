#!/usr/bin/env sh

YAML=conf/cassandra.yaml

sed -i s/'listen_address: localhost'/'listen_address: '$(hostname -i)/g $YAML
sed -i s/'# broadcast_address: 1.2.3.4'/'broadcast_address: '$(hostname -i)/g $YAML
sed -i s/'# broadcast_rpc_address: 1.2.3.4'/'broadcast_rpc_address: '$(hostname -i)/g $YAML
sed -i s/'rpc_address: localhost'/'rpc_address: 0.0.0.0'/g $YAML
sed -i s/'seeds: "127.0.0.1"'/'seeds: "'$(hostname -i)'"'/g $YAML

bin/cassandra -f