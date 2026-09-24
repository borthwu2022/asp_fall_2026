######################################################
#                                                    #
# Problem Set 1, Question 5: full analysis           #
#                                                    #
# R/Q5_run_analysis.R                                #
#                                                    #
# Simulate in parallel and save the distribution.    #
#                                                    #
######################################################

functions_path <- file.path("R", "functions_pset1_q5.R")
plot_path <- file.path("results", "Q5_randomization_distribution.pdf")

source(functions_path)

library(parallel)
library(ggplot2)
# Settings
B <- 100000
s_obs <- 67

# Set up parallel cluster
n_cores <- detectCores() # 8 cores in total
cl <- makeCluster(n_cores)

# Reproducible parallel RNG
clusterSetRNGStream(cl, iseed = 4210)

# Split simulations across cores
B_each <- rep(B %/% n_cores, n_cores)

# Simulate tea-tasting experiments
s_sim <- sim_tea_taste(cl, B_each = B, n_per_type = 50)

sim_dist_plot <- dist_plot(s_sim, s_obs, n_per_type = 50)

p <- one_sided_p(s_sim, s_obs)

ggsave(
  filename = plot_path,
  plot = sim_dist_plot,
  width = 1100 / 140,
  height = 700 / 140,
  dpi = 140,
  units = "in"
)

  cat("Simulations:", length(s_sim), "\n") # 100000
  cat("Observed score entered:", s_obs, "\n") # 67
  cat("One-sided Monte Carlo p-value:", p, "\n") # 0.00033
  cat("Distribution plot:", plot_path, "\n") 

  if (p < 0.01) {
    cat("Reject the null hypothesis at the 1% significance level.\n")
  } else {
    cat("Do not reject the null hypothesis at the 1% significance level.\n")
  }
 # Reject the null

