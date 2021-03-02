#!/bin/bash

GATEWAY_NAME=animals-gw
BACKEND_APP_NAME=animal-rescue-backend
FRONTEND_APP_NAME=animal-rescue-frontend


cf unbind-service $FRONTEND_APP_NAME $GATEWAY_NAME
cf unbind-service $BACKEND_APP_NAME $GATEWAY_NAME 
cf delete-service $GATEWAY_NAME -f
cf delete $BACKEND_APP_NAME -f
cf delete $FRONTEND_APP_NAME -f
cf delete-service dekt-sso -f