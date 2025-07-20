library(ggplot2)
df <- data.frame(
  x       = 1:5,
  exports = c(5,4,3,2,1),
  imports = c(1,2,3,4,5)
)

test_that("geom_balance_of_trade layers exist", {
  g <- ggplot(df, aes(x, exports = exports, imports = imports)) +
    geom_balance_of_trade()
  expect_s3_class(g, "ggplot")
  # check that the layer has our stat and geom
  l <- g$layers[[1]]
  expect_identical(l$stat, StatBalanceOfTrade)
  expect_identical(l$geom, GeomBalanceOfTrade)
})
