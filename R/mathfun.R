#' @include currency.R
NULL

#
# Methods for math and summary functions on Currency objects.
#
# By default, math functions operating on Currency objects should
# return "numeric" type.
#

#' @export
setMethod("Math", signature = "Currency",
          function(x) {
            callGeneric(x@.Data)
          })


# The exceptions:

#' @export
setMethod("abs", signature = "Currency",
          function(x) {
            x@.Data <- abs(x@.Data)
            x@original <- abs(x@original)
            x
          })

#' @export
setMethod("max", signature = "Currency",
          function(x) {
            vals <- as.numeric(x)
            x[which.max(vals)]
          })

#' @export
setMethod("min", signature = "Currency",
          function(x) {
            vals <- as.numeric(x)
            x[which.min(vals)]
          })

# range

# sum

# prod

# cumsum

# cumprod

# cummin

# cummin

# ceiling

# floor

# trunc

# round

# signif
