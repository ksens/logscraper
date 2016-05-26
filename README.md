# LogScraper

There were 4 query coordinator nodes. Using a setup comprising doRedis and numerous (non-SciDB) R worker nodes, multiple shim sessions were hitting SciDB with `between/cross_between/cross_join` queries at any of the 4 query coordinators. The commands are thus recorded in 4 SciDB log files. We needed a way to scrape all the relevant queries from these logs and compile into 1 or 4 master scripts -- so that one can replay the workload easily without the doRedis/remote R worker setup. 
The steps are outlined below. 

## Scrape the scidb.log to store quries and execution timestamps
```
grep -r Executing scidb.log | grep -v ": ;" | cut -d ':' -f 5- | cut -d ';' -f 1 > nodeN-queries.txt
grep -r Executing scidb.log | grep -v ": ;" | cut -d ' ' -f 2  > nodeN-times.txt
```

## Run the python script to calculate differences
```
python scraper.py nodeN-times.txt > nodeN-timediffs.txt
```

## Formulate the query stack
```
./queryStacker.sh
```

## Correct the date in the generated query stack
```
vi bunchOfQueries.sh
```
and make the following substitutions
```
%s/taq_20150611/taqPOC_20160401/g
%s/20150611/20160401/g
%s/p4\///g
```

On non-postgres nodes:
```
%s/iquery/iquery --port 1240/g
```
