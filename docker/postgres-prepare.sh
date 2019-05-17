#!/bin/bash

docker pull postgres:10
docker run -d \
	-p 5432:5432 \
	--name vaultdb \
	-e "POSTGRES_USER=u_vault" \
	-e "POSTGRES_PASSWORD=vaulttest" \
	-e "POSTGRES_DB=vault" \
	postgres:10