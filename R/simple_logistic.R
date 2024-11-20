# R/simple_logistic.R

#' Fit a Simple Logistic Regression Model
#'
#' This function fits a logistic regression model using an easy-to-use interface.
#'
#' @importFrom stats glm predict binomial
#'
#' @param formula A formula specifying the model, e.g., outcome ~ age + bmi + treatment.
#' @param data A data frame containing the variables used in the model.
#' @param ... Additional arguments to pass to \code{glm}.
#'
#' @return An object of class \code{"simple_logistic"} that includes:
#' \item{call}{The function call.}
#' \item{formula}{The model formula.}
#' \item{fit}{The fitted \code{glm} model.}
#' \item{predicted_prob}{Predicted probabilities from the model.}
#'
#' @details
#' This function is a wrapper around \code{glm()} with \code{family = binomial()}.
#' It makes it easier to fit logistic regression models without dealing with all the parameters.
#'
#' @examples
#' library(SimpleLogistic)
#' data("health_data")
#' model <- simple_logistic(outcome ~ age + bmi + treatment, data = health_data)
#' summary(model$fit)
#'
#' @export
simple_logistic <- function(formula, data, ...) {
  # Make sure formula and data are provided
  if (missing(formula) || missing(data)) {
    stop("Provide both 'formula' and 'data'.")
  }

  # Check if formula is valid
  if (!inherits(formula, "formula")) {
    stop("'formula' must be valid.")
  }

  # Check if data is a data frame
  if (!is.data.frame(data)) {
    stop("'data' must be a data frame.")
  }

  # Fit the logistic regression model
  fit <- glm(formula, data = data, family = binomial(), ...)

  # Get predicted probabilities
  predicted_prob <- predict(fit, type = "response")

  # Create a list to store the results
  result <- list(
    call = match.call(),
    formula = formula,
    fit = fit,
    predicted_prob = predicted_prob
  )

  # Assign class "simple_logistic" to the result
  class(result) <- "simple_logistic"

  return(result)
}

