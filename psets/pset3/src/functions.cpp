// [[Rcpp::plugins(cpp17)]]

#include <Rcpp.h>
#include <cmath>

using namespace Rcpp;

// 1. Evenness
// [[Rcpp::export]]
bool evenCpp(int x) {
  return x % 2 == 0;
}


// 2. Step function
// [[Rcpp::export]]
int stepCpp(double n) {
  if (n < 0) {
    return 0;
  } else if (n < 5) {
    return 1;
  } else {
    return 2;
  }
}


// 3. Approximation of pi
// [[Rcpp::export]]
double piCpp(int N) {
  if (N <= 0) stop("N must be positive.");

  int n_inside = 0;

  for (int i = 0; i < N; i++) {
    double x = R::runif(0.0, 1.0);
    double y = R::runif(0.0, 1.0);

    if (x*x + y*y <= 1.0) {
      n_inside++;
    }
  }

  return 4.0 * n_inside / N;
}


// 4. Matrix multiplication
// [[Rcpp::export]]
NumericMatrix multiplyCpp(NumericMatrix A, NumericMatrix B) {
  if (A.ncol() != B.nrow()) {
    stop("The two matrices are not conformable!");
  }

  NumericMatrix AB(A.nrow(), B.ncol());

  for (int i = 0; i < A.nrow(); i++) {
    for (int j = 0; j < B.ncol(); j++) {
      double sum = 0.0;

      for (int k = 0; k < A.ncol(); k++) {
        sum += A(i, k) * B(k, j);
      }

      AB(i, j) = sum;
    }
  }

  return AB;
}


// 5. Fibonacci
// [[Rcpp::export]]
double fibCpp(double n) {
  if (!std::isfinite(n) || n < 0 || std::floor(n) != n) {
    stop("n must be a nonnegative integer.");
  }

  if (n < 2) {
    return n;
  } else {
    return fibCpp(n - 1) + fibCpp(n - 2);
  }
}
