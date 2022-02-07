**Pre-requisites**

Run Kraken2 command and generate a report

    kraken2 --db $KRAKEN_DB --paired read_1.fastq read_2.fastq --threads 1 --use-names --report kraken_report --report-zero-counts --output kraken.out

Make sure to add the parameter **--report-zero-counts** in the kraken2 command, if this paramter is not added, then the result from this script will be hard to parse through.

**Dependecies**

- Python 3


- Python packages
    - numpy
    - scipy
    - argparse
    - pandas
    - collection

**Kraken-output-manipulation**

    git clone https://github.com/npbhavya/Kraken2-output-manipulation.git
    
