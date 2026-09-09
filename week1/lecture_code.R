sim_once <- function(seed, n = 100) {
set.seed(seed)
x <- rnorm(n)
c(mean = mean(x), sd = sd(x))
}
sim_once(2026)
sim_once(2026)

#===============================================================================
#’ Cosine similarity
#’
#’ @param x,y Numeric vectors of equal length.
#’ @return Scalar in [-1,1], or NA if a norm is zero.
#’ @export
cosine_similarity <- function(x, y) {
stopifnot(length(x) == length(y))
nx <- sqrt(sum(x^2)); ny <- sqrt(sum(y^2))
if (nx == 0 || ny == 0) return(NA_real_) # standard NA for a function
sum(x * y) / (nx * ny)

}

#===============================================================================
# Test for the cosine-similarity function

testthat::test_that('cosine similarity satisfies basic identities', {
x <- c(1, -2, 3)
y <- c(4, 1, 0)
testthat::expect_equal(cosine_similarity(x, x), 1)
testthat::expect_equal(cosine_similarity(x, y),
cosine_similarity(y, x))
testthat::expect_true(abs(cosine_similarity(x, y)) <= 1)
})

#===============================================================================
# Benchmarking for speed time

bench_one <- function(n, reps = 20L) {
x <- rnorm(n); y <- rnorm(n)
t1 <- replicate(reps, system.time(cosine_similarity(x,y))['elapsed'])
t2 <- replicate(reps, system.time(sum(x*y)/sqrt(sum(x*x)*sum(y*y)))['elapsed'])
data.frame(n = n,
method = c('function','inline'),
median = c(median(t1), median(t2)))
}
