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
#' @import utils
#'
#' @examples
#' generate_single_sheet(
#'   observation_frequency = 2,
#'   num_records = 5,
#'   treatments = c("0mg/L", "2.5mg/L", "5mg/L", "10mg/L"),
#'   replicates_per_treatment = 7,
#'   parameters = c('Number of leaves', 'Number of shoot','Number of roots')
#'
#' )
#'
generate_single_sheet <- function(
  observation_frequency,
  num_records,
  treatments,
  replicates_per_treatment,
  parameters # vector comma seperated.
) {
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
  df <- data.frame(
    UNIQUE_ID = total_expID,
    WEEK = total_weeks,
    TREATMENT_ID = total_rep_treat,
    REPLICATE_NUMBER = total_reps
  )

  parameters <- gsub(pattern = " ", replacement = "_", x = trimws(toupper(parameters)))  # reformat parameters.
  ## Add the parameters
  param_df <- as.data.frame(matrix(
    nrow = nrow(df),
    ncol = length(parameters),
    dimnames = list(NULL, parameters)
  ))

  # Combine the dataframes for parameter and other
  final_df <- cbind.data.frame(df, param_df)
  return(final_df)
}
