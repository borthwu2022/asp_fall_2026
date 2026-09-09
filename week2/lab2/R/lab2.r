######################################################
#                                                    #
# Lab 2: Pairwise distance performance               #
#                                                    #
# R/lab2.r                                           #
#                                                    #
# In-class reference implementations for:            #
#   Task 1. nested-loop pairwise distances           #
#   Task 2. vectorized pairwise distances            #
#                                                    #
######################################################

validate_pairwise_inputs <- function(x, y) {
  valid_x <-
    is.numeric(x) &&
    is.atomic(x) &&
    is.null(dim(x)) &&
    length(x) > 0L &&
    all(is.finite(x))

  valid_y <-
    is.numeric(y) &&
    is.atomic(y) &&
    is.null(dim(y)) &&
    length(y) > 0L &&
    all(is.finite(y))

  if (!valid_x) {
    stop("`x` must be a non-empty numeric vector of finite values.", call. = FALSE)
  }

  if (!valid_y) {
    stop("`y` must be a non-empty numeric vector of finite values.", call. = FALSE)
  }

  invisible(TRUE)
}

# Task 3. Thresholded pairwise distances with nested loops

# For one-dimensional points, Euclidean distance is abs(x[i] - y[j]).
# Rows correspond to x and columns correspond to y.

thresholded_distance_loop <- function(x, y, threshold = 0.5) {
  validate_pairwise_inputs(x, y)

  distances <- matrix(
    0,
    nrow = length(x),
    ncol = length(y)
  )

  for (i in seq_along(x)) {
    for (j in seq_along(y)) {
      distances[i, j] <- abs(x[i] - y[j])
      distances[i, j] <- ifelse(
        distances[i, j] < threshold, 
        0, distances[i,j])
    }
  }

  distances
}


# Task 4. Vectorized dense matrix

thresholded_distance_vectorized <- function(x, y, threshold = 0.5) {
  validate_pairwise_inputs(x, y)
  # Calculate pairwise distances for all entries
  mat <- abs(outer(x, y, FUN = "-"))
  # Impose threshold = 0.5
  mat[mat < 0.5] <- 0
  # Return the matrix
  return(mat)
}


# Task 5. Vectorized sparse matrix
thresholded_distance_sparse <- function(x, y, threshold = 0.5) {
  validate_pairwise_inputs(x, y)
  # Calculate pairwise distances for all entries
  mat <- abs(outer(x, y, FUN = "-"))
  # Impose threshold = 0.5
  mat[mat < 0.5] <- 0
  # Convert the matrix into a sparse matrix
  mat_sparse <- as(mat, "CsparseMatrix")
  # Return the sparse matrix
  return(mat_sparse)
}


# Small helpers used by the benchmark script

elapsed_seconds <- function(fun, ...) {
  timing <- system.time(fun(...))
  unname(timing[["elapsed"]])
}
