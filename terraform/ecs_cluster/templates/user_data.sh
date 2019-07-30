#!/bin/bash



yum install -y docker-17.06.2ce ecs-init
service docker start
start ecs
