# TODO: Add comment
# $Id: import_agu_records.R 3357 2013-02-14 15:37:13Z knb $
# Author: knb
# Build a corpus from AGU FALL MEETING 2012 abstracts
###############################################################################

#### 
#### config
#### 
homedir="/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/"
urlprefix="http://fallmeeting.agu.org/2012/eposters/eposter/"
wekajar="/usr/local/lib/R/site-library/RWekajars/java/weka.jar"
verbose = TRUE
show_n = 3  #show n items
outdir2="data/abstracts-agu/informatics"
wd=getwd()
####


#source("/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/R_utils/util.R")
source(paste0(homedir,"scripts/utils_text_mining.R"))


#Sys.setenv(CLASSPATH=paste(Sys.getenv("CLASSPATH"),wekajar, sep=":"))
Sys.setenv(JAVA_HOME="")
Sys.setenv(CLASSPATH=paste(wekajar, sep=":"))
Sys.getenv("CLASSPATH")
Sys.setenv(NOAWT=TRUE)

library("RWeka")  # stemming and tokenization, called by tm
library("tm")

#library("wordnet") # dictionaries

csv = read.csv(paste0(homedir, "data/abstracts-agu/itinerary-volcanology.csv"), header=TRUE, sep=",", quote="\"", fileEncoding = "UTF8")
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
  cnt = show_n
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

cnt=show_n
meta(corpus[[cnt]])
#save.image("/home/knb/code/svn/eclipse38_dynlang/R_one-offs/text_mining/01-corpus-metadata.RData")

#gc()
#stop()
corpus <- tm_map(corpus, tolower)
tm::inspect(head(corpus, n=cnt))

#print("cleaning up punctuation around words...")
#corpus <- tm_map(corpus, cleanup);
#tm::inspect(head(corpus, n=cnt))
#corpus <- Corpus(VectorSource(corpus))

#"system", "model", "..", "..,", "information"

print("removing stopwords...")
corpus <- tm_map(corpus, function(x){ removeWords(x, c(stopwords(), text_mining_util$earthsci_stopwords)) })

tm::inspect(head(corpus, n=cnt))

#stopifnot(length(corpus) > 1000, )

print("stemming...")

corpus <- tm_map(corpus, function(x){stemDocument(x, language = "english")} )

#length(corpus)
show(corpus)



tm::inspect(head(corpus, n=cnt))

fn =paste(sprintf("%05d",seq_along(corpus)), ".txt", sep = "")

system(paste0("mkdir -p ", wd, "/", outdir2))
outdir=paste0(wd, "/", outdir2)
outdir
#writeCorpus(corpus, outdir, filenames=fn )

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

# remove punctuation chars from urls, at tail+head
urls1 = lapply (urls1 , function(x){urls1[x] =rmPunc(x)});
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