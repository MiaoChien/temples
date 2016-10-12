# http://temple.twgod.com/
setwd("~/Dropbox/practice/crawler/temples")
library(httr)
library(XML)
library(magrittr)
library(data.table)
library(rvest)


url = paste0("http://temple.twgod.com/CwP/P/P",29:40,".html")

getTable = function(url){
  doc <- read_html(url)
  
  a = doc %>% 
    html_nodes(xpath = "//tr/td/div/div//div") %>% 
    html_text()
  
  name = main = addr = vector()
  for(i in 1:length(a)){
    name = c(a[2+4*(i-1)], name)
    main = c(a[3+4*(i-1)], main)
    addr = c(a[4+4*(i-1)], addr)
  }
  
  table = data.table("name"= name,
                     "deities"= main,
                     "addr"= addr) %>% na.omit
  
  return(table)
}

table = lapply(url, getTable) %>% do.call(rbind, .) %>% 
  .[!duplicated(., by=c("name", "addr"))]

write.csv(table, file = "tpe_temple.csv")
