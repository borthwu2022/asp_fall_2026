# Problem Set 3

## Project Structure

```{text}
pset3/
|-- R_functions/
|   |-- functions.r     # compile R functions
|-- src/
|   |-- functions.cpp   # compile C++ functions
|-- tests/
|   |-- pset3_test.r    # test R and C++ functions and answer questions
|-- README.md           # write-up for Q3, Q4 and Q5
```

## Question 3

The accuracies of estimates for the R and C++ functions are shown in the table below:

|       | accuracy_r | accuracy_cpp | compare |
|:----- |:----------:|:------------:|:-------:|
| **1** | 0.058      | 0.062        | -0.004  |
| **2** | 0.054      | 0.014        | 0.040   |
| **3** | 0.004      | 0.011        | -0.007  |
| **4** | 0.001      | 0.001        | 0.000   |

As shown above, as the sample size $N$ increases, the accuracy increases for both functions. The difference between these two is very small.

## Question 4

*Unit: microseconds*

| expr          | min     | lq      | mean      | median   | uq       | max      | neval |
|:------------- |:-------:|:-------:|:---------:|:--------:|:--------:|:--------:|:-----:|
| **R**         | 23369.6 | 25319.4 | 34495.058 | 35267.80 | 37569.05 | 117325.7 | 100   |
| **Cpp**       | 15942.9 | 16364.5 | 17748.500 | 17177.85 | 18098.00 | 25182.9  | 100   |
| **R_default** | 516.2   | 541.3   | 750.135   | 568.95   | 663.45   | 12728.2  | 100   |

As shown above, the default function in $\texttt{R}$,  "$\texttt{\%*\%}$," is the fastest. The custom R function is faster than the C++ function. 

## Question 5

Let $T(n)$ denote the number of recursive function calls. Then

$$
T(n)=T(n-1)+T(n-2)+1
$$

with $T(0) = T(1) = 1$.

The solution is:

$$
T(n) = 2F_{n+1} -1
$$

$F_n = \Theta(\varphi^n)$, where $\varphi = (1+\sqrt{5})/2$. Therefore, we have:

$$
T(n) = \Theta(\varphi^n)
$$

In other words, the computation time for the Fibonacci function increases exponentially as $n$ increases. 

As shown in the table below, while C++ can reduce the computational cost, it does not eliminate the computational problem that arises from the recursive nature of the function. 

**Unit: microseconds**

| expr      | min       | lq        | mean       | median     | uq        | max       | neval |
|:--------- | ---------:| ---------:| ----------:| ----------:| ---------:| ---------:| -----:|
| **R10**   | 509.2     | 509.2     | 589.75     | 589.75     | 670.3     | 670.3     | 2     |
| **Cpp10** | 14.9      | 14.9      | 16.05      | 16.05      | 17.2      | 17.2      | 2     |
| **R20**   | 76812.5   | 76812.5   | 78869.00   | 78869.00   | 80925.5   | 80925.5   | 2     |
| **Cpp20** | 78.4      | 78.4      | 83.85      | 83.85      | 89.3      | 89.3      | 2     |
| **R30**   | 8730174.0 | 8730174.0 | 8754716.15 | 8754716.15 | 8779258.3 | 8779258.3 | 2     |
| **Cpp30** | 9547.3    | 9547.3    | 10120.20   | 10120.20   | 10693.1   | 10693.1   | 2     |
