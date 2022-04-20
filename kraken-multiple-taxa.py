#!/usr/bin/env python

import sys 
import os
import argparse
import numpy as np
import pandas as pd
from collections import defaultdict

'''
writing a script to take kraken2 summary files and make one file in the format 
taxaID	taxa	sample1	sample2	sample3	sample4 ....
'''

#concatenating the kraken reports from multiple file using a dictionary
def kraken_cat_report(dir, rank, col, out):
	filelist=input_dir(dir)
	h=defaultdict(list)
	for file in filelist:
		openfi=open(file, 'r')
		for line in openfi:
			fields=line.split('\t')
			if (fields[3] == rank):
				taxa=fields[5].strip()
				h[taxa].append(fields[col-1])

	print ("Writing output to a file")
	with open (out, 'w') as fout:
		fout.write('Taxa\t%s\n' %filelist)
		for key,value in h.items():
			#print (key, len(value))
			fout.write('%s\t%s\n' %(key, value))
			
#function that open the directory and confirms there are files, and checks to see that the files are summary files 
def input_dir(dir):
	files=os.listdir(dir)
	assert (len(files)!=0), "The directory is empty"
	path=[]
	for f in files:
		fipath=os.path.join(dir,f)
		path.append(fipath)
		report=open(fipath, 'r')
		for line in report:
			fields=line.split('\t')
			cols=len(fields)
			assert (cols==6), "The %s file is not kraken2 summary report" %report
			break
	print ("Checking input file done")	
	return (path)


if __name__=='__main__' :
	parser=argparse.ArgumentParser(description="Take multiple kraken output files and consolidate them to one output")
	parser.add_argument ('-d', dest='directory', help='Enter a directory with kraken summary reports')
	parser.add_argument ('-r', dest='rank', choices=['U','R','D','K','P','C','O','F','G','S'], help='Enter a rank code')
	parser.add_argument ('-c', dest='column', type=int, choices=range(1,7), help="Enter the column number in the report you would like to include in the output")
	parser.add_argument ('-o', dest='output', help='Enter the output file name')
	results=parser.parse_args()
	#input_dir(results.directory)
	kraken_cat_report(results.directory, results.rank, results.column, results.output)

