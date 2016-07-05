# Load required libraries
if (!require(shiny))
  install.packages("shiny")
if (!require(markdown))
  install.packages("markdown")


# Customize the header panel
# Reference: http://stackoverflow.com/questions/21996887/embedding-image-in-shiny-app
# customHeaderPanel <- function(title,windowTitle=title){
#   tagList(
#     tags$head(
#       tags$title(windowTitle),
#       tags$link(rel="stylesheet", type="text/css",
#                 href="app.css"),
#       tags$h1(a(href="www.someURLlogoLinksto.com"))
#     )
#   )
# }


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
shinyUI(navbarPage("Team BabyMomma",
                   tabPanel("BumpAhead", 
                            # Application title
                            titlePanel("HackThePayGap App for Workers: BumpAhead App"),
                            sidebarLayout(
                              sidebarPanel(
                                img(src='logo_bumpAhead_small.png'),
                                # Screen 1: "Play to learn how the high cost of child care impacts the gender pay gap"
                                conditionalPanel(
                                  condition = "input.ChooseStep1 == 0",
                                  h1(helpText("Play to learn how the high cost of child care impacts the gender pay gap"))
                                  ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep1 == 0)",
                                  radioButtons("ChooseStep1", "",
                                               c("Yes" = 1, "No" = 0), selected=0, inline=TRUE)
                                  ),
                                # Screen 2: "When women have a child, their potential future earnings decrease by 5%"
                                conditionalPanel(
                                  condition = "(input.ChooseStep1 == 1) && (input.ChooseStep2 == 0)",
                                  h1(helpText("When women have a child, their potential future earnings decrease by 5%"))
                                  ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep1 == 1) && (input.ChooseStep2 == 0)",
                                  radioButtons("ChooseStep2", "",
                                               c("Yes" = 1, "No" = 0), selected=0, inline=TRUE)),
                                # Screen 3: "Imagine that you are about to be a mother for the first time"
                                conditionalPanel(
                                  condition = "(input.ChooseStep2 == 1) && (input.ChooseStep3 == 0)",
                                  h1(helpText("Imagine that you are about to be a mother for the first time"))
                                ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep2 == 1) && (input.ChooseStep3 == 0)",
                                  radioButtons("ChooseStep3", "",
                                               c("Yes" = 1, "No" = 0), selected=0, inline=TRUE)),
                                # Screen 4: "You work full time and plan on continuing to work after the baby comes"
                                conditionalPanel(
                                  condition = "(input.ChooseStep3 == 1) && (input.ChooseStep4 == 0)",
                                  h1(helpText("You work full time and plan on continuing to work after the baby comes"))
                                ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep3 == 1) && (input.ChooseStep4 == 0)",
                                  radioButtons("ChooseStep4", "",
                                               c("Yes" = 1, "No" = 0), selected=0, inline=TRUE)),
                                # Screen 5: "You need to find an affordable and high quality way to care for your baby 40 hours a week"
                                conditionalPanel(
                                  condition = "(input.ChooseStep4 == 1) && (input.ChooseStep5 == 0)",
                                  h1(helpText("You need to find an affordable and high quality way to care for your baby 40 hours a week"))
                                ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep4 == 1) && (input.ChooseStep5 == 0)",
                                  radioButtons("ChooseStep5", "",
                                               c("Yes" = 1, "No" = 0), selected=0, inline=TRUE)),
                                # Screen 6: "Your baby's first year is critical to healthy development and future success"
                                conditionalPanel(
                                  condition = "(input.ChooseStep5 == 1) && (input.ChooseStep6 == 0)",
                                  h1(helpText("Your baby's first year is critical to healthy development and future success"))
                                ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep5 == 1) && (input.ChooseStep6 == 0)",
                                  radioButtons("ChooseStep6", "",
                                               c("Yes" = 1, "No" = 0), selected=0, inline=TRUE)),
                                # Screen 7: "Where do you live?"
                                conditionalPanel(
                                  condition = "(input.ChooseStep6 == 1) && (input.ChooseStep7 == 0)",
                                  selectInput('stateName_BA', "Where do you live?", c(Choose='', state.name), 
                                              selected="Virginia", selectize=FALSE)),
                                conditionalPanel(
                                  condition = "(input.ChooseStep6 == 1) && (input.ChooseStep7 == 0)",
                                  radioButtons("ChooseStep7", "",
                                               c("Yes" = 1, "No" = 0), selected=0, inline=TRUE))
                              ),
                              mainPanel(
                                textOutput("currentTime_BA")
                                # Regular table display - instead use DataTable for more interactivity
                                # tableOutput("payGapRecords")
                                #dataTableOutput("payGapRecordsDT_BA")
                              )
                            )
                   ), # tabPanel("BumpAhead",
                   
                   tabPanel("MIDAAS",
                            # Application title
                            titlePanel("HackThePayGap App for Workers: MIDAAS Navigator"),
                            # img(src='logo_bumpAhead_small.png', align = "right"),
                            
                            # Sidebar 
                            sidebarLayout(
                              sidebarPanel(
                                img(src='logo_bumpAhead_small.png'),
                                
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
                              ), # sidebarPanel( 
                              
                              # Show a plot of the generated distribution
                              mainPanel(
                                textOutput("currentTime"),
                                # Regular table display - instead use DataTable for more interactivity
                                # tableOutput("payGapRecords")
                                dataTableOutput("payGapRecordsDT") 
                              ) # mainPanel
                            ) # sidebarLayout ( 
                   ), # tabPanel("MIDAAS",

                   tabPanel("PUMS (TBD)", 
                            # Application title
                            titlePanel("HackThePayGap App for Workers: PUMS Navigator"),
                            
                            # Sidebar 
                            sidebarLayout(
                              sidebarPanel(
                                img(src='logo_bumpAhead_small.png'),
                                #
                                # Uncomment the below line only if you want the data updates to happen 
                                # iff the user clicks the "Update View" button.
                                # submitButton("Update View"), 
                                #
                                selectInput('stateNamePUMS', "State:", c(Choose='', state.name), 
                                            selected="Virginia", selectize=FALSE)
                              ), # sidebarPanel( 
                              
                              mainPanel(
                                # textOutput("currentTime") 
                                # Regular table display - instead use DataTable for more interactivity
                                # tableOutput("payGapRecords")
                                # dataTableOutput("payGapRecordsDT")
                              ) # mainPanel
                            ) # sidebarLayout(
                   ), # tabPanel("PUMS", 
                   
                   navbarMenu("More",
                              tabPanel("BumpAhead Project Proposal",
                                       img(src='logo_bumpAhead_small.png'),
                                       fluidRow(
                                         column(6,
                                                includeMarkdown("Proposal.md")
                                         ),
                                         column(3,
                                                HTML('<div style="float: margin: 0 5px 5px 10px;"><iframe width="560" height="315" src="https://www.youtube.com/embed/guLDvQ8IPUA" frameborder="0" allowfullscreen></iframe></div>'),
                                                tags$small(
                                                  "Project Proposal Video: BumpAhead App - HackThePayGap Application for Workers"
                                                )
                                         )
                                       )
                              ),
                              tabPanel("About BumpAhead",
                                       fluidRow(
                                         column(6,
                                                includeMarkdown("About.md")
                                         ),
                                         column(3,
                                                img(class="img-polaroid",
                                                    src="logo_bumpAhead.png", width = "611px", height = "538px"),
                                                tags$strong(
                                                  "Logo: BumpAhead App - HackThePayGap Application for Workers"
                                                ),
                                                img(class="img-polaroid",
                                                    src="wordcloud_packages_res600.png", width = "806px", height = "538px"),
                                                tags$strong(
                                                  "Wordcloud of 1500 Tweets with Paygap"
                                                )
                                         )
                                       ) # fluidRow(
                              ), # tabPanel("About BumpAhead",
                              tabPanel("BumpAhead Design",
                                       img(src='logo_bumpAhead_small.png'),
                                       tags$strong(
                                         "BumpAhead App Design - HackThePayGap Application for Workers"
                                       ),
                                       img(class="img-polaroid",
                                           src="design.png", width = "1281px", height = "734px")
                              )
                   ) # navbarMenu("More",
        ) # navbarPage("BumpAhead",
) # shinyUI(navbarPage("BumpAhead",        