
Script Command Line Options Overview
=========

**import_agu_records.R**

    Usage: ./import_agu_records.R [options] file
    
    
    Options:
     -i INFILE, --infile=INFILE
    		Infile, must be a CSV file and end in .csv
    
    	-x, --override
    		Overwrite pre-existing .RData file 
    
    	-d OUTDIR, --outdir=OUTDIR
    		Outdir, must be a subdir name such as 'volcanology' 
    
    	-f OUTFILE, --outfile=OUTFILE
    		Outfile, should be a simple filename fragment such as 'volcanology' (.Rdata will be appended)
    
    	-n SHOW_N, --show_n=SHOW_N
    		Show this many records in full. [default = 3]
    
    	-t, --termdocmatrix
    		Also generate a term-document-matrix from corpus. [default=FALSE]
    
    	-v, --verbose
    		Print (a lot of) extra output [default=false]
    
    	-q, --quietly
    		Print little output
    
    	-h, --help
    		Show this help message and exit
    
    -i Infile must be .csv file with AGU abstracts 
       exported from http://agu-fm12.abstractcentral.com.
    -f Filename can be absolute path or relative path.
       If relative path, then infile will be loaded from directory
       '..../abstracts-agu/'. (default: see config.R file)
    -t If you specify the '-t' option, a term-document matrix will also be generated from the corpus 
    and saved in  
    '.../data/Rdata/'. (default: see config.R file)
  
  
  
**import_egu_records.R**
Usage: import_egu_records.R [options] file


Options:
	-i INDIR, --indir=INDIR
		Directory Containing Infiles, must be PDF files exported from meetingorganiser.egu.org

	-x, --override
		Overwrite pre-existing .RData file 

	-d OUTDIR, --outdir=OUTDIR
		Outdir, must be a subdir name such as 'volcanology' 

	-f OUTFILE, --outfile=OUTFILE
		Outfile, should be a simple filename fragment such as 'volcanology' (.Rdata will be appended)

	-n SHOW_N, --show_n=SHOW_N
		Show this many records in full. [default = 3]

	-t, --termdocmatrix
		Also generate a term-document-matrix from corpus. [default=FALSE]

	-v, --verbose
		Print (a lot of) extra output [default=false]

	-q, --quietly
		Print little output

	-h, --help
		Show this help message and exit

-i Infile must be .csv file with AGU abstracts 
   exported from http://meetingorganizer.copernicus.org/EGU2013/.
-f Filename can be absolute path or relative path.
   If relative path, then infile will be loaded from directory
   '/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/data/abstracts-agu/'.
-t If you specify the '-t' option, a term-document matrix will also be generated from the corpus 
and saved in  
'.../R_text_mining/data/Rdata/'.

  
    
**process_term-doc-matrix.R**

Usage: scripts/process_term-doc-matrix.R [options] file


Options:
	-i INFILE, --infile=INFILE
		Infile (must be .Rdata file with tm text corpus stored in variable 'corpus'

	-v, --verbose
		Print extra output [default]

	-q, --quietly
		Print little output

	-t TOP_N_PERCENT, --top_n_percent=TOP_N_PERCENT
		

	-w NUMWORDS_MIN, --numwords_min=NUMWORDS_MIN
		Min number of words per phrase in wordcloud. [DEFAULT = 1]

	-x NUMWORDS_MAX, --numwords_max=NUMWORDS_MAX
		Max number of words per phrase in wordcloud. [DEFAULT = 1; recommended: n <= 2]

	-s SPARSITY_PERCENT, --sparsity_percent=SPARSITY_PERCENT
		

	-h, --help
		Show this help message and exit

Option 'top_n_percent' defaults to the top 1% of the most abundant words 
in your text corpus. Choice of numeric values is dependent on the size of your inputfile/corpus/term-doc-matrix. 
YOU must set an appropriate value.


    
**process_corpus.R**:    
    
    Usage: ./process_corpus.R [options] file

    
    Options:
     -i INFILE, --infile=INFILE
    		Infile (must be .Rdata file with tm text corpus stored in variable 'corpus'
    
    	-x, --override
    		Overwrite pre-existing .RData file 
    
    	-f OUTFILE, --outfile=OUTFILE
    		Outfile, should be a simple filename fragment such as 'volcanology' (.Rdata will be appended)
    
    	-v, --verbose
    		Print (a lot of) extra output [default=false]
    
    	-r REMOVESPARSE, --removesparse=REMOVESPARSE
    		Remove sparse terms from the term document matrix
    
    	-s NMIN, --nmin=NMIN
    		Minimum number of words in a phrase
    
    	-e NMAX, --nmax=NMAX
    		Maximum number of words in a phrase
    
    	-q QUIETLY, --quietly=QUIETLY
    		Print little output
    
    	-a ALGORITHM, --algorithm=ALGORITHM
    		Tokenizing Algorithm to use to create the TDM. Can be "", bigram, ngram, sentdetect
    
    	-h, --help
    		Show this help message and exit
