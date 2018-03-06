library(rvest)

# Store web url
lego_movie <- read_html("http://www.imdb.com/title/tt1490017/")

#Scrape the website for the movie rating
rating <- lego_movie %>% 
  html_nodes(".ratingValue strong span[itemprop=ratingValue]") %>%
  html_text() %>%
  as.numeric()
rating

#Scrape the website for the cast
cast <- lego_movie %>%
  html_nodes("#titleCast .itemprop span[itemprop=name]") %>%
  html_text()
cast

#Scrape the webstie for the movie poster url
poster <- lego_movie %>%
  html_nodes(".poster img") %>%
  html_attr("src")
poster