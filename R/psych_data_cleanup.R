#' @title Use the xkcd API
#' @description
#' Given a comic number, the `xkcd()` function calls the xkcd JSON API and returns metadata about the comic in the form of a list object.
#'
#' @importFrom jsonlite read_json
#' @export
#'
# psych_data_cleanup <- function(number) {
# """
#   placeholder
# """
#   url <- file.path("https://xkcd.com", floor(number), "info.0.json")
#   x <- jsonlite::read_json(url)
#   return(x)
# }
# xinxin:line before 30












































































































test_df <- read.csv("dataforpackage.csv")

numeric_check <- function(x) {
  column_names <- colnames(x)

  for (i in column_names) {
    if (is.numeric(x[[i]])) {
      cat("This column: ", i, "is numeric.\n")
    } else if (is.character(x[[i]])) {
      cat("This column: ", i, "is of character type.\n")
    } else {
      print("This column: ", i, "is of some other type.\n" )
    }
  }
}

numeric_check(test_df)

na_check <- function(x) {
  x[x == ""] <- NA
  return(x)
}

na_check_df <- function(x) {
  x[] <- lapply(x, na_check)
  return(x)
}

na_check_df(test_df)

cat_check <- function(x) {
  column_names <- colnames(x)

  for (i in column_names) {
    if (is.numeric(x[[i]])) {
      max_bound <- max(x[[i]])
      lower_bound <- min(x[[i]])
    } else {
      stop("This column is not of numeric type.")
    }
  }
}

cat_check(test_df)


