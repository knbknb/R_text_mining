#!/usr/bin/Rscript
###############################################################################
#
# This is an R script designed to be called from the command line.
# Do not change or edit this file.
# This script creates an .Rdata file as output. 
# Load this .Rdata file into your R session with load("myfile.RData") 
# and then do something with that data file. 

#
################################################################################
#
# https://github.com/knbknb/R_text_mining/
#
# $Id$
# Author: knb
# read an Rdata file containing corpus built from AGU FALL MEETING 2012 abstracts, 
# write it out to an Rdata file
####
homedir="/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/"
datadir="data/abstracts-agu/"
Rdatadir="data/Rdata/"
outfileprefix="corpus--"
outfilename="" # --with-metadata--
outfileext=".RData"
select_n = 3  #show n items
outdir2="_default_outdir"
wekajar="/usr/local/lib/R/site-library/RWekajars/java/weka.jar"
procscript="process_term-doc-matrix.R"

wd=getwd()



full_datadir = function(){paste0(homedir, datadir)}
full_rdatadir = function(){paste0(homedir, Rdatadir)}
full_outfilename = function(pre ,x, suf) {paste0(pre, x, suf)} #components of the data file
full_rdatafile = function(x){paste0(full_rdatadir(), x)} # not a full path
abspath_rdatafile = function(x){paste0(full_rdatadir(), full_rdatafile(x))} # not a full path

source(paste0(homedir,"scripts/utils_text_mining.R"))

Sys.setenv(JAVA_HOME="")
Sys.setenv(CLASSPATH=paste(wekajar, sep=":"))
Sys.getenv("CLASSPATH")
Sys.setenv(NOAWT=TRUE) # advice from an internet forum, not sure what this does w.r.t weka.jar


library("tm") #text mining
library("optparse")
library("tools") # Utilities for listing files, and manipulating file paths.


option_list <- list(
		make_option(c("-i", "--infile"), type="character", 
				default="mydata.Rdata", dest="infile",
				help= "Infile (must be .Rdata file with tm text corpus stored in variable 'corpus'"),
		make_option(c("-x", "--override"), 
				action="store_true", 
				default=FALSE, dest="override",
				help="Overwrite pre-existing .RData file "),
		make_option(c("-f", "--outfile"), type="character", 
				default=full_outfilename(outfileprefix, outfilename, outfileext), dest="outfile",
				help= paste0("Outfile, should be a simple filename fragment such as 'volcanology' (.Rdata will be appended)")),
		make_option(c("-v", "--verbose"), 
				action="store_true", default=FALSE,
				help="Print (a lot of) extra output [default=false]"),
		make_option(c("-q", "--quietly"), 
				action="store_false", default=TRUE,
				dest="verbose", help="Print little output"))
#),
#		make_option(c("-a", "--algorithm"), 
#				default="", type="string", dest="algorithm",
#				help="Algorithm to use to create the TDM"))
		
parser <- OptionParser(usage = "%prog [options] file", option_list=option_list,
        add_help_option = TRUE,
		prog = NULL,
		description = "", 
		epilogue = paste0("Option ''  
			
			
			
			'"))
#outputs options parsed
opts = parse_args(parser, args = commandArgs(),
		positional_arguments = TRUE)

tmpenv <- new.env()

override=opts$options$override
infile = opts$options$infile

outfile=full_outfilename(outfileprefix, opts$options$outfile, outfileext);
show_n = opts$options$show_n  #show n items
if(file.exists(abspath_rdatafile(outfile)) && !override){
	warning('A file already exists at "',abspath_rdatafile(outfile),'", quitting\n')
	quit()
}


if(!file.exists(infile)){
	if(!file.exists(infile)){
		infile = paste0(full_rdatadir(), infile)
		print_help(parser)
	} else {
		print(paste0("Loading '", infile, "' ..."))
	}
	
} else {
	print(paste0("Loading '", infile, "' ..."))
}

 
load(infile, envir=tmpenv)
corpus <- tmpenv$corpus
show(corpus)
infile = basename(infile)
# do not use when stopwords are removed?
#BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 4))
#tdm <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer))
#tdm = DocumentTermMatrix(corpus, control=list(tokenize= "NGramTokenizer"))
tdm = TermDocumentMatrix(corpus)
paste0("Writing tdm and corpus to another .Rdata file '", outfile, "', outdir = ", full_rdatadir())

save.image(file=full_rdatafile(outfile))
print(paste0("You can load the .RData file into an R session and experiment with it, interactively."))
print(paste0("load('", full_rdatafile(outfile), "')"))