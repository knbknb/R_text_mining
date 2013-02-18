#!/usr/bin/Rscript
###############################################################################
#
#
# https://github.com/knbknb/R_text_mining/
#
# $Id: import_agu_records.R 3357 2013-02-14 15:37:13Z knb $
# Author: knb
# Build a corpus from AGU FALL MEETING 2012 abstracts, write it out to an Rdata file
###############################################################################


#### 
#### config
#### 
homedir="/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/"
datadir="data/abstracts-agu/"
Rdatadir="data/Rdata/"
outfileprefix="corpus--"
outfilename="--with-metadata--"
outfileext=".RData"
urlprefix="http://fallmeeting.agu.org/2012/eposters/eposter/"
wekajar="/usr/local/lib/R/site-library/RWekajars/java/weka.jar"
verbose = TRUE
select_n = 3  #show n items
outdir2="_default_outdir"
wd=getwd()
####
full_outfilename = function(x) {paste0(outfileprefix, x, outfileext)} 
full_datadir = function(){paste0(homedir, datadir)}
full_rdatadir = function(){paste0(homedir, Rdatadir)}
full_outdir2 = function(){paste0(homedir, datadir, outdir2)}


source(paste0(homedir,"scripts/utils_text_mining.R"))


#Sys.setenv(CLASSPATH=paste(Sys.getenv("CLASSPATH"),wekajar, sep=":"))
Sys.setenv(JAVA_HOME="")
Sys.setenv(CLASSPATH=paste(wekajar, sep=":"))
Sys.getenv("CLASSPATH")
Sys.setenv(NOAWT=TRUE) # advice from an internet forum, not sure what this does w.r.t weka.jar

library("RWeka")  # stemming and tokenization, called by tm
library("tm") #text mining
library("optparse")
library("tools") # Utilities for listing files, and manipulating file paths.

option_list <- list(
		make_option(c("-i", "--infile"), type="character", 
				default="abstracts.csv", dest="infile",
				help= paste0("Infile, must be a CSV file and end in .csv")),
		make_option(c("-od", "--outdir"), type="character", 
				default=outdir2, dest="outdir",
				help= paste0("Outdir, must be a subdir name such as 'volcanology' ")),
		make_option(c("-of", "--outfile"), type="character", 
				default=full_outfilename(outfilename), dest="outfile",
				help= paste0("Outfile, should be a simple filename fragment such as 'volcanology' (.Rdata will be appended)")),		
		make_option(c("-v", "--verbose"), 
				action="store_true", default=TRUE,
				help="Print extra output [default]"),
		make_option(c("-q", "--quietly"), 
				action="store_false",
				dest="verbose", help="Print little output"))

