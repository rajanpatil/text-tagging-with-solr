# Quick Start

### Get apache solr
Go to [Solr's download page](http://www.apache.org/dyn/closer.lua/lucene/solr/) and download either the
".zip" or the ".tgz" depending on which you prefer, then expand it.  We'll call the expanded directory
SOLR_DIST_DIR.

**Note:** These steps have been validated with solr-7.7.3 version.

### Get SolrTextTagger and install it
The OpenSextant SolrTextTagger is a plug-in to Apache Solr. To get the
text tagger's Jar, you can either download a
[pre-built one](http://search.maven.org/#search%7Cga%7C1%7Ca%3A%22solr-text-tagger%22) from Maven
central or build it yourself [SolrTextTagger](https://github.com/OpenSextant/SolrTextTagger) if you have a Java compiler and Maven.

The easiest method to install is simply to put the '.jar' file into SOLR_DIST_DIR/server/solr/lib/.  The
lib dir won't exist initially so create it.

**Note:** In case you get log4j core dependency error following below steps, download and copy log4j-core.jar
into SOLR_DIST_DIR/server/lib/ext

### Configure solr

    ./solr_configure.sh

### Load data

    ./data/load_data.sh

### Tag Time!

````
curl -X POST 'http://localhost:8983/solr/AuthorNames/tag?overlaps=NO_SUB&tagsLimit=5000&fl=id,name&wt=json&indent=on' -H 'Content-Type:text/plain' -d 'We are referring to author FirstName1 LastName1'
````

### Generate data for n records i.e n=1000
The `author_names.csv` has 5 records, generate more records using following script:

    ./data/generate_data.sh 1000

## Cleanup

    ./solr_delete_collection.sh
