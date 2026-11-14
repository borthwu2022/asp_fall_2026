library(Rcpp)
library(microbenchmark)

# Load R functions
r_function_path <- file.path("R_functions","functions.R")
source(r_function_path)

# Load C++ functions
Rcpp::sourceCpp("src/functions.cpp", rebuild = TRUE)

# 1. Evenness

n_vec <- as.integer(c(4, 7, 10, 15))

output_r <- sapply(n_vec, r_even) # T F T F
output_cpp <- sapply(n_vec, evenCpp)


# 2. Step function
n_step_vec <- c(-3, 0, 3, 5, 10)

output_step_r <- sapply(n_step_vec, stepR) # 0 1 1 2 2

output_step_cpp <- sapply(n_step_vec, stepCpp)


# 3. Approximate pi

set.seed(2016)
N <- as.integer(c(100,1e3, 1e4, 1e5))

output_pi_r <- sapply(N, piR)
output_pi_cpp <- sapply(N, piCpp)

df_accuracy <- data.frame(
  accuracy_r = round(abs(output_pi_r - pi),3),
  accuracy_cpp = round(abs(output_pi_cpp - pi),3)
)

df_accuracy$compare <- round(df_accuracy$accuracy_r - 
                               df_accuracy$accuracy_cpp, 3)

df_accuracy

# accuracy_r accuracy_cpp compare
# 1      0.058        0.062  -0.004
# 2      0.054        0.014   0.040
# 3      0.004        0.011  -0.007
# 4      0.001        0.001   0.000

# 4. Matrix multiplication
set.seed(1234)
nrow <- 100
ncol <- 100

mat_A <- matrix(runif(nrow*ncol), nrow = nrow, ncol = ncol)

mat_B <- matrix(runif(nrow*ncol), nrow = nrow, ncol = ncol)

# R function
out_mat_r <- multiplyR(mat_A, mat_B)

# C++
output_mat_cpp <- multiplyCpp(mat_A, mat_B)

# R default %*%
C <- mat_A %*% mat_B  # C = A %*% B

# Verify both functions return C
isTRUE(all.equal(out_mat_r, C)) && 
  isTRUE(all.equal(output_mat_cpp, C)) # TRUE

# Compare execution times

microbenchmark(
  R = multiplyR(mat_A, mat_B),
  Cpp = multiplyCpp(mat_A, mat_B),
  R_default = mat_A %*% mat_B,
  times = 100
)

# Unit: microseconds
#       expr     min      lq      mean   median       uq      max neval
#          R 23369.6 25319.4 34495.058 35267.80 37569.05 117325.7   100
#        Cpp 15942.9 16364.5 17748.500 17177.85 18098.00  25182.9   100
#  R_default   516.2   541.3   750.135   568.95   663.45  12728.2   100

# The default %*% function is the fastest. 
# The custom R function is faster than the Cpp function.

# 5. Fibonacci
n_vec <- c(10, 20, 30)

output_fib_r <- sapply(n_vec, fibR)

output_fib_cpp <- sapply(n_vec, fibCpp)

isTRUE(all.equal(output_fib_r, output_fib_cpp)) # TRUE

microbenchmark(
  R10 = fibR(10),
  Cpp10 = fibCpp(10),
  R20 = fibR(20),
  Cpp20 = fibCpp(20),
  R30 = fibR(30),
  Cpp30 = fibCpp(30),
  times = 2
)

# Unit: microseconds
#   expr       min        lq       mean     median        uq       max neval
#    R10     509.2     509.2     589.75     589.75     670.3     670.3     2
#  Cpp10      14.9      14.9      16.05      16.05      17.2      17.2     2
#    R20   76812.5   76812.5   78869.00   78869.00   80925.5   80925.5     2
#  Cpp20      78.4      78.4      83.85      83.85      89.3      89.3     2
#    R30 8730174.0 8730174.0 8754716.15 8754716.15 8779258.3 8779258.3     2
#  Cpp30    9547.3    9547.3   10120.20   10120.20   10693.1   10693.1     2