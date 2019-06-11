#' \code{makePriorityMapFN} normali
#'
#' @author Tati Micheletti (TRIADE)
#'
#' This functions normalizes relative rasters for better plotting
#'
#' @export
#' @param ras  An \code{RasterLayer} object to be normalized.
#' @importFrom raster getValues setValues
#'
#' @examples
#' library("raster")
#' ras <- raster::raster(ncol = 10, nrow = 10, val = runif(100, 0, 10))
#' rasNorm <- normali(ras)

normali <- function(ras){
  normVals <- (raster::getValues(x = ras) -
                 min(raster::getValues(x = ras), na.rm = TRUE))/
    (max(raster::getValues(x = ras), na.rm = TRUE) -
       min(raster::getValues(x = ras), na.rm = TRUE))
  ras <- raster::setValues(x = ras, values = normVals)
  return(ras)
}
