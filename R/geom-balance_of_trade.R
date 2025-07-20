#' @importFrom ggplot2 aes after_stat layer geom_line geom_point
#' @importFrom ggplot2 GeomRibbon
#' @importFrom ggplot2 draw_key_polygon
NULL


#' GeomBalanceOfTrade
#'
#' A ribbon between exports and imports, automatically coloring surplus vs deficit.
#'
#' @export
GeomBalanceOfTrade <- ggplot2::ggproto(
  "GeomBalanceOfTrade", ggplot2::GeomRibbon,
  default_aes = ggplot2::aes(
    fill = direction,         # <-- automatic mapping
    colour = NA,
    linetype = 1,
    linewidth = 0,
    alpha = NA
  ),
  draw_key = ggplot2::draw_key_polygon
)


#' @title geom_balance_of_trade
#' @description …  
#' @param mapping     Set of aesthetic mappings, see \code{\link[ggplot2]{geom_ribbon}}  
#' @param data        A data frame (defaults to the plot-level data)  
#' @param stat        Stat to use (defaults to \code{StatBalanceOfTrade})  
#' @param geom        Geom to use (defaults to \code{GeomBalanceOfTrade})  
#' @param position    Position adjustment  
#' @param ...         Other arguments passed on to the layer (e.g. \code{na.rm})  
#' @param na.rm       If \code{TRUE}, remove \code{NA}s  
#' @param show.legend Should this layer be included in the legend?  
#' @export
geom_balance_of_trade <- function(data = NULL, mapping = NULL,
                                  stat         = StatBalanceOfTrade,
                                  geom         = GeomBalanceOfTrade,
                                  position     = "identity",
                                  ...,
                                  na.rm        = FALSE,
                                  show.legend  = NA) {
  
  # after-stat mapping for ribbon
  ribbon_map <- aes(
    ymin      = after_stat(ymin),
    ymax      = after_stat(ymax),
    fill      = after_stat(direction),
    group     = after_stat(group)
  )
  
  # 1) the ribbon layer
  ribbon <- layer(
    data        = data,
    mapping     = ggplot2::aes(
      x      = x,
      exports = exports,
      imports = imports,
      ymin   = after_stat(ymin),
      ymax   = after_stat(ymax),
      fill   = after_stat(direction),
      group  = after_stat(group)
    ),
    stat        = stat,
    geom        = geom,
    position    = position,
    show.legend = show.legend,
    inherit.aes = FALSE,        # ← don’t pull in global aes(exports, imports) to silence warning
    params      = list(na.rm = na.rm, ...)
  )
  # 2) export line + points
  exports_line  <- geom_line(aes(y = exports),  colour = "forestgreen", inherit.aes = TRUE)
  exports_point <- geom_point(aes(y = exports), colour = "forestgreen", inherit.aes = TRUE)
  
  # 3) import line + points
  imports_line  <- geom_line(aes(y = imports), colour = "firebrick", inherit.aes = TRUE)
  imports_point <- geom_point(aes(y = imports), colour = "firebrick", inherit.aes = TRUE)
  
  list(ribbon, exports_line, exports_point, imports_line, imports_point)
}
