#!/usr/bin/Rscript
###############################################################################
# TODO: Add command line option to make calls to browserapp(URL) optional/interactive
#
# https://github.com/knbknb/R_text_mining/
#
# $Id$
# Author: knb
# read an Rdata file containing corpus built from AGU FALL MEETING 2012 abstracts, or
# EGU General assembly abstracts
# 
####
config="/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/scripts/text_mining_config.R"
source(config) # should be absolute path, 
wcloud=paste0(text_mining_config$homedir, "scripts/text_mining_wordcloud.R")
source(wcloud)
utils=paste0(text_mining_config$homedir, "scripts/text_mining_utils.R")
source(utils)

library(optparse)
library("tm") #text mining
library("tools") # Utilities for listing files, and manipulating file paths.
library("wordcloud")
library("RCurl")
library("httr")
#library("RColorBrewer")

option_list <- list(
		make_option(c("-i", "--infile"), type="character", 
				default="mydata.Rdata", dest="infile",
				help= "Infile (must be .Rdata file with tm text corpus stored in variable 'corpus'"),
		make_option(c("-v", "--verbose"), 
				action="store_true", default=TRUE,
				help="Print extra output [default]"),
		make_option(c("-q", "--quietly"), 
				action="store_false",
				dest="verbose", help="Print little output"),
		make_option(c("-t", "--top_n_percent"), 
				default="1", type="integer", dest="top_n_percent",
				help=""),
		make_option(c("-s", "--sparsity_percent"), 
				default="0.95", type="integer", dest="sparsity_percent",
				help=""))
		
parser <- OptionParser(usage = "%prog [options] file", option_list=option_list,
        add_help_option = TRUE,
		prog = NULL,
		description = "", 
		epilogue = paste0("Option 'top_n_occurence' cannot be assigned a 
			best value a priori. It is dependent on the size of your inputfile/corpus/TDM.
			YOU must find appropriate values.
			If relative path, then infile will be loaded from
			'"))
#outputs options parsed
opts = parse_args(parser, args = commandArgs(),
		positional_arguments = TRUE)

tmpenv <- new.env()
topN_percentage_wanted = opts$options$top_n_percent
sparsity = opts$options$sparsity_percent

infile = opts$options$infile
if (! file_ext(infile) == "RData"){
	print_help(parser)
}
if(!file.exists(infile)){
	print_help(parser)
} else {
	print(paste0("Loading '", infile, "' ..."))
}


# TODO [GH3] add check that .RData infile exists

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
#tm_filter(corpus, pattern="github")
#tm_map(tm_filter(corpus, pattern="github"), function(x){c(meta(x), x)})
browserapp = text_mining_config$browserapp

trms = Terms(tdm)
#LocalMetaData(trms[1])
# docs = Doucments
# topNwords= findFreqTerms(tdm, 25, Inf); topNwords
#head(trms, n=200)
# want the top n percent of most frequent words
tdm_top_N_percent = tdm$nrow / 100 * topN_percentage_wanted
topNwords= findFreqTerms(tdm, lowfreq= tdm_top_N_percent , highfreq=Inf); topNwords

#terms that do not contain an url
#urls0 = grep("^https?:", trms, perl=TRUE, value = FALSE)

#terms that contain an url
urls1 = grep("^https?:|www\\.|google|github|r-forge|sourceforge|\\.com|\\.edu", trms, perl=TRUE, value = TRUE);
urls1  = lapply(urls1, text_mining_util$rmPunc);
#urls1 = sapply (urls1 , function(x){urls1[x] =text_mining_util$rmPunc(x)});urls1;

emails= grep ("@", urls1, invert = FALSE, perl=TRUE, value = TRUE);
urls1= grep ("@", urls1, invert = TRUE, perl=TRUE, value = TRUE);
urls1 
#emails

#emails=grep ("@", trms, invert = FALSE, perl=TRUE, value = TRUE); emails
# Remove punctuation chars from urls, but only from beforebeginning of string and after the end. 
# Keep punctuation chars inside URLs 
 

#urls1 = lapply (urls1 , function(x){urls1[x] = gsub('\\.?\\n?url$', "", x, perl=TRUE)});
# make http HEAD requests to URLs 
#github_urls = grep("github", trms[urls0], perl=TRUE, value = TRUE )

#urls = head(unique(urls1[order(nchar(urls1))]), 15)
urls.https = subset(urls1, grepl("https:", urls1))
urls.http = subset(urls1, !grepl("https:", urls1))
urls.nohttp = subset(urls1, !grepl("^http:", urls.http, perl=TRUE))

#u %in% grep("^M", nm, value=TRUE)
#subset(state.x77, grepl("^M", nm), Illiteracy:Murder)
#h = getCurlHandle(header = TRUE, netrc = TRUE)
urlcheck <- function(x)
{
	print(paste0("checking ", x))
	e = url_success(x)
	if(e == TRUE){
		x
	} else if (grepl("^www.+", x, perl=TRUE)){
		paste0("url invalid: ", x)
		y = paste0("http://", x)
		str(y)
		urlcheck(y) 
	    
	}
	else stop(paste0("url invalid: ", x))
}
#urls <- c(urls.http, urls.nohttp)
urls <- c(urls.http)
#perform HEAD request on URls to exclude invalid urls
res <- lapply(urls, function(i) try(urlcheck(i), FALSE))
## keep only urls that worked
#urls = unlist(res[sapply(res, function(x) !inherits(x, "try-error"))])

print (paste0("_valid_ URLs from infile ", infile))
res

# open browser with ALL urls (can take some time)
lapply(res, function(x){system(paste(browserapp, x))})


#url= tm_filter(tdm, "http")


#tdm2 = removeSparseTerms(tdm, sparsity)
#inspect(tdm2[1:20,1:1])

#trms2=Terms(tdm2)
#head(trms2, n= 20)
#topNwords2= findFreqTerms(tdm2, lowfreq=tdm$nrow / 100 * topN_percentage_wanted, highfreq=Inf); topNwords2


#lapply(topNwords2, function(x){df = data.frame(x, findAssocs(tdm2, x, 0.1));  })
#sort(topNwords2[-grep("[aei]", topNwords2)])
#main.term"
#names(df)[1] = "associated.word"
