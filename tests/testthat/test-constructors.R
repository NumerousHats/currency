context("Constructors and numerical functions")

test_that("vectorization", {
  expect_equivalent(as.currency(1:2), c(as.currency(1), as.currency(2)))

  testvec <- as.currency(1:10)
  expect_equal(testvec[5]@.Data, 5)
  expect_equal(testvec[[7]]@.Data, 7)
  testvec[7] <- as.currency(1000, type="GBP")
  expect_equal(testvec[7]@.Data, 1000/.76)
  expect_equal(testvec[7]@original, 1000)
  expect_equal(testvec[7]@type, "GBP")

  testvec[5] <- as.currency(100)
  expect_equal(testvec[5]@.Data, 100)
  expect_equal(testvec[5]@original, 100)
  expect_equal(testvec[5]@type, "USD")
})

test_that("operations", {
  a <- as.currency(10)
  b <- as.currency(20)

  s <- a + b
  expect_s4_class(s, "Currency")
  expect_equal(s@type, "USD")
  expect_equal(s@original, 30)

  s <- b - a
  expect_s4_class(s, "Currency")
  expect_equal(s@type, "USD")
  expect_equal(s@original, 10)

  s <- a + 10
  expect_s4_class(s, "Currency")
  expect_true(is.na(s@type))
  expect_equal(s@.Data, 20)

  s <- b - 10
  expect_s4_class(s, "Currency")
  expect_true(is.na(s@type))
  expect_equal(s@.Data, 10)

  expect_equal(a*b, 200)
  expect_equal(a/b, 0.5)

  p <- b*10
  expect_s4_class(p, "Currency")
  expect_equal(p@.Data, 200)
  expect_equal(p@original, 200)

  q <- b/20
  expect_s4_class(q, "Currency")
  expect_equal(q@.Data, 1)
  expect_equal(q@original, 1)

  expect_equal(20/b, 1)
  expect_equal(a^2, 100)

  m <- -a
  expect_s4_class(m, "Currency")
  expect_equal(m@.Data, -10)
  expect_equal(m@original, -10)
})

test_that("math", {
  a <- as.currency(10)
  b <- as.currency(20)

  expect_equal(sqrt(a), sqrt(10))
})
