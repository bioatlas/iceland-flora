

# Definiera de variablar som är globala och används på flera ställen -----------------------------------------------------------------



# Börja ladda hemsidan ---------------------------------------------------------------------------------------------------------------




# get("bild_texter", get("blommor", bio_information))


# Test and debugging code ------------------------------------------------------------------------------------------------------------


test_information <- get_information_from_subsite(main_site_url, blommor_subsite_url)
# test_information <- get_information_from_subsite(main_site_url, ormbunkar_subsite_url)
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

# Skriv ut alla länkar till bilderna
" ---------------------------------------- Bilder ---------------------------------------- "
get("bilder", test_information)

# Skriv ut alla bild-texter
# " ---------------------------------------- Bildtexter ---------------------------------------- "
# get("bild_texter", test_information)

# Skriv ut de stora bitarna text på varje sida
# " ---------------------------------------- Huvudtext ---------------------------------------- "
# get("huvud_text", test_information)










