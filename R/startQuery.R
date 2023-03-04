#' start app
#'
#' @param port
#'
#' @export
#'
startQuery <- function(port=8383){
  shiny::runApp(host = getOption("shiny.host","0.0.0.0"),
                port = port)
}

