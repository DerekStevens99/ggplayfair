#' @importFrom ggplot2 aes after_stat layer geom_line geom_point
#' @importFrom ggplot2 GeomRibbon
#' @importFrom ggplot2 draw_key_polygon
NULL


#' StatBalanceOfTrade: split & interpolate exports–imports for ribbon plotting
#'
#' (Transforms a data frame with aesthetics \code{x}, \code{exports}, and \code{imports}
#'  into \code{ymin}, \code{ymax}, \code{direction}, and \code{group} for a ribbon.)
#' @export
StatBalanceOfTrade <- ggplot2::ggproto(
  "StatBalanceOfTrade", ggplot2::Stat,
  required_aes = c("x", "exports", "imports"),
  
  compute_group = function(data, scales) {
    data <- data[order(data$x), , drop = FALSE]
    net  <- data$exports - data$imports
    
    out       <- data.frame(x=double(), ymin=double(), ymax=double(),
                            direction=character(), group=integer(),
                            stringsAsFactors=FALSE)
    group_id  <- 1L
    start_idx <- 1L
    n         <- nrow(data)
    
    for (i in seq(2L, n)) {
      s0 <- sign(net[i-1L]); s1 <- sign(net[i])
      if (s0==0) s0 <- s1
      if (s1==0) s1 <- s0
      
      if (s0 != s1) {
        # crossing!
        x0 <- data$x[i-1L]; x1 <- data$x[i]
        e0 <- data$exports[i-1L]; e1 <- data$exports[i]
        m0 <- data$imports[i-1L]; m1 <- data$imports[i]
        
        denom <- (e1-e0) - (m1-m0)
        t     <- if (denom==0) 0 else (m0 - e0)/denom
        
        xc <- x0 + (x1-x0)*t
        yc <- e0 + (e1-e0)*t
        
        # 1) previous segment up to intercept
        seg <- data[start_idx:(i-1L), , drop=FALSE]
        seg_out <- data.frame(
          x         = c(seg$x,      xc),
          ymin      = c(pmin(seg$exports, seg$imports), yc),
          ymax      = c(pmax(seg$exports, seg$imports), yc),
          direction = if (net[start_idx] > 0) "surplus" else "deficit",
          group     = group_id,
          stringsAsFactors = FALSE
        )
        out <- rbind(out, seg_out)
        
        # 2) prepare next group, *starting at that same intercept*
        group_id <- group_id + 1L
        next_dir <- if (net[i] > 0) "surplus" else "deficit"
        next_row <- data.frame(
          x         = xc,
          ymin      = yc,
          ymax      = yc,
          direction = next_dir,
          group     = group_id,
          stringsAsFactors = FALSE
        )
        out <- rbind(out, next_row)
        
        start_idx <- i
      }
    }
    
    # final segment after last crossing
    seg     <- data[start_idx:n, , drop=FALSE]
    seg_out <- data.frame(
      x         = seg$x,
      ymin      = pmin(seg$exports, seg$imports),
      ymax      = pmax(seg$exports, seg$imports),
      direction = if (net[start_idx] > 0) "surplus" else "deficit",
      group     = group_id,
      stringsAsFactors = FALSE
    )
    out <- rbind(out, seg_out)
    
    # drop tiny groups (<2 points) and reorder
    ct   <- table(out$group)
    good <- as.integer(names(ct)[ct >= 2])
    out  <- out[out$group %in% good, , drop = FALSE]
    out  <- out[order(out$group, out$x), ]
    
    out
  }
)

