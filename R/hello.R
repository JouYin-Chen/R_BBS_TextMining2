
mining <- function() {
  library(XML)
  library(RCurl)

  data <- list()

  #for( i in 1058:1060){
  #    baseURL <- paste('bbs/StupidClown/index', i, '.html' , sep='')
  #    html <- content(GET("https://www.ptt.cc/" , path = baseURL),as = 'parsed')
  #    url.list <- xpathSApply(html, "//div[@class='title']/a[@href]", xmlAttrs)
  #    data <- rbind(data, paste('www.ptt.cc', url.list, sep=''))
  #  }

  for( i in 1058:1068){
    tmp <- paste(i, '.html', sep='')
    url <- paste('https://www.ptt.cc/bbs/StupidClown/index', tmp, sep='')
    html <- htmlParse(getURL(url))
    url.list <- xpathSApply(html, "//div[@class='title']/a[@href]", xmlAttrs)
    data <- rbind(data, paste('https://www.ptt.cc', url.list, sep=''))
  }
  data <- unlist(data)

  getdoc <- function(line){
    start <- regexpr('https', line)[1]
    end <- regexpr('html', line)[1]

    if(start != -1 & end != -1){
      url <- substr(line, start, end+3)
      html <- htmlParse(getURL(url), encoding="")
      doc <- xpathSApply(html, "//div[@id='main-content']", xmlValue)
      name <- strsplit(url, '/')[[1]][6]
      write(doc, gsub('html', 'txt', name))
    }
  }

  setwd(dir = "doc/")
  sapply(data, getdoc)
  setwd(dir = "../")

  library(tm)
  library(tmcn)
  library(Rwordseg)

  d.corpus <- Corpus(DirSource("doc"), list(language = NA))

  #看檔案
  #inspect(d.corpus)
  d.corpus <- tm_map(d.corpus, removePunctuation, mc.cores=1)
  d.corpus <- tm_map(d.corpus, stripWhitespace)
  d.corpus <- tm_map(d.corpus, removeNumbers)

  d.corpus <- tm_map(d.corpus, function(word) {
    gsub("[A-Za-z0-9]", "", word)
  })

  #利用segmentCN來進行斷詞
  d.corpus <- tm_map(d.corpus[1:100] , segmentCN , nature = TRUE)
  d.corpus <- tm_map(d.corpus, function(sentence) {
    noun <- lapply(sentence, function(w) {
      #取出名詞
      w[names(w) == "n"]
    })
    unlist(noun)
  })
  #d.corpus <- Corpus(VectorSource(d.corpus))
  #Error in UseMethod("meta", x) :
  #no applicable method for 'meta' applied to an object of class "character"

  d.corpus <- Corpus(DataframeSource(data.frame(as.character(d.corpus))))

  #去除不需要的常見單字
  myStopWords <- c(stopwordsCN(),  "編輯", "時間", "標題", "發信", "實業", "作者" ,'c')
  d.corpus <- tm_map(d.corpus, removeWords, myStopWords)

  tdm <- TermDocumentMatrix(d.corpus, control = list(wordLengths = c(5, Inf)))

  library(wordcloud)
  library(RColorBrewer)
  pal2 <- brewer.pal(8,"Dark2")

  m1 <- as.matrix(tdm)
  v <- sort(rowSums(m1), decreasing = TRUE)
  d <- data.frame(word = names(v), freq = v)
  wordcloud(d$word, d$freq, min.freq = 10, random.order = F, ordered.colors = F, colors = pal2)

}
