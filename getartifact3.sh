#!/usr/bin/env bash

groupId=org.jnd.microservices
artifactId=inventory
version=0.0.1-SNAPSHOT
packaging=jar


mvn -s settings.xml dependency:copy \
    -DstripVersion=true \
    -Dartifact=${groupId}:${artifactId}:${version}:${packaging} \
    -DrepositoryId=maven-snapshots \
    -DoutputDirectory=.