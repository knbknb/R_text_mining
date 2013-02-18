Step 20 - .Rdata File generation
=============


Steps to get an .R data file containing preprocessd conference abstracts:

Use an R script to perform the following:

 1. Read the Comma separaed value file, .csv)
 2. Remove Punctuation
 3. Remove Stopwords
 4. Perform Word stemming (This is optional and might not always work due to R-java IPC issues)
 5. Create a term-document-matrix
 6. Extend Term-Document-Matrix with metadata
 7. Save Session to an .Rdata file
 
This will generate a relatively big but sparse matrix, which will be the basis of future calculations and investigations.
