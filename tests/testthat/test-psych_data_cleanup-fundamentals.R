test_that("likert_scale_analyzer returns a nested list object belonging to the Likert_List class", {
  selected_lsa <- likert_scale_analyzer(
    data = religious_som,
    likert_cols = c("relig_q4","relig_q5","relig_q10","relig_q11", "SOM_q1","SOM_q2","SOM_q3"),
    invalid_values = c(" ", "NA", "N/A"))

  expect_type(selected_lsa, "list") # likert_scale_analyzer objects should be lists

  expect_s3_class(selected_lsa, "Likert_List") # likert_scale_analyzer objects should belong to the S3 class Likert_List
})

test_that("likert_scale_analyzer throws an error when it is called with no arguments", {
  expect_error(likert_scale_analyzer()) # calling likert_scale_analyzer without any arguments should throw an error
})

test_that("draw_graph returns a list object", {
  selected_lsa <- likert_scale_analyzer(data = religious_som,
                                        likert_cols = c("relig_q4","relig_q5","relig_q10",
                                                        "relig_q11", "SOM_q1","SOM_q2",
                                                        "SOM_q3"),
                                        invalid_values = c(" ", "NA", "N/A"))

  selected_lsa_graphs <- draw_graph(selected_lsa)

  expect_type(selected_lsa_graphs, "list") # output of draw_graph is a list
})

test_that("draw_graph throws an error when it is called with no arguments", {
  expect_error(draw_graph()) # calling draw_graph without any arguments should throw an error
})

test_that("draw_graph produces plots that work", {
  vdiffr::expect_doppelganger(
    title = "Selected Qs Plots",
    fig = draw_graph(
      likert_scale_analyzer(data = religious_som,
                            likert_cols = c("relig_q4", "relig_q5", "relig_q10",
                                            "relig_q11", "SOM_q1", "SOM_q2", "SOM_q3"))))
})

test_that("validate_likert throws an error given input that does not belong to Likert_List class", {
  expect_error(validate_likert(5)) # calling validate_likert with an argument that does not belong to Likert_List class should throw an error
})

test_that("validate_likert correctly identifies Likert_List objects and returns them unchanged", {
  selected_lsa <- likert_scale_analyzer(
    data = religious_som,
    likert_cols = c("relig_q4","relig_q5","relig_q10","relig_q11", "SOM_q1","SOM_q2","SOM_q3"),
    invalid_values = c(" ", "NA", "N/A"))

  expect_equal(validate_likert(selected_lsa), selected_lsa) # validate_likert should be able to validate arguments that belong to the Likert_List class and should return them unchanged
})
