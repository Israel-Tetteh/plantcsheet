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
     navbarPage(title = 'plantcsheet App' ,
                id = 'nav_id',
                theme = bslib::bs_theme(bootswatch = 'flatly',version = 5),

                # Home panel
                bslib::nav_panel(title = 'Home',icon = bsicons::bs_icon(name = 'house')),

                bslib::nav_item(), # space home from other

                # Navbarpanels
               bslib::nav_menu( title = 'Generate Datasheets',icon = bsicons::bs_icon(name = 'table'),
                         # Single treatment datasheet
                         bslib::nav_panel(title = 'Single Treatment Datasheets'),

                         # Multi factor tab
                         bslib::nav_panel(title = 'Multi Factorial Treatment Datasheets'))

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
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "plantcsheet"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}



