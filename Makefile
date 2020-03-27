build:
	docker images mob --format "{{.ID}}" > rm.old
	docker build -t mob .
	docker rmi `cat rm.old`

run:
	docker run --rm -it --name mobt -v ${CURDIR}:/data mob bash

test:
	sudo mkdir -p output
	sudo chmod 777 output
	node json-renderer.js -t template/gbfs_stationinformation.template -i example-input/station_information.json --list 'data.stations[*]' -o output/test.jsonld


