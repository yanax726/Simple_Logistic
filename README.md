
# SimpleLogistic

[![Codecov test
coverage](https://codecov.io/gh/yanax726/Simple_Logistic/graph/badge.svg)](https://app.codecov.io/gh/yanax726/Simple_Logistic)

## Introduction

**SimpleLogistic** is an R package I developed to simplify the process
of performing logistic regression analysis, especially tailored for
health data science applications. It provides easy-to-use functions for
fitting logistic regression models, generating diagnostic plots, and
visualizing predicted probabilities. Whether you’re a student just
getting started with logistic regression or a practitioner analyzing
health outcomes, this package aims to make your workflow more efficient
and intuitive.

## Features

- **Easy Model Fitting**: Quickly fit logistic regression models using a
  simple function.
- **Diagnostic Plots**: Generate basic diagnostic plots to check your
  model.
- **Prediction Visualization**: Plot predicted probabilities against
  actual outcomes.
- **Interaction Terms**: Easily include interaction terms in your
  models.
- **Performance Benchmarking**: Compare the efficiency of
  simple_logistic() with R’s base glm() function using the bench
  package.
- **Comprehensive Vignette**: Access a detailed guide with examples and
  explanations to help you make the most of the package.
- **Compatibility with Base R**: Works smoothly with base R functions
  for further analysis.

## Installation

You can install **SimpleLogistic** from GitHub:

``` r
# Install devtools if you haven't already
install.packages("devtools")

# Load devtools
library(devtools)

# Install SimpleLogistic from GitHub
install_github("yourusername/SimpleLogistic")
```

Make sure to replace “yourusername/SimpleLogistic” with the actual path
to your GitHub repository.

## Getting Started

### Load the package and the example dataset:

``` r
library(SimpleLogistic)

# Load the example dataset
data("health_data")

# Look at the first few rows
head(health_data)
#>   outcome      age      bmi treatment
#> 1       1 44.39524 33.79524         A
#> 2       1 47.69823 30.24965         A
#> 3       1 65.58708 23.93942         B
#> 4       1 50.70508 27.17278         B
#> 5       0 51.29288 23.34264         A
#> 6       1 67.15065 23.09501         A
```

#### The health_data dataset includes:

**outcome**: Binary outcome variable (0 or 1) **age**: Age in years
**bmi**: Body Mass Index **treatment**: Treatment group (“A” or “B”)

## Usage

### Fitting a Logistic Regression Model

Use the simple_logistic() function to fit a model:

``` r
# Fit the model
model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)

# View the summary
summary(model$fit)
#> 
#> Call:
#> glm(formula = formula, family = binomial(), data = data)
#> 
#> Coefficients:
#>             Estimate Std. Error z value Pr(>|z|)    
#> (Intercept) -6.38664    1.52871  -4.178 2.94e-05 ***
#> age          0.09024    0.01989   4.536 5.74e-06 ***
#> bmi          0.11340    0.04185   2.710 0.006729 ** 
#> treatmentB  -1.14974    0.32451  -3.543 0.000396 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 272.12  on 199  degrees of freedom
#> Residual deviance: 229.28  on 196  degrees of freedom
#> AIC: 237.28
#> 
#> Number of Fisher Scoring iterations: 4
```

This function simplifies the model fitting process by wrapping around
the glm() function, allowing you to focus more on interpreting results
rather than setting up the model.

### Generating Diagnostic Plots

After fitting your model, it’s essential to check how well it fits the
data. The diagnostic_plots() function helps you create two key
diagnostic plots.

``` r
# Generate diagnostic plots
plots <- diagnostic_plots(model)
#> Setting levels: control = 0, case = 1
#> Setting direction: controls < cases

# Residuals vs Fitted Values
print(plots$residuals_vs_fitted)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

``` r

# ROC Curve
print(plots$roc_curve)
```

<img src="man/figures/README-unnamed-chunk-5-2.png" width="100%" />
These plots help you assess the goodness-of-fit and the model’s ability
to discriminate between outcome classes.

### Visualizing Predicted Probabilities

Understanding the distribution of predicted probabilities can provide
valuable insights into your model’s performance. Use the
plot_predictions() function to visualize this.

``` r
# Plot predicted probabilities
plot_predictions(model)
#> Warning: Use of `data[[outcome_var]]` is discouraged.
#> ℹ Use `.data[[outcome_var]]` instead.
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" /> This
histogram shows how predicted probabilities are distributed across
actual outcome classes, helping you gauge the model’s effectiveness.

### Efficiency Benchmarking

Efficiency matters, especially with large datasets. Here’s how you can
benchmark the performance of simple_logistic() against R’s base glm()
function using the bench package.

``` r
# Create a larger dataset for benchmarking
set.seed(123)
n_large <- 10000
age_large <- rnorm(n_large, mean = 50, sd = 10)
bmi_large <- rnorm(n_large, mean = 25, sd = 4)
treatment_large <- sample(c("A", "B"), n_large, replace = TRUE)
logit_large <- -5 + 0.05 * age_large + 0.1 * bmi_large + ifelse(treatment_large == "A", 0.5, -0.5)
prob_large <- 1 / (1 + exp(-logit_large))
outcome_large <- rbinom(n_large, size = 1, prob = prob_large)
health_data_large <- data.frame(
  outcome = outcome_large,
  age = age_large,
  bmi = bmi_large,
  treatment = treatment_large
)

# Benchmarking the simple_logistic function against glm
bench_simple_logistic <- bench::mark(
  simple_logistic_model = simple_logistic(outcome ~ age + bmi + treatment, data = health_data_large),
  glm_model = glm(outcome ~ age + bmi + treatment, data = health_data_large, family = binomial()),
  iterations = 10,
  check = FALSE  # Disable result comparison
)

print(bench_simple_logistic)
#> # A tibble: 2 × 13
#>   expression      min median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time
#>   <bch:expr>   <bch:> <bch:>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm>
#> 1 simple_logi… 15.5ms 15.9ms      62.8    19.9MB     41.9     6     4     95.6ms
#> 2 glm_model    15.4ms 15.6ms      64.1    19.9MB    289.      2     9     31.2ms
#> # ℹ 4 more variables: result <list>, memory <list>, time <list>, gc <list>
```

Note: We set check = FALSE because simple_logistic() and glm() return
different types of objects. This setting allows us to focus solely on
benchmarking the performance without worrying about result equivalence.

#### Interpreting the Results:

The benchmark will provide metrics like median execution time, minimum
and maximum times, memory allocations, and garbage collections. You can
compare how simple_logistic() stacks up against glm() in terms of speed
and memory usage.

## Advanced Usage

### Including Interaction Terms

Sometimes, the relationship between a predictor and the outcome might
depend on another predictor. You can include interaction terms in your
model formula to explore these dynamics.

``` r
# Fit a model with an interaction term
model_interaction <- simple_logistic(outcome ~ age * treatment + bmi, data = health_data)

# Summarize the model
summary(model_interaction$fit)
#> 
#> Call:
#> glm(formula = formula, family = binomial(), data = data)
#> 
#> Coefficients:
#>                Estimate Std. Error z value Pr(>|z|)    
#> (Intercept)    -6.76732    1.81287  -3.733 0.000189 ***
#> age             0.09876    0.02951   3.347 0.000818 ***
#> treatmentB     -0.38286    1.93841  -0.198 0.843426    
#> bmi             0.11244    0.04183   2.688 0.007181 ** 
#> age:treatmentB -0.01580    0.03943  -0.401 0.688687    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 272.12  on 199  degrees of freedom
#> Residual deviance: 229.12  on 195  degrees of freedom
#> AIC: 239.12
#> 
#> Number of Fisher Scoring iterations: 4
```

In this example, age \* treatment includes both the main effects and
their interaction. This allows you to see if the effect of age on
outcome changes depending on the treatment group.

### Making Predictions on New Data

After fitting a model, you might want to make predictions on new
observations. Here’s how you can do that.

``` r
# New data for prediction
new_data <- data.frame(
  age = c(35, 45, 55),
  bmi = c(24, 28, 31),
  treatment = c("A", "B", "A")
)

# Predict probabilities
new_data$predicted_prob <- predict(model$fit, newdata = new_data, type = "response")

# View predictions
print(new_data)
#>   age bmi treatment predicted_prob
#> 1  35  24         A      0.3759883
#> 2  45  28         B      0.4254698
#> 3  55  31         A      0.8901211
```

This adds a predicted_prob column to your new_data dataframe, showing
the estimated probability of outcome being 1 for each new observation.

### Comparing with Base R Functions

It’s always a good practice to ensure that your custom functions are
producing results consistent with established base R functions. Here’s
how you can compare the coefficients from simple_logistic() with those
from glm() to verify their consistency.

``` r
# Fit a model using glm()
model_glm <- glm(outcome ~ age + bmi + treatment, data = health_data, family = binomial())

# Compare coefficients
all.equal(coef(model$fit), coef(model_glm))
#> [1] TRUE
```

The all.equal() function checks if the coefficients from both models are
nearly identical, ensuring that simple_logistic() is functioning
correctly.

## Dataset

The package includes a simulated dataset health_data with:

- **outcome:** Binary outcome variable (0 or 1)
- **age:** Age in years
- **bmi:** Body Mass Index
- **treatment:** Treatment group (“A” or “B”) You can load it using:

``` r
data("health_data")
head(health_data)
#>   outcome      age      bmi treatment
#> 1       1 44.39524 33.79524         A
#> 2       1 47.69823 30.24965         A
#> 3       1 65.58708 23.93942         B
#> 4       1 50.70508 27.17278         B
#> 5       0 51.29288 23.34264         A
#> 6       1 67.15065 23.09501         A
```

## Dependencies

SimpleLogistic uses the following R packages: - **ggplot2** for
plotting. - **pROC** for ROC curve analysis. - **rlang** For tidy
evaluation. Additionally, for benchmarking and documentation:

- **bench** For performance benchmarking.
- **knitr and rmarkdown** For creating vignettes and documentation.
- **testthat** For running tests. You can install them with:

``` r
install.packages(c("ggplot2", "pROC", "rlang", "bench", "knitr", "rmarkdown", "testthat"))
```

## Contributing

If you have suggestions for improvements, find any issues, or want to
contribute to the development of SimpleLogistic, feel free to open an
issue or submit a pull request on GitHub.

## License

This project is licensed under the MIT License.

I hope SimpleLogistic is helpful for your logistic regression analyses,
especially if you’re just getting started with R and statistical
modeling.

For more examples and detailed usage, check out the package vignette:

``` r
browseVignettes("SimpleLogistic")
```
