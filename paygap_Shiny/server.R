# URL: https://pragyansmita.shinyapps.io/paygap_Shiny/ 

# To deploy the app in ShinyApps.io (5 apps allowed for free)
# if (!require(rsconnect))
#   install.packages("rsconnect")
#
# rsconnect::setAccountInfo(name=<NAME>, token=<TOKEN>, secret=<SECRET>)
#
# library(rsconnect)
# rsconnect::deployApp('C:\\New folder\\HackThePayGap\\paygap_Shiny')

# Load required libraries
if (!require(shiny))
  install.packages("shiny")
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
quantile_precision <- 5

# api <- "/distribution" # API name, Options: /quantiles, /distribution
# year <- "2014" # Year, Options: 2005-2014 (any one of the 10 years)
# state <- "VA" # US State Code, Options: VA, MD, CA, etc
# race <- "white" # Race, Options: "white", "african american", "hispanic", "asian"
# sex <- "female" # Sex, Options: "male", "female"
# ageGroup <- "35-44" # Age group, Options: "18-24", "25-34", "35-44", "45-54", "55-64", "65+"
# compare <- "state" # Field to compare against, Options: "state", "race", "sex", "agegroup"

# Function Name: as.numeric.factor
# Convert factor to numbers
as.numeric.factor <- function(x) {as.numeric(levels(x))[x]}

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
formulateURL <- function(domain, api, includeYear, year, includeState, 
                         state, includeRace, race, includeSex, sex, 
                         includeAgeGroup, ageGroup, includeCompare, compare, api_key) {
  call_url <- paste(domain, api, sep="")
  firstValue <- TRUE
  #call_url
  # Add year if includeYear is checked (TRUE)
  if (includeYear) {
    fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "year", year)
    call_url <- fRetVal[[1]]
    firstValue <- fRetVal[[2]]
  }
  #call_url
  # Add state
  if (includeState) {
    fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "state", state)
    call_url <- fRetVal[[1]]
    firstValue <- fRetVal[[2]]
  }
  #call_url
  # Add race
  if (includeRace) {
    fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "race", race)
    call_url <- fRetVal[[1]]
    firstValue <- fRetVal[[2]]
  }
  #call_url
  # Add sex
  if (includeSex) {
    fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "sex", sex)
    call_url <- fRetVal[[1]]
    firstValue <- fRetVal[[2]]
  }
  #call_url
  # Add ageGroup
  if (includeAgeGroup) {
    fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "ageGroup", ageGroup)
    call_url <- fRetVal[[1]]
    firstValue <- fRetVal[[2]]
  }
  #call_url
  # Add compare
  if (includeCompare) {
    fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "compare", compare)
    call_url <- fRetVal[[1]]
    firstValue <- fRetVal[[2]]
  }
  
  # Add API key
  fRetVal <- formulateRESTAPIParameter(call_url, firstValue, "api_key", api_key)
  call_url <- fRetVal[[1]]
  
  # Log statement
  cat(file=stderr(), "MIDAAS API Called: ", call_url, "\n")
  
  return (call_url)
}


