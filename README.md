## build & run
###
The automation has been done for a linux environment having make en docker installed.

### build
The command 
```
make build
```
will trigger the docker build process. It will automatically remove the previous existing image. 

Warning: check if the docker image name is not one used by yourself. Otherwise this might have undesired side-effects.

### run
The command 
```
make run
```
will initiate a docker container having the current directory mounted on /data.
Assumption for now is that it should be the git repository.

### test
To execute the tests, initiate in the the container's commandline the following
```
cd /
sudo chmod -R 777 /data
cd /data
make test
```

This will download the example feeds, and process them. The result is found in the output directory.



## example data

From the site https://bergenbysykkel.no/en/open-data/realtime can different datasets being downloaded:
 
  - endpoint: https://gbfs.urbansharing.com/bergenbysykkel.no/gbfs.json
  - system information: https://gbfs.urbansharing.com/bergenbysykkel.no/system_information.json
  - station information: https://gbfs.urbansharing.com/bergenbysykkel.no/station_information.json
  - station status information: https://gbfs.urbansharing.com/bergenbysykkel.no/station_status.json
  - historical trip data: https://bergenbysykkel.no/en/open-data/historical


## templates



