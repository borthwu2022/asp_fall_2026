

samp <- function(pop, n, seed){
  if (!is.data.frame(pop)) {
    stop("The population data is not a data frame!")
  }
  
  if (nrow(pop) == 0L){
    stop("The population data has zero observations!")
  }
  
  # set seed for replicability
  set.seed(seed)
  
  # indices for observations
  pop.index <- rownames(lab1)
  
  samp.index <- sample(pop.index, n, replace = F)
  
  df.samp <- pop[samp.index,]
  
  return(df.samp)
}
