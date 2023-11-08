pacman::p_load(pdftools, pdftables, rpdfclown)

tt = pdf_text("astu14.pdf")

tt[1:4] <- ""
tt <- tt[nchar(tt)>2]

#tt1 <- tt[1] %>% str_split(pattern = "\n\n ") %>%  

clean_function <- function(x) { x %>% str_split(pattern = "\n\n ") %>% 
  lapply(function(x){ str_remove_all(str_remove_all(x,"(\n| )—(\\s?.\\s*)+"),pattern = "\\s{2,}")}) }
  

tt_sub <- tt[1:5]

tt_sub %>% lapply(function(x){clean_function(x)}) %>% unlist()



dictionary <- tt_sub