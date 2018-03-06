# Ladda bibliotek --------------------------------------------------------------------------------------------------------------------
library(rvest)
library(tidyverse)
library(purrr)

setwd("~/repos/iceland-flora/")

# is = isländska

# https://www.w3schools.com/cssref/css_selectors.asp

# Definiera de variablar som är globala och används på flera ställen

main_site_url <- "http://www.floraislands.is/"

blommor_subsite_url <- "blom.html"
ormbunkar_subsite_url <- "burknar.html"
mosor_subsite_url <- "mosar.html"
lavar_subsite_url <- "flettur.html"
svampar_subsite_url <- "sveppir.html"

load_all_data <- FALSE

# Funktions definiering --------------------------------------------------------------------------------------------------------------

# Få alla latinska namn från en växts sub-sida ------------------------------
extract_name_latin <- function(url) {
  res <- url %>%
    read_html() %>%
    html_nodes("#page_content h2") %>%
    html_text() %>%
    str_remove_all("\n\t\t")
  
  return (res)
}

# Lägg till en "possibly" till "extract_name_latin" funktionen
extract_name_latin_possibly <- possibly(extract_name_latin, NA)


# Få alla bilder från en växts sub-sida ------------------------------
extract_images <- function(url) {
  res <- url %>%
    read_html() %>%
    html_nodes("#right_col > p > a[href]") %>%
    html_attr("href")
  
  return (res)
}

# Lägg till en "possibly" till "extract_images" funktionen
extract_images_possibly <- possibly(extract_images, NA)

# Få alla bild-beskrivningar/ bild-texter ------------------------------
extract_image_desciptions <- function(url) {
  res <- url %>%
    read_html() %>%
    html_nodes("#right_col > p") %>%
    html_text() %>%
    str_remove_all("\n") %>%
    str_remove_all("\t") %>%
    str_trim()
  
  res <- res[res != ""]

  return (res)
}

# Lägg till en possibly till "extract_image_descriptions" funktionen
extract_image_desciptions_possibly <- possibly(extract_image_desciptions, NA)


# Få information från en sub-sida (t.ex. blommor, mosor, ormbunkar mm)
get_information_from_subsite <- function(site_url, subsite_url) {
  
  # Ladda den lokala hemsidan med alla blommor i en variabel
  flora_island_subsite <- read_html(paste0(site_url, subsite_url))
  
  # Spara alla html object som är blommor ( <a href="typ_det_latinska_namnet.html">Namn på isländska</a> )
  vaxter <- flora_island_subsite %>%
    html_nodes("#left_col > a")
  
  # Undantag pga männskliga fel och vilken typ av växt det är
  if (subsite_url == blommor_subsite_url) {
    # Undantag för blommor (Ej fungerande länk)
    vaxter <- vaxter[-99]
    
  } else if (subsite_url == ormbunkar_subsite_url) {
    # Undantag för ormbunkar
    
  } else if (subsite_url == mosor_subsite_url) {
    # Undantag för mosor
    
  } else if (subsite_url == lavar_subsite_url) {
    # Undantag för lavar
    vaxter <- vaxter[-155]
    
  } else if (subsite_url == svampar_subsite_url) {
    # Undantag för svampar
    
  }
  
  # Spara alla islänska namn på blommorna
  vaxter_namn_is <- vaxter %>%
    html_text()
  
  # Spara alla html_länkar
  vaxter_html <- vaxter %>%
    html_attr("href")
  
  # Fixa mänskliga misstag (Läbken hade en "name" attr istället för en "href" attr)
  idx <- which(is.na(vaxter_html))
  vaxter_html[idx] <- vaxter[idx] %>% html_attr("name")
  
  # Lägg till huvudhemsidan till html länkarna
  urls <- paste0(site_url, vaxter_html)
  
  # Läs in alla latinska namn
  vaxter_namn_latin <- map_chr(urls, extract_name_latin_possibly)
  
  # Läs in alla bilder
  bilder <- map(urls, extract_images_possibly)
  
  # Läs in alla bild-texter
  bild_texter <- map(urls, extract_image_desciptions_possibly)
  
  return (list("latinska_namn" = vaxter_namn_latin, "islandska_namn" = vaxter_namn_is, "bilder" = bilder, "bild_texter" = bild_texter))
}

# Börja ladda hemsidan ---------------------------------------------------------------------------------------------------------------

if (load_all_data) {
  blommor_information <- get_information_from_subsite(main_site_url, blommor_subsite_url)
  ormbunkar_information <- get_information_from_subsite(main_site_url, ormbunkar_subsite_url)
  mosor_information <- get_information_from_subsite(main_site_url, mosor_subsite_url)
  lavar_information <- get_information_from_subsite(main_site_url, lavar_subsite_url)
  svampar_information <- get_information_from_subsite(main_site_url, svampar_subsite_url)
  
  bio_information <- list(
    "blommor" = blommor_information,
    "ormbunkar" = ormbunkar_information,
    "mosor" = mosor_information,
    "lavar" = lavar_information,
    "svampar" = svampar_information
  )
}


# get("latinska_namn", get("blommor", bio_information))


# Test and debugging code ------------------------------------------------------------------------------------------------------------


# test_information <- get_information_from_subsite(main_site_url, blommor_subsite_url)
test_information <- get_information_from_subsite(main_site_url, ormbunkar_subsite_url)
# test_information <- get_information_from_subsite(main_site_url, mosor_subsite_url)
# test_information <- get_information_from_subsite(main_site_url, lavar_subsite_url)
# test_information <- get_information_from_subsite(main_site_url, svampar_subsite_url)

# Skriv ut alla latinska namn från subsidan som precis testades
# " ---------------------------------------- Latinska Namn ---------------------------------------- "

# get("latinska_namn", test_information)

# Testa efter ej-fungerande sidor (latinska namn som är NA pga att deras sida inte kunda laddas in)
# which(is.na(get("latinska_namn", test_information)))

# Skriv ut alla isländska namn från subsidan som precis testades
# " ---------------------------------------- Islandska Namn ---------------------------------------- "

# get("islandska_namn", test_information)

# " ---------------------------------------- Bilder ---------------------------------------- "
# get("bilder", test_information)

" ---------------------------------------- Bildtexter ---------------------------------------- "
get("bild_texter", test_information)


