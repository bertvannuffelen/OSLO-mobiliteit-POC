#!/bin/bash

FEEDNAMES="bfs.json system_information.json station_information.json free_bike_status.json \
  	   geofencing_zone_information.json system_regions.json"

for f in ${FEEDNAMES}
do
  curl https://mds.bird.co/gbfs/antwerp/$f |jq . &> bird-antwerp.$f
done
