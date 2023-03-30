#' start app
#'
#' @param port
#'
#' @export
startQueryApp <- function(port=8383) {
  shiny::runApp(host = getOption("shiny.host","0.0.0.0"),
                port = port)
}
#
