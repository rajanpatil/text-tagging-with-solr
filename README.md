# text-tagging-with-solr
Exploring the finite state transducer (FST) to implement text tagging via solr

## Pre-requisites:
- Java 11

## Steps to follow

### Get Apache Solr
Go to [Solr's download page](http://www.apache.org/dyn/closer.lua/lucene/solr/) and download either the
".zip" or the ".tgz" depending on which you prefer, then expand it.  We'll call the expanded directory
SOLR_DIST_DIR. 

**Note:** These steps have been validated with solr-7.7.3 version.

### Get the SolrTextTagger
The OpenSextant SolrTextTagger is a plug-in to Apache Solr. To get the
text tagger's Jar, you can either download a
[pre-built one](http://search.maven.org/#search%7Cga%7C1%7Ca%3A%22solr-text-tagger%22) from Maven
central or build it yourself [SolrTextTagger](https://github.com/OpenSextant/SolrTextTagger) if you have a Java compiler and Maven.

### Install the SolrTextTagger
The easiest method is simply to put the '.jar' file into SOLR_DIST_DIR/server/solr/lib/.  The
lib dir won't exist initially so create it.

**Note:** In case you get log4j core dependency error following below steps, download and copy log4j-core.jar 
into SOLR_DIST_DIR/server/lib/ext

### Start Solr instance
Start Solr on port 8983 (Solr's default port):

    bin/solr start

### Create and Configure a Solr Collection
There are 2 ways we could go about this.  Solr's classic approach involves editing some
config files (schema.xml, solrconfig.xml).The newer approach is to use Solr's API to modify the 
configuration.  We'll choose the latter.

Create a Solr collection named "AuthorNames" as follows:

    bin/solr create -c AuthorNames

### Configure solr schema

````
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
````

### Configure a custom Solr Request Handler:

````
curl -X POST -H 'Content-type:application/json' http://localhost:8983/solr/AuthorNames/config -d '{
  "add-requesthandler" : {
    "name": "/tag",
    "class":"org.opensextant.solrtexttagger.TaggerRequestHandler",
    "defaults":{ "field":"name_tag" }
  }
}'
````

### Load Some Sample Data

````
curl -X POST --data-binary @/path/to/author_names.csv -H 'Content-type:application/csv' \
  'http://localhost:8983/solr/AuthorNames/update?commit=true&optimize=true&separator=%2C&encapsulator=%00&fieldnames=id,name'
````

That might take around 35 seconds; it depends.  It can be a lot faster if the schema were tuned
to only have what we truly need (no text search if not needed).

In that command we said optimize=true to put the index in a state that will tmake tagging faster.
The encapsulator=%00 is a bit of a hack to disable the default double-quote.

### Tag Time!
This is a trivial example tagging a small piece of text.  For more options, see the Usage section
in the readme.

````
curl -X POST \
  'http://localhost:8983/solr/AuthorNames/tag?overlaps=NO_SUB&tagsLimit=5000&fl=id,name&wt=json&indent=on' \
  -H 'Content-Type:text/plain' -d 'We are referring to author FirstName1 LastName1'
````

The response should be this (the QTime may vary):
````
{
  "responseHeader":{
    "status":0,
    "QTime":1},
  "tagsCount":1,
  "tags":[[
      "startOffset",158,
      "endOffset",178,
      "ids",["1"]]],
  "response":{"numFound":1,"start":0,"docs":[
      {
        "id":"1",
        "name":["firstName1 lastname1"]
      }]
  }
}
````

## References

[SolrTextTagger](https://github.com/OpenSextant/SolrTextTagger)
