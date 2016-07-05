# Load required libraries
if (!require(shiny))
  install.packages("shiny")


################################################################################
# MIDAAS APIs
# [GET] /quantiles?[year=?][state=?][race=?][sex=?][agegroup=?][compare=?]
# [GET] /distribution?[year=?][state=?][race=?][sex=?][agegroup=?][compare=?]
################################################################################

# Input Variables
# api <- "/distribution" # API name, Options: /quantiles, /distribution
# year <- "2014" # Year, Options: 2005-2014 (any one of the 10 years)
# state <- "VA" # US State Code, Options: VA, MD, CA, etc
# race <- "white" # Race, Options: "white", "african american", "hispanic", "asian"
# sex <- "female" # Sex, Options: "male", "female"
# ageGroup <- "35-44" # Age group, Options: "18-24", "25-34", "35-44", "45-54", "55-64", "65+"
# compare <- "state" # Field to compare against, Options: "state", "race", "sex", "agegroup"

# Default URL: 
#   https://api.commerce.gov/midaas/distribution?year=2014&state=VA&race=white&sex=female&ageGroup=35-44&compare=state&api_key=Z69XvTaBEqK7g7VshJ0FGDb4ReDtFjKjeVvpNWMv

# Define UI for BumpAhead application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("HackThePayGap App for Workers: BumpAhead (BabyMomma)"),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      #
      # Uncomment the below line only if you want the data updates to happen 
      # iff the user clicks the "Update View" button.
      # submitButton("Update View"), 
      #
      # api <- "/distribution" # API name, Options: /quantiles, /distribution
      radioButtons("api", "MIDAAS API:",
                   c("quantiles" = "/quantiles",
                     "distribution" = "/distribution"),
                   selected="/distribution", inline=TRUE),
                   #selected="/quantiles", inline=TRUE),
      # Include Year Option
      checkboxInput("includeYear", "Include Year:", TRUE),
      # year <- "2014" # Year, Options: 2005-2014 (any one of the 10 years)
      conditionalPanel(
        condition = "input.includeYear",
        selectInput("year", "Year:",
                  c("2014" = "2014", "2013" = "2013", "2012" = "2012", "2011" = "2011", 
                    "2010" = "2010", "2009" = "2009", "2008" = "2008", "2007" = "2007", 
                    "2006" = "2006", "2005" = "2005"),
                  selected="2014")),
      # Include State Option
      checkboxInput("includeState", "Include State:", TRUE),
      # state <- "VA" # US State Code, Options: VA, MD, CA, etc
      # allow creation of new items in the drop-down list
      # Using state dataset-based state.abb
      conditionalPanel(
        condition = "input.includeState",
        selectInput('stateName', "State:", c(Choose='', state.name), 
                    selected="Virginia", selectize=FALSE)),
      # Include Race Option
      checkboxInput("includeRace", "Include Race:", TRUE),
      # race <- "white" # Race, Options: "white", "african american", "hispanic", "asian"
      conditionalPanel(
        condition = "input.includeRace",
        radioButtons("race", "Race:",
                     c("White" = "white", "African American" = "african american",
                       "Hispanic" = "hispanic", "Asian" = "asian"),
                     selected="white", inline=TRUE)),
      # Include Sex Option
      checkboxInput("includeSex", "Include Sex:", TRUE),
      # sex <- "female" # Sex, Options: "male", "female"
      conditionalPanel(
        condition = "input.includeSex",
        radioButtons("sex", "Sex:",
                     c("Female" = "female",
                       "Male" = "male"),
                     selected="female", inline=TRUE)),
      # Include Age Group Option
      checkboxInput("includeAgeGroup", "Include Age Group:", TRUE),
      # ageGroup <- "35-44" # Age group, Options: "18-24", "25-34", "35-44", "45-54", "55-64", "65+"
      conditionalPanel(
        condition = "input.includeAgeGroup",
        radioButtons("ageGroup", "Age Group:",
                     c("18-24" = "18-24", "25-34" = "25-34", "35-44" = "35-44",
                       "45-54" = "45-54", "55-64" = "55-64", "65+" = "65+"),
                     selected="35-44", inline=TRUE)),
      # Include Compare Option
      checkboxInput("includeCompare", "Include Compare:", TRUE),
      # compare <- "state" # Field to compare against, Options: "state", "race", "sex", "agegroup"
      conditionalPanel(
        condition = "input.includeCompare",
        radioButtons("compare", "Compare against:",
                     c("State" = "state", "Race" = "race",
                       "Sex" = "sex", "Age Group" = "agegroup"),
                     selected="state", inline=TRUE))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      # Regular table display - instead use DataTable for more interactivity
      # tableOutput("payGapRecords")
      # dataTableOutput("payGapRecordsDT")
      textOutput("currentTime"),
      tabsetPanel(type = "tabs", 
                  # TBD: Add project statement, video, mura.ly designs as separate tabs, if possible
                  tabPanel("MIDAAS", dataTableOutput("payGapRecordsDT")),
                  selected = "MIDAAS", position="above")
    ) # mainPanel
  ) # sidebarLayout
)) # shinyUI(fluidPage(