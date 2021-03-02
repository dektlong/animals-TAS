#!/bin/bash

cf create-service p.gateway standard animals-gw -c animals-TAS-GW.json

cf push

./routes-update.sh static

