# Kraken2-output-manipulation
Kraken2 output generates a report for each datasets, this script takes these individual output reports and combines them to one file in the formal 

|Taxa ID| sample1|     sample2|     sample3|     sample4| .....| 
|--------|-------|------------|------------|------------|------|
|1234   |    1909|          10|        100 |         0  |     ..... |

or output 

|Taxa     |sample1     |sample2     |sample3    | sample4     |..... | 
|--------|-------|------------|------------|------------|------|
|Pseudomonas | 1909    |      10    |    100    |     0       | .....| 


The Taxa ID number is the same as the column5 in the kraken2 output report, " NCBI taxonomic ID number". 
The numbers under sample1, sample2, ... etc can be determined by the user to select which value they would like reported 
- col1: Percentage of fragments covered by the clade rooted at this taxon
- col2: Number of fragments covered by the clade rooted at this taxon
- col3: Number of fragments assigned directly to this taxon
- col4: A rank code
- col5: NCBI taxonomic ID number (this doesnt make sense to report for every column but its possible)
- col6: Indented scientific name

For documentation on Krkaen2 installation and maunal, here is a link to kraken2 documentation 
- https://ccb.jhu.edu/software/kraken2/index.shtml?t=manual
- https://ncgas.org/Blog_Posts/Metagenomic%20taxa%20analysis.php

## Pre-requisites 
Run Kraken2 command and generate a report \
*kraken2 --db $KRAKEN_DB --paired read_1.fastq read_2.fastq --threads 1 --use-names --report kraken_report --report-zero-counts --output kraken.out*

Make sure to add the parameter *--report-zero-counts* in the kraken2 command, if this paramter is not added, then the result from this script will be hard to parse through. 

## Dependecies 
**Python 3** \
Python packages 
- numpy 
- scipy
- argparse
- pandas 
- collection 

## Usage 
*python kraken-multiple.py --help \
usage: kraken-multiple.py [-h] [-d DIRECTORY] [-r {U,R,D,K,P,C,O,F,G,S}] [-c {1,2,3,4,5,6}] [-o OUTPUT]* 

Take multiple kraken output files and consolidate them to one output 

optional arguments: \
  -h, --help                show this help message and exit \
  -d DIRECTORY              Enter a directory with kraken summary reports \
  -r {U,R,D,K,P,C,O,F,G,S}  Enter a rank code \
  -c {1,2,3,4,5,6}          Enter the column number in the report you would like to include in the output \
  -o OUTPUT                 Enter the output file name 

#### For getting taxa information instead of taxa ID 

*python kraken-multiple-taxa.py --help \
usage: kraken-multiple-taxa.py [-h] [-d DIRECTORY] [-r {U,R,D,K,P,C,O,F,G,S}] [-c {1,2,3,4,5,6}] [-o OUTPUT]* 

Take multiple kraken output files and consolidate them to one output

optional arguments: \
  -h, --help                show this help message and exit \
  -d DIRECTORY              Enter a directory with kraken summary reports \
  -r {U,R,D,K,P,C,O,F,G,S}  Enter a rank code \
  -c {1,2,3,4,5,6}          Enter the column number in the report you would like to include in the output \
  -o OUTPUT                 Enter the output file name 

#### Detailed usage description 
 The input for this script is 
 - directory with kraken reports only. Use the -d flag to point to this directory. 
 The format of the output should be 
 39.87  290930  290930  U       0       unclassified
 60.13  438756  117     R       1       root
 59.67  435435  723     R1      131567    cellular organisms
 58.38  425979  4039    D       2           Bacteria
 33.55  244810  2293    P       1224          Proteobacteria
 16.06  117202  1091    C       28211           Alphaproteobacteria

- rank, since the kraken report includes results for each rank ranging from "(U)nclassified, (R)oot, (D)omain, (K)ingdom, (P)hylum, (C)lass, (O)rder, (F)amily, (G)enus, or (S)pecies." The user can define the level of rank they would like to look at. The flag -r helps define this paramater 

- The -c flag sets the which column the user would like reported in the final report. 
  - col1: Percentage of fragments covered by the clade rooted at this taxon
  - col2: Number of fragments covered by the clade rooted at this taxon
  - col3: Number of fragments assigned directly to this taxon
  - col4: A rank code
  - col5: NCBI taxonomic ID number (this doesnt make sense to report for every column but its possible)
  - col6: Indented scientific name
  
- output, The -o flag sets the name of the output file to write the final report. 

## Example command 
python kraken-multiple.py -d kraken_report/ -r F -c 2 -o kraken-report-final

## Output 
Taking a look at the kraken-report-final  \
**TaxaID  ['sample1','sample2','sample3','sample4','sample5','sample6']** \
135621  ['210', '859', '2843', '595', '281', '1064'] \
468     ['80', '359', '1054', '361', '164', '299'] \
72275   ['66', '1838', '4664', '462', '75', '2074'] \
267888  ['45', '1407', '59440', '930', '120', '79'] 

If you ran the kraken-multiple-taxa.py, then the output will be  \
**Taxa           ['sample1','sample2','sample3','sample4','sample5','sample6']** \
Actinomycetaceae ['210', '859', '2843', '595', '281', '1064'] \
Budviciaceae     ['80', '359', '1054', '361', '164', '299'] \
Mycoplasmataceae ['66', '1838', '4664', '462', '75', '2074'] \
Vibrionaceae     ['45', '1407', '59440', '930', '120', '79'] 

## Downstream 
Run the bash command to generate a csv file that can be easily imported to R 

    sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" kraken_report_all >kraken_report_all_table.csv

|TaxaID  |sample1|sample2|sample3|sample4|sample5|sample6|
|---------|---------|----------|---------|---------|---------|---------|
|135621  |210|859| 2843| 595| 281| 1064|
|468     |'80|359|1054|361| 164 |299| 
|72275   |66|1838|4664|462|75| 2074|
|267888  |45|1407|59440|930|120|79|

## Visualization 
In the directory Rscripts, there are two scripts 
- Rarefaction-curves.R : that takes the output from this program to plot the rarefaction curve for the samples 
- Ordination_plots.R : that takes the output from this program to plot ordination plots for the samples
