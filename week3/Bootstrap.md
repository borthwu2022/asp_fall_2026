# Bootstrap

$$
X = \{X_1, \cdots, X_n\} \sim F_0 \\
\text{We compute a statistic of interest:}\\
T(X)\\
\text{For inference, we need the sampling distribution of }T(X):\\
G_n(t, F_0) = \Pr\{T(X) \leq t\}
$$

This distribution could be a complicated function of the unknown population distribution $F_0$. 



The inferential problem is always the same:

$$
G_n(t, F_0) \text{ depends on an unknown }F_0
$$

Asymptotics: Sample $\rightarrow$ Population

Bootstrap: Sample of a sample $\rightarrow$ Sample 

Replace the unknown $F_0$ with the empirical distribution $\hat{F}_n$. Use simulation to approximate $G_n(t, \hat{F}_n)$.



## Empirical Distribution

$$
\hat{F}_n(x) = \frac{1}{n}\sum_{i=1}^n \mathbb{I}(X_i \leq x)
$$

The target parameter is a functional $\theta = T(F)$, so the plug-in estimator is:

$$
\hat{\theta} = T(\hat{F})
$$



## Nonparametric Bootstrap

The goal of the bootstrap is to approximate the sampling distribution:

$$
\mathcal{L}_F(\hat{\theta}-\theta)
$$

using only the observed sample.



## Where does bootstrap approximation error come from?

The bootstrap method replaces an unknown object with an observable one. Ideally we want:

$$
\mathcal{L}_F(\hat{\theta}-\theta) \approx \mathcal{L}_{\hat{F}_n}(\hat{\theta}^{*}-\hat{\theta})

$$

This approximation depends on $n$ and on whether the bootstrap is valid for the statistic $T$.



**Monte Carlo approximation:** we cannot usually calculate the bootstrap distribution exactly, so we approximate it using only $B$ bootstrap replications:

$$
\mathcal{L}_{\hat{F}_n}(\hat{\theta}^{*} - \hat{\theta})\approx
\{\hat{\theta}^{*(1)}-\hat{\theta},\cdots, \hat{\theta}^{*(B)} - \hat{\theta}\}
$$

## Bootstrap bias estimate



The bootstrap estimate of finite-sample bias is:

$$
\hat{bias}_{boot} = \mathbb{E}(\hat{\theta^*})- \hat{\theta} \approx 
\bar{\theta^*} - \hat{\theta}
$$


