#' @title Use likert_scale_analyzer()
#' @description
#' Given a likert scale survey, the `likert_scale_analyzer` function filter out invalid responses
#' such as NA values and empty string, calculate scale points and range for each question, and
#' returns a list object holding counts for valid and invalid responses.
#' @param data dataset that user uploaded
#' @param likert_cols users input all the likert columns variable names in c("","",...)
#' @param invalid_values invalid values such as empty string, NA values, N/A values that are pre-set.
#' @returns A nested list object of 7 elements
#' * variable_name$question: A character vector
#' * variable_name$valid_count: A scalar numeric vector
#' * variable_name$invalid_count: A scalar numeric vector, may be empty
#' * variable_name$scale_min: A scalar numeric vector
#' * variable_name$scale_max: A scalar numeric vector
#' * variable_name$response_counts: A table includes scale point and valid counts
#' @examples
#' likert_scale_analyzer(
#'   data = religious_som,
#'   likert_cols = c("relig_q4","relig_experience1","relig_experience4","SOM_q1","SOM_q3")
#'  )
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

  # subset dataset to select only likert scale columns to process
  likert_data_subset <- data[, likert_cols]

  # create an empty list to store results for each question
  results_list <- list()

  # ---- Process each column ---- #
  for (col_name in likert_cols) {
    col_data <- likert_data_subset[[col_name]] # select column name first

    # 1) assign all invalid values as NA (include " ", NA, N/A)
    col_data[col_data %in% invalid_values] <- NA

    # 2) convert to numeric for Likert scales results
    numeric_data <- as.numeric(col_data)

    # 3) count valid responses
    valid_count <- sum(!is.na(numeric_data))
    invalid_count <- length(numeric_data)

    # 4) determine likert scales range (e.g., 1-5, 1-8) for one question
    min_value <- 1
    max_value <- max(numeric_data[!is.na(numeric_data)])

    # 5) count number of response for each likert scale point, excluding NA values when counting frequencies
    response_counts <- table(factor(numeric_data, levels = as.character(1:max_value)), useNA = "no")

    # 6) update the empty result list created in the beginning, and store result for this question.
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

  # Suggestion
  # results_list <- as.data.frame(results_list)
  # class(results_list) <- c("Likert_List", class(results_list))
  # return(results_list)

  class(results_list) <- "Likert_List"

  return(as.data.frame(results_list))
}


#' @title Define as.data.frame method for results_list using S3 method: as.data.frame.likert_scale()
#' @method as.data.frame Likert_List
#' @param list_results Any list object belonging to the "Likert_List" class
#' @importFrom purrr map_dfr
#' @importFrom tibble tibble
as.data.frame.Likert_List <- function(list_results) {
  results_df <- purrr::map_dfr(list_results, function(x) data.frame(question = x$question,
                                                         response_num = names(x$response_counts),
                                                         response_counts = as.integer(x$response_counts),
                                                         scale_max = as.factor(x$scale_max)))
  return(results_df)
}

#' @title Draw a histogram
#' @description It plots a series of histogram summarizing valid response counts by each question, differentiating by likert scale.
#' @param x The dataframe created when [likert_scale_analyzer] is called.
#' @importFrom ggplot2 geom_col
#' @importFrom ggplot2 facet_wrap
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 scale_fill_continuous
#' @importFrom ggplot2 theme_bw
#' @importFrom dplyr .data
#' @returns A series of facet_wrap histogram, corresponding to the likert_scale.
#' @export
#' @examples
#'  likert_results <- likert_scale_analyzer(
#'   data = religious_som,
#'   likert_cols = c("relig_practice0", "relig_q4","relig_q5"),
#'   invalid_values = c(" ", "NA")
#'   )
#'  draw_graph(likert_results)
#'
draw_graph <- function(x) {

  df_results <- x

  # ggplot2::ggplot(df_results, ggplot2::aes(x = response_num, y = response_counts, fill = scale_max)) +
  #   ggplot2::geom_col() +
  #   ggplot2::facet_wrap(~question, scales = "free_x") +
  #   ggplot2::labs(title = "Response Count by Question",
  #        x = "Response",
  #        y = "Count",
  #        fill = "Likert Point Scales") +
  #   ggplot2::theme_bw()
#
#   df_col_names <- names(x)

  # x <- validate_likert(x)
  #
  # expected_col_names <- c("question", "response_num", "response_counts", "scale_max")
  #
  # if (!is.data.frame(x) && grepl(expected_col_names, df_col_names, ignore.case = FALSE) == FALSE) {
  #   stop("Input `x` must be the data frame returned when `likert_scale_analyzer` is called")
  # }
  #
  # if (class(x) != "Likert_List") {
  #   stop("Input `x` must be a Liker_List object returned from `likert_scale_analyzer()`")
  # }
  #
  # if(!is.data.frame(x)) {
  #   stop("Input `x` must be a data frame")
  # }

  ggplot2::ggplot(df_results, ggplot2::aes(x = .data[["response_num"]], y = .data[["response_counts"]], fill = .data[["scale_max"]])) +
    ggplot2::geom_col() +
    ggplot2::facet_wrap(~question, scales = "free_x") +
    ggplot2::labs(title = "Response Count by Question",
                  x = "Response",
                  y = "Count",
                  fill = "Likert Point Scales") +
    ggplot2::theme_bw()
}
