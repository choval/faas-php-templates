#!/bin/sh
TEMPLATE=$1
cd "${0%/*}" && \
echo "Testing $TEMPLATE" && \
docker build -t faas-$TEMPLATE template/$TEMPLATE && \
docker run --rm -p 8080:8080 -p 8081:8081 -d --name $TEMPLATE faas-$TEMPLATE && \
curl http://localhost:8080/ -s | grep Hello && \
curl http://localhost:8081/metrics -s -o /dev/null && \
(docker stop -t 1 $TEMPLATE; exit 0) || \
(docker stop -t 1 $TEMPLATE; exit 1)
