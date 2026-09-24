######################################################
#                                                    #
# Problem Set 1, Question 5: full analysis           #
#                                                    #
# tests/pset1_q5_test.R                              #
#                                                    #
# Simulate in parallel and save the distribution.    #
#                                                    #
######################################################

functions_path <- file.path("R", "functions_pset1_q5.R")
plot_path <- file.path("results", "randomization_distribution_for_tests.pdf")

source(functions_path)

# We use the tea-tasting example from Q4 as a test for our functions
# Suppose we have 8 cups (4 milk-first and 4 tea-first cups). 
# The participant classifies 4 of those cups as tea-first.
# Therefore, n_per_type = 4.Recall that the number of actual milk-first cups
# is equal to the number of actual tea-first cups equal to the number of
# cups classified as tea-first.

expected_p_value <- 1/70

# We should also expect to reject the null hypothesis.

library(parallel)
library(ggplot2)
# Settings
B <- 100000
s_obs <- 8 # The number of correctly classified cups is 8

# Set up parallel cluster
n_cores <- detectCores() # 8 cores in total
cl <- makeCluster(n_cores)

# Reproducible parallel RNG
clusterSetRNGStream(cl, iseed = 4210)

# Split simulations across cores
B_each <- rep(B %/% n_cores, n_cores)

# Simulate tea-tasting experiments
s_sim <- sim_tea_taste(cl, B_each = B, n_per_type = 4)

sim_dist_plot <- dist_plot(s_sim, s_obs, n_per_type = 4)

p <- one_sided_p(s_sim, s_obs) # Presumably it should be very close to 0.01429

ggsave(
  filename = plot_path,
  plot = sim_dist_plot,
  width = 1100 / 140,
  height = 700 / 140,
  dpi = 140,
  units = "in"
)

   isTRUE(p < 0.05)

  cat("Simulations:", length(s_sim), "\n") # 100000
  cat("Observed score entered:", s_obs, "\n") # 8
  cat("One-sided Monte Carlo p-value:", p, "\n") # 0.00033
  cat("Distribution plot:", plot_path, "\n") 

  