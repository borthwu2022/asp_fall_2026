######################################################
#                                                    #
# Problem Set 1, Question 5: tea tasting             #
#                                                    #
# R/functions_pset1_q5.R                             #
#                                                    #
# Simulate the null distribution, calculate the      #
# one-sided p-value, and plot the results.           #
#                                                    #
######################################################


# (a) and (b) Monte Carlo simulation
# By assumption, in the tea-tasting experiment, the number of actual tea-first
# cups is equal to that of actual milk-first cups as well as that of cups 
# classified as tea-first.
 
sim_tea_taste <- function(cl, B_each, n_per_type){
sim_list <- parLapply(
  cl,
  B_each,
  function(nsim) {

# Number of correctly identified tea-first cups X
# As shown above, X follows a hypergeometric distribution
    
    X <- rhyper( 
      nsim,
      m = n_per_type,# number of actual tea-first cups
      n = n_per_type, # number of actual milk-first cups
      k = n_per_type # number of cups classified as tea-first
    )

    # Total number correctly classified (both tea-first and milk-first)
    2 * X
  }
)

stopCluster(cl)

s_sim <- unlist(sim_list)

}

# (c). Plot the randomization distribution

# s_sim is the object resulting from sim_tea_taste

dist_plot <- function(s_sim, s_obs, n_per_type) {
 
  df <- data.frame(s_sim = s_sim)

 p <- ggplot(df, aes(x = s_sim)) +
  # Histogram 
  geom_histogram(
    aes(y = after_stat(density)),
    breaks = seq(-1, 2 * n_per_type + 1, by = 2),
    fill = "steelblue",
    color = "white"  
  ) +
  # Vertical line for observed S with dynamic legend text
  geom_vline(
    aes(xintercept = s_obs, linetype = paste("Observed S =", s_obs)),
    linewidth = 0.8
  ) +
  scale_linetype_manual(
    name = NULL,
    values = "dashed"
  ) +
  # Labels and title
  labs(
    title = "Monte Carlo randomization distribution",
    x = "Number correctly classified, S",
    y = "Density"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = c(0.85, 0.85),
    legend.background = element_blank(),
    legend.key = element_blank()
  )
 
 p
}


# (d). Estimate the p-value

one_sided_p <- function(s_sim, s_obs) {
 
    monte_carlo = mean(s_sim >= s_obs)
}
