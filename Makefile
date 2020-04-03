SHELL=/bin/bash
OUTPUT=output
INPUT=example-input
TEMPLATE=template

JSONLDFILES=${OUTPUT}/station_status.jsonld \
            ${OUTPUT}/station_information.jsonld \
            ${OUTPUT}/bird-antwerp.free_bike_status.jsonld \
            ${OUTPUT}/bird-antwerp.station_information.jsonld

TTLFILES=$(JSONLDFILES:.jsonld=.ttl)

build:
	docker images mob --format "{{.ID}}" > rm.old
	docker build -t mob .
	docker rmi `cat rm.old`

run:
	docker run --rm -it --name mobt -v ${CURDIR}:/data mob /bin/bash

test: getfeeds output json-renderer.js ${TTLFILES}

%.ttl: %.jsonld
	jsonld format -q $< > $@

${OUTPUT}/station_information.jsonld: ${INPUT}/station_information.json json-renderer.js ${TEMPLATE}/gbfs_stationinformation.template
	node json-renderer.js -t ${TEMPLATE}/gbfs_stationinformation.template -i $< --list 'data.stations[*]' -o $@

${OUTPUT}/station_status.jsonld: ${INPUT}/station_status.json json-renderer.js ${TEMPLATE}/gbfs_stationstatus.template
	node json-renderer.js -t ${TEMPLATE}/gbfs_stationstatus.template -i $< --list 'data.stations[*]' -o $@

# stupid template at present
${OUTPUT}/bird-antwerp.free_bike_status.jsonld: ${INPUT}/bird-antwerp.free_bike_status.json json-renderer.js ${TEMPLATE}/bird-antwerp.free_bike_status.template
	node json-renderer.js -t ${TEMPLATE}/bird-antwerp.free_bike_status.template -i $< --list 'data.bikes[*]' -o $@

# data file is currently empty (reusing gbfs template)
${OUTPUT}/bird-antwerp.station_information.jsonld: ${INPUT}/bird-antwerp.station_information.json json-renderer.js ${TEMPLATE}/gbfs_stationinformation.template
	node json-renderer.js -t ${TEMPLATE}/gbfs_stationinformation.template -i $< --list 'data.stations[*]' -o $@

# Recover feeds


getfeeds: ${INPUT}/station_information.json ${INPUT}/station_status.json ${INPUT}/bird-antwerp.gbfs.json ${INPUT}/bird-antwerp.free_bike_status.json

${INPUT}/station_information.json: ${INPUT}/get_data1.sh
	sudo chmod a+x ${INPUT}/*.sh
	cd ${INPUT} ; ./get_data1.sh

${INPUT}/station_status.json: ${INPUT}/station_information.json

${INPUT}/bird-antwerp.free_bike_status.json: ${INPUT}/bird-antwerp.gbfs.json























${INPUT}/bird-antwerp.gbfs.json: ${INPUT}/get_data2.sh
	sudo chmod a+x ${INPUT}/*.sh
	cd ${INPUT} ; sudo ./get_data2.sh

output:
	sudo mkdir -p ${OUTPUT}
	sudo chmod 777 ${OUTPUT}

realclean:
	rm -rf ${TTLFILES} ${JSONLDFILES}
