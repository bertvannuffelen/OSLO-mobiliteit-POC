build:
	docker images mob --format "{{.ID}}" > rm.old
	docker build -t mob .
	docker rmi `cat rm.old`

run:
	docker run --rm -it --name mobt -v ${CURDIR}:/data mob bash

test: example-input/station_information.json
	sudo mkdir -p output
	sudo chmod 777 output
	node json-renderer.js -t template/gbfs_stationinformation.template -i example-input/station_information.json --list 'data.stations[*]' -o output/test.jsonld


example-input/station_information.json: example-input/get_data1.sh
	sudo chmod +x example-input/*.sh
	cd example-input ; sudo ./get_data1.sh

example-input/ bird-antwerp.gbfs.json: example-input/get_data2.sh
	sudo chmod +x example-input/*.sh
	cd example-input ; sudo ./get_data2.sh
