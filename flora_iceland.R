library(rvest)
library(tidyverse)

# https://www.w3schools.com/cssref/css_selectors.asp
# is = isländska

extract_toc_link <- function(url) {
  read_html(url) %>% html_nodes("#left_col > a")
}

extract_page_urls <- function() {
  
  theme <- 
    paste0("http://www.floraislands.is/", c(
      "blom.html",
      "burknar.html",
      "mosar.html",
      "flettur.html",
      "sveppir.html"))
  
  blom <- extract_toc_link(theme[1])
  burknar <- extract_toc_link(theme[2])
  mosar <- extract_toc_link(theme[3])
  flettur <- extract_toc_link(theme[4])
  sveppir <- extract_toc_link(theme[5])

  # fix exceptions due to 404 etc
  flettur <- flettur[-c(155)]
  blom <- blom[-c(99)]
  
  # fix missing href attribute
  idx <- which(is.na(blom %>% html_attr("href")))
  href <- blom[idx] %>% html_attr("name")
  xml_set_attr(blom[idx], "href", href)
  
  urls_df <- function(theme_label, theme_xml) {
    icelandic_name <- theme_xml %>% html_text()
    page <- theme_xml %>% html_attr("href")
    url <- paste0("http://www.floraislands.is/", page)
    tibble(theme = theme_label, url, icelandic_name)
  }
  
  res <- bind_rows(
    urls_df("Plants", blom),
    urls_df("Ferns", burknar),
    urls_df("Mosses", mosar),
    urls_df("Lichen", flettur),
    urls_df("Fungi", sveppir)
  )
  
  return(res)
}

extract_name_latin <- function(url) {
  url %>%
  read_html() %>%
  html_nodes("#page_content h2") %>%
  html_text() %>%
  str_replace_all("\n\t\t", "")
}

extract_images <- function(url) {
  
  images <- 
    url %>% read_html() %>%
    html_nodes("#right_col > p > a[href]") %>%
    html_attr("href")

  img_urls = paste0("http://www.floraislands.is/", images)
  
  tibble(page_url = url, img_urls)
  
}

extract_image_descriptions <- function(url) {
  
  desc <- url %>% read_html() %>%
    html_nodes("#right_col > p") %>%
    html_text() %>%
    str_replace_all("\n", "") %>%
    str_replace_all("\t", "") %>%
    str_trim()
  
  desc <- desc[desc != ""]
  
  tibble(page_url = url, img_desc = desc)
  
}

extract_main_text <- function(url) {
  
  profile <- url %>% read_html() %>%
    html_nodes("#page_content") %>%
    html_text()
    
  tibble(page_url = url, profile_text = profile)
}

extract_main_text_xpath <- function(url) {
  # TODO fix this, and write a test
  # https://stackoverflow.com/questions/18871618/xpath-to-select-between-two-html-comments
  beg <- "Texti"
  #beg <- "#BeginEditable \"Texti\""
  end <- "#EndEditable"
  xpath_expr <- paste0("//node()[@id='page_content']",
    "[following::comment()[contains(., '", beg, "')]]",
    "[preceding::comment()[contains(., '", end, "')]]"
  )
  
  url %>% 
  read_html() %>%
  html_nodes(xpath = xpath_expr) %>%
  html_text()
  
}


