#!/usr/bin/env bash

set -e
SCRIPT_HOME=$(dirname $0 | while read a; do cd $a && pwd && break; done)
curl -X POST --data-binary @$SCRIPT_HOME/author_names.csv -H 'Content-type:application/csv' \
  'http://localhost:8983/solr/AuthorNames/update?commit=true&optimize=true&separator=%2C&encapsulator=%00&fieldnames=id,name'
  