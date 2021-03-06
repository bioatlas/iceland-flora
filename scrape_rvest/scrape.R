# Ladda alla olika typer av växter
message("Starting to load plants...                                             (0 / 5)")
blommor_information <- get_information_from_subsite(main_site_url, blommor_subsite_url)
  
message("Loaded plants successfully, starting to load ferns...                  (1 / 5)")
ormbunkar_information <- get_information_from_subsite(main_site_url, ormbunkar_subsite_url)
  
message("Loaded ferns successfully, starting to load mosses...                  (2 / 5)")
mosor_information <- get_information_from_subsite(main_site_url, mosor_subsite_url)

message("Loaded mosses successfully, starting to load lichen...                 (3 / 5)")
lavar_information <- get_information_from_subsite(main_site_url, lavar_subsite_url)

message("Loaded lichen successfully, starting to load fungi...                  (4 / 5)")
svampar_information <- get_information_from_subsite(main_site_url, svampar_subsite_url)

message("Done loading from files or website.                                    (5 / 5)")

# Sätt ihop de olika växterna på höjden för att skapa en stor tibble som kan användas till darwins core

message("Starting to create taxon_core_tibble...                                (0 / 3)")
taxon_core_tibble <- bind_rows(
  blommor_information[1],
  ormbunkar_information[1],
  mosor_information[1],
  lavar_information[1],
  svampar_information[1]
  )

message("Taxon_core_tibble done, starting to create taxon_desc_tibble...        (1 / 3)")

taxon_desc_tibble <- bind_rows(
  blommor_information[2],
  ormbunkar_information[2],
  mosor_information[2],
  lavar_information[2],
  svampar_information[2]
)

message("Taxon_desc_tibble done, starting to create simple_multimedia_tibble... (2 / 3)")

simple_multimedia_tibble <- bind_rows(
  blommor_information[3],
  ormbunkar_information[3],
  mosor_information[3],
  lavar_information[3],
  svampar_information[3]
)

message("simple_multimedia_tibble done, starting to save files...               (3 / 3)")


# View(taxon_core_tibble)
# View(taxon_desc_tibble)
# View(simple_multimedia_tibble)

message("Saving results: savind taxon_core_tibble into file...                  (0 / 3)")

# Spara de tre tibblerna i tre olika filer
write_excel_csv(taxon_core_tibble, "data-raw/taxon_core.csv", na = "")

message("Saving results: savind taxon_desc_tibble into file...                  (1 / 3)")

write_excel_csv(taxon_desc_tibble, "data-raw/taxon_description.csv", na = "")

message("Saving results: savind simple_multiledia_tibble into file...           (2 / 3)")

write_excel_csv(simple_multimedia_tibble, "data-raw/simple_multimedia.csv", na = "")

message("Saving results, done saving all files.                                 (3 / 3)")

message("")

message("Done loading and saving data!")

message("")

message("Info: ")

message("The amount of species in the data: ", taxon_core_tibble[, 1] %>%
          unlist() %>% unname() %>% length())

message("The amount of images in the data: ", simple_multimedia_tibble[, 1] %>%
          unlist() %>% unname() %>% length())
