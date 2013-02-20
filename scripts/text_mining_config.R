#!/usr/bin/Rscript
###############################################################################
#
#
# https://github.com/knbknb/R_text_mining/
#
# $Id$
# Author: knb
# Build a corpus from AGU FALL MEETING 2012 abstracts, write it out to an Rdata file
# Config file
###############################################################################

########################################
## Put everything into an environment, to not pollute global namespace

text_mining_config = new.env()
library(tools)



#### 
#### config
#### 
text_mining_config$homedir="/home/knb/code/svn/eclipse38_dynlang/R_one-offs/R_text_mining/"
text_mining_config$scriptdir="scripts/"
text_mining_config$datadir="data/abstracts-agu/"
text_mining_config$Rdatadir="data/Rdata/"
text_mining_config$outfileprefix="corpus--"
text_mining_config$outfilename="" # --with-metadata--
text_mining_config$outfileext=".RData"
text_mining_config$tdmfileext=".tdm.RData"
text_mining_config$urlprefix="http://fallmeeting.agu.org/2012/eposters/eposter/"
text_mining_config$wekajar="/usr/local/lib/R/site-library/RWekajars/java/weka.jar"
text_mining_config$outdir2="_default_outdir"
text_mining_config$procscript="process_corpus.R"
text_mining_config$max_length=50 # constrain verbosity
text_mining_config$wd=getwd()
text_mining_config$show_n_default=3
####
text_mining_config$full_datadir = function(){paste0(homedir, datadir)}
text_mining_config$full_rdatadir = function(){paste0(homedir, Rdatadir)}
text_mining_config$full_outdir_corpusfiles = function(){paste0(homedir, datadir, outdir2)}
text_mining_config$full_outfilename = function(pre ,x, suf) {paste0(pre, x, suf)} #components of the data file
text_mining_config$full_rdatafile = function(x){paste0(full_rdatadir(), x)} # 
text_mining_config$full_tdmfile = function(x){x = basename(x); x = sub(paste0('\\.?', file_ext(x), '$'), '', x); paste0(full_rdatadir(), x, tdmfileext)}

# necessary for Statet (R console inside Eclipse) ?
Sys.setenv(JAVA_HOME="")
Sys.setenv(CLASSPATH=paste(text_mining_config$wekajar, sep=":"))
Sys.getenv("CLASSPATH")
Sys.setenv(NOAWT=TRUE) # advice from an internet forum, not sure what this does w.r.t weka.jar



########################################
## Has to be last in file

while("text_mining_config" %in% search())
	detach("text_mining_config")
attach(text_mining_config)