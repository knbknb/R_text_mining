#!/usr/bin/Rscript
###############################################################################
#
# $Id$
# Author: knb
###############################################################################

print(getwd())

config="/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/scripts/text_mining_config.R"
source(config) # should be absolute path,
utils=paste0(text_mining_config$homedir, "scripts/text_mining_utils.R")
source(utils)


library("RWeka")  # stemming and tokenization, called by tm
library("tm") #text mining
library("optparse")
library("tools") # Utilities for listing files, and manipulating file paths.


of=text_mining_config$full_outfilename(text_mining_config$outfileprefix, text_mining_config$outfilename, text_mining_config$outfileext)

#options must be -s single-letter or --longer-string. -dd double letters don't work
option_list <- list(
		make_option(c("-i", "--infile"), type="character",
				default="abstracts.csv", dest="infile",
				help= paste0("Infile, must be a CSV file and end in .csv")),
		make_option(c("-x", "--override"),
				action="store_true",
				default=FALSE, dest="override",
				help="Overwrite pre-existing .RData file "),
		make_option(c("-d", "--outdir"), type="character",
				default=text_mining_config$outdir2, dest="outdir",
				help= paste0("Outdir, must be a subdir name such as 'volcanology' ")),
		make_option(c("-f", "--outfile"), type="character",
				default=of, dest="outfile",
				help= paste0("Outfile, should be a simple filename fragment such as 'volcanology' (.Rdata will be appended)")),
		make_option(c("-n", "--show_n"),
				type="integer", default=text_mining_config$show_n_default, dest="show_n",
				help=paste0("Show this many records in full. [default = ", text_mining_config$show_n_default, "]")),
		make_option(c("-t", "--termdocmatrix"),
				action="store_true", default=FALSE, dest="termdocmatrix",
				help="Also generate a term-document-matrix from corpus. [default=FALSE]"),
		make_option(c("-v", "--verbose"),
				action="store_true", default=FALSE,
				help="Print (a lot of) extra output [default=false]"),
		make_option(c("-q", "--quietly"),
				action="store_false", default=TRUE,
				dest="verbose", help="Print little output"))

