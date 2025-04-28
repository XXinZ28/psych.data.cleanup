#' @title Use likert_scale_analyzer()
#' @description
#' Given a likert scale survey, the `likert_scale_analyzer` function filter out invalid responses such as NA values and empty string, calculate scale points and range for each question, and returns a list object holding counts for valid and invalid responses.
#' @param data dataset that user uploaded
#' @param likert_cols users input all the likert columns variable names in c("","",...)
#' @param invalid_values invalid values such as empty string, NA values, N/A values that are pre-set.
#' @importFrom uploaded dataset from users
#' @returns A nested list of 7 elements
#' * variable_name$question: A character vector
#' * variable_name$valid_count: A scalar numeric vector
#' * variable_name$invalid_count: A scalar numeric vector, may be empty
#' * variable_name$scale_range: A scalar numeric vector
#' * variable_name$scale_min: A scalar numeric vector
#' * variable_name$scale_max: A scalar numeric vector
#' * variable_name$response_counts_numeric_data: A table includes scale point and valid counts
#' @examples
#' data <- readr::read_csv("dataforpackage.csv")
#' likert_scale_analyzer(data,likert_cols = c("relig_practice0", "relig_q4","relig_q5","relig_q10","relig_q11","relig_q12","relig_experience1","relig_experience2","relig_experience3","relig_experience4","SOM_q1","SOM_q2","SOM_q3","SOM_q4","SOM_q5","SOM_q6","SOM_q7"))
#' @export
#'
likert_scale_analyzer <- function(data,
                                  likert_cols,
                                  invalid_values = c(" ", "NA", "N/A")) {


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

    # # convert all to character vector first for smooth processing later
    # if (is.factor(col_data)) {
    # col_data_char <- as.character(col_data)
    # }

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
      min_value <- 1
      max_value <- max(non_na_values, na.rm = TRUE)
      scale_range <- max_value - min_value + 1

    # 5) count number of response for each likert scale point, excluding NA values when counting frequencies
      # response_counts <- table(numeric_data, levels = seq(1, max_value), useNA = "no")
      # Troubleshoot the following code:
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
    ) |>
    }
  }

  return(results_list)
}

#' @title Draw a histogram...
#'
#' @param x
#'
#' @returns
#' @export
#'
#' @examples
draw_graph <- function(data, likert_cols, invalid_values = c("", NA, "N/A")) {
  # Creating an object, `results_list` that is a call to the `likert_scale_analyzer` function,
  # and passing on the arguments: `data`, `likert_cols`, `invalid_values`.
  results_list <- likert_scale_analyzer(data, likert_cols, invalid_values)
  library(tidyverse) # We must import this package

  # Using `map_dfr` to turn the elements of the `results_list` into a data frame.
  # Focusing only on keeping the name of the question, response number, response counts, and the max number count.
  results_df <- map_dfr(results_list, function(x) tibble(question = x$question,
                                                      response_num = names(x$response_counts),
                                                      count = as.numeric(x$response_counts),
                                                      max_count = as.numeric(x$scale_max)))
  # Using the variables stored in the newly created `results_df` to plot faceted stacked bar plots by likert scale.
  # Each question corresponds to a specific likert scale range, and the responses for each of the corresponding questions
  # are differentiated by colors.
  ggplot(results_df, aes(x = response_num, y = count, fill = question)) +
    geom_col() +
    facet_wrap(~max_count, scales = "free", ncol = 1) +
    labs(title = "Response by Likert Scale",
         x = "Response",
         y = "Count",
         fill = "Question Name")

}

## Note: The color palette is not final. It's very difficult to differentiate between questions with this current color palette.

### sample data
# data <- readr::read_csv("dataforpackage.csv")
# likert_scale_analyzer(data, likert_cols = c("relig_practice0", "relig_q4","relig_q5","relig_q10","relig_q11","relig_q12","relig_experience1","relig_experience2","relig_experience3","relig_experience4","SOM_q1","SOM_q2","SOM_q3","SOM_q4","SOM_q5","SOM_q6","SOM_q7"))

# ------------------------------------------------------#
# psych_data_cleanup <- function(number) {
# """
#   placeholder
# """
#   url <- file.path("https://xkcd.com", floor(number), "info.0.json")
#   x <- jsonlite::read_json(url)
#   return(x)
# }
# xinxin:line before 30
# test_df <- read.csv("dataforpackage.csv")
#
# numeric_check <- function(x) {
#   column_names <- colnames(x)
#
#   for (i in column_names) {
#     if (is.numeric(x[[i]])) {
#       cat("This column: ", i, "is numeric.\n")
#     } else if (is.character(x[[i]])) {
#       cat("This column: ", i, "is of character type.\n")
#     } else {
#       print("This column: ", i, "is of some other type.\n" )
#     }
#   }
# }
#
# numeric_check(test_df)
#
# na_check <- function(x) {
#   x[x == ""] <- NA
#   return(x)
# }
#
# na_check_df <- function(x) {
#   x[] <- lapply(x, na_check)
#   return(x)
# }
#
# na_check_df(test_df)
#
# cat_check <- function(x) {
#   column_names <- colnames(x)
#
#   for (i in column_names) {
#     if (is.numeric(x[[i]])) {
#       max_bound <- max(x[[i]])
#       lower_bound <- min(x[[i]])
#     } else {
#       stop("This column is not of numeric type.")
#     }
#   }
# }
#
# cat_check(test_df)



# 7) group questions by scale type

# 8) summarize counts by scale type
