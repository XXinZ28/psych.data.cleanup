#' @title Use the xkcd API
#' @description
#' Given a comic number, the `xkcd()` function calls the xkcd JSON API and returns metadata about the comic in the form of a list object.
#'
#' @importFrom jsonlite read_json
#' @export
#'
psych_data_cleanup <- function(number) {
"""
  placeholder
"""
  url <- file.path("https://xkcd.com", floor(number), "info.0.json")
  x <- jsonlite::read_json(url)
  return(x)
}
# xinxin:line before 30
