##============================
# Functions for EM Algorithm 
##============================



# To avoid log(0)
clip_prob <- function(x, eps = 1e-12) {
  pmin(pmax(x, eps), 1 - eps)
}

# Log-sum-exp identity
lse <- function(x, y) {

  # Find maximum
  z <- max(x, y)

  # Handle infinite values
  if (is.infinite(z)) return(z)

  # Apply LSE formula
  z + log(exp(x - z) + exp(y - z))
}


# Probability Kernel

delta_ga <- function(delta_g, a, log_scale = FALSE) {

  log_prob_val <- sum(
    delta_g * log(a) +
      (1 - delta_g) * log1p(-a)
  )

  if (log_scale) return(log_prob_val)

  return(exp(log_prob_val))
}


# Posterior Match Probability

gamma_g <- function(p, delta_g, m, u) {

  # Log joint probability of match
  log_delta_gm <- log(p) +
    delta_ga(delta_g, m, log_scale = TRUE)

  # Log joint probability of nonmatch
  log_delta_gu <- log1p(-p) +
    delta_ga(delta_g, u, log_scale = TRUE)

  # Log marginal probability
  log_denom <- lse(log_delta_gm, log_delta_gu)

  # Posterior match probability
  gamma <- exp(log_delta_gm - log_denom)

  return(gamma)
}


# Observed-Data Log-Likelihood

# Single agreement pattern
loglik_o_single <- function(delta_g, p, m, u) {

  log_delta_gm <- log(p) +
    delta_ga(delta_g, m, log_scale = TRUE)

  log_delta_gu <- log1p(-p) +
    delta_ga(delta_g, u, log_scale = TRUE)

  ell_o_single <- lse(log_delta_gm, log_delta_gu)

  return(ell_o_single)
}

# Full observed-data log-likelihood
loglik_o <- function(delta_mat, G, p, m, u) {

  loglik_vec <- numeric(length(G))

  for (g in seq_along(G)) {

    delta_g <- delta_mat[g, ]
    g_count <- G[g]

    ell_o_g <- loglik_o_single(delta_g, p, m, u)

    loglik_vec[g] <- g_count * ell_o_g
  }

  return(sum(loglik_vec))
}

# E-step

e_step <- function(delta_mat, p, m, u) {

  # Initialize vector of posterior probabilities
  gamma <- numeric(nrow(delta_mat))

  # Calculate gamma for every agreement pattern
  for (g in seq_len(nrow(delta_mat))) {

    delta_g <- delta_mat[g, ]

    gamma[g] <- gamma_g(
      p = p,
      delta_g = delta_g,
      m = m,
      u = u
    )
  }

  return(gamma)
}

# M-step

m_step <- function(delta_mat, G, gamma, eps = 1e-12) {

  # Expected counts for matches and nonmatches
  G_match <- G * gamma
  G_nonmatch <- G * (1 - gamma)

  # Expected total numbers of matches and nonmatches
  n_match <- sum(G_match)
  n_nonmatch <- sum(G_nonmatch)

  if (n_match <= 0 || n_nonmatch <= 0) {
    stop("One mixture component has zero expected weight.")
  }

  # 1. Update p
  p_new <- n_match / sum(G)

  # 2. Initialize m and u
  K <- ncol(delta_mat)

  m_new <- numeric(K)
  u_new <- numeric(K)

  # 3. Update m_k and u_k
  for (k in seq_len(K)) {

    m_new[k] <- sum(G_match * delta_mat[, k]) /
      n_match

    u_new[k] <- sum(G_nonmatch * delta_mat[, k]) /
      n_nonmatch
  }
  
  

  # 4. Return updated parameters
  return(list(
    p = clip_prob(p_new, eps),
    m = clip_prob(m_new, eps),
    u = clip_prob(u_new, eps)
  ))
}

# Multiple Random Starts (because EM does not automatically reach global max)

random_starts <- function(n_starts, K) {

  lapply(seq_len(n_starts), function(i) {

    list(
      p = runif(1, 0.00001, 0.01),
      m = runif(K, 0.5, 0.99),
      u = runif(K, 0.00001, 0.02)
    )
  })
}

# EM Algorithm with Random Starts

em_algorithm <- function(delta_mat, G,
                         n_starts = 20,
                         tol = 1e-10,
                         max_iter = 10000) {

  # 1. Generate random initializations
  starts <- random_starts(n_starts, ncol(delta_mat))

  # 2. Run EM for each initialization
  fits <- lapply(starts, function(start) {

    p <- start$p
    m <- start$m
    u <- start$u

    ll <- numeric(max_iter + 1)
    ll[1] <- loglik_o(delta_mat, G, p, m, u)

    converged <- FALSE

    for (iter in seq_len(max_iter)) {

      # E-step
      gamma <- e_step(delta_mat, p, m, u)

      # M-step
      params <- m_step(delta_mat, G, gamma)

      p <- params$p
      m <- params$m
      u <- params$u

      # Observed-data log-likelihood
      ll[iter + 1] <- loglik_o(delta_mat, G, p, m, u)

      # Convergence check
      if (abs(ll[iter + 1] - ll[iter]) <
          tol * (1 + abs(ll[iter]))) {
        converged <- TRUE
        break
      }
    }

    # Return results for this initialization
    list(
      p = p,
      m = m,
      u = u,
      gamma = e_step(delta_mat, p, m, u),
      loglik = ll[seq_len(iter + 1)],
      iterations = iter,
      converged = converged
    )
  })

  # 3. Compare final log-likelihoods
  final_ll <- sapply(fits, function(x) tail(x$loglik, 1))

  # Prefer converged runs
  converged_runs <- which(
    sapply(fits, function(x) x$converged)
  )

  candidates <- if (length(converged_runs) > 0) {
    converged_runs
  } else {
    seq_along(fits)
  }

  best <- candidates[which.max(final_ll[candidates])]

  # 4. Return the best model
  result <- fits[[best]]

  result$best_start <- best
  result$all_loglik <- final_ll

  return(result)
}