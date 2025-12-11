#' generate_single_sheet UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import bslib
#' @import DT
#'
mod_generate_single_sheet_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bslib::layout_sidebar(
      height = "900px",
      #-----------------------------------
      # Sidebar Section for Inputs
      #-----------------------------------
      sidebar = bslib::sidebar(
        width = 380,
        class = "bg-light",
        title = tags$h4("Single Treatment Datasheets"),

        # Step 1: File Uploads
        bslib::accordion(
          id = "config_accordion",
          open = c("data_details", "metadata"), # Panels to be open by default

          bslib::accordion_panel(
            value = "data_details", title = "Configure Datasheet Parameters",
            # input for treatment levels
            textInput(
              inputId = ns("trts"),
              label = "Treatment levels (comma-separated):",
              placeholder = "0mg/L, 2.5mg/L, 5mg/L, 10mg/L",
              width = "100%"
            ),

            # input for replicates.
            numericInput(
              inputId = ns("reps"),
              label = "Replicates per treatment:",
              value = 5,
              min = 1,
              step = 1
            ),

            # Input for time units
            selectInput(
              inputId = ns("time_unit"),
              label = "Time unit for observations:",
              choices = c("Weekly", "Daily"),
              selected = "Weekly"
            ),

            # input for number of records
            numericInput(
              inputId = ns("num_rec"),
              label = "Number of observation time points:",
              value = 5,
              min = 1,
              step = 1
            ),

            # input for number of observation interval.
            numericInput(
              inputId = ns("obs_int"),
              label = "Observation interval (chosen time units):",
              value = 2,
              min = 1,
              step = 1
            ),

            # input for parameters
            textInput(
              inputId = ns("params"),
              label = "Growth parameters (comma-separated):",
              placeholder = "Number of leaves, Number of Shoots,...."
            )
          ),

          # Step 2: Column Mapping
          bslib::accordion_panel(
            title = "Configure Metadata Parameters", value = "metadata",
            # input for research title
            textInput(
              inputId = ns("research_title"),
              label = "Experiment title:",
              placeholder = "Effect of kinetin on in vitro shoot proliferation"
            ),

            # input for researcher's name
            textInput(
              inputId = ns("researcher"),
              label = "Researcher name:",
              placeholder = "First name and surname"
            ),

            # input for researcher's mail
            textInput(
              inputId = ns("researcher_mail"),
              label = "Researcher email:",
              placeholder = "name@example.com"
            ),

            # input date of experiment start
            dateInput(
              inputId = ns("date_started"),
              label   = "Experiment start date:"
            ),

            # input for plant species
            textInput(
              inputId = ns("plant_species"),
              label = "Plant species:",
              placeholder = "Dioscorea rotundata"
            ),

            # input for explant type
            textInput(
              inputId = ns("explant_type"),
              label = "Explant type:",
              placeholder = "Shoot tip, node, leaf disc..."
            ),

            # input for culture conditions
            textAreaInput(
              inputId = ns("culture_condition"),
              label = "Culture conditions:",
              placeholder = "25°C, 16h light / 8h dark",
              value = "25°C, 16h light / 8h dark",
              width = "100%",
              rows = 3
            ),

            # input on treatment description
            textAreaInput(
              inputId = ns("trt_desc"),
              label = "Treatment description:",
              placeholder = "Kinetin at 0, 2.5, 5 and 10 mg/L on MS medium",
              width = "100%",
              rows = 2
            )
          )
        ),
        # Action button to submit
        div(
          class = "mt-4 d-grid gap-2",
          actionButton(
            inputId = ns("run_butt"),
            label = "Run",
            icon = icon("play", class = "me-2"),
            class = "btn-success btn-lg",
            style = "font-weight: 600; box-shadow: 0 4px 6px rgba(0,0,0,0.1);"
          )
        )
      ),

      # ===========
      # Main panel area
      # ===========

      bslib::navset_card_pill(
        id = ns("results_tabs"),
        full_screen = TRUE,
        # Data Table tab
        bslib::nav_panel(
          title = "Datasheet",
          icon = icon("table"),
          value = "table_tab",

          # Card for displaying results table
          bslib::card(
            #   class = "h-100",
            bslib::card_header(
              div(
                icon("table", class = "me-2"),
                strong("Preview of Datasheet")
              )
            ),
            # Data table output
            bslib::card_body(
              class = "p-0",
              DT::DTOutput(ns("gen_table"), height = "500px"),
            ),
            # Footer with download options
            bslib::card_footer(
              div(
                style = "display: flex; align-items: center; height: 100%; margin-top: 12px;",
                downloadButton(
                  ns("download_table"),
                  label = "Export",
                  class = "btn-success w-100",
                  icon = icon("download")
                )
              )
            )
          )
        ),
        bslib::nav_panel(
          title = "Meta Data",
          icon = icon("table"),
          value = "table_tab_2",

          # Card for displaying results table
          bslib::card(
            #   class = "h-100",
            bslib::card_header(
              div(
                icon("table", class = "me-2"),
                strong("Preview of Meta Data")
              )
            ),
            # Data table output
            bslib::card_body(
              class = "p-0",
              DT::DTOutput(ns("gen_table_2"), height = "500px"),
            )
          )
        )
      )
    )
  )
}

