pacman::p_load(pdftools, pdftables, rpdfclown, dplyr, stringr)

tt = pdf_text("astu14.pdf")

tt[1:4] <- ""
tt <- tt[nchar(tt)>2]

#tt1 <- tt[1] %>% str_split(pattern = "\n\n ") %>%  

clean_function <- function(x) { x %>% str_split(pattern = "\n\n ") %>% 
    lapply(function(x){ str_remove_all(str_remove_all(x,"\n?\\s?—\\s?(.\\s*)+"),pattern = "\\s{2,}")}) }


#tt_sub <- tt[1:5]

tt <- tt %>% lapply(function(x){clean_function(x)}) %>% unlist()

tt <- tt[nchar(tt)<54]


dictionary <- tt

# cleaning again
dictionary %>% View()
dictionary <- dictionary[!str_detect(dictionary, "[:digit:]+\n")]
dictionary <- dictionary[nchar(dictionary)>2]

source("Translation.R")

dictionary <- data.frame(ru=dictionary)
dictionary$hy <- dictionary$ru %>% lapply( function(x) translate_Google(x, sourceLang="ru", targetLang="hy") ) %>% unlist()
dictionary$en <- dictionary$ru %>% lapply( function(x) translate_Google(x, sourceLang="ru", targetLang="en") ) %>% unlist()

dictionary %>% View()
dictionary%>% writexl::write_xlsx("dictionary_1.xlsx")

