# Få alla latinska namn från en växts sub-sida
extract_name_latin <- function(html_object) {
  res <- html_object %>%
    html_nodes("#page_content > h2") %>%
    html_text() %>%
    cut_n_and_t() %>%
    fix_whitespace_size()
  
  return (res)
}

# Lägg till en "possibly" till "extract_name_latin" funktionen
extract_name_latin_possibly <- possibly(extract_name_latin, NA)

# Ladda in det isländska namnet
extract_name_is <- function(html_object) {
  res <- html_object %>%
    html_nodes("#page_content > h1") %>%
    html_text() %>%
    cut_n_and_t() %>%
    fix_whitespace_size()
  
  return (res)
}

# Lägg till en "possibly" till "extract_name_is" funktionen
extract_name_is_possibly <- possibly(extract_name_is, NA)

# Få alla bilder från en växts sub-sida
extract_images <- function(html_object, add_tag) {
  res <- html_object %>%
    html_nodes("#right_col > p > a[href]") %>%
    html_attr("href")
  
  more_images <- html_object %>%
    html_nodes("#right_col > p > font > a[href]") %>%
    html_attr("href")
  
  more_images2 <- html_object %>%
    html_nodes("#right_col > p > img") %>%
    html_attr("src")
  
  more_images3 <- html_object %>%
    html_nodes("#right_col > a[href]") %>%
    html_attr("href")
  
  more_images4 <- html_object %>%
    html_nodes("#right_col > img") %>%
    html_attr("src")
  
  if (!is.na(more_images[1])) {
    res <- c(res, unlist(more_images)) %>%
      unique()
  }
  if (!is.na(more_images2[1])) {
    res <- c(res, unlist(more_images2)) %>%
      unique()
  }
  if (!is.na(more_images3[1])) {
    res <- c(res, unlist(more_images3)) %>%
      unique()
  }
  if (!is.na(more_images4[1])) {
    res <- c(res, unlist(more_images4)) %>%
      unique()
  }
  
  res <- paste0(main_site_url, add_tag, res)
  
  return (res)
}

# Lägg till en "possibly" till "extract_images" funktionen
extract_images_possibly <- possibly(extract_images, NA)

# Få alla bild-beskrivningar/ bild-texter
extract_image_desciptions <- function(html_object) {
  res <- html_object %>%
    html_nodes("#right_col > p") %>%
    html_text()

  return (res)
}

# Lägg till en possibly till "extract_image_descriptions" funktionen
extract_image_desciptions_possibly <- possibly(extract_image_desciptions, NA)


# Få alla huvud-texter
extract_main_text <- function(html_object, subsite) {
  title_is <- html_object %>%
    html_nodes("#page_content > h1") %>%
    html_text()

  title_la <- html_object %>%
    html_nodes("#page_content > h2") %>%
    html_text()
  
  res <- html_object %>%
    html_nodes("#page_content") %>%
    html_text() %>%
    paste(collapse = " ") %>%
    str_remove(title_la) %>%
    str_remove(title_is) %>%
    clean_up_vector() %>%
    fix_dots_and_spaces()
  
  return (res)
}

# Lägg till en possibly till "extract_main_text" funktionen
extract_main_text_possibly <- possibly(extract_main_text, NA)

