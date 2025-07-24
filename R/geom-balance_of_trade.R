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
#' @description `geom_balance_of_trade()` creates a custom ggplot2 ribbon that visualizes the balance of trade by shading the area between exports and imports. 
#' @param mapping     Set of aesthetic mappings, see \code{\link[ggplot2]{geom_ribbon}}  
#' @note
#' If you map `exports`/`imports` in the global `aes()`, you'll see:
#'   \"The following aesthetics were dropped…exports and imports.\"
#' This simply means the stat used them to compute the ribbon and then removed
#' them—your plot still renders correctly. To suppress this warning, simply move
#' the aes to the geom_balance_of_trade() call.
#' @param data        A data frame (defaults to the plot-level data)  
#' @param stat        Stat to use (defaults to \code{StatBalanceOfTrade})  
#' @param geom        Geom to use (defaults to \code{GeomBalanceOfTrade})  
#' @param position    Position adjustment  
#' @param ...         Other arguments passed on to the layer (e.g. \code{na.rm})  
#' @param na.rm       If \code{TRUE}, remove \code{NA}s  
#' @param show.legend Should this layer be included in the legend?  
#' @return A ggplot2 layer representing the balance of trade. Within the layer with be a colored ribbon and two lines and point sets representing your imports and exports
#' @export
geom_balance_of_trade <- function(data = NULL, mapping = NULL,
                                  stat        = StatBalanceOfTrade,
                                  geom        = GeomBalanceOfTrade,
                                  position    = "identity",
                                  ...,
                                  na.rm       = FALSE,
                                  show.legend = NA) {
  
  # only the *after_stat* aesthetics here:
  computed_map <- aes(
    ymin  = after_stat(ymin),
    ymax  = after_stat(ymax),
    fill  = after_stat(direction),
    group = after_stat(group)
  )
  
  ribbon <- layer(
    data        = data,
    mapping     = computed_map,
    stat        = stat,
    geom        = geom,
    position    = position,
    show.legend = show.legend,
    #prevents warning from dropping exports/imports
    inherit.aes = T,   
    params      = list(na.rm = na.rm, ...)
  )
  
  exports_line  <- geom_line(aes(y = exports),  colour = "forestgreen", inherit.aes = TRUE)
  exports_point <- geom_point(aes(y = exports), colour = "forestgreen", inherit.aes = TRUE)
  imports_line  <- geom_line(aes(y = imports),  colour = "firebrick",   inherit.aes = TRUE)
  imports_point <- geom_point(aes(y = imports), colour = "firebrick",   inherit.aes = TRUE)
  
  list(ribbon, exports_line, exports_point, imports_line, imports_point)
}
