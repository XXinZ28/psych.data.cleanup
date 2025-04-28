## code to prepare `religious_som` dataset goes here

religious_som_p <- readr::read_csv("dataforpackage.csv")

likert_scale_analyzer <- do.call(rbind, religious_som_p)
religious_som <- as.data.frame(likert_scale_analyzer)

usethis::use_data(religious_som, overwrite = TRUE)
