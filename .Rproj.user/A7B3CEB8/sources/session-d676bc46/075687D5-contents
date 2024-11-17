#' Plot Predicted Probabilities Against Observed Outcomes
#'
#' Visualizes predicted probabilities from a logistic regression model.
#'
#' @importFrom stats predict
#' @importFrom ggplot2 ggplot aes geom_histogram labs theme_minimal
#' @importFrom rlang .data
#'
#' @param model An object of class \code{"simple_logistic"}.
#' @param newdata Optional data frame for prediction. Defaults to model data.
#'
#' @return A ggplot object showing the distribution of predicted probabilities.
#'
#' @details
#' This function creates a histogram of predicted probabilities, colored by the actual outcome.
#' It helps in visualizing how well the model distinguishes between classes.
#'
#' @examples
#' library(SimpleLogistic)
#' data("health_data")
#' model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)
#' plot_predictions(model)
#'
#' @export
plot_predictions <- function(model, newdata = NULL) {
  # Check if the model is of the correct class
  if (!inherits(model, "simple_logistic")) {
    stop("Error: The model must be of class 'simple_logistic'.")
  }

  # Use new data if provided; otherwise, use the model's data
  data <- if (is.null(newdata)) {
    model$fit$data
  } else {
    newdata
  }

  # Ensure the outcome variable is present
  outcome_var <- as.character(model$formula[[2]])
  if (!(outcome_var %in% names(data))) {
    stop(paste("Error: The outcome variable '", outcome_var, "' is missing in the data.", sep = ""))
  }

  # Predict probabilities
  data$predicted_prob <- predict(model$fit, newdata = data, type = "response")

  # Create the plot
  plot <- ggplot2::ggplot(data, ggplot2::aes(x = .data$predicted_prob, fill = factor(data[[outcome_var]]))) +
    ggplot2::geom_histogram(alpha = 0.6, bins = 30, position = "identity") +
    ggplot2::labs(
      title = "Predicted Probabilities",
      x = "Predicted Probability",
      fill = "Outcome"
    ) +
    ggplot2::theme_minimal()

  # Return the ggplot object
  return(plot)
}

