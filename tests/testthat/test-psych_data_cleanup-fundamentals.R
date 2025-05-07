test_that("likert_scale_analyzer returns a nested list object with designated elements names", {
  selected_lsa <- likert_scale_analyzer(
    data = religious_som,
    likert_cols = c("relig_q4","relig_q5","relig_q10","relig_q11", "SOM_q1","SOM_q2","SOM_q3"),
    invalid_values = c(" ", "NA", "N/A"))

  expect_type(selected_lsa, "list") # likert_scale_analyzer returned objects should be lists
  expect_named(selected_lsa, c("question", "response_num", "response_counts", "scale_max")) # likert_scale_analyzer returned list should contain elements: `question`, `response_num`, `count`, and `max_count`
  expect_type(selected_lsa$question, "character") # element `question` of the likert_scale_analyzer returned nested list object should be of character type
  expect_type(selected_lsa$response_num, "character") # element `response_num` of the likert_scale_analyzer returned nested list object should be of character type
  expect_type(selected_lsa$response_counts, "integer") # element `count` of the likert_scale_analyzer returned nested list object should be of integer type
  expect_type(selected_lsa$scale_max, "integer") # element `max_count` of the likert_scale_analyzer returned nested list object should be of integer
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

# test_that("print.Likert_List takes in an argument", {
#
# })

test_that("data_graph produces a series of histogram given the data frame returned by likert_scale_analyzer", {
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
