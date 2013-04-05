#!/usr/bin/Rscript
###############################################################################
#
#
# https://github.com/knbknb/R_text_mining/
#
# $Id$
# Author: knb
# read an Rdata file containing corpus built from AGU FALL MEETING 2012 abstracts, 
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
library("RWeka") # for tokenization algorithms more complicated  than single-word
library("tools") # Utilities for listing files, and manipulating file paths.
library("wordcloud")
#library("RColorBrewer")
infile_default = "/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/data/Rdata/corpus--egu-essi.RData"
option_list <- list(
		
		make_option(c("-i", "--infile"), type="character", 
				default=infile_default, dest="infile",
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
		make_option(c("-w", "--numwords_min"), 
				default="1", type="integer", dest="numwords_min",
				help="Min number of words per phrase in wordcloud. [DEFAULT = 1]"),
		make_option(c("-x", "--numwords_max"), 
				default="1", type="integer", dest="numwords_max",
				help="Max number of words per phrase in wordcloud. [DEFAULT = 1; recommended: n <= 2]"),
		make_option(c("-s", "--sparsity_percent"), 
				default="0.95", type="numeric", dest="sparsity_percent",
				help=""))
		
parser <- OptionParser(usage = "%prog [options] file", option_list=option_list,
        add_help_option = TRUE,
		prog = NULL,
		description = "", 
		epilogue = paste0("Option 'top_n_percent' defaults to the top 1% of the most abundant words 
in your text corpus. Choice of numeric values is dependent on the size of your inputfile/corpus/term-doc-matrix. 
YOU must set an appropriate value.
			"))
#outputs options parsed
opts = parse_args(parser, args = commandArgs(),
		positional_arguments = TRUE)

tmpenv <- new.env()
topN_percentage_wanted = opts$options$top_n_percent
sparsity = opts$options$sparsity_percent

wmin = min(opts$options$numwords_min, opts$options$numwords_max)
wmax = max(opts$options$numwords_min, opts$options$numwords_max)

infile = opts$options$infile
if (! file_ext(infile) == ".RData"){
	print_help(parser)
}
if(!file.exists(infile)){
	print_help(parser)
} else {
	print(paste0("Loading '", infile, "' ..."))
}

# TODO [GH1] add check 
load(infile, envir=tmpenv)
corpus <- tmpenv$corpus

show(corpus)
print("")
print("Removing stopwords")
corpus <- tm_map(corpus, function(x){ removeWords(x, c(stopwords(), text_mining_util$earthsci_stopwords)) })

print("")
print('removing digitPhrases such as "1 2"   "= 2"   "3 4"  "et al":')

tempterms <- Terms(TermDocumentMatrix(corpus))

tempterms <- text_mining_util$digitPhrase(tempterms)
tempterms <- grep("'", tempterms)
#tempterms
corpus <- tm_map(corpus, function(x){ removeWords(x, c("et al", "^\\s*\\d+\\s*$", "^\\s*\\d+\\s?\\d+\\s*$", tempterms)) })
#remove all terms that onsist only of digits and whitespace such as 0 1 


show(corpus)

lsz = text_mining_wordcloud$find_fontsize(wordlength_min = 2, wordlength_max = 2)

# do not use when stopwords are removed?
UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = wmin, max = wmax))
tdm <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer))
#BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
#tdm <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer))
#tdm = DocumentTermMatrix(corpus, control=list(tokenize= "NGramTokenizer"))
#
tdm <- removeSparseTerms(tdm, 0.99)
print("----")
print("tdm properties")
str(tdm)
tdm_top_N_percent = tdm$nrow / 100 * topN_percentage_wanted
#text_mining_util$sft(corpus, tdm, tdm_top_N_percent , Inf)
topNwords= findFreqTerms(tdm, lowfreq= tdm_top_N_percent , highfreq=Inf); 

print(paste0("\ntop n words of '", infile, "':\n"))
print(topNwords)

#
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

#title = paste0("top ", topN_percentage_wanted , "% of words from ", infile);
#title = paste(title, "\n", round(tdm_top_N_percent), "words of ",  tdm$nrow , "words from", tdm$ncol, "documents" )

#layout(matrix(c(1, 2), nrow=2), heights=c(1, 4))
#par(mar=rep(0, 4))
#plot.new()
#text(x=0.5, y=0.5, title)

#wordcloud(d$word,d$freq,scale=c(9,.3),min.freq=4,max.words=Inf,random.order=FALSE,rot.per=.15,colors=pal,vfont=c("sans serif","plain"))
#dev.off()
#text_mining_wordcloud$wordclouds_pngs(d, seq=c(0.1,0.5,1,2,5), title=infile)
text_mining_wordcloud$wordclouds_pngs(d, seq=c(10,20,30,40,50), title=basename(infile), fn=paste0(infile, "-", wmin, "-", wmax ,"-"), lettersize=lsz)
#text_mining_wordcloud$wordclouds_svgs(d, seq=c(10,20,30,40,50), title=basename(infile), fn=paste0(infile, "-", wmin, "-", wmax ,"-"), lettersize=lsz)

warnings()