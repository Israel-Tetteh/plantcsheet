#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    navbarPage(
      title = "plantcsheet App",
      id = "nav_id",
      theme = bslib::bs_theme(
        version = 5,
        bootswatch = "flatly",
        primary = "#145214",
        success = "#27AE60",
        info = "#3498DB",
        warning = "#F39C12",
        danger = "#E74C3C"
      ),

      # # Home panel
      # bslib::nav_panel(
      #   title = "Home",
      #   icon  = bsicons::bs_icon("house"),
      #   bslib::card(
      #     bslib::card_body(
      #       h3("Home page under development"),
      #       p("This section is not available yet. Please use the Single Treatment Datasheet tab for now.")
      #     )
      #   )
      # ),
      #
      # bslib::nav_item(), # space home from other

      # Navbarpanels
      bslib::nav_panel(
        title = "Single Treatment Datasheets",
        # module for single factor sheet generation
        mod_generate_single_sheet_ui("generate_single_sheet_1")
      ),
      bslib::nav_item(), # space home from other

      # Multi factor tab
      bslib::nav_panel(title = "Multi Factorial Treatment Datasheets",
                       bslib::card(
                         bslib::card_body(
                           h3("Multi Factorial Treatment Datasheets"),
                           p("This section is not available yet. Please use the Single Treatment Datasheet tab for now.")
                         )
                       )
                       )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "plantcsheet"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