#' generate_single_sheet Server Functions
#'
#' @noRd
mod_generate_single_sheet_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Require necessary inputs and generate the output.
    result <- reactiveVal()

    observeEvent(input$run_butt, {
      # required to work
      req(
        input$trts,
        input$reps,
        input$time_unit,
        input$params,
        input$obs_int,
        input$num_rec,
        input$research_title,
        input$researcher,
        input$researcher_mail,
        input$date_started,
        input$plant_species,
        input$explant_type,
        input$culture_condition,
        input$trt_desc
      )

      # trycatch for error checking and feedback
      tryCatch(
        {
          data <- generate_single_sheet(
            observation_frequency = input$obs_int,
            num_records = input$num_rec,
            time_unit = input$time_unit,
            treatments = unlist(strsplit(x = trimws(input$trts), split = ",")),
            replicates_per_treatment = input$reps,
            parameters = unlist(strsplit(x = trimws(input$params), split = ",")),
            research_title = input$research_title,
            researcher_mail = input$researcher_mail,
            researcher_name = input$researcher,
            date_started = format(input$date_started, "%Y-%m-%d"),
            plant_species = input$plant_species,
            explant_type = input$explant_type,
            culture_condition = input$culture_condition,
            treatment_desc = input$trt_desc,
            replicate_per_treatment = input$reps,
            observation_interval = input$obs_int
          )
          result(data)

          # Success alert
          shinyWidgets::show_alert(
            title = "Success!",
            text = "Datasheet generated successfully",
            type = "success"
          )
        },
        error = function(e) {
          # Show error alert to user
          shinyalert::shinyalert(
            title = "Error",
            text = e$message,
            type = "error"
          )
          return(NULL)
        }
      )
    })

    # Display output in data tables.
    output$gen_table <- DT::renderDT({
      req(result())
      DT::datatable(data = result()$final_df, options = list(scrollX = TRUE))
    })

    # Display results for metadata
    output$gen_table_2 <- DT::renderDT({
      req(result())
      DT::datatable(result()$meta_data, options = list(scrollX = TRUE))
    })


    # Download excel sheet.
    output$download_table <- downloadHandler(
      filename = function() {
        #file name
        clean_name <- gsub(pattern = ' ',replacement = '_',x = trimws(input$research_title))
        paste0(clean_name, '.xlsx')
      },
      content = function(file) {
          openxlsx::write.xlsx(result(), file,headerStyle = openxlsx::createStyle(textDecoration = "BOLD"))
        }

    )

  })
}

## To be copied in the UI
# mod_generate_single_sheet_ui("generate_single_sheet_1")

## To be copied in the server
# mod_generate_single_sheet_server("generate_single_sheet_1")
