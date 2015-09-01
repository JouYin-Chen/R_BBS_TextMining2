# R_BBS_TextMining2

##參考資料：
http://rstudio-pubs-static.s3.amazonaws.com/12422_b2b48bb2da7942acaca5ace45bd8c60c.html <br />
http://onertipaday.blogspot.tw/2011/07/word-cloud-in-r.html <br />
http://davetang.org/muse/2013/04/06/using-the-r_twitter-package/ <br />
http://bbs.pinggu.org/thread-3546893-1-1.html<br />


##細節修正:
    url <- paste('www.ptt.cc/bbs/StupidClown/index', tmp, sep='')
        修改為
    url <- paste('http://www.ptt.cc/bbs/StupidClown/index', tmp, sep='')

##getdoc的funtion中{
    start <- regexpr('www', line)[1]
      www修改為https
    start <- regexpr('https', line)[1]

    name <- strsplit(url, '/')[[1]][4]
      4修改為6
    name <- strsplit(url, '/')[[1]][6]
  }

##tncm下載&安裝
    https://r-forge.r-project.org/R/?group_id=1571<br />
    install.packages("~/../Downloads/tmcn_0.1-4.zip", repos=NULL, type="source")<br />
  
##Rwordseg下載&安裝
  電腦必須先安裝java<br />
  R安裝rJava<br />
  http://R-Forge.R-project.org/bin/windows/contrib/3.0/Rwordseg_0.2-1.zip<br />
  install.packages("~/../Downloads/Rwordseg_0.2-1.zip", repos=NULL, type="source")<br />

##VectorSource
  d.corpus <- Corpus(VectorSource(d.corpus))<br />
　會產生錯誤訊息<br />
    Error in UseMethod("meta", x) :<br />
    no applicable method for 'meta' applied to an object of class "character"<br />

  以下方指令代替，但效果並不佳，會出現不需要的單字。<br />
  d.corpus <- Corpus(DataframeSource(data.frame(as.character(d.corpus))))<br />

##wordLengths
  tdm <- TermDocumentMatrix(d.corpus, control = list(wordLengths = c(2, Inf)))<br />
  每個單字都會多出""與,。因故，將2改為5<br />
  tdm <- TermDocumentMatrix(d.corpus, control = list(wordLengths = c(5, Inf)))<br />

