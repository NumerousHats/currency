#' An S4 class to represent currency values.
#'
#' Currency is a subclass of "numeric", and is intended to perform currency
#' conversions, store original unconverted values and the original currency
#' unit, and provide formatted output in the form of strings like "$33 thousand"
#' instead of "33000".
#'
#' @slot type The original currency unit before conversion.
#' @slot original The original currency value before conversion.
setClass("Currency",
         contains = "numeric",
         slots = c(type = "character", original = "numeric")
         )

currency <- function(x, type = "USD") {
  # TODO make sure x is numeric

  # dummy exchange rates
  exchange_rate <- c(EUR=0.88, GBP=0.76, JPY=111)

  original <- x
  if (type != "USD") {
    x <- x/exchange_rate[type]
  }

  new("Currency", .Data = x, type = type, original = original)
}

#' @export
is.currency <- function(x) is(x, c("Currency"))

millionize <- function(x, prefix="$", suffixes=c("",
                                                 "thousand",
                                                 "million",
                                                 "billion",
                                                 "trillion")) {
  index <- floor(log10(x)/3)+1
  index <- ifelse(index < 1, 1, index)
  index <- ifelse(index > length(suffixes), length(suffixes), index)
  divisor <- 10^(3*(index-1))

  formatted <- ifelse(x < 1000,
                      sprintf("%s%s %s", prefix,
                              formatC(x/divisor, format = "f", digits=0),
                              suffixes[index]),
                      sprintf("%s%s %s", prefix,
                              formatC(x/divisor, format = "f", digits=1,
                                      drop0trailing = TRUE),
                              suffixes[index])
  )

  formatted <- ifelse(is.na(x), "NA", formatted)
  trimws(formatted)
}


#' Do fancy printing of currency values.
#'
#' This is currently a proof-of-principle example.
#'
#' @param x An currency object.
#' @param original A boolean indicating whether to print the original,
#'   unconverted value.
#'
#' @return A formatted string
#'
#' @export
format.Currency <- function(x, original=FALSE, ...) {
  if (original) {
    paste(millionize(x@original, prefix = ""), x@type)
  } else {
    millionize(x@.Data)
  }
}

get_currency_type <- function(curr) curr@type
get_currency_original <- function (curr) curr@original

#' @export
as.currency <- function(x, ...) standardGeneric("as.currency")

setGeneric("as.currency")

#' @export
setMethod("as.currency", signature(x = "Currency"), function(x, ...) {
  stopifnot(inherits(x, "Currency"))
  x
})

#' @export
setMethod("as.currency", signature(x = "numeric"), function(x, ...) {
  currency(x, ...)
})

#' @export
setMethod("c", signature(x = "Currency"), function(x, ...) {
  elements <- lapply(list(...), as.currency)
  vals <- c(x@.Data, unlist(elements@.Data))
  currencies <- c(x@type, sapply(elements, get_currency_type))
  originals <- c(x@original, sapply(elements, get_currency_original))
  new("Currency", .Data = vals, type = currencies, original = originals)
})

#' @export
setMethod("rep", signature(x = "Currency"), function(x, ...) {
  new("Currency", .Data = rep(x@.Data, ...), type = rep(x@type, ...),
      original = rep(x@original, ...))
})

#' @export
setMethod("[", signature(x = "Currency"),
          function(x, i, j, ..., drop = TRUE) {
            new("Currency", x@.Data[i], type = x@type[i], original = x@original[i])
          }
)

#' @export
setMethod("[[", signature(x = "Currency"),
          function(x, i, j, ..., exact = TRUE) {
            new("Currency", x@.Data[i], type = x@type[i], original = x@original[i])
          }
)

#' @export
setMethod("[<-", signature(x = "Currency"), function(x, i, j, ..., value) {
  if (is.currency(value)) {
    x@.Data[i] <- value@.Data
    x@type[i] <- value@type
    x@original[i] <- value@original
  } else {
    x@.Data[i] <- value
    x@type[i] <- NA
    x@original[i] <- NA
  }
  new("Currency", x@.Data, type = x@type, original = x@original)
})

#' @export
setMethod("[[<-", signature(x = "Currency"), function(x, i, j, ..., value) {
  if (is.currency(value)) {
    x@.Data[i] <- value@.Data
    x@type[i] <- value@type
    x@original[i] <- value@original
  } else {
    x@.Data[i] <- value
    x@type[i] <- NA
    x@original[i] <- NA
  }
  new("Currency", x@.Data, type = x@type, original = x@original)
})


#' @export
summary.Currency <- function(object, ...) summary(as.numeric(object, ...))

#' @export
setMethod("show", signature(object = "Currency"), function(object) {
  print(format.Currency(object))
})

