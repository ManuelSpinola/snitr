#'
#' @name download_IGN_5_data
#'
#' @title Download IGN 5 mil layers
#'
#' @param layer_name The specific layer you want to download (e.g., IGN_5:delimitacion2017_5k).
#' @param output_format The format in which to download the data (default is GeoJSON, application/json).
#' @param output_file The path where the downloaded spatial data will be saved (e.g., .gpkg, .shp).
#'
#' @return
#' @export
#'
#' @examples
#'
#' Select a layer from the list (replace with your chosen layer)
#'
#' Replace with the actual layer name from the list
#'
#' layer_name <- "IGN_5:delimitacion2017_5k"
#'
#' Specify your desired output file format and name
#'
#' output_file <- "IGN_5_delimitacion2017_5k.gpkg"
#'
#' Download the selected layer
#'
#' downloaded_file <- download_IGN_5_data(layer_name, output_file = output_file)
#'
#'
#'

library(httr)
library(xml2)
library(sf)

download_IGN_5_data <- function(layer_name, output_format = "application/json", output_file) {
  # load libraries
  library(httr)
  library(xml2)
  library(sf)

  # Hardcoded WFS service URL
  wfs_url <- "https://geos.snitcr.go.cr/be/IGN_5/wfs?"

  # Construct the WFS request URL
  request_url <- paste0(
    wfs_url,
    "service=WFS",
    "&version=2.0.0",
    "&request=GetFeature",
    "&typeName=", layer_name,
    "&outputFormat=", output_format
  )

  # Send the GET request to the WFS endpoint
  response <- GET(request_url)

  # Check if the request was successful
  if (status_code(response) == 200) {
    # Write the response content to a temporary file
    temp_file <- tempfile(fileext = ".geojson")
    writeBin(content(response, "raw"), temp_file)

    # Read the downloaded GeoJSON file as an sf object
    spatial_data <- st_read(temp_file)

    # Save the sf object to the specified output file (can be .gpkg, .shp, etc.)
    st_write(spatial_data, output_file, delete_dsn = TRUE)

    # Return the path to the output file
    return(output_file)
  } else {
    stop("Failed to download data: ", status_code(response))
  }
}
