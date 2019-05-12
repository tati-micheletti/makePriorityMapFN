#' \code{makePriorityMapFN} makePriorityMap
#'
#' This functions creates the priority map for cat management in
#' Fernando de Noronha. It downloads all needed data and creates
#' a raster object and saves it in the home directory
#'
#' @export
#'
#' @importFrom raster getValues setValues rasterize crop writeRaster
#' @importFrom rgeos gUnaryUnion gBuffer
#' @importFrom reproducible prepInputs postProcess
#' @importFrom data.table data.table
#' @importFrom magrittr %>%
#' @importFrom ggplot2 ggplot geom_tile guides theme element_blank guide_legend aes
#' @importFrom ggthemes theme_map
#' @importFrom viridis scale_fill_viridis
#' @importFrom methods as
#'
#' @examples
#' \dontrun{
#' mapa <- makePriorityMap()
#' }

makePriorityMap <- function(){

  # Load libraries
  message("Instalando bibliotecas necessárias... Recomendamos fazer update de todas as bibliotecas sugeridas.")
  # devtools::install_github("PredictiveEcology/reproducible@development")
  # library("reproducible")
  # reproducible::Require("raster")
  # reproducible::Require("rgeos")
  # reproducible::Require("ggplot2")
  # reproducible::Require("ggthemes")
  # reproducible::Require("viridis")
  # reproducible::Require("magrittr")
  # reproducible::Require("data.table")

  # Downloading data
  message("Fazendo download dos dados...")
  DEM <- reproducible::prepInputs(url = "https://drive.google.com/open?id=1PuddyT1Ncl2uuHXfMWJT9iUTpY7NuhhJ",
                                  targetFile = "fen_slope.tif",
                                  destinationPath = file.path(getwd(), "data"), filename2 = NULL) # Dias et. al 2017: Prospects raster.
  catSectors <- reproducible::prepInputs(url = "https://drive.google.com/open?id=1BVh3UNCBI8v12S1PbN9HpCZW0mL9otBP",
                                  targetFile = "areas.shp",
                                  archive = "areas.zip",
                                  alsoExtract = "similar",
                                  destinationPath = file.path(getwd(), "data"), filename2 = NULL) # Dias et. al 2017: Prospects raster.
  parnamar <- reproducible::prepInputs(url = "https://drive.google.com/open?id=1iVDpYFsM8r4jqJkHFKQz7l3mMapf2bvn",
                                       targetFile = "PARNAMAR_Clipped.shp",
                                       archive = "PARNAMAR_Clipped.zip",
                                       alsoExtract = "similar",
                                       destinationPath = file.path(getwd(), "data"), filename2 = NULL) # Dias et. al 2017: Prospects shapefile.

  message("Processando os dados...")
  parnamar <- rgeos::gUnaryUnion(spgeom = parnamar) %>%
    rgeos::gBuffer(byid = TRUE, width = 100) %>%
    reproducible::postProcess(studyArea = catSectors, filename2 = NULL)

  # Creating data table:
  # In this data.frame, we used the newer densities from Filipe's work on areas 6 ("CapimAcu");
  # and 2 ("CaracasGolfinhos"). The rest is from Dias et. al 2017.
  # Also reduced APA's to zero, after buffering around the PARNAMAR
  dt.table <- data.frame(id = c(1, 2, 3, 4, 5, 6),
                         OfficialName = c("Porto", "Sueste", "CaracasGolfinhos", "Caieras", "SaoJose", "CapimAcu"),
                         density = c(207.8, 96.4, 56.08, 10.8, 38.7, 48.156),
                         lowerBound = c(164.6, 67.9, 30.98, 0.0004, 2, 19.48),
                         upperBound = c(262.5, 136.9, 101.51, 272834.5, 765.5, 119.05),
                         area = c(3.96, 2.12, 4.01, 2.81, 0.71, 3.4))

  # Original table
  # dt.tableDias <- data.frame(id = c(1, 2, 3, 4, 5, 6),
  #                        OfficialName = c("Porto", "Sueste", "CaracasGolfinhos", "Caieras", "SaoJose", "CapimAcu"),
  #                        density = c(207.8, 96.4, 19.3, 10.8, 38.7, 10.8),
  #                        lowerBound = c(164.6, 67.9, 13.1, 0.0004, 2, 8.9),
  #                        upperBound = c(262.5, 136.9, 28.3, 272834.5, 765.5, 13.2),
  #                        area = c(3.96, 2.12, 4.01, 2.81, 0.71, 3.4))

  ord <- as.numeric(catSectors@data$id)
  dt.table <- dt.table[match(ord, dt.table$id),]
  catSectors@data <- cbind(catSectors@data, dt.table[-1])
  catSectors <- postProcess(catSectors, rasterToMatch = DEM, filename2 = NULL)

  # Rasterize the shapefiles with density values
  DEMvals <- getValues(DEM)
  DEMvals[!is.na(DEMvals)] <- 0
  template <- setValues(x = DEM, values = DEMvals)
  catSecRas <- rasterize(catSectors, y = template, field = "density")

  # Eventualmente pode-se incluir observaçõs diretas de gatos no modelo. O código abaixo eh um ponto de partida pra isso.

  # Cats sighting + interpolation
  # sights <- prepInputs(url = "https://drive.google.com/open?id=1p6YIa3M2QHhuc2fnYZAU3ZLcrClyNDAi",
  #                      targetFile = "pontoGatosUTM.shp",
  #                      destinationPath = file.path(getwd(), "data"),
  #                      archive = "pontoGatosUTM.zip",
  #                      alsoExtract = "similar",
  #                      filename2 = NULL) # Dados Filipe Sobral, mestrado, 2019
  # message("Interpolando dados de observação de gatos...")
  # sightsCats <- projectInputs(sights, targetCRS = raster::crs(DEM))
  # sightsCats$vals <- 1
  # gs <- gstat(formula = vals ~ 1, locations = sightsCats, nmax = 5, set = list(idp = 0))
  # catSightRas <- interpolate(template, gs)
  # plot(catSightRas)
  #
  # extractedPoints <- data.table::data.table(raster::extract(x = template, buffer = 50, y = sightsCats,
  #                                               cellnumbers = TRUE, na.rm = TRUE))
  # cls <- unlist(lapply(extractedPoints$V1, function(x){
  #   if (length(x) != 1){
  #     return(x[,1])
  #     } else {
  #       return(NA)
  #     }
  # })
  # )
  # cls <- cls[!is.na(cls)]
  # extractedPoints <- data.frame(cells = cls, value = 1)
  # valsTas <- getValues(x = template)
  # valsTas[extractedPoints$cells] <- extractedPoints$value
  # catSightRas <- setValues(x = catSightRas, values = valsTas)

  message("Gerando mapa...")
  # Applying the model

  priorityArea <- normali(catSecRas * DEM)

  # GIS manipulation
  priorityAreaCropped <- postProcess(x = priorityArea, studyArea = parnamar,
                                     filename2 = NULL,
                                     format = "GTiff",
                                     overwrite = TRUE)

  # raster with priorityAreaCropped as 1, and area around within the island as 0 and rest as NA
  template[is.na(priorityAreaCropped)] <- -1
  template[is.na(template)] <- -1
  template[is.na(DEM)] <- NA
  template[template == 0] <- 1
  template[template == -1] <- 0
  template2 <- crop(template, priorityAreaCropped)
  valsPark <- getValues(template2)
  valsPrio <- getValues(priorityAreaCropped)
  valsPrio[valsPark == 0] <- 0

  prio <- setValues(priorityAreaCropped, values = valsPrio)
  prio <- prio + 0.001
  prio[valsPark == 0] <- 0
  prio <- normali(prio)

  sp.Prio <- as(prio, "SpatialPixelsDataFrame")
  df.Prio <- as.data.frame(sp.Prio)
  colnames(df.Prio) <- c("value", "x", "y")

  # The plotting
  plt <- ggplot() +
    geom_tile(data = df.Prio, aes(x=df.Prio$x, y=df.Prio$y, fill=df.Prio$value)) +
    scale_fill_viridis(option = "B", direction = -1) +
    theme_map() +
    theme(legend.position = "bottom",
          axis.title.x = element_blank(),
          axis.title.y = element_blank()) +
    guides(fill=guide_legend(title="Áreas Prioritárias"))

  print(plt)

  writeRaster(prio, filename = file.path(getwd(), "priorityAreasPARNAMAR"),
              format = "GTiff", overwrite = TRUE)
  return(prio)
}
