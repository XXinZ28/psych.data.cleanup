## code to prepare `religious_som` dataset goes here

religious_som <- readr::read_csv("dataforpackage.csv")
usethis::use_data(religious_som, overwrite = TRUE)
