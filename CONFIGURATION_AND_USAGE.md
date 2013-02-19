Installation and Configuration
=========

*R package dependencies*

You will need these R packages from CRAN. Install them with the install.packages("<PackageName>") command.

 - *tm* - text mining. There are transitive dependencies such as
  - *rweka* - word stemming
 - *optparse* - parse command line options
 - *tools* -  Filename manipulation. Might be a core package.

*R Package configuration - issues*

 - To perform word stemming, *tm* package calls external Java code in weka.jar. So a Java JVM must be installed on your machine. 
 - Classpath must be correctly set to enable R to interact with weka.jar. This Classpath value can be machine-dependent. Environment Variables might need to be set.
 Look at the R script code in the src dir. You might need to change the "config" section.

Script Usage
=========

Run the scripts in the "scripts" directory individually.

    ./import_agu_records.R --help

This creates a corpus stored in an .RData file. Please read the documentation in the "doc" directory of this repo.


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
    '/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/data/abstracts-agu/'


