# see section Code style
#browseURL("http://r-pkgs.had.co.nz/r.html")

#library(lintr)
#lint("flora_iceland.R")

# setwd("~/repos/iceland-flora/")

source("flora_iceland.R")

pages_df <- extract_page_urls()
page_subset <- pages_df %>% slice(1:10) %>% rename(page_url = url)
urls <- page_subset$page_url
  
latin_names <- map_chr(urls, possibly(extract_name_latin, NA))
latin <- tibble(page_url = urls, latin_names)

images <- map_df(urls, possibly(extract_images, NA))
image_labels <- map_df(urls, possibly(extract_image_descriptions, NA))
desc <- map_df(urls, possibly(extract_main_text, NA))

df <- 
  page_subset %>% 
  left_join(latin) %>%
  left_join(desc)

images_df <- 
  page_subset %>%
  left_join(images) %>%
  left_join(image_labels)

# inspect values
df$profile_text
images_df$img_urls

# output to file
write_excel_csv(df, "iceland-flora.csv")

View(df)
