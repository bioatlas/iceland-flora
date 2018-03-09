# Få information från en sub-sida (t.ex. blommor, mosor, ormbunkar mm)
get_information_from_subsite <- function(site_url, subsite_url) {
  # site_url <- main_site_url
  # subsite_url <- blommor_subsite_url
  
  # Ladda den lokala hemsidan med alla blommor i en variabel
  flora_island_subsite <- read_html(paste0(site_url, subsite_url))
  
  # Spara alla html object som är växter ( <a href="typ_det_latinska_namnet.html">Namn på isländska</a> )
  vaxter <- flora_island_subsite %>%
    html_nodes("#left_col > a")
  
  # Undantag pga männskliga fel och vilken tag man måste lägga till på main_site_url innan bild_urlen för att hitta bilden
  bild_tag <- ""
  theme_str <- ""
  
  if (subsite_url == blommor_subsite_url) {
    # Undantag för blommor (Ej fungerande länk)
    vaxter <- vaxter[-99]
    
    bild_tag <- ""
    theme_str <- "Plants"
    
  } else if (subsite_url == ormbunkar_subsite_url) {
    # Undantag för ormbunkar
    
    bild_tag <- "BURKNAR/"
    theme_str <- "Ferns"
    
  } else if (subsite_url == mosor_subsite_url) {
    # Undantag för mosor
    
    bild_tag <- "MOSAR/"
    theme_str <- "Mosses"
    
  } else if (subsite_url == lavar_subsite_url) {
    # Undantag för lavar
    vaxter <- vaxter[-155]
    
    vaxter <- vaxter[2:length(vaxter)]
    
    bild_tag <- "FLETTUR/"
    theme_str <- "Lichen"
    
  } else if (subsite_url == svampar_subsite_url) {
    # Undantag för svampar
    
    bild_tag <- "SVEPPIR/"
    theme_str <- "Fungi"
    
  }
  
  # Spara alla islänska namn på blommorna
  vaxter_namn_is <- vaxter %>%
    html_text() %>%
    fix_whitespace_size()
  
  # Spara alla html_länkar
  vaxter_html <- vaxter %>%
    html_attr("href")
  
  # Fixa mänskliga misstag (Läbken hade en "name" attr istället för en "href" attr)
  idx <- which(is.na(vaxter_html))
  vaxter_html[idx] <- vaxter[idx] %>%
    html_attr("name")
  
  # Lägg till huvudhemsidan till html länkarna så att vi kan ladda hemsidan
  urls <- paste0(site_url, vaxter_html)
  
  # Om vi bara ska ladda in några växter, korta ner de url:er vi ska använda
  if (only_load_the_n_firsts_species != -1) {
    urls <- urls[1:only_load_the_n_firsts_species]
  }
  
  # Ladda alla sidor så att vi slipper ladda de individuellt för varje egenskap (namn på latin, bilder, bild-texter mm)
  loaded_html_sites <- map(urls, read_html)
  
  # Läs in alla latinska namn till alla växter
  vaxter_namn_latin <- map_chr(loaded_html_sites, extract_name_latin_possibly)
  
  # Läs in alla bilder till alla växter
  image_urls <- map2(loaded_html_sites, bild_tag, extract_images_possibly)
  
  image_desc <- map(loaded_html_sites, extract_image_desciptions_possibly)
  
  image_tibble <- tibble(page_url = urls[1], img_url = unlist(image_urls[1]), img_desc = unlist(image_desc[1]))
  
  for (n in 2:length(image_urls)) {
    # if (length(unlist(urls[n])) != length(unlist(image_urls[n]))) {
    #   print("Error : length of page_url and image_urls")
    #   print(length(unlist(urls[n])))
    #   print(length(unlist(image_urls[n])))
    #   print(unlist(urls[n]))
    # }
    image_tibble <- image_tibble %>%
      bind_rows(tibble(page_url = urls[n], img_url = unlist(image_urls[n]), img_desc = unlist(image_desc[n])))
  }
    
  # Läs in all bröd-text till alla växter
  huvud_text <- map2(loaded_html_sites, subsite_url, extract_main_text_possibly) %>%
    unlist()
  
  # Korta ner de islandska namnen som bildades utan att ladda hemsidan om vi inte ska ladda alla
  if (only_load_the_n_firsts_species != -1) {
    vaxter_namn_is <- vaxter_namn_is[1:only_load_the_n_firsts_species]
  }
  
  desc_tibble <- tibble(page_url = urls, desc = huvud_text)
  
  taxon_core_tibble <- tibble(theme = theme_str, page_url = urls, latin_name = vaxter_namn_latin, icelandic_name = vaxter_namn_is)
  
  taxon_desc_tibble <- desc_tibble
  
  simple_multimedia_tibble <- image_tibble
  
  return (list(taxon_core_tibble, taxon_desc_tibble, simple_multimedia_tibble))
}