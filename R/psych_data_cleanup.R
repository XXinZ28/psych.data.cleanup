#' @title Use likert_scale_analyzer()
#' @description
#' Given a likert scale survey, the `likert_scale_analyzer` function filter out invalid responses such as NA values and empty string, calculate scale points and range for each question, and returns a list object holding counts for valid and invalid responses.
#' @param data dataset that user uploaded
#' @param likert_cols users input all the likert columns variable names in c("","",...)
#' @param invalid_values invalid values such as empty string, NA values, N/A values that are pre-set.
#' @returns A nested list object of 7 elements
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

    # 5) count number of response for each likert scale point, excluding NA values when counting frequencies
    response_counts <- table(factor(numeric_data, levels = as.character(1:max_value)), useNA = "no")

    # 6) update the empty result list created in the beginning, and store resut for this question.
    results_list[[col_name]] <- list(
      question = col_name,
      valid_count = valid_count,
      invalid_count = invalid_count,
      scale_min = min_value,
      scale_max = max_value,
      response_counts = response_counts
    )
    }

  # 7) assign class "Likert_List" to the result_list list object
  class(results_list) <- "Likert_List"

print(results_list)
return(as.data.frame(results_list))
}

#' @S3method Define print method for results_list using S3 method: print.likert_scale()
#' @param x Any list object belonging to the "Likert_list" class
print.Likert_List <- function(x) {
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

#' @S3method Define as.data.frame method for results_list using S3 method: as.data.frame.likert_scale()
#' @param list_results Any list object belonging to the "Likert_list" class
as.data.frame.Likert_List <- function(list_results) {
  results_df <- purrr::map_dfr(list_results, function(x) tibble::tibble(question = x$question,
                                                         response_num = names(x$response_counts),
                                                         count = as.numeric(x$response_counts),
                                                         max_count = as.numeric(x$scale_max)))
  return(results_df)
}


# ---------------------------------------------------#
#' @title Draw a histogram
#' @description It plots a series of histogram summarizing valid response counts by each question, differentiating by likert scale.
#' @param x The dataframe created when [likert_scale_analyzer] is called.
#'
#' @returns A series of facet_wrap histogram, corresponding to the likert_scale.
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

  df_results <- x
  ggplot2::ggplot(df_results, ggplot2::aes(x = response_num, y = count, fill = max_count)) +
    ggplot2::geom_col() +
    ggplot2::facet_wrap(~question, scales = "free_x") +
    ggplot2::labs(title = "Response Count by Question",
         x = "Response",
         y = "Count",
         fill = "Likert Scale") +
    ggplot2::scale_fill_continuous() + # if we remove this, the scale remains continuous but we want it to be discrete
    ggplot2::theme_bw()
}


# -------------------------------#
### sample data usage
# data <- readr::read_csv("dataforpackage.csv")
# likert_scale_analyzer(data, likert_cols = c("relig_practice0", "relig_q4","relig_q5","relig_q10","relig_q11","relig_q12","relig_experience1","relig_experience2","relig_experience3","relig_experience4","SOM_q1","SOM_q2","SOM_q3","SOM_q4","SOM_q5","SOM_q6","SOM_q7"))


# likert_results <- likert_scale_analyzer(
#   data,
#   likert_cols = c("relig_practice0", "relig_q4","relig_q5","relig_q10","relig_q11","relig_q12","relig_experience1","relig_experience2","relig_experience3","relig_experience4","SOM_q1","SOM_q2","SOM_q3","SOM_q4","SOM_q5","SOM_q6","SOM_q7"),
#   invalid_values = c(" ", "NA")
# )
# draw_graph(likert_results)

