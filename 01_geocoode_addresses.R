library(tidyverse)
library(tidygeocoder)

pharmacies <- 
  tribble(
    ~ Name, ~ Address, ~ CityStateZip, ~ Phone,
    "Malcom Randall VA Medical Ctr",	 "1601 SW Archer Rd",	      "Gainesville,FL 32608",	"(352)376-1611",
    "Shands Hospital-University FL",	 "1600 SW Archer Rd",	      "Gainesville,FL 32610",	"(352)265-0111",
    "Tacachale",	                     "1621 NE Waldo Rd",	      "Gainesville,FL 32609",	"(352)955-5000",
    "North Florida Evaluation/Trtmnt", "1200 NE 55th Blvd",	      "Gainesville,FL 32641",	"(352)375-8484",
    "Shands Rehabilitation Hospital",	 "4101 NW 89th Blvd",	      "Gainesville,FL 32606",	"(352)265-5491",
    "Shands Vista",	                   "4101 NW 89th Blvd",	      "Gainesville,FL 32606",	"(352)265-5497",
    "N Florida Reg Med Ctr",	         "6500 W Newberry Rd",	    "Gainesville,FL 32605",	"(352)333-4000",
    "Tri County Hospital Williston",	 "125 SW 7th St",	          "Williston,FL 32696",	  "(352)528-2801",
    "Reception & Medical Center",	     "7765 S County Road 231",	"Lake Butler,FL 32054",	"(386)496-6000",
    "Shands Starke Medical Center",	   "922 E Call St",	          "Starke,FL 32091",	    "(904)368-2300",
    "Lake Butler Hospital",	           "850 E Main St",	          "Lake Butler,FL 32054",	"(386)496-2323",
    "Ocala Regional Medical Center",	 "1431 SW 1st Ave",	        "Ocala,FL 34471",	      "(352)401-1000",
    "Munroe Regional Medical Center",	 "1500 SW 1st Ave",	        "Ocala,FL 34471",	      "(352)351-7200"
  )

pharmacies

pharmaciesCSZSeparate <-
  pharmacies %>%
    tidyr::separate(
      data = .,
      col = CityStateZip,
      into = c("City", "StateZip"),
      sep = "\\,",
  ) %>%
    tidyr::separate(
      data = .,
      col = StateZip,
      into = c("State", "Zip"),
      sep = "\\s"
    )

pharmaciesCSZSeparate

pharmaciesGeocoded <-
pharmaciesCSZSeparate %>%
  tidygeocoder::geocode(
    .,
    street = Address,
    city = City,
    state = State,
    postalcode = Zip,
    method = "cascade"
  )

library(leaflet)

leaflet(pharmaciesGeocoded) %>%
  addTiles() %>%
  addMarkers(pharmaciesGeocoded, lng = long, lat = lat)

disp_info_02 <-
  disp_info %>%
  mutate(
    id = 1:n(),
    state = "FL",
    single_address = paste0(address, ", ", city, ", ", state)
  ) %>%
  tidygeocoder::geocode(street = address, state = state, city = city, method = "cascade")
