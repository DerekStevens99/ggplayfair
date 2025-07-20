# ggplayfair 0.1.0

**2025-07-20**

## New features

- **`geom_balance_of_trade()`**:  
  A one-call ggplot2 layer that fills the area *between* two series (`exports` vs `imports`) and automatically colors each segment **green** for surplus and **red** for deficit.  
  - Detects every crossing between exports and imports  
  - Interpolates exact intercepts so ribbons split cleanly at the crossover point  
  - Draws the underlying export/import lines and points by default  

- **`StatBalanceOfTrade` ggproto**:  
  The statistical transformation powering `geom_balance_of_trade()`.  
  - Sorts data in ascending `x`  
  - Breaks series into segments at each sign‐change of (`exports - imports`)  
  - Inserts interpolated rows at crossovers  
  - Emits `ymin`, `ymax`, `direction`, and `group` columns for ribbon plotting  

- **`GeomBalanceOfTrade` ggproto**:  
  A subclass of `GeomRibbon` supplying a default `fill = direction` aesthetic, so users no longer need to map `fill` manually.

## Bug fixes & improvements

- Ribbon polygons now stitch seamlessly—no more jagged spikes or missing segments at crossovers.
- Silenced R CMD check notes:
  - Declared global variables via `utils::globalVariables()`
  - Added `importFrom(ggplot2, ...)` directives for all ggplot2 generics used
  - Removed stray example PNGs and updated `.Rbuildignore`
- Expanded unit tests for `StatBalanceOfTrade` to cover both no-crossing and single-crossing scenarios.

## CI / tooling

- **GitHub Actions**: R-CMD-check workflow enabled, badge added to README.
- Documentation generated with **roxygen2**, updated Rd files for both stat and geom.
- Test suite powered by **testthat**, now included in package and passing locally and in CI.

## Documentation

- Full examples and usage in `geom_balance_of_trade()` help page.
- A new vignette (coming soon) will demonstrate Playfair-style trade plots using real-world data.

---

Looking forward to hearing how people use this new geom to build elegant, historically inspired balance-of-trade charts!
