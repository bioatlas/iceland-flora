#browseURL("http://r-pkgs.had.co.nz/tests.html")

library(testthat)

source("flora_iceland.R")

test_that("can extract table of content links from thematic pages", {
  
  theme <- 
    paste0("http://www.floraislands.is/", c(
      "blom.html",
      "burknar.html",
      "mosar.html",
      "flettur.html",
      "sveppir.html"))
  
  res1 <- as.character(extract_toc_link(theme[1]))
  res2 <- as.character(extract_toc_link(theme[2]))
  res3 <- as.character(extract_toc_link(theme[3]))
  res4 <- as.character(extract_toc_link(theme[4]))
  res5 <- as.character(extract_toc_link(theme[5]))
  
  expect_equal(length(res1), 452)
  expect_equal(length(res2), 38)
  expect_equal(length(res3), 69)
  expect_equal(length(res4), 431)
  expect_equal(length(res5), 114)
    
})


test_that("can extract page urls from Icelandic Flora webpage", {
  
  res <- extract_page_urls()
  themes <- unique(res$theme)
  rowcount <- nrow(res)

  expect_equal(rowcount, 1102) 
  
  expect_equal(
    themes, 
    c("Plants", "Ferns", "Mosses", "Lichen", "Fungi")
  )
  
})