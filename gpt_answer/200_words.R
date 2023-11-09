library(stringr)
library(dplyr)

Sys.setenv("OPENAI_API_KEY" = "***")

load("Names_data_old.rda")
Names_data_new <- NULL

for(i in 1:10){
  # Get response from OpenAI "gpt-3.5-turbo"
  response <- openai::create_completion(model = "text-davinci-003",
                                        #Input Your Prompt
                                        prompt = 'system clear \n I want to create an app like Alias but only using terms from mathematics. I need 1000 full names of the most famouts mathematician and math related person for my game. Also year of birth and death',
                                        temperature = 1,
                                        max_tokens = 3900)
  
  Names <- response$choices$text %>% str_split(pattern = "\n?\n[0-9]*\\.\\s+", simplify = T) %>% t() %>% c()
  Names_data <- Names %>% str_split(pattern = "\\(", simplify = T) 
  Names_data[,1] <- trimws(Names_data[,1])
  Names_data[,2] <- str_remove_all(Names_data[,2], pattern = "\\)")
  
  Names_data_new<- rbind(Names_data_new, Names_data)  
}

Names_data_old <- rbind(Names_data_old, Names_data_new)

Names_data_old <- data.frame(Names_data_old)%>% filter(nchar(X1)<20) %>% distinct(X1,.keep_all = T)

save(Names_data_old, file = "Names_data_old.rda")


Names_data_old <- data.frame(en=Names_data_old$X1, year = Names_data_old$X2)

Names_data_old$hy <- Names_data_old$en %>% lapply( function(x) translate_Google(x, sourceLang="en", targetLang="hy") ) %>% unlist()
Names_data_old$ru <- Names_data_old$en %>% lapply( function(x) translate_Google(x, sourceLang="en", targetLang="ru") ) %>% unlist()

Names_data_old %>% writexl::write_xlsx("Names_data_old.xlsx")
