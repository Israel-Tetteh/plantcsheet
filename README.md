# plantcsheet

**plantcsheet** is a tool for the standardized and automated generation of plant tissue culture datasheets, which can be readily exported to Excel files.  

Currently, only the **single datasheet functionality** is available. Other functionalities will be added very soon.  

If you encounter any problems, feel free to reach out.  

## Installation

To install and use the development version of the app, run the following in R:

```r
# Install devtools if you don't have it
install.packages("devtools")

# Install plantcsheet from GitHub
devtools::install_github("Israel-Tetteh/plantcsheet")
```
To use the customizable function for generating a single-treatment datasheet in R:
```r
# Generate a single treatment datasheet.
plantcsheet::generate_single_sheet(
  observation_frequency    = 1,
  num_records              = 4,
  time_unit                = "Weekly",
  treatments               = c("0mg/L", "2.5mg/L", "5mg/L"),
  replicates_per_treatment = 3,
  parameters               = c("Number of Leaves", 'Plantlet Height'),
  research_title           = "Effect of Cytokinin Concentration on Yam Node Culture",
  researcher_mail          = "everythingr25.com",
  researcher_name          = "EverythingR",
  date_started             = "2025-01-15",
  plant_species            = "Dioscorea  rotundata",
  explant_type             = "Node",
  culture_condition        = "25°C, 16h light / 8h dark",
  treatment_desc           = "Cytokinin at 0, 2.5, and 5 mg/L",
  replicate_per_treatment  = 3,
  observation_interval     = "Weekly"
)
```


To launch the Shiny app:
```r
plantcsheet::run_app()
```
