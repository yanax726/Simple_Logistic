# R/plot_predictions.R

#' Plot Predicted Probabilities Against Actual Outcomes
#'
#' This function creates a histogram of predicted probabilities, colored by actual outcomes.
#'
#' @importFrom ggplot2 ggplot aes geom_histogram labs theme_minimal
#' @importFrom rlang .data
#'
#' @param model An object of class \code{"simple_logistic"}.
#' @param newdata (Optional) A new data frame for which to make predictions.
#'
#' @return A ggplot object showing the distribution of predicted probabilities.
#'
#' @details
#' This plot helps visualize how well the model's predicted probabilities align with the actual outcomes.
#'
#' @examples
#' library(SimpleLogistic)
#' data("health_data")
#' model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)
#' plot_predictions(model)
#'
#' @export
plot_predictions <- function(model, newdata = NULL) {
  # Ensure the model is of the correct class
  if (!inherits(model, "simple_logistic")) {
    stop("The model must be of class 'simple_logistic'.")
  }

  # If newdata is provided, use it; otherwise, use the original data
  if (!is.null(newdata)) {
    if (!is.data.frame(newdata)) {
      stop("'newdata' must be a data frame.")
    }

    # Check if the outcome variable exists in newdata
    if (!"outcome" %in% names(newdata)) {
      stop("The outcome variable 'outcome' is missing in the data.")
    }

    predicted_prob <- predict(model$fit, newdata = newdata, type = "response")
    plot_data <- data.frame(outcome = newdata$outcome, predicted_prob = predicted_prob)
  } else {
    plot_data <- data.frame(outcome = model$fit$y, predicted_prob = model$predicted_prob)
  }

  # Plot histogram of predicted probabilities colored by actual outcomes
  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$predicted_prob, fill = factor(.data$outcome))) +
    ggplot2::geom_histogram(position = "identity", alpha = 0.5, bins = 30) +
    ggplot2::labs(
      title = "Predicted Probabilities vs Actual Outcomes",
      x = "Predicted Probability",
      y = "Count",
      fill = "Actual Outcome"
    ) +
    ggplot2::theme_minimal()

  return(p)
}


