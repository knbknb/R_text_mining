Installation and Configuration
=========

*R package dependencies*

You will need these R packages from CRAN. Install them with the install.packages(" *PackageName*" ) command.

 - *tm* - text mining. There are transitive dependencies such as
  - *rweka* - word stemming
 - *optparse* - parse command line options
 - *tools* -  Filename manipulation. Might be a core package.

*R Package configuration - issues*

 - To perform word stemming, *tm* package calls external Java code in weka.jar. So a Java JVM must be installed on your machine. 
 - Classpath must be correctly set to enable R to interact with weka.jar. This Classpath value can be machine-dependent. Environment Variables might need to be set.
 Look at the R script code in the "scripts" dir. You might need to change the paths to weka.jar in the "config" section, and look at the Sys.setenv() calls.

Script Usage
=========

Run the scripts in the ["scripts"](scripts) directory individually. Read here *how* you use the scripts.

Please read the documentation in the ["doc"](doc) directory of this repo for an explanation of  *what* the scripts are doing.

**import_agu_records.R** creates a corpus stored in an .RData file.

    ./import_agu_records.R --infile itinerary-seismology.csv  --outdir seismology-and-deep-earth
 


 
**process_corpus.R** loads an .RData file, creates a term-document-matrix from the corpus in the .RData file (must be in variable *corpus*):

    ./process_corpus.R --infile .../R_text_mining/data/Rdata/corpus--corpus.RData.RData
    



Script Command Line Options Overview
=========


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
    

    
Output:    
    
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
