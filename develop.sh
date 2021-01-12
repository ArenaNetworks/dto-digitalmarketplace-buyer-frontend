#!/bin/bash

export ENVIRONMENT=local

docker run -d -it --rm --name redis-dto-buyer-frontend redis 

docker run --rm -it \
    --env REDIS_HOST \
    --link redis-dto-buyer-frontend:redis \
    -p 5002:5002 \
    dto-buyer-frontend
docker stop redis-dto-buyer-frontend