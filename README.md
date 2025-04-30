
<!-- README.md is generated from README.Rmd. Please edit that file -->

# psych.data.cleanup

<!-- badges: start -->
<!-- badges: end -->

The `psych.data.cleanup` package provides an R interface to retrieve
data from surveys containing likert scale questionnaires. It converts
all invalid values to identical format, generates a nested object list
of descriptive statistics, and print it out to the user. You can
visualize the results in the RStudio plot window.

## Installation

You can install the development version of psych.data.cleanup from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("XXinZ28/psych.data.cleanup")
```

## Usage

Given a religious optimism survey data, the `likert_scale_analyzer`
function returns a nested list object containing elements that
summarizes response counts for each question.

``` r
library(psych.data.cleanup)

likert_results <- likert_scale_analyzer(
  data = religious_som,
  likert_cols = c("relig_q4","relig_q5","relig_q10","relig_q11", "SOM_q1","SOM_q2","SOM_q3"),
  invalid_values = c(" ", "NA")
) 
#> Likert Scale Analysis Results
#> ----------------------------
#> Question: relig_q4 
#> Valid Responses: 40 
#> Invalid Responses: 17 
#> Scale Min: 1 
#> Scale Max: 8 
#> Response Counts:
#>  1  2  3  4  5  6  7  8 
#> 15  4  4  2  2  2  3  8 
#> ----------------------------
#> Question: relig_q5 
#> Valid Responses: 40 
#> Invalid Responses: 17 
#> Scale Min: 1 
#> Scale Max: 8 
#> Response Counts:
#>  1  2  3  4  5  6  7  8 
#> 14  6  1  7  3  3  0  6 
#> ----------------------------
#> Question: relig_q10 
#> Valid Responses: 40 
#> Invalid Responses: 17 
#> Scale Min: 1 
#> Scale Max: 5 
#> Response Counts:
#>  1  2  3  4  5 
#> 17 10  3  2  8 
#> ----------------------------
#> Question: relig_q11 
#> Valid Responses: 40 
#> Invalid Responses: 17 
#> Scale Min: 1 
#> Scale Max: 5 
#> Response Counts:
#>  1  2  3  4  5 
#> 14  9  4  2 11 
#> ----------------------------
#> Question: SOM_q1 
#> Valid Responses: 38 
#> Invalid Responses: 19 
#> Scale Min: 1 
#> Scale Max: 5 
#> Response Counts:
#>  1  2  3  4  5 
#>  1  3  9 16  9 
#> ----------------------------
#> Question: SOM_q2 
#> Valid Responses: 38 
#> Invalid Responses: 19 
#> Scale Min: 1 
#> Scale Max: 5 
#> Response Counts:
#>  1  2  3  4  5 
#>  2  3  6 11 16 
#> ----------------------------
#> Question: SOM_q3 
#> Valid Responses: 38 
#> Invalid Responses: 19 
#> Scale Min: 1 
#> Scale Max: 5 
#> Response Counts:
#>  1  2  3  4  5 
#>  2  4  6 16 10 
#> ----------------------------
```

The `draw_graph` function takes in list results
from`likert_scale_analyzer` function and displays a series of
histograms.

``` r
draw_graph(likert_results)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />
