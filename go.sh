#!/bin/bash

echo "Starting container using AWS CLIv2 ..."
docker-compose up --detach --remove-orphans
docker-compose exec tftools bash
