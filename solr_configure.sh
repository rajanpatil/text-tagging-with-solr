#!/usr/bin/env bash

set -e

SCRIPT_HOME=$(dirname $0 | while read a; do cd $a && pwd && break; done)
SOLR_DIST_DIR="$SCRIPT_HOME/solr-7.7.3"

$SOLR_DIST_DIR/bin/solr restart

$SOLR_DIST_DIR/bin/solr create -c AuthorNames

curl -X POST -H 'Content-type:application/json'  http://localhost:8983/solr/AuthorNames/schema -d '{
  "add-field-type":{
    "name":"tag",
    "class":"solr.TextField",
    "postingsFormat":"FST50",
    "omitNorms":true,
    "indexAnalyzer":{
      "tokenizer":{ 
         "class":"solr.StandardTokenizerFactory" },
      "filters":[
        {"class":"solr.EnglishPossessiveFilterFactory"},
        {"class":"solr.ASCIIFoldingFilterFactory"},
        {"class":"solr.LowerCaseFilterFactory"},
        {"class":"org.opensextant.solrtexttagger.ConcatenateFilterFactory"}
      ]},
    "queryAnalyzer":{
      "tokenizer":{ 
         "class":"solr.StandardTokenizerFactory" },
      "filters":[
        {"class":"solr.EnglishPossessiveFilterFactory"},
        {"class":"solr.ASCIIFoldingFilterFactory"},
        {"class":"solr.LowerCaseFilterFactory"}
      ]}
    },
  "add-field":{ "name":"name", "type":"text_general"},
  "add-field":{ "name":"name_tag", "type":"tag", "stored":false },
  "add-copy-field":{ "source":"name", "dest":[ "name_tag" ]}
}'

curl -X POST -H 'Content-type:application/json' http://localhost:8983/solr/AuthorNames/config -d '{
  "add-requesthandler" : {
    "name": "/tag",
    "class":"org.opensextant.solrtexttagger.TaggerRequestHandler",
    "defaults":{ "field":"name_tag" }
  }
}'

echo "Successfully configured solr collection!"
