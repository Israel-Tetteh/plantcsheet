#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  # Auto-stop R when the browser closes
  session$onSessionEnded(function(){
    stopApp()
  })

  # Module for single sheet.
  mod_generate_single_sheet_server("generate_single_sheet_1")
}
