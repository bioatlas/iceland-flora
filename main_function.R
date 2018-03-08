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
    
    vaxter <- vaxter[2:length(vaxter)]
    
    bild_tag <- "FLETTUR/"
    
  } else if (subsite_url == svampar_subsite_url) {
    # Undantag för svampar
    
    bild_tag <- "SVEPPIR/"
    
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
  image_url_tibble <- pmap_df(
    list(loaded_html_sites, bild_tag, urls), 
    extract_images_possibly)
  
  # Läs in alla bild-texter till alla växter och bilder
  image_desc_tibble <- map2_df(loaded_html_sites, urls, extract_image_desciptions_possibly)
  
  # Läs in all bröd-text till alla växter
  huvud_text <- map2(loaded_html_sites, subsite_url, extract_main_text_possibly) %>%
    unlist()
  
  # Korta ner de islandska namnen som bildades utan att ladda hemsidan om vi inte ska ladda alla
  if (only_load_the_n_firsts_species != -1) {
    vaxter_namn_is <- vaxter_namn_is[1:only_load_the_n_firsts_species]
  }
  
  name_is_tibble <- tibble(page_url = urls, icelandic_name = vaxter_namn_is)
  name_latin_tibble <- tibble(page_url = urls, latin_name = vaxter_namn_latin)
  
  desc_tibble <- tibble(page_url = urls, desc = huvud_text)
  
  # Skapa de stora tibblarna
  taxon_core_tibble <- left_join(name_latin_tibble, name_is_tibble, by = "page_url")
  
  taxon_desc_tibble <- desc_tibble
  
  simple_multimedia_tibble <- left_join(image_url_tibble, image_desc_tibble)
  
  return (list(taxon_core_tibble, taxon_desc_tibble, simple_multimedia_tibble))
}