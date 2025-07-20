# CRAN submission comments for ggplayfair 0.1.0

## New in Version 0.1.1

- **bug fix with exports and imports globally not recognized**:
  * Fixes bug with improper naming scope

- **More extensive README**
  * Adds how to use sections and commentary


## Version 0.1.0

- **`geom_balance_of_trade()`**:  
  A single-call ggplot2 layer that  
  1. Fills the area _between_ two series (`exports` vs `imports`)  
  2. Automatically detects and interpolates crossing points  
  3. Splits and colors each segment **green** (surplus) or **red** (deficit)  
  4. Overlays the raw export/import lines and points  

- **StatBalanceOfTrade / GeomBalanceOfTrade**:  
  Underlying `ggproto` objects with  
  - Strict ordering of `x`  
  - Per-group splitting at sign changes  
  - Insertion of exact intercept rows  
  - Default `aes(fill = direction)`  

- **Documentation & tests**  
  - `roxygen2`-generated Rd files for both stat and geom  
  - Unit tests covering no-crossing and single-crossing scenarios  
  - GitHub Actions CI: all R CMD check, on Linux, macOS, Windows, pass with zero ERRORs/WARNINGs/NOTEs  

## Other changes

- Declared global variables via `utils::globalVariables()`  
- Added `importFrom(ggplot2, aes, after_stat, layer, geom_line, geom_point, GeomRibbon, draw_key_polygon)`  
- Cleaned up `.Rbuildignore` to drop stray PNGs  
- Added `LICENSE` (MIT + file LICENSE), updated DESCRIPTION  

## Testing platforms

- R 4.5.1 on macOS Sonoma 14.6.1  
- Linux (via GitHub Actions)  
- Windows (via GitHub Actions)  

## Dependencies

- Imports: **ggplot2** (>= 3.4.0)  
- Suggests: **testthat** (>= 3.0.0), **devtools**, **roxygen2**  

## Please note

- All examples run in < 1 second  
- No compiled code or external dependencies  
- Ready for CRAN; thank you for your review!  
