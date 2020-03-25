build:
	docker build -t mob .

run:
	docker run --rm -it --name mobt mob bash

test:
	sudo mkdir -p output
	sudo chmod 777 output
	node json-renderer.js -t template/wegsegment.jsonld  -i example-input/station_information.json --list 'data.stations' -o output/test.jsonld


