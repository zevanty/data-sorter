# Data Sorter
This script sorts columns of CSV (comma-separated) and TSV (tab-separated) files. 

## Usage
`perl sort.pl --file FILE [OPTIONS]`

The output of the sorted result will be a file with a `-sorted` appended to its name.

**Assumptions:**  

  * CSV files unless specified as TSV 
  * Each row has same number of columns

## Options
`--file FILE`  
**Required.** Input file to sort by.

`--columns C1,C2,...`  
**Optional.** Comma-separated list of columns to sort by, such as `3,1,2`. If not provided, sort by column 1.

`--ignoreheaders`  
**Optional.** Number of headers to ignore. If not provided, all rows will be evaluated.

`--descending`  
**Optional.** Sort by descending.

`--caseinsensitive`  
**Optional.** Do case-insensitive sort.

`--tsv`  
**Optional.** The file is a TSV file (tab-separated).

`--help`  
**Optional.** Display the help message.


## Example
A sample data has been provided under `example.csv`. Data is randomly generated. Any resemblance to real persons, living or dead, is purely coincidental.