parser <- OptionParser(usage = "%prog [options] file", option_list=option_list,
		add_help_option = TRUE,
		prog = NULL,
		description = "", epilogue = paste0("-i Infile must be .csv file with AGU abstracts
   exported from http://agu-fm12.abstractcentral.com.
-f Filename can be absolute path or relative path.
   If relative path, then infile will be loaded from directory
   '",text_mining_config$full_datadir(), "'.
-t If you specify the '-t' option, a term-document matrix will also be generated from the corpus
and saved in
'", text_mining_config$full_rdatadir(), "'.
"))

#outputs options parsed
opts = parse_args(parser, args = commandArgs(),
		positional_arguments = TRUE)



gentdm = opts$options$termdocmatrix
override=opts$options$override
infile = opts$options$infile
show_n = opts$options$show_n  #show n items
#outdir = opts$options$outdir


outfile = text_mining_config$full_outfilename(text_mining_config$outfileprefix, opts$options$outfile, text_mining_config$outfileext)
print(outfile)


if(file.exists(full_rdatafile(outfile)) && !override){
	warning('A file already exists at "',text_mining_config$full_rdatafile(outfile),'", quitting\n')
	quit()
}

if (! file_ext(infile) == "csv"){
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

csv = read.csv(infile, header=TRUE, sep=",", quote="\"", fileEncoding = "UTF8")  #"
#csv = read.csv(paste0(homedir, "/abstracts-agu/itinerary-volcanology.csv", header=TRUE, sep=",", quote="\"", fileEncoding = "UTF8"))


bodies= csv[,18] #col 18 is abstract body
names(csv)

# Column List:
# [1] "X.Session.or.Event.Title"           "Session.or.Event.Abbreviation"
# [3] "Session.or.Event.Type"              "Session.or.Event.Topic"
# [5] "Session.or.Event.Date"              "Session.or.Event.Start.Time"
# [7] "Session.or.Event.End.Time"          "Session.or.Event.Location"
# [9] "Session.or.Event.Details"           "Abstract.or.Placeholder.Title"
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



print("Appending collection-level metadata to Corpus...")
meta(corpus, type="corpus", "opts") =opts
meta(corpus, type="corpus", "infile") =infile
meta(corpus, type="corpus", "rdata") = text_mining_config$full_rdatafile(outfile)

corpus <- tm_map(corpus, stripWhitespace)
#remove empty docs
corpus <- corpus[grep("\\S+", corpus, invert=FALSE, perl=TRUE)]



#preprocessing
#'arg' should be one of
#' “title”, “creator”, “description”, “date”, “identifier”, “language”, “subject”,
#' “publisher”, “contributor”, “type”, “format”, “source”, “relation”, “coverage”, “rights”
if (opts$options$verbose == TRUE){
	show_n = min(length(corpus), max_length)
}
print("")
tm::inspect(head(corpus, n=show_n))
print("Generating Metadata Records...")
len=length(corpus)
i = 0
corpus = tm_map(corpus, function(x){
	i <<- i + 1
#for (i in seq(from= 1, to=len, by=1)){
	if(opts$options$verbose == TRUE || i %% 50 == 0){
		print(paste(date(), "-", i, "of", len, substr(x, 1, 140), sep = " "))
	}
	DublinCore(x, "creator") = text_mining_util$rmPunc(csv[[i,14]])      #abstract presenter
	DublinCore(x, "title") = csv[[i,10]]  #abstract title => heading
	DublinCore(x, "description") = paste(csv[[i,11]] , csv[[i,1]], sep=": ") #session id, session name
	DublinCore(x, "source" ) = paste0(urlprefix, csv[[i,11]]) #URL to poster
	DublinCore(x, "Publisher" ) = csv[[i,16]]   #institutions
	DublinCore(x, "contributor" ) =  gsub('[[:space:]]+'," ", text_mining_util$cleanup(csv[[i,15]], ";") , perl=TRUE) ;  #all authors
	x
})

print("")
print("Finished with generating Metadata records:")
tm::inspect(head(corpus, n=show_n))
meta(corpus[[show_n]])
corpus <- tm_map(corpus, tolower)
#tm::inspect(head(corpus, n=show_n))


print("Removing stopwords...")
corpus <- tm_map(corpus, function(x){ removeWords(x, c(stopwords(), text_mining_util$earthsci_stopwords)) })


tm::inspect(head(corpus, n=show_n))

print("Stemming... (and removing stopwords, 2nd pass)")

corpus <- tm_map(corpus, function(x){stemDocument(x, language = "english")} )
corpus <- tm_map(corpus, function(x){ removeWords(x, c(stopwords(), text_mining_util$earthsci_stopwords)) })

#corpus <- tm_map(corpus, function(x){ text_mining_util$cleanup(x)})

show(corpus)
#print("Cleaning up punctuation around words..., again")
#corpus <- tm_map(corpus, text_mining_util$cleanup);
print("Printing a few sample documents")
tm::inspect(head(corpus, n=show_n))

# create a dirsource with text documents. this is optional.
# it allows for checking intermediate results.
# Just open small text file that remains from each document.
fn =paste(sprintf("%05d",seq_along(corpus)), ".txt", sep = "")
fn = text_mining_util$trim(fn)
system(paste0("mkdir -p ", text_mining_config$full_outdir_corpusfiles()))

#paste0("Writing corpus to files '", fn, "', outdir = ", text_mining_config$full_outdir_corpusfiles())
#writeCorpus(corpus, text_mining_config$full_outdir_corpusfiles(), filenames=fn )


paste0("Writing corpus to .Rdata file '", outfile, "', outdir = ", full_rdatadir())
save.image(file=text_mining_config$full_rdatafile(outfile))
print(paste0("You can load the .RData file into an R session and experiment with it, interactively."))
print(paste0("load('", text_mining_config$full_rdatafile(outfile), "')"))
print(paste0("... done with saving corpus to file."))
if(gentdm == TRUE){
	infile = basename(infile)
	tdm = tm::TermDocumentMatrix(corpus)
	print(paste0("Writing TDM (and corpus) to another .Rdata file, outdir = ", text_mining_config$full_rdatadir()))
	print(paste0("Saving away Term-Document-Matrix to ..."))
	print(paste0(text_mining_config$full_tdmfile(outfile)))
	save.image(file=text_mining_config$full_tdmfile(outfile))
	print(paste0("... done with saving Term-Document-Matrix to file."))

}

print(paste0("(Optional) You can also create a ***customized*** Term-Document-Matrix by executing "))
print(paste0(procscript, " --infile ", text_mining_config$full_rdatafile(outfile)))


#remove local .RData file in case the script was called with Rscript --save.
# We just  have saved away everything, no need to save it again in the working dir.
tryCatch(
		unlink(".RData"),
		error=function(e) {
			message(paste("Local .RData file does not seem to exist, but that's okay."))
			message("Here's the original error message:")
			message(e)
			# Choose a return value in case of error
			return(NA)
		},
		finally={
			#message(paste("Processed URL:", url))
			#message("Some other message at the end")
})
