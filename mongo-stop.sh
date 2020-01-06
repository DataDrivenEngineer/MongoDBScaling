#!/bin/bash
docker kill $(docker ps -a --filter name=mongo | grep -i mongo | cut -d " " -f1)
docker rm $(docker ps -a --filter name=mongo | grep -i mongo | cut -d " " -f1)

