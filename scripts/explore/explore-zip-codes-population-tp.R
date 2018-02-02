library("geojsonio")
library("stringr")
library("leaflet")

zip_codes_df <- readRDS('./r-objects/zip_code_total_population.rds')

tn_counties_geojson <- geojsonio::geojson_read(
  "http://catalog.civicdashboards.com/dataset/6982aae7-954b-4b7e-8f18-ab56b3fe625d/resource/60b241a8-07dc-478c-bb10-a55802e1cb36/download/4811a0678aed4619ac7857e831df9ccctemp.geojson",
  what = "sp"
)

names(tn_counties_geojson)[names(tn_counties_geojson) == "name"] <- "county"

tn_counties_geojson@data$county <- word(tolower(tn_counties_geojson@data$county), 1)

tn_counties_geojson@data <- data.frame(
  tn_counties_geojson@data, 
  zip_codes_df[match(tn_counties_geojson@data[, 'county'], zip_codes_df[, 'county']), ]
)

pal <- colorNumeric("viridis", NULL)

leaflet(tn_counties_geojson) %>%
  addTiles() %>%
  addPolygons(
    stroke = FALSE, 
    smoothFactor = 0.3, 
    fillOpacity = 1,
    fillColor = ~pal(log10(total_population)),
    label = ~paste0(county, ": ", formatC(total_population, big.mark = ","))
  ) %>%
  addLegend(
    pal = pal, 
    values = ~log10(total_population), 
    opacity = 1.0,
    labFormat = labelFormat(transform = function(x) round(10^x))
  )

# Save off the summarized total pop per county / geojson
saveRDS(tn_counties_geojson, './r-objects/tn_counties_pop_geojson.rds')
write.csv(tn_counties_geojson, './r-objects/tn_counties_pop_geojson.csv')