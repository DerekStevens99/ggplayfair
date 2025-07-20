test_that("balance does exports minus imports", {
  expect_equal(balance(10, 4), 6)
  expect_equal(balance(c(5,2), c(1,3)), c(4, -1))
})