# MIDAAS API Call
# Example : https://api.commerce.gov/midaas/distribution?state=VA&race=white&sex=female&api_key=Z69XvTaBEqK7g7VshJ0FGDb4ReDtFjKjeVvpNWMv
#definedURL <- formulateURL(domain, api, year, state, race, sex, ageGroup, compare, api_key)
#payGapRecords <- rjson::fromJSON(file = definedURL)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  # cat ("here") # Debug statement
  # Expression that generates a table. The expression is
  # wrapped in a call to renderTable to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically
  #     re-executed when inputs change
  #  2) Its output type is a plot
  
  
  datasetInput <- reactive({
    ###############################################################
    # MIDAAS API Call
    ###############################################################
    # Default URL:
    #   https://api.commerce.gov/midaas/distribution?year=2014&state=VA&
    #   race=white&sex=female&ageGroup=35-44&compare=state&
    #   api_key=Z69XvTaBEqK7g7VshJ0FGDb4ReDtFjKjeVvpNWMv
    ###############################################################
    # definedURL <- formulateURL(domain, api, year, state, race, sex, ageGroup, compare, api_key)
    # payGapRecords <- rjson::fromJSON(file = definedURL)
    ###############################################################
    # Read values from UI input
    api <- input$api
    includeYear <- input$includeYear
    year <- input$year
    
    includeState <- input$includeState
    state <- state.abb[state.name == input$stateName]
    cat(file=stderr(), "State in MIDAAS tab = ", state, "\n")
    state_BA <- state.abb[state.name == input$stateName_BA]
    cat(file=stderr(), "State in BumpAhead tab = ", state_BA, "\n")
    # TBD: Add logic to make the REST API call using State (and the rest of the parameters) 
    #      from the tab initiating the reactive method call
    
    includeRace <- input$includeRace
    race <- input$race
    includeSex <- input$includeSex
    sex <- input$sex
    includeAgeGroup <- input$includeAgeGroup
    ageGroup <- input$ageGroup
    includeCompare <- input$includeCompare
    compare <- input$compare
    
    definedURL <- formulateURL(domain, api, includeYear, year, includeState, 
                               state, includeRace, race, includeSex, sex, 
                               includeAgeGroup, ageGroup, includeCompare, compare, api_key)
    #t(data.frame(rjson::fromJSON(file = definedURL)))
    #do.call(rbind.data.frame, your_list)
    midaasDataList <- rjson::fromJSON(file = definedURL)
    # typeof(midaasDataList) ## "list"
    # midaasDataList
    #
    #   $`$30.00k-$40.00k`
    #   [1] 0.1257477
    #   
    #   $`$40.00k-$50.00k`
    #   [1] 0.1063846
    #   
    
    midaasDataFrame <- data.frame()
    
    if (length(midaasDataList) != 0 ) {
      if (api == "/distribution") { 
        midaasDataList <- do.call(rbind.data.frame, midaasDataList)
        # typeof(midaasDataList) ## "list"
        # midaasDataList
        #
        #   c.0.125747745933784..0.106384589390417..0.145321617573951..0.00526319486229768..
        #   $30.00k-$40.00k                                                                       1.257477e-01
        #   $40.00k-$50.00k                                                                       1.063846e-01
        #
        
        midaasDataFrame <- data.frame(cbind(rownames(midaasDataList), midaasDataList[[1]]))
        # typeof(midaasDataFrame) ## "list"
        #   > midaasDataFrame
        #   
        #             X1                   X2
        #   1    $30.00k-$40.00k    0.125747745933784
        #   2    $40.00k-$50.00k    0.106384589390417
        #   
        names(midaasDataFrame) <- c("Income","Quantile")
        # Change Quantiles to numeric values
        midaasDataFrame$Quantile <- as.numeric.factor(midaasDataFrame$Quantile)        
        # Round Quantiles to 5-digit precision
        midaasDataFrame$Quantile <- round(midaasDataFrame$Quantile, quantile_precision)
      }
      else if (api == "/quantiles") { 
        midaasDataList <- do.call(cbind.data.frame, midaasDataList)
        # typeof(midaasDataList) ## "list"
        # midaasDataList
        #
        #
        # overall.5% overall.10% overall.20% overall.30% overall.40% overall.50% overall.60% overall.70% overall.80%
        #       2000        6000       14000       23000       30600       40000       50000       63000       84000
        # overall.90% overall.95% overall.99%
        #      120000      156000      426000
        #
        
        midaasDataList <- t(midaasDataList)
        midaasDataFrame <- data.frame(cbind(rownames(midaasDataList), midaasDataList[,1]))
        rownames(midaasDataFrame) <- NULL
        names(midaasDataFrame) <- c("Quantile","Income")
      }
    }
    
    #> midaasDataFrame
    #             Income             Quantile
    #    1    $30.00k-$40.00k    0.125747745933784
    #    2    $40.00k-$50.00k    0.106384589390417    
    midaasDataFrame
  })
  
  
  # Show the MIDAAS API Call resulting information
  # Regular table display - instead use DataTable for more interactivity
  #   output$payGapRecords <- renderTable({
  #     datasetInput()
  #   })
  #   output$payGapRecords_BA <- renderTable({
  #     datasetInput()
  #   })
  
  output$payGapRecordsDT <- renderDataTable({
    datasetInput()
  })
  
  output$payGapRecordsDT_BA <- renderDataTable({
    datasetInput()
  })
  
  output$currentTime <- renderText({
    invalidateLater(1000, session)
    paste("The current time is", Sys.time())
  })
  
  output$currentTime_BA <- renderText({
    invalidateLater(1000, session)
    paste("The current time is", Sys.time())
  })
  
  output$pdfviewer <- renderText({
    return('<iframe style="height:600px; width:100%", src="babymamma_InVision.pdf"></iframe>')
  })
  
})