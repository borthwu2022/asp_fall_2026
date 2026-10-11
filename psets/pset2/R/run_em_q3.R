##=======================
# Run EM Algorithm for Q3
##=======================

function_path <- file.path("R","functions_for_em.R")

source(function_path)

delta_mat <- matrix(c(0,0,0,
                  1,0,0,
                  0,1,0,
                  0,0,1,
                  1,1,1), nrow = 5, byrow = T)

# Frequency for agreement patterns
G <- c(172738,2030,114,68,50)

# Fit EM Model

set.seed(123)

fit <- em_algorithm(
  delta_mat = delta_mat,
  G = G,
  n_starts = 50,
  tol = 1e-10,
  max_iter = 10000
)

# Best parameter estimates
fit$p
fit$m
fit$u

# Posterior match probabilities
fit$gamma

# Diagnostics
fit$best_start
fit$iterations
fit$converged

# Final log-likelihoods across random starts
fit$all_loglik

# Log-Likelihood Convergence

pdf("results/convergence_plot.pdf", width = 8, height = 6)

plot(
  0:(length(fit$loglik) - 1),
  fit$loglik,
  type = "l",
  col = "steelblue",
  lwd = 2,
  xlab = "Iteration",
  ylab = "Observed-Data Log-Likelihood",
  main = "EM Convergence: Best Random Start"
)

dev.off()