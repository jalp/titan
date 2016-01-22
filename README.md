# Introduction
The main purpose of this repository is to have Titan running in docker.

Inside, you will find titan running inside an alpine linux pointing to its dependencies cassandra and elasticsearch (also running in alpine linux solutions)

## Run it
You only have to download it directly and

    > docker-compose build
    > docker-compose up -d

### Check result
To check that the service is running:

    > curl http://<your_docker_ip>:8182/gremlin?gremlin=100-1

As a result, you will see something like that:

    >{"requestId":"c98604b5-8ed9-401d-bf58-001363ea69c2","status":{"message":"","code":200,"attributes":{}},"result":{"data":[99],"meta":{}}}