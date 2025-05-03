test_that("likert_scale_analyzer returns objects that are of data frame type", {
  first_selected_list <- likert_scale_analyzer(
    data = religious_som,
    likert_cols = c("relig_q4","relig_q5","relig_q10","relig_q11", "SOM_q1","SOM_q2","SOM_q3"),
    invalid_values = c(" ", "NA", "N/A"))

    expect_type(first_selected_list, "list") # likert_scale_analyzer objects should be lists
    expect_named(first_selected_list, c("question", "response_num", "count", "max_count")) # testing that the list returned by likert_scale_analyzer contains elements named: question, response_num, count, and max_count
    expect_type(first_selected_list$question, "character") # question elements of the likert_scale_analyzer nested list object should be of character type
    expect_type(first_selected_list$response_num, "character") # response_num elements of the likert_scale_analyzer nested list object should be of character type
    expect_type(first_selected_list$count, "integer") # count elements of the likert_scale_analyzer nested list object should be of integer type
    expect_type(first_selected_list$max_count, "integer" ) # max_count elements of the likert_scale_analyzer nested list object should be of integer type
})

test_that("data_graph produces a series of histogram given the data frame returned by likert_scale_analyzer", {
  expect_doppelganger(
    title = "religious_som questions plot",
    fig = plot(likert_scale_analyzer(data = religious_som, likert_cols = c("relig_practice0", "relig_q4","relig_q5","relig_q10","relig_q11","relig_q12","relig_experience1","relig_experience2","relig_experience3","relig_experience4","SOM_q1","SOM_q2","SOM_q3","SOM_q4","SOM_q5","SOM_q6","SOM_q7")))
  )
})
