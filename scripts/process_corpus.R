#!/usr/bin/Rscript
###############################################################################
#
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
select_n = 3  #show n items
outdir2="_default_outdir"



wd=getwd()

library(optparse)
library("tm") #text mining
library("tools") # Utilities for listing files, and manipulating file paths.
source(paste0(homedir,"scripts/utils_text_mining.R"))

option_list <- list(
		make_option(c("-i", "--infile"), type="character", 
				default="mydata.Rdata", dest="infile",
				help= "Infile (must be .Rdata file with tm text corpus stored in variable 'corpus'"),
		make_option(c("-v", "--verbose"), 
				action="store_true", default=TRUE,
				help="Print extra output [default]"),
		make_option(c("-q", "--quietly"), 
				action="store_false",
				dest="verbose", help="Print little output"))
		
parser <- OptionParser(usage = "%prog [options] file", option_list=option_list,
        add_help_option = TRUE,
		prog = NULL,
		description = "", epilogue = "")
#outputs options parsed
opts = parse_args(parser, args = commandArgs(),
		positional_arguments = TRUE)

tmpenv <- new.env()

infile = opts$options$infile
if (! file_ext(infile) == ".RData"){
	print_help(parser)
}
if(!file.exists(infile)){
	print_help(parser)
} else {
	print(paste0("Loading '", infile, "' ..."))
}

# TODO add check 
load(infile, envir=tmpenv)
corpus <- tmpenv$corpus
show(corpus)

# do not use when stopwords are removed?
#BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 4))
#tdm <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer))
#tdm = DocumentTermMatrix(corpus, control=list(tokenize= "NGramTokenizer"))
tdm = TermDocumentMatrix(corpus)
#tdm
#attributes(tdm)
##rownames(tdm)
#colnames(tdm)
#dimnames(tdm)
#

trms = Terms(tdm)
LocalMetaData(trms[1])
# docs = Doucments
# topNwords= findFreqTerms(tdm, 25, Inf); topNwords
#head(trms, n=200)
topNwords= findFreqTerms(tdm, 310, Inf); topNwords

#terms that do not contain an url
#urls0 = grep("^https?:", trms, perl=TRUE, value = FALSE)

#terms that contain an url
urls1 = grep("^https?:", trms, perl=TRUE, value = TRUE)

# Remove punctuation chars from urls, but only from beforebeginning of string and after the end. 
# Keep punctuation chars inside URLs 
urls1 = lapply (urls1 , function(x){urls1[x] =text_mining_util$rmPunc(x)});
urls1 = lapply (urls1 , function(x){urls1[x] = gsub('\\.?\\n?url$', "", x, perl=TRUE)});

#github_urls = grep("github", trms[urls0], perl=TRUE, value = TRUE )

urls1 = unique(urls1[order(nchar(urls1))])
#url= tm_filter(tdm, "http")


tdm2 = removeSparseTerms(tdm, 0.95)
inspect(tdm2[1:20,1:1])

trms2=Terms(tdm2)
head(trms2, n= 20)
topNwords2= findFreqTerms(tdm2, 310, Inf); topNwords2
#lapply(topNwords2, function(x){df = data.frame(x, findAssocs(tdm2, x, 0.1));  })
sort(topNwords2[-grep("[aei]", topNwords2)])
#main.term"
#names(df)[1] = "associated.word"
tm_filter(corpus, pattern="github")
tm_map(tm_filter(corpus, pattern="github"), function(x){c(meta(x), x)})
