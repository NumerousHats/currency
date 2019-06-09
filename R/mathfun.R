#' @include currency.R
NULL

#
# Methods for math functions on Currency objects.
#
# Apart from a few exceptions, math functions operating on Currency objects should
# return "numeric" type.
#

#' @export
# setMethod("Math", signature(e1 = "Currency"),
#           function(e1) {
#             callGeneric(e1@.Data)
#           })

