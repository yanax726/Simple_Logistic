context("SimpleLogistic Package Tests")

library(testthat)
library(SimpleLogistic)

# Load the health_data
data("health_data")

test_that("simple_logistic function works correctly", {
  # Test with correct inputs
  model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)
  expect_s3_class(model, "simple_logistic")
  expect_s3_class(model$fit, "glm")

  # Test with missing data
  expect_error(simple_logistic(outcome ~ age + bmi + treatment), "Error: Provide both 'formula' and 'data'.")

  # Test with incorrect formula
  expect_error(simple_logistic("outcome ~ age", data = health_data), "Error: 'formula' must be valid.")

  # **New Test: Test with 'data' not being a data frame**
  expect_error(
    simple_logistic(outcome ~ age + bmi + treatment, data = "not_a_data_frame"),
    "Error: 'data' must be a data frame."
  )
})
