# text-tagging-with-solr
Exploring the finite state transducer (FST) to implement text tagging using solr. The FST solution 
is memory efficient (although there are more CPU computations used for lookups) and super fast lookups.

#### [Solr-7 example](./Solr_7_7_3.md)
The solr 7 example is using OpenSextant text tagger library. This is the third party library which 
uses FST based implementation. This library needs to be downloaded/built separately and then 
configured in solr.
Follow [solr-7 example](./Solr_7_7_3.md) for more details.

#### [Solr-8 example](./Solr_8_11_1.md)
The solr 8 example is using built-in text tagger which is similar to OpenSextant text tagger. It is 
also based on FST. Follow [solr-8 example](./Solr_8_11_1.md) for more details.

### References
- [Open sextant text tagger](https://github.com/OpenSextant/SolrTextTagger)
- [Solr 8 text tagger](https://solr.apache.org/guide/8_11/the-tagger-handler.html)

### Utilities
There are some utilities which are quite useful in generating more sample data or converting 
existing parquet files to csv format.

#### Data generator
Following command generates csv with `10` author names, it can be used to generate csv with any 
number of author names. In absence of argument, by default 5 records generated.

    ./data/generate_data.sh 10

#### Parquet to csv converter
The existing parquet format file can be converted into csv using `parquet_to_csv.py` utility.

Follow [parquet_to_csv](./converter/README.md) for more details.
