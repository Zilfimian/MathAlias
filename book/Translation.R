library(purrr)
library(httr)
library(jsonlite)
library(stringr)

translate_Google <- function(sourceText, sourceLang, targetLang){
  url <- paste0("https://translate.googleapis.com/translate_a/single?client=gtx&sl=",
                sourceLang, "&tl=", targetLang, "&dt=t&q=", URLencode(sourceText))
  
  response <- GET(url)
  content <- content(response, as = "text", encoding = "UTF-8")
  json <- fromJSON(content)
  
  
  
  if(!is.null(nrow(json[[1]]))){ # in case of data table - (from en to hy)
    translatedText <- json[[1]][[1]]  
  }else if(length(json[[1]])>1){ # in case of 2 rows (from hy to en)
    length_of_levels <- length(json[[1]])
    all_json <- NULL
    for (i in 1:length_of_levels) {
      current_json <- json[[1]][[i]][[1]]
      all_json = c(all_json, current_json)
    }
    translatedText <- paste(all_json, collapse = " ") 
  }else{
    translatedText <- json[[1]][[1]][[1]]  
  }
  
  return(translatedText)
}
