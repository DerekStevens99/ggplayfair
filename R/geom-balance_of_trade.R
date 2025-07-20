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


#' geom_balance_of_trade
#'
#' Fill between exports and imports, coloring surplus vs deficit.
#'
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
    mapping     = ribbon_map,
    stat        = stat,
    geom        = geom,
    position    = position,
    show.legend = show.legend,
    inherit.aes = TRUE,
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
