$$
\text{The step goes: } n/2, n/2^2, n/2^3, \cdots, n/2^k
$$

Pinpoint the middle element and compare the middle element to the target number. These count as one single operation/step. So for a vector of length n, we need to take a  maximum of $k = \lfloor \log_2n \rfloor + 1$ steps.



If we combine the two processes (e.g., binary search and bubble sort), the order of complexity is dominated by the more complex one:

$$
T^{*}(n) = \Theta(n^2)
$$

The order of complexity is different than computation time (which is also dependent on the complexity and efficiency of your code)



The constant clearly affects how fast the algorithm is, but not how its running time scales as the problem gets larger. 



## Comparing common orders of complexity

1 - $\log n$ - $n$ - $n \log n$ - $n^2$ - $n^3$ - $2^n$

where $f(n)$ is less complex than $g(n)$ means:

$$
\lim_{n\to \infty} \frac{f(n)}{g(n)} = 0
$$



Copying objects to the memory is a bad practice. It creates unncessary overhead.



log-exp/log-sum-exp is a trick to get around numerical instability. 



$$
\max_{i}\vert f_1(x_i) - f_0(x_i) \vert \leq \delta \text{ then evaluate }
\frac{T_0}{T_1} \text{. The larger, the better.}
$$


