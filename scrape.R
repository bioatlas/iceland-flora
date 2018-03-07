scrape <- function() {
  blommor_information <- get_information_from_subsite(main_site_url, blommor_subsite_url)
  ormbunkar_information <- get_information_from_subsite(main_site_url, ormbunkar_subsite_url)
  mosor_information <- get_information_from_subsite(main_site_url, mosor_subsite_url)
  lavar_information <- get_information_from_subsite(main_site_url, lavar_subsite_url)
  svampar_information <- get_information_from_subsite(main_site_url, svampar_subsite_url)
  
  bio_information <- list(
    "blommor" = blommor_information,
    "ormbunkar" = ormbunkar_information,
    "mosor" = mosor_information,
    "lavar" = lavar_information,
    "svampar" = svampar_information
  )
}
