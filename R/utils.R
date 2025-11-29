#' Meta data generator for experiment documentation
#'
#' @param research_title title of the research
#' @param researcher researcher's name
#' @param researcher_mail email address of the researcher
#' @param date_started date when the experiment started
#' @param plant_species plant species used in the experiment
#' @param explant_type explant type used
#' @param culture_condition culture conditions (e.g., temperature, light)
#' @param treatment description of treatments applied
#' @param replicate_per_treatment number of replicates per treatment
#' @param observation_interval interval for observations
#'
#' @returns A dataframe with two columns: 'Field' and 'Entry', documenting key metadata about the experiment
#' @export
#'
#' @examples
#' Meta_data_func(
#'   research_title         = "Effect of Kinetin on D. rotundata",
#'   researcher_name        = "Israel",
#'   researcher_mail        = "israeltetteh715.mail.com",
#'   date_started           = "2023-10-01",
#'   plant_species          = "Dioscorea rotundata",
#'   explant_type           = "Node",
#'   culture_condition      = "25°C, 16h light / 8h dark",
#'   treatment              = "Kinetin at 0, 2.5, 5.0, 7.0, 10 mg/L",
#'   replicate_per_treatment = 5,
#'   observation_interval   = "Bi-weekly"
#' )
#'
Meta_data_func <- function(
    research_title            = NULL,
    researcher_mail           = NULL,
    researcher_name           = NULL,
    date_started              = NULL,
    plant_species             = NULL,
    explant_type              = NULL,
    culture_condition         = NULL,
    treatment                 = NULL,
    replicate_per_treatment   = NULL,
    observation_interval      = NULL
) {

  meta_dataframe <- data.frame(
    FIELD = c(
      "Experiment Title",
      "Researcher's Name",
      "Researcher's Email",
      "Date of Experiment Start",
      "Plant Species",
      "Explant Type",
      "Culture Conditions",
      "Treatments",
      "Replicate per Treatment",
      "Observation Interval"
    ),
    ENTRY = c(
      research_title,
      researcher_name,
      researcher_mail,
      date_started,
      plant_species,
      explant_type,
      culture_condition,
      treatment,
      replicate_per_treatment,
      observation_interval
    ),
    stringsAsFactors = FALSE
  )

  return(meta_dataframe)
}
