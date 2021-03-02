#!/bin/bash

cf create-service p.gateway standard dekt4pets-gw -c dekt4pets-TAS-GW.json

cf push

./routes-update.sh static

