########################################
## Put everything into an environment, to not pollute global namespace
library("wordcloud")

text_mining_wordcloud = new.env()



#create a wordcloud. 
# input params:
#  - df: a data frame with columns "word" and "freq"
#  - fn: a filename 
#  - minfreq: minimum frequency with which a word must occur inside the text
#  - maxfreq: maximum frequency with which a word must occur inside the text
text_mining_wordcloud$create_wordcloud_png = function(df, fn="wordcloud.png", minfreq=2, maxwords=Inf, title=""){
	png(filename, width=1280,height=800)
	#wordcloud(df$word,df$freq,c(8,.3),2,100,TRUE,.15, pal,vfont=c("sans serif","plain"))
	layout(matrix(c(1, 2), nrow=2), heights=c(1, 4))
	par(mar=rep(0, 4))
	plot.new()
	text(x=0.5, y=0.5, title)
	wordcloud(df$word,df$freq,scale=c(9,.3),min.freq=minfreq,max.words=maxwords,random.order=FALSE,rot.per=.15,colors=pal,vfont=c("sans serif","plain"))
	dev.off()
}

# create many png files from the top 1,2...20 % of words in document
text_mining_wordcloud$wordclouds_pngs = function(df, fn="wordcloud", minfreq=2, maxwords=Inf, seq=c(1, 2,3,4,5, 10, 20), title=""){
	
	lapply(seq, function(x){
				x1 = sprintf("%04d", x)
				text_mining_wordcloud$create_wordclouds_png(df, fn=paste0("wordcloud-", x1, ".png"), minfreq=minfreq, maxwords=maxwords, title=title)
				
			})
	
}

while("text_mining_wordcloud" %in% search())
	detach("text_mining_wordcloud")
attach(text_mining_wordcloud)
