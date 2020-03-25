#!/bin/bash

curl https://gbfs.urbansharing.com/bergenbysykkel.no/station_information.json | jq . &> station_information.json
curl https://gbfs.urbansharing.com/bergenbysykkel.no/station_status.json | jq . &> station_status.json
curl https://data.urbansharing.com/bergenbysykkel.no/trips/v1/2020/02.json  | jq . &> trip.json
