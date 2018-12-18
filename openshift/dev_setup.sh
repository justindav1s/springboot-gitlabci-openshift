#!/usr/bin/env bash

APP=inventory
VERSION=dev
IMAGE=registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5
IP=ocp.datr.eu
USER=justin
PROJECT=amazin-gitlab

oc login https://${IP}:8443 -u $USER

oc delete project $PROJECT
oc adm new-project $PROJECT --node-selector='capability=apps' 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc adm new-project $PROJECT --node-selector='capability=apps' 2> /dev/null
done

oc project ${PROJECT}

oc delete all -l app=${APP} -n ${PROJECT}
oc delete sa ${APP}-sa
oc delete is,bc,dc,svc,route,sa ${APP} -n ${PROJECT}
oc delete template ${APP}-dev-dc ${APP}-dev-template -n ${PROJECT}
oc delete configmap ${APP}-config -n ${PROJECT}

echo Setting up ${APP} for ${PROJECT}
oc new-app -f spring-boot-dev-template.yaml \
    -p APPLICATION_NAME=${APP} \
    -p BASE_IMAGE=${IMAGE} \
    -n ${PROJECT}

