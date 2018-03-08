library(purrr)
library(tidyverse)
library(rvest)

get_rating <- function(html_object) {
  
  rating <- html_object %>% 
    html_nodes(".ratingValue strong span[itemprop=ratingValue]") %>%
    html_text() %>%
    as.numeric()
  
  return (rating)  
}

urls <- c("http://www.imdb.com/title/tt1490017/", 
          "http://www.imdb.com/title/tt4877122/?ref_=nv_sr_1", 
          "http://www.imdb.com/title/tt2096673/?ref_=nv_sr_1", 
          "http://www.imdb.com/title/tt2527336/?ref_=nv_sr_2"
          )

sites <- map(urls, read_html)

ratings <- map(sites, get_rating)

ratings






# TIBBLE TEST

one <- tibble(a = 1:10, b = letters[1:10])
two <- c(1:10)

bind_cols(one, c = two)

