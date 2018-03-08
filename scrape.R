# Funktion som blir kallad i Init.R för att köra programmet när alla bibliotek har blivit laddade och alla variablar har blivit sätta
scrape <- function() {
  # Ladda alla olika typer av växter
  blommor_information <- get_information_from_subsite(main_site_url, blommor_subsite_url)
  ormbunkar_information <- get_information_from_subsite(main_site_url, ormbunkar_subsite_url)
  mosor_information <- get_information_from_subsite(main_site_url, mosor_subsite_url)
  lavar_information <- get_information_from_subsite(main_site_url, lavar_subsite_url)
  svampar_information <- get_information_from_subsite(main_site_url, svampar_subsite_url)

  # Sätt ihop de olika växterna på höjden för att skapa en stor tibble som kan användas till darwins core
  taxon_core_tibble <- bind_rows(
    blommor_information[1],
    ormbunkar_information[1],
    mosor_information[1],
    lavar_information[1],
    svampar_information[1]
    )

  taxon_desc_tibble <- bind_rows(
    blommor_information[2],
    ormbunkar_information[2],
    mosor_information[2],
    lavar_information[2],
    svampar_information[2]
  )

  simple_multimedia_tibble <- bind_rows(
    blommor_information[3],
    ormbunkar_information[3],
    mosor_information[3],
    lavar_information[3],
    svampar_information[3]
  )

  View(taxon_core_tibble)
  View(taxon_desc_tibble)
  View(simple_multimedia_tibble)

  # Spara de tre tibblerna i tre olika filer
  # write_excel_csv(taxon_core_tibble, "taxon_core_tibble.csv")
  # write_excel_csv(taxon_desc_tibble, "taxon_desc_tibble.csv")
  # write_excel_csv(simple_multimedia_tibble, "simple_multimedia_tibble.csv")
}
