test_that("likert_scale_analyzer returns a nested list object with designated elements names", {
  selected_lsa <- likert_scale_analyzer(
    data = religious_som,
    likert_cols = c("relig_q4","relig_q5","relig_q10","relig_q11", "SOM_q1","SOM_q2","SOM_q3"),
    invalid_values = c(" ", "NA", "N/A"))

  expect_type(selected_lsa, "list") # likert_scale_analyzer returned objects should be lists

  expect_s3_class(selected_lsa, "Likert_List")
  # expect_named(selected_lsa, c("question", "response_num", "response_counts", "scale_max")) # likert_scale_analyzer returned list should contain elements: `question`, `response_num`, `count`, and `max_count`
  # expect_type(selected_lsa$question, "character") # element `question` of the likert_scale_analyzer returned nested list object should be of character type
  # expect_type(selected_lsa$response_num, "character") # element `response_num` of the likert_scale_analyzer returned nested list object should be of character type
  # expect_type(selected_lsa$response_counts, "integer") # element `count` of the likert_scale_analyzer returned nested list object should be of integer type
  # expect_type(selected_lsa$scale_max, "integer") # element `max_count` of the likert_scale_analyzer returned nested list object should be of integer
})

# test_that("draw_graph takes in a list object from likert_scale_analyzer with the correct element names", {
#   selected_lsa_2 <- NULL
#   selected_lsa_graphs <- draw_graph(selected_lsa_2)
#   expect_error(is.null(selected_lsa_2), "There is nothing being fed into draw_graph")
# })

test_that("draw_graph returns a list object containing elements containing plot data", {
  selected_lsa_2 <- likert_scale_analyzer(
    data = religious_som,
    likert_cols = c("relig_q4","relig_q5","relig_q10","relig_q11", "SOM_q1","SOM_q2","SOM_q3"),
    invalid_values = c(" ", "NA", "N/A"))

  selected_lsa_2_graphs <- draw_graph(selected_lsa_2)

  expect_type(selected_lsa_2_graphs, "list")
})


test_that("draw_graph produces a series of histograms given the data frame returned by likert_scale_analyzer", {
  vdiffr::expect_doppelganger(
    title = "histogram series",
    fig = draw_graph(
      likert_scale_analyzer(
        data        = religious_som,
        likert_cols = c("relig_q4", "relig_q5", "relig_q10",
                        "relig_q11", "SOM_q1", "SOM_q2", "SOM_q3")
      )
    )
  )
})

test_that("`validate_likert` produces an error given an object that is not of class `Likert_List`", {
  expect_error(object = validate_likert(5))
})

test_that("`validate_likert()` returns an object given that it belongs to `Likert_List` class", {
  selected_lsa <- likert_scale_analyzer(
    data = religious_som,
    likert_cols = c("relig_q4","relig_q5","relig_q10","relig_q11", "SOM_q1","SOM_q2","SOM_q3"),
    invalid_values = c(" ", "NA", "N/A"))

  expect_equal(object = validate_likert(selected_lsa), expected = selected_lsa)
})

