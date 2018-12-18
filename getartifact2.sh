#!/usr/bin/env bash

wget --user=admin \
--password=admin123 \
'https://nexus-cicd.apps.ocp.datr.eu/repository/maven-snapshots/org/jnd/microservices/inventory/0.0.1-SNAPSHOT/inventory-0.0.1-20181218.115457-5.jar' \
-O inventory-0.0.1-SNAPSHOT.jar

