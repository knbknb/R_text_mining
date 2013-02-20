# utils_text_mining.R:
# Utilities for text mining AGU Fall meeting abstracts.
# 


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
	# lookbehind there must be a word char to the left and punct/whitespace stuff to the end.
	# append 1 extra blank 
	x <- gsub('(.*?)(?<=[[:alnum:]])([[:space:][:punct:]’“”:±</>\\\\]+?)$',"\\1", x, perl=TRUE)
	
	# remove all strings that consist *only* of punct chars 
	x <- gsub('^[[:space:][:punct:]’“”:±</>\\\\]+$',"", x, perl=TRUE) ;
	x
	
}

#create a wordcloud. input a data frame with columns "word" and "freq"
# a filename 
text_mining_util$create_wordcloud_png = function(df, fn="wordcloud.png", minfreq=2, maxfreq=Inf){
	png(filename, width=1280,height=800)
	#wordcloud(df$word,df$freq,c(8,.3),2,100,TRUE,.15, pal,vfont=c("sans serif","plain"))
	wordcloud(df$word,df$freq,scale=c(8,.3),min.freq=2,max.words=Inf,random.order=TRUE,rot.per=.15,colors=pal,vfont=c("sans serif","plain"))
	dev.off()
}

# create many png files
text_mining_util$wordclouds_pngs = function(df, fn="wordcloud", minfreq=2, maxfreq=Inf, seq=c(10,20,30,40,50, 100, 200)){
	
	lapply(seq, function(x){
				text_mining_util$create_wordclouds_png(df, fn=paste0("wordcloud-", x, ".png"), minfreq=minfreq, maxfreq=maxfreq)
			})
	
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
