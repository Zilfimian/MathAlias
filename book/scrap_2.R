pacman::p_load(pdftools, pdftables, rpdfclown, dplyr, stringr)

tt = pdf_text("Dictionary of mathematics terms Douglas Downing.pdf")


clean_function <- function(x) { x%>% str_split(pattern = "\n") %>% 
    lapply(function(x){ str_trim(str_extract(x,"([:upper:]|[:space:]){4,}"))}) }


tt <- tt %>% lapply(function(x){clean_function(x)}) %>% unlist()

tt <- tt[nchar(tt)<54]
tt <- tt[nchar(tt)>2]

dictionary <- tt
dictionary[127:135] <- NA
dictionary <- dictionary[!is.na(dictionary)]
# cleaning again
dictionary <- str_remove_all(dictionary, pattern = "(\\s[:upper:])$")
dictionary <- tolower(dictionary)
dictionary <- str_to_title(dictionary)

source("Translation.R")

dictionary <- data.frame(en=dictionary)
dictionary$hy <- dictionary$en %>% lapply( function(x) translate_Google(x, sourceLang="en", targetLang="hy") ) %>% unlist()
dictionary$ru <- dictionary$en %>% lapply( function(x) translate_Google(x, sourceLang="en", targetLang="ru") ) %>% unlist()

dictionary %>% View()

dictionary_1 <- readxl::read_xlsx("dictionary_1.xlsx")

dictionary[!dictionary$en%in%dictionary_1$en,]%>% writexl::write_xlsx("dictionary_2.xlsx")

