#' \code{rankSpecies} rankSpecies
#'
#' @author Tati Micheletti (TRIADE)
#'
#' @description This functions creates the priority values for a bird species list.
#'              The default uses values provided by CEMAVE/ICMBio specialists.
#'              The list HAS to have all 11 species found in Fernando de Noronha and
#'              you have to provide 11 values for the relative importance of these,
#'              with \code{1} being the lowest priority.
#'
#' @param species Character vector giving the 11 species to assign priorities.
#' @param ranking Numeric. Should give priorities for the 11 species passed in \code{species}
#'                argument. Has to be of length 11L. Pririty 1 is the lowest, the others are
#'                relative to the maximum priority given.#'
#'
#' @export
#'
#' @importFrom data.table data.table
#'
#' @examples
#' \dontrun{
#' spRankDefault <- rankSpecies()
#' spRank <- rankSpecies(species = c("Phaethon lepturus", "Phaethon aethereus", "Sula dactylatra",
#'                       "Sula sula", "Sula leucogaster", "Arenaria interpres", "Onychoprion fuscatus",
#'                       "Anous minutus", "Gygis alba", "Anous stolidus",
#'                       "Bubulcus ibis"),
#'                       ranking = seq(11:1))
#' }

rankSpecies <- function(species = NULL,
                        ranking = NULL){
  # Ranking: The higher the number, the most important! Ranking is relative to the other species
  # 1 is no priority

  # Data sanity check
  if ((is.null(species) & !is.null(ranking)) |
      (is.null(ranking) & !is.null(species)))
    stop("Both species and ranking have to be NULL, or both have to have a value")
  if (length(species) != length(ranking))
    stop("The length of species doesn't match the length of rank values. Please provide one value per species")
  if (!is.null(species) & length(species) != 11)
    stop("At least one specis is missing from the species you are passing to the function. Please specify all species:
Phaethon lepturus
Phaethon aethereus
Sula dactylatra
Sula sula
Sula leucogaster
Arenaria interpres
Onychoprion fuscatus
Anous minutus
Gygis alba
Anous stolidus
Bubulcus ibis")

  # Default values
  if (is.null(species)){
    message("Ranking and species not provided, using original ranks suggested by CEMAVE")
    species <- c("Phaethon lepturus", "Phaethon aethereus", "Sula dactylatra", "Sula sula", "Sula leucogaster", "Arenaria interpres",
                 "Onychoprion fuscatus", "Anous minutus", "Gygis alba", "Anous stolidus",
                 "Bubulcus ibis")
    ranking <- c(rep(3, times = 6), rep(2, times = 4), rep(1, times = 1))
  }

  rankSpecies <- data.table::data.table(species = species, ranking = ranking)
  message("This is the species ranking being returned:")
  print(rankSpecies)
return(rankSpecies)
}
