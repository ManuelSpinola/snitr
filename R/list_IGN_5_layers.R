#'
#' @name list_IGN_5_layers
#'
#' @title List IGN 5 mil layers
#'
#' @description
#' This function list the available IGN 5 mil layers
#'
#'
#' @return
#' @export
#'
#' @examples
#'
#' List available layers
#'
#' capas <- list_IGN_5_layers()
#'

library(httr)
library(xml2)

list_IGN_5_layers <- function() {
  # load libraries
  library(httr)
  library(xml2)

  # Hardcoded WFS service URL
  wfs_url <- "https://geos.snitcr.go.cr/be/IGN_5/wfs?"

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
