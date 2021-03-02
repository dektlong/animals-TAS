#!/bin/bash

ROOT_DIR=$(pwd)
GATEWAY_NAME=dekt4pets-gw
GATEWAY_CONFIG=dekt4pets-TAS-GW.json
FRONTEND_APP_NAME=dekt4pets-frontend
FRONTEND_ROUTE_CONFIG=frontend/dekt4pets-TAS-frontend-routes.json
BACKEND_APP_NAME=dekt4pets-backend
BACKEND_ROUTE_CONFIG=backend/dekt4pets-TAS-backend-routes.json



#---- static route update, using undbind and bind ----#
#input: app name, route config
static_route_update_for_app() {

  app_name=$1
  route_config=$2

  echo
  echo "===> Static update to $app_name route configuration..."
  echo
  
  cf unbind-service $app_name $GATEWAY_NAME 
  cf bind-service $app_name $GATEWAY_NAME -c $route_config
}

#---- dynamic route update, using api endpoint, requires space developer permisions ----#
dynamic_route_update_for_app() {
  
  app_name=$1
  route_config=$2

  echo
  echo "===> Static update to $app_name route configuration..."
  echo

  app_guid=$(cf app "$app_name" --guid)
  gateway_service_instance_id="$(cf service $GATEWAY_NAME --guid)"
  gateway_url=$(cf curl /v2/service_instances/"$gateway_service_instance_id" | jq .entity.dashboard_url | sed "s/\/scg-dashboard//" | sed "s/\"//g")

  printf "Calling dynamic binding update endpoint for %s...\n=====\n\n" "$app_name"
  status_code=$(curl -k -XPUT "$gateway_url/actuator/bound-apps/$app_guid/routes" -d "@$ROOT_DIR/$route_config" \
    -H "Authorization: $(cf oauth-token)" -H "Content-Type: application/json" --write-out %{http_code} -vsS)
  if [[ $status_code == '204' ]]; then
    printf "\n=====\nBound app %s route configuration update response status: %s\n\n" "$app_name" "$status_code"
  else
    printf "\033[31m\n=====\nUpdate %s configuration failed\033[0m" "$app_name" >/dev/stderr
    exit 1
  fi
}


if [ "$1" == "dynamic" ]; then
	dynamic_route_update_for_app $FRONTEND_APP_NAME $FRONTEND_ROUTE_CONFIG
	dynamic_route_update_for_app $BACKEND_APP_NAME $BACKEND_ROUTE_CONFIG
	exit
fi

if [ "$1" == "static" ]; then
	static_route_update_for_app $FRONTEND_APP_NAME $FRONTEND_ROUTE_CONFIG
	static_route_update_for_app $BACKEND_APP_NAME $BACKEND_ROUTE_CONFIG
	exit
fi

echo "incorrect usage. specify static or dynamic"