library(shiny)
library(gdata)
library(data.table)
library(tm)
lookup.table <- fread("lookup_table_10k.csv", header = TRUE,stringsAsFactors = FALSE)

fn.predict <- function(phrase){
    full.phrase <- trim(phrase)
    phrase <- trim(phrase)
    phrase <- tolower(phrase)
    phrase <- gsub(phrase,pattern = "[[:punct:]]",replacement = "")
    phrase <- gsub(phrase,pattern = "[0-9]",replacement = "")
    phrase <- gsub(phrase,pattern = "  ",replacement = " ")
    phrase <- gsub(phrase,pattern = "   ",replacement = " ")
    
    phrase <- unlist(strsplit(phrase,split = " "))
    
    len <- length(phrase)
    
    start.loc <- ifelse(length(phrase)>=3,length(phrase)- 2,
                 ifelse(length(phrase)==2,length(phrase)- 1,
                 ifelse(length(phrase)==1,length(phrase), 1)))
    
    phrase <- phrase[start.loc:length(phrase)]
    phrase <- paste(phrase,collapse = " ")
    
    if(phrase%in%lookup.table$trigrams){
        x <- subset(lookup.table, subset = trigrams==phrase, select = trigram_prediction)       
    }
    
    
    if(!phrase%in%lookup.table$trigrams & len >=3){
        phrase <- unlist(strsplit(phrase,split = " "))
        phrase <- phrase[2:3]
        phrase <- paste(phrase,collapse = " ")
    }
    
    if(phrase%in%lookup.table$bigrams){
        x <- subset(lookup.table, subset = bigrams==phrase, select = bigram_prediction)       
    }
    
    if(!phrase%in%lookup.table$trigrams & !phrase%in%lookup.table$bigrams & len ==2){
        phrase <- unlist(strsplit(phrase,split = " "))
        phrase <- phrase[2]
        phrase <- paste(phrase,collapse = " ")
    }
    
    if(phrase%in%lookup.table$unigrams){
        x <- subset(lookup.table, subset = unigrams==phrase, select = unigram_prediction)
    }
    
    
    if (!phrase%in%lookup.table$trigrams & !phrase%in%lookup.table$bigrams & !phrase%in%lookup.table$unigrams){
        x <- sample(stopwords(kind = "en"),1,replace = FALSE)
    }
    
    if(len==0){
        x <- ''
    }
    
    
    x <- trim(paste(full.phrase, x,sep = " "))
    return(x)
}

shinyServer(
  function(input, output) {
    output$phrase <- renderPrint({input$phrase})
    output$prediction <- renderPrint({fn.predict(input$phrase)})
  }
)