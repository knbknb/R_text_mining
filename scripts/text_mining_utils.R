# utils_text_mining.R:
# Utilities for text mining AGU Fall meeting abstracts.
# useful in conjunction with, but does not depend on packages: tm 


########################################
## Put everything into an environment, to not pollute global namespace

text_mining_util = new.env()




########################################
## 
text_mining_util$earthsci_stopwords = function(){
	#return a vector
	c( "data", "earth", "science", "using" ) # "(..,"
}


# returns string w/o trailing whitespace
text_mining_util$trim.leading  <- function (x) {sub("^\\s+", "", x)}
text_mining_util$trim.trailing <- function (x) {sub("\\s+$", "", x)}
text_mining_util$trim <- function (x) {x = text_mining_util$trim.trailing(x);text_mining_util$trim.leading(x)}

text_mining_util$rmPunc =  function(x){
	# lookbehinds :
	# need to be careful to specify fixed-width conditions 
	# so that it can be used in lookbehind
	x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”\\|:±</>]{9})([[:alnum:]])',"\\2", x, perl=TRUE) ;
	x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>]{8})([[:alnum:]])',"\\2", x, perl=TRUE) ;
	x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”\\|:±</>]{7})([[:alnum:]])',"\\2", x, perl=TRUE) ;
	x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>]{6})([[:alnum:]])',"\\2", x, perl=TRUE) ;
	x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”\\|:±</>]{5})([[:alnum:]])',"\\2", x, perl=TRUE) ;
	x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>]{4})([[:alnum:]])',"\\2", x, perl=TRUE) ;
	x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>]{3})([[:alnum:]])',"\\2", x, perl=TRUE) ;
	x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>]{2})([[:alnum:]])',"\\2", x, perl=TRUE) ;
	x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>])([[:alnum:]])',"\\2", x, perl=TRUE) ; 
	# lookbehind: there must be a word char to the left and punct/whitespace stuff to the end.
	# Then append 1 extra blank 
	x <- gsub('(.*?)(?<=[[:alnum:]])([[:space:][:punct:]’“”:±</>\\\\]+?)$',"\\1", x, perl=TRUE)
	
	# remove all strings that consist *only* of punct chars 
	x <- gsub('^[[:space:][:punct:]’“”:±</>\\\\]+$',"", x, perl=TRUE) ;
	x
	
}


text_mining_util$cleanup = function(doc, sep= " "){
	doc = gsub("body:", "", doc, perl=TRUE);
	y = strsplit(doc, sep); 
	
	y = lapply(y, text_mining_util$rmPunc); 
	y[grep("\\S+", y, invert=FALSE, perl=TRUE)]; 
	
	y = sapply(y, paste, sep=" ")
	paste(y, collapse = sep)
	y
}


########################################
## Has to be last in file

while("text_mining_util" %in% search())
	detach("text_mining_util")
attach(text_mining_util)
