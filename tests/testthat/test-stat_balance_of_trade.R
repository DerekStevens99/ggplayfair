# tests/testthat/test-stat_balance_of_trade.R

library(testthat)
library(ggplayfair)

test_that("StatBalanceOfTrade: no crossing yields one segment", {
  df <- data.frame(
    x       = 1:3,
    exports = c(5, 6, 7),
    imports = c(1, 2, 3)
  )
  
  res <- StatBalanceOfTrade$compute_group(df, scales = NULL)
  
  # should be a single group of length 3
  expect_equal(res$group, rep(1L, 3))
  expect_equal(res$direction, rep("surplus", 3))
  expect_equal(res$x, 1:3)
  expect_equal(res$ymin, c(1, 2, 3))
  expect_equal(res$ymax, c(5, 6, 7))
})

test_that("StatBalanceOfTrade: one crossing splits at intercept", {
  df <- data.frame(
    x       = c(0, 1),
    exports = c(2, 0),
    imports = c(0, 2)
  )
  
  res <- StatBalanceOfTrade$compute_group(df, scales = NULL)
  
  # Expect 4 rows: two for the "surplus" group and two for the "deficit" group
  expect_equal(res$group, c(1L, 1L, 2L, 2L))
  expect_equal(res$direction, c("surplus", "surplus", "deficit", "deficit"))
  
  # Intercept should fall at x = 0.5, y = 1
  expect_equal(res$x, c(0.0, 0.5, 0.5, 1.0), tolerance = 1e-6)
  expect_equal(res$ymin, c(0.0, 1.0, 1.0, 0.0), tolerance = 1e-6)
  expect_equal(res$ymax, c(2.0, 1.0, 1.0, 2.0), tolerance = 1e-6)
})
