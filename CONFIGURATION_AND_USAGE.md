Installation and Configuration
=========

*R package dependencies*

You will need these R packages from CRAN. Install them with the install.packages(" *PackageName*" ) command.

 - *tm* - text mining. There are transitive dependencies such as
 - *rweka* - word stemming.
 - *optparse* - parse command line options.
 - *tools* -  Filename manipulation. Might be a core package.
 - *wordcloud* - Create a wordcloud from text, save it to a png file.

*R Package configuration - issues*

 - To perform word stemming, *tm* package calls external Java code in weka.jar. So a Java JVM must be installed on your machine. 
 - Classpath must be correctly set to enable R to interact with weka.jar. This Classpath value can be machine-dependent. Environment Variables might need to be set.
 Look at the R script code in the "scripts" dir. You might need to change the paths to weka.jar in the "config" section, and look at the Sys.setenv() calls.

Script Usage
=========

Run the scripts in the ["scripts"](scripts) directory individually. Read here *how* you use the scripts.

Please read the documentation in the ["doc"](doc) directory of this repo for an explanation of  *what* the scripts are doing.

**import_agu_records.R** creates a corpus from AGU Fall Meeting 2012 abstracts, store it in an .RData file located in new subdir
    cleaned-up (whitespace, punctuation, removed, words stemmed) will get stored in new subdir seismology-and-deep-earth

    ./import_agu_records.R --infile itinerary-seismology.csv  --outdir seismology-and-deep-earth
 
**import_egu_records.R** creates a corpus from EGU General Assembly 2013 abstracts, from PDF files stored in directory -i, store it in an .RData file, overwrite preexisting .RData File

    ./import_egu_records.R -i /home/knb/Downloads/egu-2013-pdfs -f egutest -d egutest -x

**process_term-doc-matrix.R** load .RData file, create word-clouds from the documents in the corpus

    ./process_term-doc-matrix.R --infile data/Rdata/corpus--education-publicrel-outreach.RData
 
*This file is not used at this time*
**process_corpus.R** loads an .RData file, creates a term-document-matrix from the corpus in the .RData file (must be in variable *corpus*):

    ./process_corpus.R --infile .../R_text_mining/data/Rdata/corpus--corpus.RData.RData
    


