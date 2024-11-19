# SimpleLogistic

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/yanax726/Simple_Logistic/graph/badge.svg)](https://app.codecov.io/gh/yanax726/Simple_Logistic)
<!-- badges: end -->

The goal of SimpleLogistic is to …

## Installation

You can install the development version of SimpleLogistic from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("yanax726/Simple_Logistic")
```

# SimpleLogistic

A simplified approach to logistic regression analysis in R, tailored for health data science applications.

## Introduction

**SimpleLogistic** is an R package I developed to make logistic regression easier, especially for those working with health data. It provides functions for fitting logistic regression models, creating diagnostic plots, and visualizing predicted probabilities. I hope this package makes it easier for students and practitioners to perform logistic regression without getting too bogged down in coding details.

## Features

- **Easy Model Fitting**: Quickly fit logistic regression models using a simple function.
- **Diagnostic Plots**: Generate basic diagnostic plots to check your model.
- **Prediction Visualization**: Plot predicted probabilities against actual outcomes.
- **Interaction Terms**: Easily include interaction terms in your models.
- **Compatibility with Base R**: Works smoothly with base R functions for further analysis.

## Installation

You can install **SimpleLogistic** from GitHub:

```r
# Install devtools if you don't have it
install.packages("devtools")

# Install SimpleLogistic from GitHub
devtools::install_github("yourusername/SimpleLogistic")
```

## Getting Started
### Load the package and the example dataset:
```r
library(SimpleLogistic)

# Load the example dataset
data("health_data")

# Look at the first few rows
head(health_data)
```
## Usage
### Fitting a Logistic Regression Model
Use the simple_logistic() function to fit a model:
```r
# Fit the model
model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)

# View the summary
summary(model$fit)
```
### Generating Diagnostic Plots
Create diagnostic plots to assess the model:
```r
# Generate diagnostic plots
plots <- diagnostic_plots(model)

# Residuals vs Fitted Values
print(plots$residuals_vs_fitted)

# ROC Curve
print(plots$roc_curve)
```
### Visualizing Predicted Probabilities
Plot the predicted probabilities:
```r
# Plot predicted probabilities
plot_predictions(model)
```
## Advanced Usage
### Including Interaction Terms
Include interaction terms in the model:
```r
# Fit a model with an interaction term
model_interaction <- simple_logistic(outcome ~ age * treatment + bmi, data = health_data)

# Summarize the model
summary(model_interaction$fit)
```
### Making Predictions on New Data
Predict outcomes for new data:
```r
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
```
### Comparing with Base R Functions
Check that the results are consistent with base R's glm() function:
```r
# Fit a model using glm()
model_glm <- glm(outcome ~ age + bmi + treatment, data = health_data, family = binomial())

# Compare coefficients
all.equal(coef(model$fit), coef(model_glm))
```
## Dataset
The package includes a simulated dataset health_data with:

- **outcome:** Binary outcome variable (0 or 1)
- **age:** Age in years
- **bmi:** Body Mass Index
- **treatment:** Treatment group ("A" or "B")
You can load it using:
```r
data("health_data")
```
## Dependencies
SimpleLogistic uses the following R packages:
**ggplot2** for plotting.
**pROC** for ROC curve analysis.
You can install them with:
```r
install.packages(c("ggplot2", "pROC"))
```
## Contributing
If you have suggestions or find any issues, feel free to open an issue or pull request on GitHub.

## License
This project is licensed under the MIT License.

I hope SimpleLogistic is helpful for your logistic regression analyses, especially if you're just getting started with R and statistical modeling.

For more examples and detailed usage, check out the package vignette:
```r
browseVignettes("SimpleLogistic")
```
