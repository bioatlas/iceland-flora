# is = isländska
#
# https://www.w3schools.com/cssref/css_selectors.asp

# Ladda bibliotek
library(rvest)
library(tidyverse)
library(purrr)

# Ladda filer
source(functions.R)
source(cleanup_functions.R)
source(main_function.R)
source(scrape.R)

# Set 'working directory' så att vi kan scrapa från våran lokala nedladning av hemsidan 
setwd("~/repos/iceland-flora/")




# Skapa de vaiablar som är globala
main_site_url <- "floraislands.is/"

# Use the downloaded version of the website or connect to the internet
use_actual_website <- TRUE

# För testning, ladda bara t.ex. de tio första växterna, (-1 == alla växter)
only_load_the_n_firsts_species <- -1

# De olika sidorna för olika växt-typer
blommor_subsite_url <- "blom.html"
ormbunkar_subsite_url <- "burknar.html"
mosor_subsite_url <- "mosar.html"
lavar_subsite_url <- "flettur.html"
svampar_subsite_url <- "sveppir.html"

# Ladda all data och skapa "bio_information" vaiablen
load_all_data <- FALSE

# Lägg till "http://www." i början av det vi ska ladda för att ansluta till 'the world wide web' om vi ska använda den riktiga hemsidan
if (use_actual_website) {
  main_site_url <- paste0("http://www.", main_site_url)
}  