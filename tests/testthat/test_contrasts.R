library("testthat")
library("weightedcontrasts")

is.diagonal <- function(m) {
    m <- zapsmall(m)
    all(diag(diag(m)) == m)
}

test_that("linear effect (n = 3, width = 1)", {
    df <- data.frame(y = rnorm(6), group = c(1, 1, 2, 2, 3, 3))
    coef_linear <- coef(lm(y ~ group, data = df))[[2]]

    df$group <- as.factor(df$group)
    contrasts(df$group) <- contr.poly.weighted(df$group, width = 1)

    X <- model.matrix(~ group, data = df)
    expect_equal(is.diagonal(crossprod(X)), TRUE)

    coef_orthogonal <- coef(lm(y ~ group, data = df))[[2]]
    expect_equal(coef_linear, coef_orthogonal)
})

test_that("linear effect (n = 3, width = 10)", {
    df <- data.frame(y = rnorm(3), group = c(5, 15, 25))
    coef_linear <- coef(lm(y ~ group, data = df))[[2]]

    df$group <- as.factor(df$group)
    contrasts(df$group) <- contr.poly.weighted(df$group, width = 10)

    X <- model.matrix(~ group, data = df)
    expect_equal(is.diagonal(crossprod(X)), TRUE)

    coef_orthogonal <- coef(lm(y ~ group, data = df))[[2]]
    expect_equal(coef_linear, coef_orthogonal)
})

test_that("linear effect (n = 5, width = 3)", {
    df <- data.frame(y = rnorm(10), group = c(3, 3, 6, 6, 9, 9, 12, 12, 15, 15))
    coef_linear <- coef(lm(y ~ group, data = df))[[2]]

    df$group <- as.factor(df$group)
    contrasts(df$group) <- contr.poly.weighted(df$group, width = 3)

    X <- model.matrix(~ group, data = df)
    expect_equal(is.diagonal(crossprod(X)), TRUE)

    coef_orthogonal <- coef(lm(y ~ group, data = df))[[2]]
    expect_equal(coef_linear, coef_orthogonal)
})

test_that("unbalanced groups (n = 3, width = 1)", {
    df <- data.frame(y = rnorm(4), group = c(1, 1, 2, 3))
    coef_linear <- coef(lm(y ~ group, data = df))[[2]]

    df$group <- as.factor(df$group)
    contrasts(df$group) <- contr.poly.weighted(df$group)

    X <- model.matrix(~ group, data = df)
    expect_equal(is.diagonal(crossprod(X)), TRUE)

    coef_orthogonal <- coef(lm(y ~ group, data = df))[[2]]
    expect_equal(coef_linear, coef_orthogonal)
})

test_that("unbalanced groups (n = 3, width = 3)", {
    df <- data.frame(y = rnorm(4), group = c(1, 1, 4, 7))
    coef_linear <- coef(lm(y ~ group, data = df))[[2]]

    df$group <- as.factor(df$group)
    contrasts(df$group) <- contr.poly.weighted(df$group, width = 3)

    X <- model.matrix(~ group, data = df)
    expect_equal(is.diagonal(crossprod(X)), TRUE)

    coef_orthogonal <- coef(lm(y ~ group, data = df))[[2]]
    expect_equal(coef_linear, coef_orthogonal)
})

test_that("same predictions", {
    df <- data.frame(y = rnorm(6), group = c(1, 1, 4, 7, 7, 7))
    m1 <- lm(y ~ group + I(group^2), data = df)
    df$group <- as.factor(df$group)
    contrasts(df$group) <- contr.poly.weighted(df$group, width = 3)
    m2 <- lm(y ~ group, data = df)

    expect_equal(predict(m1), predict(m2))
})

test_that("error when weights do not sum to 1", {
    expect_error(contr.poly.weighted(factor(1:3), weights = c(.1)))
})
