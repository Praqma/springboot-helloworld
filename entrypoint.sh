#!/bin/bash
set -euo pipefail

PID=0

term_handler() {
    if [ -f './pid' ]; then
        PID=$(cat ./pid) && kill -15 $PID
    fi
}

start_helloworld() {
    if [ -f './pid' ]; then
        PID=$(cat ./pid)
    fi
    nohup java -jar "helloworld-${HELLOWORLD_VERSION}.jar" < /dev/null & PID=$!; echo $PID > ./pid &
}

# Docker politely sends a SIGTEM first. Respect it.
trap 'kill ${!}; term_handler' SIGTERM

java -version
echo "Starting Spring Boot Hello World App!"

start_helloworld

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done