#' @title Use the xkcd API
#' @description
#' Given a comic number, the `xkcd()` function calls the xkcd JSON API and returns metadata about the comic in the form of a list object.
#'
#' @importFrom jsonlite read_json
#' @export
#'
likert_scale_analyzer <- function(data, likert_cols, invalid_values = c("", "NA", "N/A")) {

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

  # create an empty list to store results for each question
  results_list <- list()

  # ---- Process each column ---- #
  for (col_name in likert_cols) {
    col_data <- likert_data_subset[[col_name]] # select column name first

    # convert all to character vector first for smooth processing later
    if (is.factor(col_data)) {
      col_data_char <- as.character(col_data)
    } else {
      col_data_char <- as.character(col_data)
    }

    # 1) assign all invalid values as NA (include " ", NA, N/A)
    col_data[col_data %in% invalid_values | is.na(col_data)] <- NA

    # 2) convert to numeric for Likert scales results
    # numeric_data <- suppressWarnings(as.numeric(col_data))
    numeric_data <- as.numeric(col_data)

    # 3) count valid responses
    valid_count <- sum(!is.na(numeric_data))
    invalid_count <- sum(is.na(numeric_data))

    # 4) determine likert scales range (e.g., 1-5, 1-8) for one question
    non_na_values <- numeric_data[!is.na(numeric_data)]
    if (length(non_na_values) > 0) {
      min_value <- min(non_na_values, na.rm = TRUE)
      max_value <- max(non_na_values, na.rm = TRUE)
      scale_range <- max_value - min_value + 1

    # 5) count number of response for each likert scale point, excluding NA values when counting frequencies
    response_counts <- table(numeric_data, useNA = "no")

    # 6) update the empty result list created in the beginning, and store resut for this question.
    results_list[[col_name]] <- list(
      question = col_name,
      valid_count = valid_count,
      invalid_count = invalid_count,
      scale_range = scale_range,
      scale_min = min_value,
      scale_max = max_value,
      response_counts = response_counts
    )
    }
  }

  # 7) group questions by scale type

  # 8) summarize counts by scale type

}