parser <- OptionParser(usage = "%prog [options] file", option_list=option_list,
		add_help_option = TRUE,
		prog = NULL,
		description = "", epilogue = paste0("Infile must be .csv file with AGU abstracts 
exported from http://agu-fm12.abstractcentral.com.
Filename can be absolute path or relative path.
If relative path, then infile will be loaded from
'", full_datadir(), "'
 "))
#outputs options parsed
opts = parse_args(parser, args = commandArgs(),
		positional_arguments = TRUE)

tmpenv <- new.env()

infile = opts$options$infile
outdir2 = opts$options$outdir
outfile= opts$options$outfile
outfile=full_outfilename(outfile);

if (! file_ext(infile) == ".csv"){
	print_help(parser)
}
if(!file.exists(infile)){
	if(!file.exists(infile)){
		infile = paste0(full_datadir(), infile)
		print_help(parser)
	} else {
		print(paste0("Loading '", infile, "' ..."))
	}
	
} else {
	print(paste0("Loading '", infile, "' ..."))
}

#library("wordnet") # dictionaries

csv = read.csv(infile, header=TRUE, sep=",", quote="\"", fileEncoding = "UTF8")
#csv = read.csv(paste0(homedir, "/abstracts-agu/itinerary-volcanology.csv", header=TRUE, sep=",", quote="\"", fileEncoding = "UTF8"))


bodies= csv[,18] #col 18 is abstract body
names(csv)
#[1] "X.Session.or.Event.Title"           "Session.or.Event.Abbreviation"     
#[3] "Session.or.Event.Type"              "Session.or.Event.Topic"            
#[5] "Session.or.Event.Date"              "Session.or.Event.Start.Time"       
#[7] "Session.or.Event.End.Time"          "Session.or.Event.Location"         
#[9] "Session.or.Event.Details"           "Abstract.or.Placeholder.Title"     
#[11] "Abstract.Final.ID"                  "Abstract.or.Placeholder.Start.Time"
#[13] "Abstract.or.Placeholder.End.Time"   "Abstract.Presenter.Name"           
#[15] "Abstract.Authors"                   "Institutions.All"                  
#[17] "Abstract.Status"                    "Abstract.Body"                     
#[19] "Session.Abstract.Sort.Order"  
#attributes(csv[[2]])
head(csv,n=1)
words = bodies
stopifnot(length(bodies) > 0)

corpus <- Corpus(VectorSource(words))
class(corpus)

corpus <- tm_map(corpus, stripWhitespace)
#remove empty docs
corpus <- corpus[grep("\\S+", corpus, invert=FALSE, perl=TRUE)]

#preprocessing
#'arg' should be one of 
#' “title”, “creator”, “description”, “date”, “identifier”, “language”, “subject”, 
#' “publisher”, “contributor”, “type”, “format”, “source”, “relation”, “coverage”, “rights”
if (verbose == TRUE){
	cnt = length(corpus)
} else {
  cnt = select_n
}
for (i in seq(from= 1, to=cnt, by=1)){
    print(paste(i, " ", substr(corpus[[i]], 1, 140), sep = " "))
	DublinCore(corpus[[i]], "creator") = rmPunc(csv[[i,14]])      #abstract presenter
	DublinCore(corpus[[i]], "title") = csv[[i,10]]  #abstract title => heading
	DublinCore(corpus[[i]], "description") = paste(csv[[i,11]] , csv[[i,1]], sep=": ") #final id => description
	DublinCore(corpus[[i]], "source" ) = paste0(urlprefix, csv[[i,11]])
	DublinCore(corpus[[i]], "Publisher" ) = csv[[i,16]]   #institutions
	DublinCore(corpus[[i]], "contributor" ) =  gsub('[[:space:]]+'," ", cleanup(csv[[i,15]], ";") , perl=TRUE) ;  #all authors
	#attr(corpus[[i]], "Origin") = csv[[i,16]]   #institutions
	#"Abstract.or.Placeholder.Start.Time"
		
}

cnt=select_n
meta(corpus[[cnt]])
#save.image("/home/knb/code/svn/eclipse38_dynlang/R_one-offs/text_mining/01-corpus-metadata.RData")

#gc()
#stop()
corpus <- tm_map(corpus, tolower)
tm::inspect(head(corpus, n=cnt))


print("Removing stopwords...")
corpus <- tm_map(corpus, function(x){ removeWords(x, c(stopwords(), text_mining_util$earthsci_stopwords)) })

tm::inspect(head(corpus, n=cnt))

print("Stemming...")

corpus <- tm_map(corpus, function(x){stemDocument(x, language = "english")} )

corpus <- tm_map(corpus, function(x){ removeWords(x, c(stopwords(), text_mining_util$earthsci_stopwords)) })
#length(corpus)
show(corpus)
#print("Cleaning up punctuation around words..., again")
#corpus <- tm_map(corpus, text_mining_util$cleanup);



tm::inspect(head(corpus, n=cnt))

#fn =paste(sprintf("%05d",seq_along(corpus)), ".txt", sep = "")
#fn = text_mining_util$trim(fn)
#system(paste0("mkdir -p ", full_outdir2()))

#paste0("Writing corpus to files '", fn, "', outdir = ", full_outdir2())
#writeCorpus(corpus, outdir, filenames=fn )


paste0("Writing corpus to .Rdata file '", outfile, "', outdir = ", full_rdatadir())
save.image(file=outfile)
