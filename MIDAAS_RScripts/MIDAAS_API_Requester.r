# Load required libraries
# if (!require(jsonlite))
#   install.packages("jsonlite")
if (!require(rjson))
  install.packages("rjson")

################################################################################
# MIDAAS APIs
# [GET] /quantiles?[year=?][state=?][race=?][sex=?][agegroup=?][compare=?]
# [GET] /distribution?[year=?][state=?][race=?][sex=?][agegroup=?][compare=?]
################################################################################

################################################################################
# Data.gov API Key: Z69XvTaBEqK7g7VshJ0FGDb4ReDtFjKjeVvpNWMv
################################################################################
# TBD: Before use, replace with your registered Data.gov API key
################################################################################
api_key <- "Z69XvTaBEqK7g7VshJ0FGDb4ReDtFjKjeVvpNWMv"
################################################################################

# Set variables
domain <- "https://api.commerce.gov/midaas"

api <- "/distribution" # API name, Options: /quantiles, /distribution
year <- "2014" # Year, Options: 2005-2014 (any one of the 10 years)
state <- "VA" # US State Code, Options: VA, MD, CA, etc
race <- "white" # Race, Options: "white", "african american", "hispanic", "asian"
sex <- "female" # Sex, Options: "male", "female"
ageGroup <- "35-44" # Age group, Options: "18-24", "25-34", "35-44", "45-54", "55-64", "65+"
compare <- "state" # Field to compare against, Options: "state", "race", "sex", "agegroup"


# Function Name: formulateRESTAPIParameter
formulateRESTAPIParameter <- function(call_url, firstValue, paramName, paramVal) {
  if (!is.null(paramVal)) {
    if (firstValue) {
      retVal <- paste("?", paramName, "=", paramVal, sep="")
      firstValue <- FALSE
    }
    else {
      retVal <- paste("&", paramName, "=", paramVal, sep="")
    }
    call_url <- paste(call_url, retVal, sep="")
  }
  return (list(call_url,firstValue))
}


# Formulate the API call string
# Example : https://api.commerce.gov/midaas/distribution?state=CA&race=white&sex=male&api_key=Z69XvTaBEqK7g7VshJ0FGDb4ReDtFjKjeVvpNWMv
# Function Name: formulateURL
formulateURL <- function(domain, api, year, state, race, sex, ageGroup, compare, api_key) {
  call_url <- paste(domain, api, sep="")
  firstValue <- TRUE
  #call_url
  # Add year
  fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "year", year)
  call_url <- fRetVal[[1]]
  firstValue <- fRetVal[[2]]
  #call_url
  # Add state
  fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "state", state)
  call_url <- fRetVal[[1]]
  firstValue <- fRetVal[[2]]
  #call_url
  # Add race
  fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "race", race)
  call_url <- fRetVal[[1]]
  firstValue <- fRetVal[[2]]
  #call_url
  # Add sex
  fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "sex", sex)
  call_url <- fRetVal[[1]]
  firstValue <- fRetVal[[2]]
  #call_url
  # Add ageGroup
  fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "ageGroup", ageGroup)
  call_url <- fRetVal[[1]]
  firstValue <- fRetVal[[2]]
  #call_url
  # Add compare
  fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "compare", compare)
  call_url <- fRetVal[[1]]
  firstValue <- fRetVal[[2]]
  
  # Add API key
  fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "api_key", api_key)
  call_url <- fRetVal[[1]]
  
  return (call_url)
}

# MIDAAS API Call
# Example : https://api.commerce.gov/midaas/distribution?state=CA&race=white&sex=male&api_key=Z69XvTaBEqK7g7VshJ0FGDb4ReDtFjKjeVvpNWMv
definedURL <- formulateURL(domain, api, year, state, race, sex, ageGroup, compare, api_key)
payGapRecords <- rjson::fromJSON(file = definedURL)