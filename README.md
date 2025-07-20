---
title: "README"
author: "Derek Stevens"
date: "2025-07-20"
output: html_document
---

# ggplayfair
  
<!-- badges: start -->
[![R-CMD-check](https://github.com/DerekStevens99/ggplayfair/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/DerekStevens99/ggplayfair/actions/workflows/R-CMD-check.yaml)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/ggplayfair)](https://CRAN.R-project.org/package=ggplayfair)
<!-- badges: end -->

## About:

Makes Playfair graphs easier to create using ggplot.

## How to Use `ggplayfair`

This section provides a quickstart guide for installing and using the `ggplayfair` package to create balance of trade charts with `ggplot2`.

---

### Installation

Install the latest CRAN release:

```{r}
#install.packages("ggplayfair")
```

Or install the development version from GitHub:

```{r}
# If you don’t have devtools installed:
#install.packages("devtools")
library(devtools)

devtools::install_github("DerekStevens99/ggplayfair")
```

---

### Basic Usage

Load the package and prepare your data frame. Your data should include:

- `x`: the x-axis variable (e.g., year, quarter)
- `exports`: numeric values representing deficit lessening activity.
- `imports`: numeric values representing deficit driving activity.

```r
library(ggplot2)
library(ggplayfair)

# sample data
df <- data.frame(
  year    = 2000:2010,
  exports = c(50, 55, 60, 58, 62, 65, 63, 67, 70, 72, 75),
  imports = c(45, 50, 52, 55, 58, 60, 100, 120, 68, 70, 74)
)

# one line - geom_balance_of_trade - builds the Playfair‐style ribbon + lines + points
ggplot(df, aes(x = year, exports = exports, imports = imports)) +
  geom_balance_of_trade(alpha = 0.6) +
  scale_fill_manual(
    values = c(surplus = "forestgreen", deficit = "firebrick")
  ) +
  labs(
    title    = "Balance of Trade",
    subtitle = "Exports vs Imports, 2000–2010"
  ) +
  theme_minimal()
```

---

### Customization

- **Colors**: override default with `scale_fill_manual()` or any `scale_fill_*()`.
- **Themes**: apply any `ggplot2` theme (e.g., `theme_classic()`, `theme_dark()`).
- **Labels**: customize with `labs()` or `scale_x_*()`, `scale_y_*()` functions.

---

