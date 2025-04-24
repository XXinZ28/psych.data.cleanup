#' @title Use the xkcd API
#' @description
#' Given a comic number, the `xkcd()` function calls the xkcd JSON API and returns metadata about the comic in the form of a list object.
#'
#' @importFrom jsonlite read_json
#' @export
#'
likert_scale_analyzer <- function(data, likert_cols, invalid_values) {

  data <- readr::read_csv("dataforpackage.csv")

  # ---- Validator Function for input ---- #
  # check 1) if data is actually a dataframe 2) likert_cols is a list of text names
  if (!is.data.frame(data)) {
    stop("Input 'data' must be a data frame.")
  }
  if (!is.character(likert_cols)) {
    stop("'likert_cols' must be a character vector of column names.")
  }

  # select only likert scale columns to process
  likert_data_subset <- data[, likert_cols]

  # create an emtpy dataframe to run function and store values
  summary_df <- data.frame(Question = character(),
                           ValidResponses = integer())

  # ---- Process each column ---- #
  for (col_name in likert_cols) {
    col_data <- likert_data_subset[[col_name]] # select column name first

    # 1) handle empty string, convert to NA
    # convert all vector types to character vector first
    if (is.factor(col_data)) {
      col_data_char <- as.character(col_data)
    } else {
      col_data_char <- as.character(col_data)
    }
    # existing NA values in col_data_char will remain NA_character_
    col_data_char[col_data_char == ""] <- NA_character_

    # 2) count valid

  return(x)

}

