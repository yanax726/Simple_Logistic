#' Fit a Simple Logistic Regression Model
#'
#' This function fits a logistic regression model using a simplified interface.
#'
#' @importFrom stats glm predict binomial
#'
#' @param formula A formula specifying the model.
#' @param data A data frame containing the variables in the model.
#' @param ... Additional arguments passed to \code{\link[stats]{glm}}.
#'
#' @return An object of class \code{"simple_logistic"} containing:
#' \item{call}{The matched call.}
#' \item{formula}{The model formula.}
#' \item{fit}{The fitted \code{glm} model.}
#' \item{predicted_prob}{Predicted probabilities from the model.}
#'
#' @details
#' This function is a wrapper around \code{glm()} with \code{family = binomial()}.
#' It simplifies the process of fitting logistic regression models.
#'
#' @examples
#' library(SimpleLogistic)
#' data("health_data")
#' model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)
#' summary(model$fit)
#'
#' @export
simple_logistic <- function(formula, data, ...) {
  # Check inputs
  if (missing(formula) || missing(data)) {
    stop("Error: Provide both 'formula' and 'data'.")
  }
  if (!inherits(formula, "formula")) {
    stop("Error: 'formula' must be valid.")
  }
  if (!is.data.frame(data)) {
    stop("Error: 'data' must be a data frame.")
  }

  # Fit model
  fit <- glm(formula, data = data, family = binomial(), ...)

  # Predicted probabilities
  predicted_prob <- predict(fit, type = "response")

  # Return results
  result <- list(
    call = match.call(),
    formula = formula,
    fit = fit,
    predicted_prob = predicted_prob
  )
  class(result) <- "simple_logistic"

  return(result)
}

