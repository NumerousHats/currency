#' @include currency.R
NULL

#
# Methods for arithmetic operations on currency objects.
#
# Operations will, in general, lose original currency information, e.g.
# the result of adding Euros to Dollars doesn't have a meaningful "original currency".
#
# Also, the results of some operations cannot be meaningfully interpreted as currency
# values, therefore the results of those operations are of type "numeric".
#

# Binary operations involving "Currency" should default to "numeric" output ####

#' @export
setMethod("Ops", signature(e1 = "Currency", e2 = "Currency"),
          function(e1, e2) {
            callGeneric(e1@.Data, e2@.Data)
          })

#' @export
setMethod("Ops", signature(e1 = "numeric", e2 = "Currency"),
          function(e1, e2) {
            callGeneric(e1@.Data, e2@.Data)
          })

#' @export
setMethod("Ops", signature(e1 = "Currency", e2 = "numeric"),
          function(e1, e2) {
            callGeneric(e1@.Data, e2@.Data)
          })


# Now, deal with the special cases that *should* return "Currency" ####

# Sums and differences ----

sumdiff <- function(e1, e2, value, original) {
  out <- currency(value)
  out@type <- NA_character_
  out@original <- NA_real_

  if (inherits(e1, "Currency") && inherits(e2, "Currency") &&
      !is.na(e1@type) && !is.na(e2@type) && e1@type == e2@type) {
      out@type <- e1@type
      out@original <- original
  }
  return(out)
}

#' @export
setMethod("+", signature(e1 = "Currency", e2 = "Currency"),
          function(e1, e2) {
            sumdiff(e1, e2,
                     callGeneric(e1@.Data, e2@.Data),
                     callGeneric(e1@original, e2@original))
          }
)

#' @export
setMethod("-", signature(e1 = "Currency", e2 = "Currency"),
          function(e1, e2) {
            sumdiff(e1, e2,
                     callGeneric(e1@.Data, e2@.Data),
                     callGeneric(e1@original, e2@original))
          }
)

#' @export
setMethod("+", signature(e1 = "Currency", e2 = "numeric"),
          function(e1, e2) {
            sumdiff(e1, e2, callGeneric(e1@.Data, e2), NA)
          }
)

#' @export
setMethod("-", signature(e1 = "Currency", e2 = "numeric"),
          function(e1, e2) {
            sumdiff(e1, e2, callGeneric(e1@.Data, e2), NA)
          }
)

#' @export
setMethod("+", signature(e1 = "numeric", e2 = "Currency"),
          function(e1, e2) {
            sumdiff(e1, e2, callGeneric(e1, e2@.Data), NA)
          }
)

#' @export
setMethod("-", signature(e1 = "numeric", e2 = "Currency"),
          function(e1, e2) {
            sumdiff(e1, e2, callGeneric(e1, e2@.Data), NA)
          }
)


# Currency mulitplied by numeric ----

#' @export
setMethod("*", signature(e1 = "Currency", e2 = "numeric"),
          function(e1, e2) {
            out <- currency(e1@.Data*e2)
            out@type <- e1@type
            out@original <- e1@original*e2
            out
          }
)


#' @export
setMethod("*", signature(e1 = "numeric", e2 = "Currency"),
          function(e1, e2) {
            out <- currency(e1*e2@.Data)
            out@type <- e1@type
            out@original <- e1*e2@original
            out
          }
)


# Currency divided by numeric ----

#' @export
setMethod("/", signature(e1 = "Currency", e2 = "numeric"),
          function(e1, e2) {
            out <- currency(e1@.Data/e2)
            out@type <- e1@type
            out@original <- e1@original/e2
            out
          }
)

# Unary minus ----

#' @export
setMethod("-", signature(e1 = "Currency", e2 = "missing"),
          function(e1) {
            out <- currency(-e1@.Data)
            out@type <- e1@type
            out@original <- -e1@original
            out
          }
)
