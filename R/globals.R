## in R/globals.R
if (getRversion() >= "2.15.1") {
  utils::globalVariables(
    c("x", "exports", "imports",
      "ymin", "ymax",
      "direction", "group")
  )
}