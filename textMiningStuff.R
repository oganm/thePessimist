library(tm)
require(RCurl)
library(XML)
html <- list.files('Training2',pattern="\\.(htm|html)$") # get just .htm and .html files


source("https://raw.githubusercontent.com/tonybreyal/Blog-Reference-Functions/master/R/htmlToText/htmlToText.R")


html2txt <- lapply(paste0('Training2/',html), htmlToText)

# clean out non-ASCII characters
html2txtclean <- sapply(html2txt, function(x) iconv(x, "latin1", "ASCII", sub=""))
corpus <- Corpus(VectorSource(html2txtclean))

#clean corpus
skipWords <- function(x) removeWords(x, stopwords("english"))

funcs <- list(tolower, removePunctuation, stripWhitespace, skipWords)
a <- tm_map(corpus, FUN = tm_reduce, tmFuns = funcs)

a = tm_map(a, PlainTextDocument)

a.dtm1 <- TermDocumentMatrix(a, control = list(wordLengths = c(3,154))) 
findFreqTerms(a.dtm1, highfreq=0.7)

findFreqTerms(a.dtm1, lowfreq=10)[which(findFreqTerms(a.dtm1, lowfreq=10) %in% locNames)]
freqTerms = findFreqTerms(a.dtm1, lowfreq=10)
