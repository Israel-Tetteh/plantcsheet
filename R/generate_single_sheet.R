#' Generate a datasheet for single factor treatment experiments
#'
#' @param observation_frequency number of weeks between observations
#' @param num_records number of observation records to generate
#' @param treatments vector of treatment names
#' @param replicates_per_treatment number of replicates for each treatment
#' @param parameters vector of dependent variables to measure.
#'
#' @returns A dataframe structured for single factor treatment experiments, including unique IDs, weeks, treatment IDs, replicate numbers, and parameter columns initialized with NA values
#' @export
#'
#' @examples
#'
#' generate_single_sheet(
#'   observation_frequency = 1,
#'   num_records = 4,
#'   time_unit = "Days",
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
  time_unit = c("Weeks", "Days"),
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
  if (time_unit == "Weeks") {
    df <- data.frame(
      UNIQUE_ID = total_expID,
      WEEK = total_weeks,
      TREATMENT_ID = total_rep_treat,
      REPLICATE_NUMBER = total_reps
    )
  } else if (time_unit == "Days") {
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
  return(list(final_df = final_df, meta_data = meta_dataframe))
}
