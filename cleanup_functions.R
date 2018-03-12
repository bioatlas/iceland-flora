# Ta bort alla tomma bitar ur en vektor
cut_white_space <- function(vec) {
  vec <- str_trim(vec)
  
  vec <- vec[vec != ""]
  
  return (vec)
}


# Ta bort alla '\n' och alla '\t' ur en sträng
cut_n_and_t <- function(str) {
  str <- str %>%
    str_remove_all("\n") %>%
    str_remove_all("\t")
  
  return (str)
}


# Ta bort alla 'nbsp;' ur en sträng
cut_nbsp <- function(str) {
  str <- str %>%
    str_remove_all("nbsp;")
  
  return (str)
}

# Ta bort alla strängar som är för korta ur en vektor
cut_par <- function(vec) {
  vec <- vec[nchar(vec) > 9]
  
  return (vec)
}

# Lägg ihop vectorer baserat på mellanrum för att få en vector utan toma 
# vectorer och för att slippa använda jobbiga xpath selektorer för att få 
# flera stycken som en sträng
fix_image_desc_para <- function(img_desc) {
  newVec <- vector()
  
  currentStringBuildup <- ""
  for (n in 1:length(img_desc)) {
    if (str_trim(img_desc[n]) != "") {
      currentStringBuildup <- paste0(currentStringBuildup, img_desc[n])
    } else {
      newVec <- c(newVec, currentStringBuildup)
      currentStringBuildup <- ""
    }
  }
  
  if (currentStringBuildup != "") {
    newVec <- c(newVec, currentStringBuildup)
  }
  
  return (newVec)
}

# Sammla alla funktioner för att rensa i texten i en funktion för att förenkla koden senare
clean_up_vector <- function(vec) {
  new_vec <- vec %>%
    cut_n_and_t() %>%
    cut_white_space() %>%
    cut_nbsp()
  
  return (new_vec)
}

# Lägg till ett mellanslag efter alla punkter som inte har ett
add_space_after_dots <- function(str) {
  # remove all spaces after a dot and then add spaces for all dots
  str <- str %>%
    str_replace_all("\\. ", "\\.") %>%
    str_replace_all("\\.", "\\. ") %>%
    str_trim()
  
  return (str)
}

# Ta bort ".. " från en sträng
cut_dot_dot_space <- function(str) {
  str <- str %>%
    str_replace_all("\\.\\. ", "\\.")
  
  return (str)
}

# Förminska allt "whitespace" till ett mellanslag
fix_whitespace_size <- function(str) {
  str <- str %>%
    str_replace_all("\\s+", " ") %>%
    str_trim()
  
  return (str)
}

# Fixa allt med punkter och mellanslag
fix_dots_and_spaces <- function(str) {
  str <- str %>%
    cut_dot_dot_space() %>%
    add_space_after_dots() %>%
    fix_whitespace_size()
  
  return (str)
}