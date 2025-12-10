#' Generate a datasheet for single-factor treatment experiments
#'
#' @param observation_frequency Numeric. Interval (in weeks or days) between successive observations.
#' @param num_records Numeric. Total number of observation time points to generate.
#' @param time_unit Character. Unit of time for observations; either "Weeks" or "Days".
#' @param treatments Character vector. Names or labels of the treatment levels.
#' @param replicates_per_treatment Numeric. Number of biological or experimental replicates per treatment.
#' @param parameters Character vector. Names of the dependent variables or traits to be measured.
#'
#' @param research_title Character. Title of the research experiment.
#' @param researcher_mail Character. Email address of the researcher.
#' @param researcher_name Character. Name of the researcher.
#' @param date_started Character or Date. Date the experiment was initiated.
#' @param plant_species Character. Scientific name of the plant species used.
#' @param explant_type Character. Type of explant used for culture.
#' @param culture_condition Character. Description of growth or culture conditions maintained during the experiment.
#' @param treatment_desc Character. Full description of the treatment structure.
#' @param replicate_per_treatment Numeric. (Metadata) Number of replicates specified for documentation.
#' @param observation_interval Character. Human-readable description of how often observations occur (e.g., "Weekly").
#'
#' @returns A list containing:
#' \describe{
#'   \item{data_collection_sheet}{A dataframe containing the structured observation datasheet for single-factor treatment experiments.}
#'   \item{metadata_sheet}{A dataframe containing metadata describing the experiment.}
#' }
#' @export
#'
#' @examples
#'
#' generate_single_sheet(
#'   observation_frequency = 1,
#'   num_records = 4,
#'   time_unit = "Weekly",
#'   treatments = c("0mg/L", "2.5mg/L", "5mg/L"),
#'   replicates_per_treatment = 3,
#'   parameters = "Number of leaves",
#'   # Metadata inputs
#'   research_title = "Effect of Cytokinin Concentration on Yam Node Culture",
#'   researcher_mail = "israel.example.com",
#'   researcher_name = "Israel Tetteh",
#'   date_started = "2025-01-15",
#'   plant_species = "Dioscorea  rotundata",
#'   explant_type = "Node",
#'   culture_condition = "25°C, 16h light / 8h dark",
#'   treatment_desc = "Cytokinin at 0, 2.5, and 5 mg/L",
#'   replicate_per_treatment = 3,
#'   observation_interval = "Weekly"
#' )
#'
generate_single_sheet <- function(
  observation_frequency = NULL,
  num_records = NULL,
  time_unit = c("Weekly", "Daily"),
  treatments = NULL,
  replicates_per_treatment = NULL,
  parameters, # vector comma seperated.
  research_title = NULL,
  researcher_mail = NULL,
  researcher_name = NULL,
  date_started = NULL,
  plant_species = NULL,
  explant_type = NULL,
  culture_condition = NULL,
  treatment_desc = NULL,
  replicate_per_treatment = NULL,
  observation_interval = NULL
) {

  #==============
  # Datasheet info
  #===============
  rep_treat <- rep(treatments, each = replicates_per_treatment) # Get treatment replicated

  # Replicate only
  repl_only <- rep(1:replicates_per_treatment, times = length(treatments))

  # compute total number of rows based on the observation frequency.
  nrow_result <- seq(
    from = observation_frequency,
    to = observation_frequency * num_records,
    by = observation_frequency
  )

  # Expand to total rows
  total_rep_treat <- rep(rep_treat, times = length(nrow_result))
  total_weeks <- rep(nrow_result, each = length(rep_treat))
  total_reps <- rep(repl_only, times = length(nrow_result))
  total_expID <- paste0(total_rep_treat, "_R", total_reps)

  # Knit into dataframe
  # Check user specified time frame.
  if (time_unit == "Weekly") {
    df <- data.frame(
      UNIQUE_ID = total_expID,
      WEEK = total_weeks,
      TREATMENT_ID = total_rep_treat,
      REPLICATE_NUMBER = total_reps
    )
  } else if (time_unit == "Daily") {
    df <- data.frame(
      UNIQUE_ID = total_expID,
      DAY = total_weeks,
      TREATMENT_ID = total_rep_treat,
      REPLICATE_NUMBER = total_reps
    )
  }

  parameters <- gsub(pattern = " ", replacement = "_", x = trimws(toupper(parameters))) # reformat parameters.
  ## Add the parameters
  param_df <- as.data.frame(matrix(
    nrow = nrow(df),
    ncol = length(parameters),
    dimnames = list(NULL, parameters)
  ))

  # Combine the dataframes for parameter and other
  final_df <- cbind.data.frame(df, param_df)


  #===========================
  # Meta data columnn.
  #===========================
  meta_dataframe <- data.frame(
    FIELD = c(
      "EXPERIMENT TITLE:",
      "RESEARCHER'S NAME:",
      "RESEARCHER'S EMAIL:",
      "DATE OF EXPERIMENT START:",
      "PLANT SPECIES:",
      "EXPLANT TYPE:",
      "CULTURE CONDITIONS:",
      "TREATMENTS:",
      "REPLICATE PER TREATMENT:",
      "OBSERVATION INTERVAL:"
    ),
    ENTRY = c(
      research_title,
      researcher_name,
      researcher_mail,
      date_started,
      plant_species,
      explant_type,
      culture_condition,
      treatment_desc,
      replicate_per_treatment,
      observation_interval
    ),
    stringsAsFactors = FALSE
  )




  # Return both datasheet and metadataframe.
  return(list(Data_Collection_Sheet = final_df, metadata_sheet = meta_dataframe))
}
