#mining google news for future training
#refreshes google RSS every 30 minutes to
#download the articles

library(stringr)
require(XML)
require(RCurl)


# open google news feed and parse xml
fileURL <- "https://news.google.com/news/feeds?q=&output=rss"
xData <- getURL(fileURL, cainfo = 'cacert.pem.txt')
xmlfile = xmlTreeParse(xData)
src<-xpathApply(xmlRoot(xmlfile), "//item")
#for every news article, store title 

while (T){
  xData <- getURL(fileURL, cainfo = 'cacert.pem.txt')
  xmlfile = xmlTreeParse(xData)
  src<-xpathApply(xmlRoot(xmlfile), "//item")\
  
for (i in src){
  title = regmatches(as.character(i[1][1]), gregexpr('(?<=value =).*?"(?=[)])', as.character(i[1][1]),perl=T))
  title = regmatches(title[[1]], gregexpr('^.*?(?=[ ][-][ ])',title[[1]],perl=T))[[1]]
  title = substr(title,3,nchar(title))
  title = str_replace_all(title, "[^[:alnum:]]", " ")
  link = regmatches(as.character(i[[2]])[3], gregexpr('(?<=url=).*?"', as.character(i[[2]])[3],perl=T))
  link = substr(link,1,nchar(link)-1)[[1]]
  tryCatch({
     #site<<-readLines(link)
    site <- getURL(link, .opts = curlOptions(
      cookiejar="",  useragent = "Mozilla/5.0", followlocation = TRUE
    ))
    site = paste0('<!--',link,'-->\n',site)
     #site = c(paste0('<!--',link,'-->'),site)
    
  }, error = function(e) {
    site <<- link
    title <<- paste0('ERR_',title)
  })
  fileConn<-file(paste0('Training2/',title,'.html'))
  cat(site, file=fileConn)
  close(fileConn)
}
Sys.sleep(60*30)
}
