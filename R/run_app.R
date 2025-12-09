#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  pkg_install = T,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  # Check all suggested packages at the start
  suggested_packages <- c(
    "bslib", "config", "golem", "openxlsx", "shiny", "shinyalert"
  )

  missing_packages <- suggested_packages[!sapply(suggested_packages,
    requireNamespace,
    quietly = TRUE
  )]

  if (length(missing_packages) > 0) {
    if (pkg_install) {
      message("Installing missing packages: ", paste(missing_packages, collapse = ", "))
      install.packages(missing_packages)
    } else {
      stop(
        sprintf(
          "Missing packages: %s\nInstall with: install.packages(c(%s))",
          paste(missing_packages, collapse = ", "),
          paste(sprintf("'%s'", missing_packages), collapse = ", ")
        ),
        call. = FALSE
      )
    }
  }


  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
