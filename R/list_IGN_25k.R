#'
#' @name list_IGN_25k
#'
#' @title List IGN 1:25000 scale layers
#'
#' @description
#' This function list the available layers at a 1:25000 scale from
#' the Instituto Geográfico Nacional, Costa Rica, through
#' Sistema Nacional de Información Territorial de Costa Rica
#'  \href{https://www.snitcr.go.cr}{SNIT}
#'
#' @usage list_IGN_25k()
#'
#' @return a list of the available layers
#'
#' @export
#'
#' @examples
#'
#' List available layers
#'
#' capas <- list_IGN_25k()
#'

library(httr)
library(xml2)

list_IGN_25k <- function() {
  # load libraries
  library(httr)
  library(xml2)
  library(sf)

  # Hardcoded WFS service URL
  wfs_url <- "https://geos.snitcr.go.cr/be/IGN_25/wfs?"

  # Construct the WFS GetCapabilities request URL
  capabilities_url <- paste0(wfs_url, "service=WFS&version=2.0.0&request=GetCapabilities")

  # Send the GET request to retrieve the capabilities document
  response <- GET(capabilities_url)

  # Check if the request was successful
  if (status_code(response) == 200) {
    # Parse the XML response
    capabilities <- read_xml(content(response, "text"))

    # Extract and print all available layer names
    layers <- xml_find_all(capabilities, ".//wfs:FeatureType/wfs:Name", xml_ns(capabilities))
    layer_names <- xml_text(layers)
    print(layer_names)

    return(layer_names)
  } else {
    stop("Failed to retrieve layers: ", status_code(response))
  }
}
