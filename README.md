
<!-- README.md is generated from README.Rmd. Please edit that file -->

# weightedcontrasts

<!-- badges: start -->

[![CRAN
Version](https://www.r-pkg.org/badges/version/weightedcontrasts)](https://CRAN.R-project.org/package=weightedcontrasts)
[![Travis build
status](https://travis-ci.com/elbersb/weightedcontrasts.svg?branch=master)](https://travis-ci.com/elbersb/weightedcontrasts)
[![Codecov test
coverage](https://codecov.io/gh/elbersb/weightedcontrasts/branch/master/graph/badge.svg)](https://codecov.io/gh/elbersb/weightedcontrasts?branch=master)
<!-- badges: end -->

Provides the function `contr.poly.weighted` to apply orthogonal
polynomial contrasts to unbalanced data. The function is general, but
the examples are specific to age-period-cohort models. Currently, the
package contains the following:

  - The function `contr.poly.weighted`
  - The dataset `prostate` from Holford 1983 (Table 2)
  - A vignette that reanalyzes [the example given in
    Holford 1983](https://htmlpreview.github.io/?https://github.com/elbersb/weightedcontrasts/blob/master/doc/fosse_winship2019.html)
  - A vignette that reanalyzes [the example given in Fosse and
    Winship 2019](https://htmlpreview.github.io/?https://github.com/elbersb/weightedcontrasts/blob/master/doc/holford1983.html)

## Installation

You can install the development version:

``` r
remotes::install_github("elbersb/weightedcontrasts")
```

## Example

This example shows how `contr.poly.weighted` provides a contrast matrix
that will lead to an orthogonal design matrix, even if the data are
unbalanced. We assume a situation in which an evenly-spaced predictor,
such as age groups (e.g., 20-24, 25-29, 30-34, etc.).

``` r
library("weightedcontrasts")

# first, the balanced case
group <- factor(c(20, 20, 25, 25, 30, 30))
contrasts(group) <- contr.poly
X <- model.matrix(~ group)
zapsmall(crossprod(X)) # correct result
#>             (Intercept) group.L group.Q
#> (Intercept)           6       0       0
#> group.L               0       2       0
#> group.Q               0       0       2

# but in the unbalanced case, contr.poly fails
group <- factor(c(20, 20, 25, 25, 30))
contrasts(group) <- contr.poly
X <- model.matrix(~ group)
zapsmall(crossprod(X)) # wrong result!
#>             (Intercept)   group.L   group.Q
#> (Intercept)    5.000000 -0.707107 -0.408248
#> group.L       -0.707107  1.500000 -0.288675
#> group.Q       -0.408248 -0.288675  1.833333

# this is where contr.poly.weighted comes in
# (width specifies the width of the group intervals)
group <- factor(c(20, 20, 25, 25, 30))
contrasts(group) <- contr.poly.weighted(group, width = 5)
X <- model.matrix(~ group)
zapsmall(crossprod(X)) # correct result
#>             (Intercept) group.L group.Q
#> (Intercept)           5       0 0.00000
#> group.L               0      70 0.00000
#> group.Q               0       0 1.55556
```

## References

Elbers, Benjamin. 2020. [*Orthogonal Polynomial Contrasts and
Applications to Age-Period-Cohort
Models*](https://osf.io/preprints/socarxiv/xrbgv/), Working Paper.

Fosse, Ethan and Christopher Winship. 2019. [*Analyzing
Age-Period-Cohort Data: A Review and
Critique*](https://www.annualreviews.org/doi/abs/10.1146/annurev-soc-073018-022616),
Annual Review of Sociology 45:467–92.

Holford, Theodore R.. 1983. [*The Estimation of Age, Period and Cohort
Effects for Vital Rates*](https://www.jstor.org/stable/2531004),
Biometrics 39(2): 311-324.
