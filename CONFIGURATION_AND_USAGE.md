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
 Look at the R script code in the "scripts" dir. You might need to change the paths wo weka.jar "config" section, and look at the Sys.setenv() calls.

Script Usage
=========

Run the scripts in the ["scripts"](scripts) directory individually. Read here *how* you use the scripts.

Please read the documentation in the ["doc"](doc) directory of this repo for an explanation of  *what* the scripts are doing.



    ./import_agu_records.R --help

This creates a corpus stored in an .RData file. 


    ./import_agu_records.R --help
    
    [1] "/usr/local/lib/R/site-library/RWekajars/java/weka.jar"
    Loading required package: methods
    Usage: ./import_agu_records.R [options] file
    
    
    Options:
      -i INFILE, --infile=INFILE
      	Infile, must be a CSV file and end in .csv
    
    	-ov, --override
    		Overwrite pre-existing .RData file 
    
    	-od OUTDIR, --outdir=OUTDIR
    		Outdir, must be a subdir name such as 'volcanology' 
    
    	-of OUTFILE, --outfile=OUTFILE
    		Outfile, should be a simple filename fragment such as 'volcanology' (.Rdata will be appended)
    
    	-v, --verbose
    		Print extra output [default]
    
    	-q, --quietly
    		Print little output
    
    	-h, --help
    		Show this help message and exit
    
    Infile must be .csv file with AGU abstracts 
    exported from http://agu-fm12.abstractcentral.com.
    Filename can be absolute path or relative path.
    If relative path, then infile will be loaded from
    '.../R_text_mining/data/abstracts-agu/'


This loads an .RData file, creates a term-document-matrix from the corpus in the .RData file (must be in variable *corpus*):


    ./process_corpus.R --help
    
Output:    
    
    Loading required package: methods
    Usage: ./process_corpus.R [options] file
    
    
    Options:
     -i INFILE, --infile=INFILE
    		Infile (must be .Rdata file with tm text corpus stored in variable 'corpus'
    
    	-v, --verbose
    		Print extra output [default]
    
    	-q, --quietly
    		Print little output
    
    	-h, --help
    		Show this help message and exit

