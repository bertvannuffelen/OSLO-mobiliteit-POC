OUTPUT=output
INPUT=example-input
TEMPLATE=template

build:
	docker images mob --format "{{.ID}}" > rm.old
	docker build -t mob .
	docker rmi `cat rm.old`

run:
	docker run --rm -it --name mobt -v ${CURDIR}:/data mob bash

test: output ${OUTPUT}/station_status.jsonld ${OUTPUT}/station_information.jsonld

${OUTPUT}/station_information.jsonld: json-renderer.js ${INPUT}/station_information.json template/gbfs_stationinformation.template
	node json-renderer.js -t template/gbfs_stationinformation.template -i ${INPUT}/station_information.json --list 'data.stations[*]' -o ${OUTPUT}/stations_information.jsonld

${OUTPUT}/station_status.jsonld: json-renderer.js ${INPUT}/station_status.json template/gbfs_stationstatus.template
	node json-renderer.js -t template/gbfs_stationstatus.template -i ${INPUT}/station_status.json --list 'data.stations[*]' -o ${OUTPUT}/stations_status.jsonld

${INPUT}/station_information.json: ${INPUT}/get_data1.sh
	sudo chmod +x ${INPUT}/*.sh
	cd ${INPUT} ; sudo ./get_data1.sh

${INPUT}/station_status.json: ${INPUT}/station_information.json

${INPUT}/bird-antwerp.gbfs.json: ${INPUT}/get_data2.sh
	sudo chmod +x ${INPUT}/*.sh
	cd ${INPUT} ; sudo ./get_data2.sh

output:
	sudo mkdir -p ${OUTPUT}
	sudo chmod 777 ${OUTPUT}
