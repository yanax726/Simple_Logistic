# R/diagnostic_plots.R

#' Generate Diagnostic Plots for a Logistic Regression Model
#'
#' This function creates two diagnostic plots: residuals vs fitted values and an ROC curve.
#'
#' @importFrom stats residuals fitted
#' @importFrom pROC roc
#' @importFrom ggplot2 ggplot aes geom_point labs theme_minimal
#' @importFrom rlang .data
#'
#' @param model An object of class \code{"simple_logistic"}.
#'
#' @return A list with two ggplot objects:
#' \item{residuals_vs_fitted}{Plot of residuals vs fitted values.}
#' \item{roc_curve}{ROC curve showing model performance.}
#'
#' @details
#' These plots help you understand how well your model fits the data and how good it is at predicting outcomes.
#'
#' @examples
#' library(SimpleLogistic)
#' data("health_data")
#' model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)
#' plots <- diagnostic_plots(model)
#' print(plots$residuals_vs_fitted)
#' print(plots$roc_curve)
#'
#' @export
diagnostic_plots <- function(model) {
  # Ensure the model is of the correct class
  if (!inherits(model, "simple_logistic")) {
    stop("The model must be of class 'simple_logistic'.")
  }

  # Get residuals and fitted values
  residuals <- residuals(model$fit, type = "deviance")
  fitted_values <- fitted(model$fit)
  df_residuals <- data.frame(Fitted = fitted_values, Residuals = residuals)

  # Plot Residuals vs Fitted
  p1 <- ggplot2::ggplot(df_residuals, ggplot2::aes(x = .data$Fitted, y = .data$Residuals)) +
    ggplot2::geom_point(alpha = 0.6) +
    ggplot2::labs(title = "Residuals vs Fitted", x = "Fitted Values", y = "Residuals") +
    ggplot2::theme_minimal()

  # Create ROC Curve
  roc_obj <- pROC::roc(model$fit$y, fitted_values)
  df_roc <- data.frame(
    FalsePositiveRate = 1 - roc_obj$specificities,
    TruePositiveRate = roc_obj$sensitivities
  )

  p2 <- ggplot2::ggplot(df_roc, ggplot2::aes(x = .data$FalsePositiveRate, y = .data$TruePositiveRate)) +
    ggplot2::geom_line() +
    ggplot2::geom_abline(linetype = "dashed", color = "red") +
    ggplot2::labs(title = "ROC Curve", x = "False Positive Rate", y = "True Positive Rate") +
    ggplot2::theme_minimal()

  # Return the plots
  list(
    residuals_vs_fitted = p1,
    roc_curve = p2
  )
}

