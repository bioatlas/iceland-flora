# Få information från en sub-sida (t.ex. blommor, mosor, ormbunkar mm)
get_information_from_subsite <- function(site_url, subsite_url) {
  
  # Ladda den lokala hemsidan med alla blommor i en variabel
  flora_island_subsite <- read_html(paste0(site_url, subsite_url))
  
  # Spara alla html object som är växter ( <a href="typ_det_latinska_namnet.html">Namn på isländska</a> )
  vaxter <- flora_island_subsite %>%
    html_nodes("#left_col > a")
  
  # Undantag pga männskliga fel och vilken tag man måste lägga till på main_site_url innan bild_urlen för att hitta bilden
  bild_tag <- ""
  
  if (subsite_url == blommor_subsite_url) {
    # Undantag för blommor (Ej fungerande länk)
    vaxter <- vaxter[-99]
    
    bild_tag <- ""
    
  } else if (subsite_url == ormbunkar_subsite_url) {
    # Undantag för ormbunkar
    
    bild_tag <- "BURKNAR/"
    
  } else if (subsite_url == mosor_subsite_url) {
    # Undantag för mosor
    
    bild_tag <- "MOSAR/"
    
  } else if (subsite_url == lavar_subsite_url) {
    # Undantag för lavar
    vaxter <- vaxter[-155]
    
    bild_tag <- "FLETTUR/"
    
  } else if (subsite_url == svampar_subsite_url) {
    # Undantag för svampar
    
    bild_tag <- "SVEPPIR/"
    
  }
  
  # Spara alla islänska namn på blommorna
  vaxter_namn_is <- vaxter %>%
    html_text()
  
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
  bilder <- map2(loaded_html_sites, bild_tag, extract_images_possibly)
  
  # Läs in alla bild-texter till alla växter och bilder
  bild_texter <- map(loaded_html_sites, extract_image_desciptions_possibly)
  
  # Läs in all bröd-text till alla växter
  huvud_text <- map2(loaded_html_sites, subsite_url, extract_main_text_possibly) %>%
    unlist()
  
  # Korta ner de islandska namnen som bildades utan att ladda hemsidan om vi inte ska ladda alla
  if (only_load_the_n_firsts_species != -1) {
    vaxter_namn_is <- vaxter_namn_is[1:only_load_the_n_firsts_species]
  }
  
  namn_is_tibble <- tibble(page_url = urls, icelandic_name = vaxter_namn_is)
  namn_latin_tibble <- tibble(page_url = urls, latin_name = vaxter_namn_latin)
  
  image_url_tibble <- map_df(page_url = urls, img_url = bilder)
  image_desc_tibble <- map_df(page_url = urls, img_desc = bild_texter)
  
  desc_tibble <- tibble(page_url = urls, desc = huvud_text)
  
  # TODO: Create a big tibble that can be returned
  # TODO: Test if this works (it should)
  # TODO: Write the rest of the "scrape.R" file
}