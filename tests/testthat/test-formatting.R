context("Formatting")

test_that("basic formatting", {
  ten <- as.currency(10)

  expect_equal(show(ten), "$10")
  expect_equal(show(-ten), "-$10")
})
