#!/bin/bash


curl https://mds.bird.co/gbfs/antwerp/gbfs.json |jq . &> bird-antwerp.gbfs.json
# we should download all the urls expressed in the previous output
