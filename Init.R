# is = isländska
#
# https://www.w3schools.com/cssref/css_selectors.asp

# Ladda bibliotek
message("Loading libraries...")

library(rvest)
library(tidyverse)
library(purrr)
library(dplyr)

# Set 'working directory' så att vi kan scrapa från våran lokala nedladning av hemsidan 
# Linux
# setwd("~/repos/iceland-flora/")

# Windows
# setwd("D:/Code/R/RStudio/iceland-flora/")

# Universal
dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dir)

# Ladda filer
message("Done loading libraries, starting to load files...")

source("functions.R", encoding = "utf-8")
source("cleanup_functions.R", encoding = "utf-8")
source("main_function.R", encoding = "utf-8")
source("scrape.R", encoding = "utf-8")



# Skapa de vaiablar som är globala
message("Done loading files, starting to set global vaiables...")

main_site_url <- "floraislands.is/"

# Use the downloaded version of the website or connect to the internet
use_actual_website <- FALSE

# För testning, ladda bara t.ex. de tio första växterna, (-1 == alla växter på varje sida)
only_load_the_n_firsts_species <- -1

# De olika sidorna för olika växt-typer
blommor_subsite_url <- "blom.html"
ormbunkar_subsite_url <- "burknar.html"
mosor_subsite_url <- "mosar.html"
lavar_subsite_url <- "flettur.html"
svampar_subsite_url <- "sveppir.html"

# Lägg till "http://www." i början av det vi ska ladda för att ansluta till 'the world wide web' om vi ska använda den riktiga hemsidan
if (use_actual_website) {
  main_site_url <- paste0("http://www.", main_site_url)
}

# Kör koden för att skrapa hemsidan
message("Done setting global vaiables, running code:")

scrape()
