# data-raw/health_data.r

set.seed(123)  # For reproducibility

n <- 200  # Number of observations

# Simulate age and bmi using stats::rnorm()
age <- stats::rnorm(n, mean = 50, sd = 10)
bmi <- stats::rnorm(n, mean = 25, sd = 4)

# Simulate treatment groups
treatment <- sample(c("A", "B"), n, replace = TRUE)

# Calculate the logit (linear predictor)
logit <- -5 + 0.05 * age + 0.1 * bmi + ifelse(treatment == "A", 0.5, -0.5)

# Convert logit to probability
prob <- 1 / (1 + exp(-logit))

# Simulate the binary outcome using stats::rbinom()
outcome <- stats::rbinom(n, size = 1, prob = prob)

# Create the data frame
health_data <- data.frame(
  outcome = outcome,
  age = age,
  bmi = bmi,
  treatment = treatment
)

# Save the dataset
usethis::use_data(health_data, overwrite = TRUE)
