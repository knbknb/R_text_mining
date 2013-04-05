########################################
## Put everything into an environment, to not pollute global namespace
library("wordcloud")
library("RColorBrewer")
#library("Cairo")

text_mining_wordcloud = new.env()


text_mining_wordcloud$size_muliplier = 4

#create a wordcloud. 
# input params:
#  - df: a data frame with columns "word" and "freq"
#  - fn: a filename 
#  - minfreq: minimum frequency with which a word must occur inside the text
#  - maxwords: maximum number of words that will appear in wordcloud
text_mining_wordcloud$create_wordcloud_png = function(df, fn="wordcloud.png", minfreq=2, maxwords=Inf, title="", lettersize=2){
	#pal <- brewer.pal(9, "BuGn")
	pal <- brewer.pal(8,"Dark2")
    #pal <- pal[-(1:2)]
	#getOption("device")

	#sink(fn)
	#options(device="png")
	#dev.new(which=dev.cur())
	
	png(fn, width=1280 * text_mining_wordcloud$size_muliplier,height=1000 * text_mining_wordcloud$size_muliplier,  res=180 * text_mining_wordcloud$size_muliplier)
	
	#dev.new()
	#dev.list()
	
	layout(matrix(c(1, 2), nrow=2), heights=c(1, 4))
	par(mar=rep(0, 4)) # margin in lines of text
	plot.new()
	text(x=0.5, y=0.5, title)
	lsz=lettersize
	# if there are warnings, not all words fot on canvas and thus cannot be plotted. Change scale= Argument, reduce first item
	wordcloud(df$word,df$freq,scale=c(lsz,.3), min.freq=minfreq, max.words=maxwords, random.order=FALSE, rot.per=.15, colors=pal, vfont=c("sans serif","plain"))
	dev.off()
	#dev.next()
	
}



# create many png files from the most common 10,20,30,40 words in document
text_mining_wordcloud$wordclouds_pngs = function(df, fn="wordcloud", minfreq=2, maxwords=Inf, seq=c(10, 20,30,40,50, 100), title="", lettersize=2){
	
	for (x in seq){
		x1 = sprintf("%04d", x)
		fnx = paste0(fn, "-", x1, ".png");
		titlex = paste0("Most common ", x, " words/phrases of '", title, "'")
		#titlex = paste0("Top ", x, "% words of ", title)
		png(fn, width=1280 * text_mining_wordcloud$size_muliplier, height=800 * text_mining_wordcloud$size_muliplier,  res=130 * text_mining_wordcloud$size_muliplier)
		maxwx = x
		minfx = minfreq
		print(paste0("Maxwords = ", x, "; Creating wordcloud file '", fnx, "'"))
		lsz=lettersize
		text_mining_wordcloud$create_wordcloud_png(df, fn=fnx, minfreq=minfx, maxwords=maxwx, title=titlex, lettersize=lsz)
	}
	
}


# find max font sizes to use in wordcloud creating. 
# when phrase lengths > 1 word, strings tend to get longer, and do not fit on canvas
text_mining_wordcloud$find_fontsize = function (wordlength_min = 2, wordlength_max = 2){
	if (max(c(wordlength_min, wordlength_max)) >= 3 ){
		lsz = 2
	} else if (max(c(wordlength_min, wordlength_max)) >= 2  ){
		lsz = 3
	} else {
		lsz = 4
	}
	lsz
}

while("text_mining_wordcloud" %in% search())
	detach("text_mining_wordcloud")
attach(text_mining_wordcloud)