# test_that("as.data.frame.Likert_List method creates a data frame with the correct column names and rows", {
#   selected_lsa <- likert_scale_analyzer(
#     data = religious_som,
#     likert_cols = c("relig_q4", "relig_q5", "relig_q10", "relig_q11", "SOM_q1", "SOM_q2", "SOM_q3"),
#     invalid_values = c(" ", "NA", "N/A")
#   )
#
#   expected_df <- structure(list(question = c("relig_q4", "relig_q4", "relig_q4",
#                                              "relig_q4", "relig_q4", "relig_q4",
#                                              "relig_q4", "relig_q4", "relig_q5",
#                                              "relig_q5", "relig_q5", "relig_q5",
#                                              "relig_q5", "relig_q5", "relig_q5",
#                                              "relig_q5", "relig_q10", "relig_q10",
#                                              "relig_q10", "relig_q10", "relig_q10",
#                                              "relig_q11", "relig_q11", "relig_q11",
#                                              "relig_q11", "relig_q11", "SOM_q1",
#                                              "SOM_q1", "SOM_q1", "SOM_q1",
#                                              "SOM_q1", "SOM_q2", "SOM_q2",
#                                              "SOM_q2", "SOM_q2", "SOM_q2",
#                                              "SOM_q3", "SOM_q3", "SOM_q3",
#                                              "SOM_q3", "SOM_q3"),
#                                 response_num = c("1", "2", "3",
#                                                  "4", "5", "6",
#                                                  "7", "8", "1",
#                                                  "2", "3", "4",
#                                                  "5", "6", "7",
#                                                  "8", "1", "2",
#                                                  "3", "4", "5",
#                                                  "1", "2", "3",
#                                                  "4", "5", "1",
#                                                  "2", "3", "4",
#                                                  "5", "1", "2",
#                                                  "3", "4", "5",
#                                                  "1", "2", "3",
#                                                  "4", "5"),
#                                 response_counts = c(15L, 4L, 4L,
#                                                     2L, 2L, 2L,
#                                                     3L, 8L, 14L,
#                                                     6L, 1L, 7L,
#                                                     3L, 3L, 0L,
#                                                     6L, 17L, 10L,
#                                                     3L, 2L, 8L,
#                                                     14L, 9L, 4L,
#                                                     2L, 11L, 1L,
#                                                     3L, 9L, 16L,
#                                                     9L, 2L, 3L,
#                                                     6L, 11L, 16L,
#                                                     2L, 4L, 6L,
#                                                     16L, 10L),
#                                 scale_max = structure(c(1L, 1L, 1L,
#                                                         1L, 1L, 1L,
#                                                         1L, 1L, 1L,
#                                                         1L, 1L, 1L,
#                                                         1L, 1L, 1L,
#                                                         1L, 2L, 2L,
#                                                         2L, 2L, 2L,
#                                                         2L, 2L, 2L,
#                                                         2L, 2L, 2L,
#                                                         2L, 2L, 2L,
#                                                         2L, 2L, 2L,
#                                                         2L, 2L, 2L,
#                                                         2L, 2L, 2L,
#                                                         2L, 2L),
#                                                       levels = c("8", "5"),
#                                                       class = "factor")),
#                            class = c("tbl_df", "tbl", "data.frame"),
#                            row.names = c(NA, -41L))
#
#   expect_identical(selected_lsa, expected_df)

  # expected_df <- data.frame(
  #   question = c("relig_q4", "relig_q4", "relig_q4", "relig_q4", "relig_q4", "relig_q4", "relig_q4", "relig_q4",
  #                "relig_experience1", "relig_experience1", "relig_experience1", "relig_experience1", "relig_experience1",
  #                "relig_experience4", "relig_experience4", "relig_experience4", "relig_experience4", "relig_experience4",
  #                "SOM_q1", "SOM_q1", "SOM_q1", "SOM_q1", "SOM_q1", "SOM_q3", "SOM_q3", "SOM_q3", "SOM_q3", "SOM_q3"),
  #   response_num = c("1", "2", "3", "4", "5", "6", "7", "8", "1", "2", "3", "4", "5", "1", "2", "3", "4", "5", "1", "2", "3", "4", "5", "1", "2", "3", "4", "5"),
  #   response_counts = as.integer(c(15, 4, 4, 2, 2, 2, 3, 8, 7, 13, 5, 5, 10, 14, 10, 8, 6, 2, 1, 3, 9, 16, 9, 2, 4, 6, 16, 10)),
  #   scale_max = as.factor(c(8, 8, 8, 8, 8, 8, 8, 8, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5)))
  #
  # expect_identical(likert_scale_analyzer(data = religious_som,
  #                                        likert_cols = c("relig_q4", "relig_experience1",
  #                                                        "relig_experience4","SOM_q1","SOM_q3"),
  #                                        invalid_values = c(" ", "NA", "N/A")), expected_df)
# })
