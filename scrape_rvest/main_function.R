# Få information från en sub-sida (t.ex. blommor, mosor, ormbunkar mm)
get_information_from_subsite <- function(site_url, subsite_url) {
  # Tester om man inte gör funktionen men behöver de variablarna
  # site_url <- main_site_url
  # subsite_url <- ormbunkar_subsite_url
  
  # Ladda den lokala hemsidan med alla blommor i en variabel
  flora_island_subsite <- read_html(paste0(site_url, subsite_url), encoding = "utf-8")
  
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
    # Plants (blommor)
    theme_str <- "Flowering plants"
    
  } else if (subsite_url == ormbunkar_subsite_url) {
    # Undantag för ormbunkar
    
    bild_tag <- "BURKNAR/"
    # Ferns (ormbunkar)
    theme_str <- "Ferns"
    
  } else if (subsite_url == mosor_subsite_url) {
    # Undantag för mosor
    
    bild_tag <- "MOSAR/"
    # Mosses (mosor)
    theme_str <- "Mosses"
    
  } else if (subsite_url == lavar_subsite_url) {
    # Undantag för lavar
    vaxter <- vaxter[-155]
    
    bild_tag <- "FLETTUR/"
    # Lichen (lavar)
    theme_str <- "Lichens"
    
  } else if (subsite_url == svampar_subsite_url) {
    # Undantag för svampar
    
    bild_tag <- "SVEPPIR/"
    # Fungi (svampar)
    theme_str <- "Fungi"
  }
  
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
  
  print(theme_str)
  
  if (print_exceptions) {
    urls_save <- urls
    
    urls <- urls[duplicated(urls)]
    
    dup_names <- list()
    
    for (n in 1:length(vaxter_html)) {
      if (paste0(site_url, vaxter_html[n]) %in% urls) {
        if (exists(paste0(site_url, vaxter_html[n]), where = dup_names)) {
          dup_names[paste0(site_url, vaxter_html[n])] <- list(c(unlist(dup_names[paste0(site_url, vaxter_html[n])]), html_text(vaxter[n])))
        } else {
          dup_names[paste0(site_url, vaxter_html[n])] <- list(html_text(vaxter[n]))
        }
      }
    }
    
    print(dup_names)
    
    urls <- urls_save
  }
  
  # Ta bort kopior av länkar (Flera namn till samma växt som pekar på samma html sida)
  urls <- urls %>%
    unique()
  
  # TEST: för att testa en speciel sida med bilder eller något annat
  # urls <- "http://floraislands.is/listeova.html"
  
  # Ladda alla sidor så att vi slipper ladda de individuellt för varje egenskap (namn på latin, bilder, bild-texter mm)
  loaded_html_sites <- map(urls, function(x) read_html(x, encoding = "utf-8"))
  
  # Lägg till "http://www." för att de ska vara fulla länkar om de inte redan är det
  if (!use_actual_website) {
    urls <- paste0("http://www.", urls)
  }
  
  # Läs in alla latinska namn till alla växter
  vaxter_namn_latin <- map_chr(loaded_html_sites, extract_name_latin_possibly)
  
  # Läs in alla isländska namn till alla växter
  vaxter_namn_is <- map_chr(loaded_html_sites, extract_name_is_possibly)
  
  # Läs in alla bilder till alla växter
  image_urls <- pmap(list(loaded_html_sites, bild_tag, urls), extract_images_possibly)
  
  image_desc <- map(loaded_html_sites, extract_image_desciptions_possibly)
  
  test_desc <- image_desc[1] %>%
    unlist() %>%
    clean_up_vector() %>%
    fix_dots_and_spaces() %>%
    cut_par()
  
  length_dif <- length(unlist(image_urls[1])) - length(unlist(test_desc))
  
  if (length_dif > 0) {
    image_desc[1] <- list(c(unlist(test_desc), unlist(rep(NA, length_dif))))
  } else if (length_dif < 0) {
    image_desc[1] <- image_desc[1] %>%
      unlist() %>%
      fix_image_desc_para() %>%
      clean_up_vector() %>%
      fix_dots_and_spaces() %>%
      cut_par() %>%
      list()
    if (print_exceptions) {
      print(paste0("Some image(s) on this page have their description on multiple <p> objects: ", urls[n]))
    }
  } else {
    image_desc[1] <- test_desc %>%
      list()
  }
  
  if (!use_actual_website) {
    image_urls[1] = list(paste0("http://www.", unlist(image_urls[1])))
  }
  
  image_tibble <- tibble(page_url = urls[1], img_url = unlist(image_urls[1]), img_desc = unlist(image_desc[1]))
  
  if (length(image_urls) >= 2) {
    for (n in 2:length(image_urls)) {
      test_desc <- image_desc[n] %>%
        unlist() %>%
        clean_up_vector() %>%
        fix_dots_and_spaces() %>%
        cut_par()
    
      length_dif <- length(unlist(image_urls[n])) - length(unlist(test_desc))
    
      if (length_dif > 0) {
        image_desc[n] <- list(c(unlist(test_desc), unlist(rep(NA, length_dif))))
      } else if (length_dif < 0) {
        image_desc[n] <- image_desc[n] %>%
          unlist() %>%
          fix_image_desc_para() %>%
          clean_up_vector() %>%
          fix_dots_and_spaces() %>%
          cut_par() %>%
          list()
        if (print_exceptions) {
          print(paste0("Some image(s) on this page have their description on multiple <p> objects: ", urls[n]))
        }
      } else {
        image_desc[n] <- test_desc %>%
          list()
      }
      
      if (length(unlist(image_urls[n])) != length(unlist(image_desc[n]))) {
        message("Error : length of image_urls and image_desc do not match!")
        message(paste0("    Length of image_urls: ", length(unlist(image_urls[n]))))
        message(paste0("    Length of image_desc: ", length(unlist(image_desc[n]))))
        message(paste0("    Site url: ", unlist(urls[n])))
      }
      
      if (!use_actual_website) {
        image_urls[n] = list(paste0("http://www.", unlist(image_urls[n])))
      }
      
      image_tibble <- image_tibble %>%
        bind_rows(tibble(page_url = urls[n], img_url = paste0("http://www.", unlist(image_urls[n])), img_desc = unlist(image_desc[n])))
    }
  }
  
  # Ta bort de rader på växter som inte har några bilder
  image_tibble <- image_tibble %>%
    filter(img_url != main_site_url)
    
  # Läs in all bröd-text till alla växter
  huvud_text <- map2(loaded_html_sites, subsite_url, extract_main_text_possibly) %>%
    unlist()
  
  # Korta ner de islandska namnen som bildades utan att ladda hemsidan om vi inte ska ladda alla
  if (only_load_the_n_firsts_species != -1) {
    vaxter_namn_is <- vaxter_namn_is[1:only_load_the_n_firsts_species]
  }
  
  taxon_core_tibble <- tibble(theme = theme_str, page_url = urls, latin_name = vaxter_namn_latin, icelandic_name = vaxter_namn_is)
  
  taxon_desc_tibble <- tibble(page_url = urls, desc = huvud_text)
  
  simple_multimedia_tibble <- image_tibble
  
  # Byt namn på de olika columnerna för att de ska passa i darwin core
  taxon_core_tibble <- taxon_core_tibble %>%
    rename(scientificName = latin_name, vernacularName = icelandic_name, taxonRemarks = theme, taxonID = page_url) %>%
    mutate(language = "is")
  
  taxon_desc_tibble <- taxon_desc_tibble %>%
    rename(description = desc, taxonID = page_url) %>%
    mutate(type = "distribution", creator = "Hörður Kristinsson", language = "is", license = "Unknown")
   # LICENSE --------------------
  
  simple_multimedia_tibble <- simple_multimedia_tibble %>%
    rename(identifier = img_url, description = img_desc, taxonID = page_url) %>%
    mutate(creator = "Hörður Kristinsson", license = "Unknown", type = "StillImage", format = "image/jpg", language = "is")
  # LICENSE --------------------
  
  return (list(taxon_core_tibble, taxon_desc_tibble, simple_multimedia_tibble))
}