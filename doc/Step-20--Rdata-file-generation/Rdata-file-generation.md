Step 20 - .Rdata File generation
=============


Steps to get an .R data file containing preprocessd conference abstracts:

Use an R script to perform the following:

 1. Read the Comma separaed value file, .csv)
 2. Remove Punctuation
 3. Remove Stopwords
 4. Perform Word stemming (This is optional and might not always work due to R <-> Java interprocess-communication issues)
 5. Save Session to an .Rdata file
 
This will generate an .RData file which can be read in with another script, and processed further.

An alternative would be to save the documents individually to a dedicated directory (which should be empty). 
Reload the files inside the directory with *tm*'s DirSource() function.

