
# Convert, manipulate, and provide formatted display of monetary values.

## **Warning**: this is pre-alpha code. 

**Many of the features described below have not yet been implemented, or are broken. Use at your own risk**

The `currency` R package provides an S4 object that can be used to store, do arithmetic, validate, and pretty-print monetary numbers. 

With it, you can:

* Use a user-defined table of exchange rates to convert a monetary value into a "base currency" (see below), while retaining the original currency value and unit.
* Validate that a converted monetary value is consistent with the exchange rate table.
* Perform arithmetic on currency values.
* Format monetary values in arbitrary currency units, allowing for control over the currency sign and its position, separators, and abbreviations such as "thousand" and "million".

## Use cases

This package is intended to be used in scenarios where you have monetary values in a variety of currencies, but want to do data analysis using a common "base currency" while still having the ability to report the results of that analysis in any currency unit. For example, you may have data reported in U.S. Dollars, Euros, and Yen. You want to do all of the analysis using USD as a base currency, but you still need to be able to generate reports, for example, in both Euros and USD.

`currency` uses a static exchange rate table that cannot easily be changed. This makes it suitable for cases where it is reasonable to use an average exchange rate (e.g. [as required by the U.S. Internal Revenue Service for tax calculation](http://www.irs.gov/Individuals/International-Taxpayers/Yearly-Average-Currency-Exchange-Rates)). This package is singularly **not** suitable for use cases where accounting for the fluctuations in exchange rates is essential.



## Installation

This package is not yet released on CRAN.

To install the development version:
`
devtools::install_github("numeroushats/currency")
`


## Usage

A `currency` object can be constructed using `currency()` or `as.currency()`, which optionally takes an argument specifying the original currency unit.

The `currency` object inherits from the base R `numeric` class, so most arithmetic operations and functions that operate on numerical values (e.g. `mean()`) work as expected. The class of the returned value is intended to be consisent with the general principle of [dimensional analysis](https://en.wikipedia.org/wiki/Dimensional_analysis): e.g. a `currency` divided by a `numeric` is a `currency`, but a `numeric` divided by a `currency` or a `currency` divided by a `currency` is a `numeric`. See the documentation for full details.

By default, the base currency is U.S. Dollars, but this and the formatting behavior can be costomized.

Please see the associated vignette for a full demonstration of usage and configuration.
