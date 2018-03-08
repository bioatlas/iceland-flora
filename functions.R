# Få alla latinska namn från en växts sub-sida
extract_name_latin <- function(html_object) {
  res <- html_object %>%
    html_nodes("#page_content h2") %>%
    html_text() %>%
    cut_n_and_t() %>%
    fix_whitespace_size()
  
  return (res)
}

# Lägg till en "possibly" till "extract_name_latin" funktionen
extract_name_latin_possibly <- possibly(extract_name_latin, NA)


# Få alla bilder från en växts sub-sida
extract_images <- function(html_object, add_tag) {
  res <- html_object %>%
    html_nodes("#right_col > p > a[href]") %>%
    html_attr("href")
  
  res <- paste0(main_site_url, add_tag, res)
  
  return (res)
}

# Lägg till en "possibly" till "extract_images" funktionen
extract_images_possibly <- possibly(extract_images, NA)


# Få alla bild-beskrivningar/ bild-texter
extract_image_desciptions <- function(html_object) {
  res <- html_object %>%
    html_nodes("#right_col > p") %>%
    html_text() %>%
    clean_up_vector() %>%
    cut_par()
  
  if (is.na(res[1]) || is.na(res)) {
    res <- html_object %>%
      html_nodes("#right_col") %>%
      html_text() %>%
      clean_up_vector()
      cut_par()
  }
  
  if (is.na(res[1])) {
    print("Image desc is NA")
  }
  
  return (res)
}

# Lägg till en possibly till "extract_image_descriptions" funktionen
extract_image_desciptions_possibly <- possibly(extract_image_desciptions, NA)


# Få alla huvud-texter
extract_main_text <- function(html_object, subsite) {
  res <- html_object %>%
    html_nodes("#page_content > h2 + *") %>%
    html_text() %>%
    clean_up_vector()
  
  if (subsite == blommor_subsite_url) {
    more_text <- html_object %>%
      html_nodes("#page_content > span") %>%
      html_text() %>%
      clean_up_vector()
    
    res <- paste0(res, ". ", more_text) %>%
      fix_dots_and_spaces()
  } else if (subsite == ormbunkar_subsite_url) {
    res <- res %>%
      fix_dots_and_spaces()
  } else if (subsite == mosor_subsite_url) {
    res <- res %>%
      fix_dots_and_spaces()
  } else if (subsite == lavar_subsite_url) {
    res <- res %>%
      fix_dots_and_spaces()
  } else if (subsite == svampar_subsite_url) {
    more_text <- html_object %>%
      html_nodes("#page_content > p") %>%
      html_text() %>%
      clean_up_vector()
    
    res <- more_text %>%
      paste(collapse = " ") %>%
      fix_dots_and_spaces() %>%
      clean_up_vector()
  }
  
  return ("test")
  
  return (res)
}

# Lägg till en possibly till "extract_main_text" funktionen
extract_main_text_possibly <- possibly(extract_main_text, NA)

