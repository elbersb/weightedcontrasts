#' Orthogonal polynomial contrast matrices for unbalanced data
#'
#' Similar to \link[stats:contrast]{contr.poly}, but will provide orthogonal contrasts
#' for unbalanced data. By specifying the `width` argument correctly
#' the function will also return a contrast matrix with an interpretable
#' linear term.
#'
#' @param f a factor
#' @param weights optional vector of weights. If not supplied, weights
#'   are calculated from \code{f}
#' @param width width of group variable (only affects the linear term)
#' @return contrast matrix
#' @export
contr.poly.weighted <- function (f, weights = NULL, width = 1) {
    if (!is.factor(f))
        stop(gettextf("f needs to be a factor"), domain = NA)

    n <- length(levels(f))
    if (n < 2)
        stop(gettextf("contrasts not defined for %d degrees of freedom", n - 1), domain = NA)
    if (n > 95)
        stop(gettextf("orthogonal polynomials cannot be represented accurately enough for %d degrees of freedom",
                      n - 1), domain = NA)

    if (is.null(weights)) {
       weights <- as.numeric(table(f)) / length(f)
    } else {
        if (all.equal(sum(weights), 1) != TRUE)
            stop(gettextf("weights need to sum to 1"), domain = NA)
    }
    y <- 1:n - sum(1:n * weights)
    X <- sqrt(weights) * outer(y, seq_len(n) - 1, "^")
    QR <- qr(X)
    z <- QR$qr
    z <- z * (row(z) == col(z))
    raw <- qr.qy(QR, z) / sqrt(weights)
    contr <- sweep(raw, 2L, apply(raw, 2L, function(x) sqrt(sum(x^2))),
                   "/", check.margin = FALSE)

    # recover the linear effect
    scores <- seq(1, width * n, by = width)
    scores <- scores - sum(scores * weights)
    contr[, 2] <- contr[, 2] * sqrt(sum(scores^2))

    dn <- paste0("^", 1L:n - 1L)
    dn[2:min(4, n)] <- c(".L", ".Q", ".C")[1:min(3, n - 1)]
    colnames(contr) <- dn
    contr[, -1, drop = FALSE]
}
