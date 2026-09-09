######################################################
#                                                    #
# Lab 2 in-class exercise: Tasks 3-5                 #
#                                                    #
# tests/run_assignment.r                             #
#                                                    #
######################################################
# Redirect console output to a log file
setwd("C:/Users/Bort Wu/Desktop/Classes/Fall 2026/asp/week2/assignment_lab2")

log_file <- file("correctness_checks.txt", open = "wt")
sink(log_file, type = "output")
sink(log_file, type = "message") # Captures error messages if stopifnot fails

# Generate random data
source(file.path("R", "gendata.r"))

# Path for the function code
functions_path <- file.path("R", "functions.r")

if (!file.exists(functions_path)) {
  stop(
    paste0(
      "Cannot find '", functions_path, "'. ",
      "Set the working directory to the assignment_lab2 folder and try again."
    ),
    call. = FALSE
  )
}

source(functions_path)


# Small example for tests
x_test <- c(0, 1)
y_test <- c(0, 0.5, 2)

expected <- matrix(
  c(0, 0.5, 2, 
    1, 0.5, 1),
  nrow = 2,
  byrow = TRUE
)

d_loop <- thresholded_distance_loop(x_test, y_test, threshold = 0.5)
d_vec_dense <- thresholded_distance_vectorized(x_test, y_test, threshold = 0.5)
d_vec_sparse <- thresholded_distance_sparse(x_test, y_test, threshold = 0.5)

# Large results
x_large <- lab2_vectors[[1]]
y_large <- lab2_vectors[[2]]

# Calculate pairwise distances using different methods for large vectors
d_loop_large <- thresholded_distance_loop(x_large, y_large, threshold = 0.5)
d_dense_large <- thresholded_distance_vectorized(x_large, y_large, threshold = 0.5)
d_sparse_large <- thresholded_distance_sparse(x_large, y_large, threshold = 0.5)

stopifnot(
# The Task 3 result equals expected
  isTRUE(all.equal(d_loop, expected, tolerance = 1e-12)),
# The Task 4 result equals expected
  isTRUE(all.equal(d_vec_dense, expected, tolerance = 1e-12)),
# as.matrix() of the Task 5 result equals expected
  isTRUE(all.equal(as.matrix(d_vec_sparse), expected, tolerance = 1e-12)),
# The large results have dimensions 3000 by 5000
  isTRUE(identical(dim(d_loop_large), c(3000L, 5000L))),
  isTRUE(identical(dim(d_dense_large), c(3000L, 5000L))),
  isTRUE(identical(dim(d_sparse_large), c(3000L, 5000L))),

# Every dense output entry is either 0 or at least 0.5
  isTRUE(all(d_loop == 0 | d_loop >= 0.5)),
  isTRUE(all(d_vec_dense == 0 | d_vec_dense >= 0.5)),
# All distances exactly equal to 0.5 are preserved
  isTRUE(all.equal(
  target = d_vec_sparse[d_vec_dense == 0.5], 
  current = rep(0.5, sum(d_vec_dense == 0.5)), 
  tolerance = 1e-12)),
 # Task 5 has the same number of nonzero entries as Task 4
  isTRUE(sum(d_vec_dense != 0) == nnzero(d_vec_sparse))
)

cat("PASS: The Task 3 result equals expected.\n",
    "The Task 4 result equals expected.\n",
    "as.matrix() of the Task 5 result equals expected.\n",
    "The large results have dimensions 3000 by 5000.\n",
    "Every dense output entry is either 0 or at least 0.5.\n",
    "All distances exactly equal to 0.5 are preserved.\n",
    "Task 5 has the same number of nonzero entries as Task 4.")

# invalid_vector_error <- tryCatch(
#   {
#     thresholded_distance_vectorized(c(0, NA_real_), y, threshold = 0.5)
#     NA_character_
#   },
#   error = function(e) conditionMessage(e)
# )
# 
# stopifnot(
#   !is.na(invalid_vector_error),
#   grepl("non-empty numeric vector", invalid_vector_error, fixed = TRUE)
# )
# 
# cat("PASS: invalid vector inputs return an informative error.\n")
cat("All Tasks 3-5 correctness checks passed.\n")

timing <- data.frame(
  experiment = "3000 x 5000 absolute differences",
  method = c(
    "nested loop",
    "vectorized with dense matrix",
    "vectorized with sparse matrix"
  ),
  elapsed_seconds = c(
    elapsed_seconds(thresholded_distance_loop, x_large, y_large, threshold = 0.5),
    elapsed_seconds(thresholded_distance_vectorized, x_large, y_large, threshold = 0.5),
    elapsed_seconds(thresholded_distance_sparse, x_large, y_large, threshold = 0.5)
  ),
  stored_result_bytes = c(
    object.size(d_loop_large),
    object.size(d_dense_large),
    object.size(d_sparse_large)
  ),
  nonzero_entries = c(
    Matrix::nnzero(d_loop_large),
    Matrix::nnzero(d_dense_large),
    Matrix::nnzero(d_sparse_large)
  ),
  stringsAsFactors = FALSE
)

# Calculate time gain (time_loop/time_vectorized)
timing$time_gain <-
  timing$elapsed_seconds[1] / timing$elapsed_seconds

# Percentage reduction in elapsed time
timing$time_reduction_percent <-
  100 * (1 - timing$elapsed_seconds / timing$elapsed_seconds[1])

# Task 4 to Task 5 final-object memory reduction

timing$memory_reduction_percent <- c(NA, NA,
  100 * (1 - as.numeric(object.size(d_sparse_large))/
           as.numeric(object.size(d_dense_large))))

dir.create("results", showWarnings = FALSE)

write.csv(
  timing,
  file = file.path("results", "small_timing.csv"),
  row.names = FALSE
)

# cat("Tasks 3-5 timing:\n")
# print(timing)

# Reset console output
sink(type = "message")
sink(type = "output")
close(log_file)