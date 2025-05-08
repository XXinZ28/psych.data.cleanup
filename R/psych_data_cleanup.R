#' @title Use likert_scale_analyzer()
#' @description
#' Given a likert scale survey, the `likert_scale_analyzer` function filters out invalid responses
#' such as NA values and empty strings, calculates scale points and range for each question, and
#' returns a list object holding counts for valid and invalid responses.
#' @param data A data frame containing survey questions and responses uploaded by the user.
#' @param likert_cols A character vector containing Likert-scale question names in c("","", ...).
#' @param invalid_values A character vector containing invalid values such as empty string, NA values, N/A
#' values, which are pre-set.
#' @returns A list object belonging to the `Likert_List` class where each element contains a nested list with
#' the following 6 components:
#' * variable_name$question: A character vector
#' * variable_name$valid_count: A scalar numeric vector
#' * variable_name$invalid_count: A scalar numeric vector, may be empty
#' * variable_name$scale_min: A scalar numeric vector
#' * variable_name$scale_max: A scalar numeric vector
#' * variable_name$response_counts: A table that includes scale point and valid counts
#' @examples
#' likert_scale_analyzer(
#'   data = religious_som,
#'   likert_cols = c("relig_q4","relig_experience1","relig_experience4","SOM_q1","SOM_q3"),
#'   invalid_values = c(" ", "NA", "N/A")
#'  )
#' @export
likert_scale_analyzer <- function(data, likert_cols, invalid_values = c(" ", "NA", "N/A")) {

  # ---- Validator Function for input ---- #
  # check 1) if data is actually a data frame 2) likert_cols is a list of text names
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

    # 4) determine Likert scales range (e.g., 1-5, 1-8) for one question
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
  class(results_list) <- c("Likert_List")

  return(results_list)

}

#' @title Convert objects belonging to the `Likert_List` class into a data frame
#' @description Given an object of the `Likert_List` class, `as.data.frame.Likert_List()` converts the object
#' into a data frame. The resulting data frame contains columns for: question name (`question`), point on
#' Likert-scale (`response_num`), number of counts for each Likert-scale point (`response_counts`), and the
#' maximum Likert-scale point per question (`scale_max`).
#' @method as.data.frame Likert_List
#' @param list_results A list object of the `Likert_List` class.
#' @returns A data frame containing the Likert-scale question names, Likert-scale points, counts for each
#' Likert-scale point, and the maximum scale value for each question.
#' @importFrom purrr map_dfr
as.data.frame.Likert_List <- function(list_results) {
  results_df <- purrr::map_dfr(list_results, function(x) data.frame(question = x$question,
                                                         response_num = names(x$response_counts),
                                                         response_counts = as.integer(x$response_counts),
                                                         scale_max = x$scale_max))
  return(results_df)
}

#' @title Visualize Likert-scale response counts
#' @description Given the object returned by [likert_scale_analyzer()], the `draw_graph()` function checks
#' that the object belongs to `Likert_List` class, converts the object into a data frame, and
#' generates a series of faceted bar charts for each of the selected Likert-scale questions. Each bar chart
#' displays the valid response counts for each Likert point scale, with the fill color of the bars
#' representing the Likert-scale for each question.
#' @param x The `Likert_List` object returned by [likert_scale_analyzer()].
#' @importFrom ggplot2 geom_col
#' @importFrom ggplot2 facet_wrap
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 scale_fill_continuous
#' @importFrom ggplot2 theme_bw
#' @importFrom dplyr .data
#' @returns A series of faceted bar charts. Each bar chart corresponds to a Likert-scale question and displays
#' the valid number of counts for each Likert-scale point. The fill color of each bar differentiates the
#' Likert-scale for each question.
#' @export
#' @examples
#'  likert_results <- likert_scale_analyzer(
#'   data = religious_som,
#'   likert_cols = c("relig_practice0", "relig_q4","relig_q5"),
#'   invalid_values = c(" ", "NA")
#'   )
#'  draw_graph(likert_results)
draw_graph <- function(x) {

  # 1) making a call to the validator function to validate `x`
  x <- validate_likert(x)

  # 2) converting `x` into a data frame
  df_results <- as.data.frame(x)

  # 3) converting the `scale_max` variable of the `df_results` data frame into a factor
  df_results$scale_max <- as.factor(df_results$scale_max)

  # 4) generating the faceted bar charts
  ggplot2::ggplot(df_results, ggplot2::aes(x = .data[["response_num"]],
                                           y = .data[["response_counts"]],
                                           fill = .data[["scale_max"]])) +
    ggplot2::geom_col() +
    ggplot2::facet_wrap(~.data[["question"]], scales = "free_x") +
    ggplot2::labs(title = "Response Counts by Likert-Scale Question",
                  subtitle = "Excludes missing or invalid responses",
                  x = "Response",
                  y = "Count",
                  fill = "Likert Point Scales") +
    ggplot2::theme_bw()
}

#' @title Validating objects to ensure they belong to the `Likert_List` class
#' @description The validator function `validate_likert()` certifies that the argument `x` belongs to the
#' `Likert_List` class. It is used within the [draw_graph()] function to validate input.
#' @param x An object that is going to be validated to ensure that it belongs to the `Likert_List` class.
#' @importFrom methods is
#' @returns If object `x` does belong to the `Likert_List` class, `validate_likert()` will return the object.
#' Otherwise, it will throw an error.
#' @examples
#' likert_results <- likert_scale_analyzer(
#'   data = religious_som,
#'   likert_cols = c("relig_practice0", "relig_q4","relig_q5"),
#'   invalid_values = c(" ", "NA"))
#' draw_graph(likert_results)
validate_likert <- function(x) {

  if (!is(x, "Likert_List")) {
    stop("Argument `x` needs to be of class `Likert_List`")
  }

  return(x)
}
