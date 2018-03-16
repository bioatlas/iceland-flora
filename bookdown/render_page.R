library(rmarkdown)
library(finch)

dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dir)

file.copy("~/repos/iceland-flora/scrape_rvest/DarwinCoreArchive/dwca-flora-iceland.zip", "~/repos/iceland-flora/bookdown/flora.zip")

render_page <- function() {
  rmarkdown::render("species_page.Rmd", params = list(
    dwca_path = "flora.zip"
  ))
}

print(as.list(body(dwca_read)))

# render_page()