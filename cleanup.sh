#!/usr/bin/env bash

set -e

SCRIPT_HOME=$(dirname $0 | while read a; do cd $a && pwd && break; done)
SOLR_DIST_DIR="$SCRIPT_HOME/solr-7.7.3"

"$SOLR_DIST_DIR"/bin/solr delete -c AuthorNames
