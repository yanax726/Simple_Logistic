context("SimpleLogistic Package Tests")

test_that("simple_logistic function works correctly", {
  data("health_data")

  # Test with correct inputs
  model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)
  expect_s3_class(model, "simple_logistic")
  expect_s3_class(model$fit, "glm")

  # Test with missing data
  expect_error(simple_logistic(outcome ~ age + bmi + treatment), "Error: Provide both 'formula' and 'data'.")

  # Test with incorrect formula
  expect_error(simple_logistic("outcome ~ age", data = health_data), "Error: 'formula' must be valid.")
})

test_that("diagnostic_plots function works correctly", {
  data("health_data")
  model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)

  # Test with correct model
  plots <- diagnostic_plots(model)
  expect_true(is.list(plots))
  expect_true(all(sapply(plots, function(p) inherits(p, "ggplot"))))

  # Test with incorrect model
  expect_error(diagnostic_plots(model$fit), "Error: The model must be of class 'simple_logistic'.")
})

test_that("plot_predictions function works correctly", {
  data("health_data")
  model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)

  # Test with model data
  plot <- plot_predictions(model)
  expect_s3_class(plot, "ggplot")

  # Test with new data
  new_data <- data.frame(
    age = c(30, 40, 50),
    bmi = c(22, 27, 29),
    treatment = c("A", "B", "A"),
    outcome = c(0, 1, 1)
  )
  plot_new <- plot_predictions(model, newdata = new_data)
  expect_s3_class(plot_new, "ggplot")

  # Test with missing outcome variable
  new_data_missing <- new_data[, -4]
  expect_error(plot_predictions(model, newdata = new_data_missing), "Error: The outcome variable 'outcome' is missing in the data.")
})


