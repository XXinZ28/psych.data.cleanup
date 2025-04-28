#' @title Use likert_scale_analyzer()
#' @description
#' Given a likert scale survey, the `likert_scale_analyzer` function filter out invalid responses such as NA values and empty string, calculate scale points and range for each question, and returns a list object holding counts for valid and invalid responses.
#' @param data dataset that user uploaded
#' @param likert_cols users input all the likert columns variable names in c("","",...)
#' @param invalid_values invalid values such as empty string, NA values, N/A values that are pre-set.
#' @importFrom uploaded dataset from users
#' @S3method define print method for results_list using S3 method: print.likert_scale()
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

    # 1) assign all invalid values as NA (include " ", NA, N/A)
    col_data[col_data %in% invalid_values | is.na(col_data)] <- NA

    # 2) convert to numeric for Likert scales results
    numeric_data <- as.numeric(col_data)

    # 3) count valid responses
    valid_count <- sum(!is.na(numeric_data))
    invalid_count <- sum(is.na(numeric_data))

    # 4) determine likert scales range (e.g., 1-5, 1-8) for one question
    non_na_values <- numeric_data[!is.na(numeric_data)]
    min_value <- 1
    max_value <- max(non_na_values, na.rm = TRUE)
    scale_range <- max_value - min_value + 1

    # 5) count number of response for each likert scale point, excluding NA values when counting frequencies
    response_counts <- table(factor(numeric_data, levels = as.character(1:max_value)), useNA = "no")

    # 6) update the empty result list created in the beginning, and store resut for this question.
    results_list[[col_name]] <- list(
      question = col_name,
      valid_count = valid_count,
      invalid_count = invalid_count,
      # scale_range = scale_range,
      scale_min = min_value,
      scale_max = max_value,
      response_counts = response_counts
    )
    }

  # 7) assign class "Likert_List" to the result_list
  class(results_list) <- "Likert_List"

  # 8) define print method for Likert_List class
  # method 1:
  print.Likert_List <- function(x, ...) {
    cat("Likert Scale Analysis Results\n")
    cat("----------------------------\n")
    for (item in x) {
      cat("Question:", item$question, "\n")
      cat("Valid Responses:", item$valid_count, "\n")
      cat("Invalid Responses:", item$invalid_count, "\n")
      cat("Scale Min:", item$scale_min, "\n")
      cat("Scale Max:", item$scale_max, "\n")
      cat("Response Counts:")
      print(item$response_counts)
      cat("----------------------------\n")
    }
  }

  # Method 2:
  # print.Likert_List <- function(x, ...) {
  #   df <- as.data.frame(x)
  #   cat("Likert Scale Summary:\n")
  #   print(df, row.names = FALSE)
  # }

  # 9) define as.data.frame method for Likert_List class: variable names in the dataframe: question,
  # valid_count, invalid_count, scale_min, scale_max

  # as.data.frame.Likert_List <- function(x, ...) {
  #   do.call(rbind, purrr::map_df(x, function(item) {
  #     data.frame(
  #       question = item$question,
  #       valid_count = item$valid_count,
  #       invalid_count = item$invalid_count,
  #       scale_min = item$scale_min,
  #       scale_max = item$scale_max,
  #       response_count = item$response_counts
  #     )
  #   }))
  # }

  return(print.Likert_List(results_list))
  # print.Likert_List(results_list))
  return(invisible(results_list))
  # return(as.data.frame(results_list))

  }


# ---------------------------------------------------#
#' @title Draw a histogram...
#'
#' @param x The list output from [likert_scale_analyzer].
#'
#' @returns
#' @export
#'
#' @examples
#' # likert_results <- likert_scale_analyzer(
#' #   data = religious_optimism,
#' #   likert_cols = c("relig_practice0", "relig_q4","relig_q5"),
#' #   invalid_values = c(" ", "NA")
#' #   )
#' #  draw_graph(likert_results)
#'
draw_graph <- function(x) {
  # Creating an object, `results_list` that is a call to the `likert_scale_analyzer` function,
  # and passing on the arguments: `data`, `likert_cols`, `invalid_values`.
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
         fill = "Question Name") +
    theme_bw()
  print(x)

}

## Note: The color palette is not final. It's very difficult to differentiate between questions with this current color palette.

# -------------------------------#
### sample data
# data <- readr::read_csv("dataforpackage.csv")
# likert_scale_analyzer(data, likert_cols = c("relig_practice0", "relig_q4","relig_q5","relig_q10","relig_q11","relig_q12","relig_experience1","relig_experience2","relig_experience3","relig_experience4","SOM_q1","SOM_q2","SOM_q3","SOM_q4","SOM_q5","SOM_q6","SOM_q7"))


# likert_results <- likert_scale_analyzer(
#   data,
#   likert_cols = c("relig_practice0", "relig_q4","relig_q5","relig_q10","relig_q11","relig_q12","relig_experience1","relig_experience2","relig_experience3","relig_experience4","SOM_q1","SOM_q2","SOM_q3","SOM_q4","SOM_q5","SOM_q6","SOM_q7"),
#   invalid_values = c(" ", "NA")
# )
# draw_graph(likert_results)

