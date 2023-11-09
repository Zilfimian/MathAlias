library(stringr)
library(dplyr)
source("Translation.R")

Sys.setenv("OPENAI_API_KEY" = "***")

load("Objects_old.rda")

  # Get response from OpenAI "gpt-3.5-turbo"
  response <- openai::create_completion(model = "text-davinci-003",
                                        #Input Your Prompt
                                        prompt = 'system clear \n List 1000 mathematical 1-word Object different names.',
                                        temperature = 1,
                                        max_tokens = 3900)
  
  Objects <- response$choices$text %>% str_split(pattern = "\n[0-9]*\\.\\s?", simplify = T) %>% t() %>% c()
  Objects

  #Objects <- Objects_old[169]%>% str_split(pattern = ",|:|\n", simplify = T)%>% t() %>% c()
  Objects_old <- c(Objects, Objects_old)
  Objects_old <- unique(trimws(Objects_old))
  Objects_old <- Objects_old[nchar(Objects_old)>2]
  length(Objects_old)
  #which(nchar(Objects_old)>100)
  
  save(Objects_old, file = "Objects_old.rda")

  
  
  Objects_old_df <- data.frame(en=Objects_old, hy= Objects_old)
  
  Objects_old_df$hy <- Objects_old_df$en %>% lapply( function(x) translate_Google(x, sourceLang="en", targetLang="hy") ) %>% unlist()
  Objects_old_df$ru <- Objects_old_df$en %>% lapply( function(x) translate_Google(x, sourceLang="en", targetLang="ru") ) %>% unlist()
  
  Objects_old_df %>% writexl::write_xlsx("Objects.xlsx")
  
