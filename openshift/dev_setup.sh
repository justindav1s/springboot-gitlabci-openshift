#!/usr/bin/env bash

APP=inventory
VERSION=dev
S2I_IMAGE=redhat-openjdk18-openshift:1.5
IP=ocp.datr.eu
USER=justin
PROJECT=amazin-gitlab

. ../../env.sh

oc login https://${IP}:8443 -u $USER

oc project ${PROJECT}

oc delete all -l app=${APP} -n ${PROJECT}
oc delete pvc -l app=${APP} -n ${PROJECT}
oc delete sa ${APP}-sa
oc delete is,bc,dc,svc,route,sa ${APP} -n ${PROJECT}
oc delete template ${APP}-dev-dc ${APP}-dev-template -n ${PROJECT}
oc delete configmap ${APP}-config -n ${PROJECT}

echo Setting up ${APP} for ${PROJECT}
oc new-app -f spring-boot-dev-template.yaml \
    -p APPLICATION_NAME=${APP} \
    -p BASE_IMAGE_NAMESPACE="openshift" \
    -p BASE_IMAGE=${S2I_IMAGE} \
    -n ${PROJECT}

