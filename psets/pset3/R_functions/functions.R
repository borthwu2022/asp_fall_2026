#==============================
# Problem Set 3: C++ and R 
  
# R_functions/functions.R

# R functions
  
#===============================

# 1. R function for evaluating evenness
r_even <- function(x){
  
  stopifnot(is.numeric(x) && n %% 1 == 0)
  
  if (x%%2 == 0) return(TRUE) else return(FALSE)
}

# 2. Step function
stepR <- function(n){
  if (n < 0){
    return(0)
  }
  else if (n >= 0 & n < 5){
    return(1)
  }
  else{
    return(2)
  }
}


# 3. Approximate pi

piR <- function(N){
  
  stopifnot(N > 0 & is.integer(N))
  
  n_inside <- 0

for (i in 1:N) {
   xy <- runif(2)
    x <- xy[1]
    y <- xy[2]
    is_inside <- ifelse(x^2+y^2 <= 1, 1, 0)
    n_inside <- n_inside + is_inside
}
  return(4*n_inside/N)
}

# 4. Matrix multiplication

multiplyR <- function(A, B){
  
  stopifnot(is.matrix(A) & is.matrix(B))
  
  if (ncol(A) != nrow(B)) stop("The two matrices are not conformable!")
  
  AB <- matrix(nrow = nrow(A), ncol = ncol(B))
  
  i <- 1 
  
  while (i <= nrow(A)) {
    j <- 1
    while (j <= ncol(B)){
  AB[i,j] = sum(A[i,]*B[,j]) 
  j <- j + 1 
    }
    i <- i + 1
  }
  
  return(AB)
}

# 5. Fibonacci sequence

fibR <- function(n){
  
  stopifnot(is.numeric(n) && length(n) == 1 && n >= 0 && n %% 1 == 0)
  
    if (n < 2) return(n) else return(fibR(n-1) + fibR(n-2))
}
