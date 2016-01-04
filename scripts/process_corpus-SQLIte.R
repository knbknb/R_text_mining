#!/usr/bin/Rscript
###############################################################################
#
# create a term-document matrix from a corpus. The tdm can be parameterized by
# specifying an "--algorithm" command line option that
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
config="/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/scripts/text_mining_config.R"
source(config) # should be absolute path,
utils=paste0(text_mining_config$homedir, "scripts/text_mining_utils.R")
source(utils)

print(getwd())


library("tm") #text mining
library("optparse")
library("RWeka") #for tokenizers
library("tools") # Utilities for listing files, and manipulating file paths.



of=text_mining_config$full_outfilename(text_mining_config$outfilename)

option_list <- list(
		make_option(c("-i", "--infile"), type="character",
				default="corpus--seismo900_new.RData", dest="infile",
				help= "Infile (must be .Rdata file with tm text corpus stored in variable 'corpus'"),
		make_option(c("-x", "--override"),
				action="store_true",
				default=FALSE, dest="override",
				help="Overwrite pre-existing .RData file "),
		make_option(c("-f", "--outfile"), type="character",
				default="unk", dest="outfile",
				help= paste0("Outfile, should be a simple filename fragment such as 'volcanology' (.Rdata will be appended)")),
		make_option(c("-v", "--verbose"),
				action="store_true", default=FALSE,
				help="Print (a lot of) extra output [default=false]"),
		make_option(c("-r", "--removesparse"),
				default=TRUE,
				dest="removesparse", help="Remove sparse terms from the term document matrix"),
		make_option(c("-s", "--nmin"), type="integer",
				default=2,
				dest="nmin", help="Minimum number of words in a phrase"),
		make_option(c("-e", "--nmax"), type="integer",
				default=10,
				dest="nmax", help="Maximum number of words in a phrase"),
		make_option(c("-q", "--quietly"),
				default=TRUE,
				dest="verbose", help="Print little output"),
		make_option(c("-a", "--algorithm"),
				default="", type="character", dest="algorithm",
				help="Tokenizing Algorithm to use to create the TDM. Can be \"\", bigram, ngram, sentdetect"));

#make_option(c("-e", "--extra-args"),
#		default="", type="string", dest="algorithm",
#		help="Pass addtional options to the tokenizer"))

parser <- OptionParser(usage = "%prog [options] file", option_list=option_list,
        add_help_option = TRUE,
		prog = NULL,
		description = "",
		epilogue = paste0("Options... "))
#outputs options parsed
opts = parse_args(parser, args = commandArgs(),
		positional_arguments = TRUE)

tmpenv <- new.env()

override=opts$options$override
infile = opts$options$infile
algo = opts$options$algorithm
nmin = opts$options$nmin
nmax = opts$options$nmax
removesparse = opts$options$removesparse

outfile = text_mining_config$full_outfilename(opts$options$outfile)
if(!nchar(outfile)){
        outfile <- sub(".RData$", "-out.RData", basename(infile), perl = TRUE)
}
print(c("Infile: ", infile, "Outfile:", outfile))

show_n = opts$options$show_n  #show n items
if(file.exists(text_mining_config$full_rdatafile(outfile)) && !override){
	warning('A file already exists at "',text_mining_config$full_rdatafile(outfile),'", quitting\n')
	quit()
}


if(!file.exists(infile)){
	if(!file.exists(infile)){
		infile = paste0(text_mining_config$full_rdatadir(), infile)
		print_help(parser)
	} else {
		print(paste0("Loading '", infile, "' ..."))
	}

} else {
	print(paste0("Loading '", infile, "' ..."))
}

#load(infile)

load(infile, envir=tmpenv)
#corpus <- tmpenv$corpus

library(filehashSQLite)
#filehashFormats()
getwd()

s <- "sqldb_pcorpus_seism" # this string becomes filename, must not contain dots. Example: "mydata.sqlite" is not permitted.

suppressMessages(library(filehashSQLite))

if(! file.exists(s)){

        pc = PCorpus(DataframeSource(csv), readerControl = list(language = "en"), dbControl = list(dbName = s, dbType = "SQLite"))
        dbCreate(s, "SQLite")
        db <- dbInit(s, "SQLite")
        set.seed(234)
        dbInsert(db, "test", "hi there")
} else {
        db <- dbInit(s, "SQLite")
        pc <- dbLoad(db)
}
csv[1:3]
colnames(csv)
show(pc)
dbFetch(db, "test")
# remove it
rm(db)
rm(pc)

#reload it
db <- dbInit(s, "SQLite")
pc <- dbLoad(db)

# the corpus entries are now accessible, but not loaded into memory.
# now 900 documents are bound via "Active Bindings", created by makeActiveBinding() from the base package
show(pc)
dbFetch(db, "900")
# <<PlainTextDocument>>
#         Metadata:  7
# Content:  chars: 33

dbFetch(db, "test")
#dbFetch(db, "test")
#[1] "hi there"

inspect(corpus)
# do not use when stopwords are removed?
if (algo == "bigram") {
  BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
  tdm <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer))
  removesparse = FALSE
} else if (algo == "ngram"){
	NgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = nmin, max = nmax))
    tdm = DocumentTermMatrix(corpus, control=list(tokenize= NgramTokenizer))
  removesparse = FALSE
} else {
	#use tm's defaults
    tdm = TermDocumentMatrix(corpus)
}


#removesparse <- TRUE
if(removesparse == TRUE){
	tdm = removeSparseTerms(tdm, 0.8)
}
tdm
Terms(tdm)
paste0("Writing tdm and corpus to another .Rdata file '", outfile, "', outdir = ", text_mining_config$full_rdatadir())

print(paste0("Saving away Term-Document-Matrix to ..."))
print(paste0(text_mining_config$full_tdmfile(outfile)))
save.image(file=text_mining_config$full_tdmfile(outfile))
print(paste0("... done with saving Term-Document-Matrix to file."))
print(paste0("You can load the .RData file into an R session and experiment with it, interactively."))
print(paste0("load('", text_mining_config$full_tdmfile(outfile), "')"))
