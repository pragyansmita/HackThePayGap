# Load required libraries
if (!require(shiny))
  install.packages("shiny")
if (!require(markdown))
  install.packages("markdown")
if (!require(DT))
  install.packages("DT")
# http://rpackages.ianhowson.com/cran/metricsgraphics/
if (!require(metricsgraphics))
  install.packages("metricsgraphics")


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
                            tags$head(tags$style(
                              HTML('
                                #sidebarInfo {
                                    background-color: #d8ddfe; #Light blue for Informational pages
                                }
                                #sidebarImagine {
                                    background-color: #9da9fb; #Dark blue for Imagination pages
                                }
                                #sidebarData {
                                    background-color: #9dfbca; #Light green for Data pages
                                }
                        
                                body, label, input, button, select { 
                                  font-family: "Arial";
                                }')
                            )),
                            # Application title
                            titlePanel("HackThePayGap App for Workers: BumpAhead App"),
                            sidebarLayout(
                              sidebarPanel(
                                #id="sidebarInfo",
                                img(src='logo_bumpAhead_small.png'),
                                # Screen 1: "On average, and across all occupations, women in the United States earn 79 cents for every dollar earned by men."
                                conditionalPanel(
                                  condition = "input.ChooseStep1 == 0",
                                  id="sidebarInfo",
                                  h1(helpText("On average, and across all occupations, women in the United States earn", 
                                     strong("79 cents"), "for every", 
                                     strong("100 cents (dollar)"), "earned by men."))
                                  ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep1 == 0)",
                                  actionButton("ChooseStep1", "Next")
                                  ),
                                # Screen 2: "Due, in large part, to the motherhood penalty."
                                conditionalPanel(
                                  condition = "(input.ChooseStep1 == 1) && (input.ChooseStep2 == 0)",
                                  id="sidebarInfo",
                                  h1(helpText("Due, in large part, to", strong("the motherhood penalty.")))
                                  ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep1 == 1) && (input.ChooseStep2 == 0)",
                                  actionButton("ChooseStep2", "Next")
                                  ),
                                # Screen 3: "When women have a child, their potential future earnings decreases by 5%."
                                conditionalPanel(
                                  condition = "(input.ChooseStep2 == 1) && (input.ChooseStep3 == 0)",
                                  id="sidebarInfo",
                                  h1(helpText("When women have a child, their potential future earnings decreases by", strong("5%.")))
                                  ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep2 == 1) && (input.ChooseStep3 == 0)",
                                  actionButton("ChooseStep3", "Next")
                                  ),
                                # Screen 4: "Simultaneously, their expenses drastically increase. On average, child care in the U.S. costs $11,666 per year."
                                conditionalPanel(
                                  condition = "(input.ChooseStep3 == 1) && (input.ChooseStep4 == 0)",
                                  id="sidebarInfo",
                                  h1(helpText("Simultaneously, their expenses drastically increase. On average, child care in the U.S. costs", 
                                              strong("$11,666"), "per year."))
                                  ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep3 == 1) && (input.ChooseStep4 == 0)",
                                  actionButton("ChooseStep4", "Next")
                                  ),
                                # Screen 5: "Imagine..."
                                conditionalPanel(
                                  condition = "(input.ChooseStep4 == 1) && (input.ChooseStep5 == 0)",
                                  id="sidebarImagine",
                                  h1(helpText(strong("Imagine...")))
                                  ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep4 == 1) && (input.ChooseStep5 == 0)",
                                  actionButton("ChooseStep5", "Next")
                                  ),
                                # Screen 6: "that you are about to be a mother for the first time. You are excitedly planning for the new life that you and your child will share."
                                conditionalPanel(
                                  condition = "(input.ChooseStep5 == 1) && (input.ChooseStep6 == 0)",
                                  id="sidebarImagine",
                                  h1(helpText("that you are about to be a mother for the first time.")),
                                  h1(helpText("You are",
                                              strong("excitedly planning"), "for the", 
                                              strong("new life"), "that you and your child will share."))
                                  ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep5 == 1) && (input.ChooseStep6 == 0)",
                                  actionButton("ChooseStep6", "Next")
                                  ),
                                # Screen 7: "You are young and driven and want to make something of your life. You work full-time and plan on continuing to work after the baby comes."
                                conditionalPanel(
                                  condition = "(input.ChooseStep6 == 1) && (input.ChooseStep7 == 0)",
                                  id="sidebarImagine",
                                  h1(helpText("You are young and driven and want to make something of your life.")),
                                  h1(helpText("You work full-time and plan on", 
                                              strong("continuing to work"), "after the baby comes."))
                                ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep6 == 1) && (input.ChooseStep7 == 0)",
                                  actionButton("ChooseStep7", "Next")
                                ),
                                # Screen 8: "That means you need affordable and high quality child care. You take this decision seriously, because your baby's first year is critical to healthy development and future success."
                                conditionalPanel(
                                  condition = "(input.ChooseStep7 == 1) && (input.ChooseStep8 == 0)",
                                  id="sidebarImagine",
                                  h1(helpText("That means you need", 
                                              strong("affordable"), "and", 
                                              strong("high quality"), "child care.")),
                                  h1(helpText("You take this decision seriously, because your baby's first year is critical to healthy development and future success."))
                                ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep7 == 1) && (input.ChooseStep8 == 0)",
                                  actionButton("ChooseStep8", "Next")
                                ),
                                # Screen 9: "Play to see how this choice causes the motherhood penalty."
                                conditionalPanel(
                                  condition = "(input.ChooseStep8 == 1) && (input.ChooseStep9 == 0)",
                                  id="sidebarImagine",
                                  h1(helpText("Play to see how this choice", 
                                              strong("causes"), "the motherhood penalty."))
                                ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep8 == 1) && (input.ChooseStep9 == 0)",
                                  actionButton("ChooseStep9", "Play >")
                                ),
                                # Screen 10: "Where do you live?"
                                conditionalPanel(
                                  condition = "(input.ChooseStep9 == 1) && (input.ChooseStep10 == 0)",
                                  id="sidebarData",
                                  selectInput('stateName_BA', "Where do you live?", c(Choose='', state.name), 
                                              selected="Virginia", selectize=FALSE)
                                  ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep9 == 1) && (input.ChooseStep10 == 0)",
                                  actionButton("ChooseStep10", "Next")
                                  )
                              ),
                              mainPanel(
                                textOutput("currentTime_BA"),
                                conditionalPanel(
                                  condition = "input.ChooseStep1 == 0",
                                  img(src='skintones_b.gif')
                                ),
                                conditionalPanel(
                                  condition = "(input.ChooseStep9 == 1) && (input.ChooseStep10 == 0)",
                                  #plotOutput("plot_BA"),
                                  metricsgraphicsOutput("mjs_plot_BA"),
                                  # Regular table display - instead use DataTable for more interactivity
                                  # tableOutput("payGapRecords_BA")
                                  dataTableOutput("payGapRecordsDT_BA")
                                )
                              ) # mainPanel(
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
                   #navbarMenu("More",
                   tabPanel("Project Proposal",
                            img(src='logo_bumpAhead_small.png'),
                            fluidRow(
                              column(6,
                                     includeMarkdown("Proposal.md")
                              ),
                              column(3,
                                     tags$video(width="560", height="315", src="BumpaheadVideoSubmission.m4v", controls=NA),
                                     tags$small(
                                       "Project Proposal Video: BumpAhead App - HackThePayGap Application for Workers"
                                     )
                              )
                            )
                   ),
                   tabPanel("Design",
                            img(src='logo_bumpAhead_small.png'),
                            tags$strong(
                              "BumpAhead App Design - HackThePayGap Application for Workers"
                            ),
                            htmlOutput('pdfviewer'),
                            # tags$iframe(width = "100%", height = "500px", scrolling="yes", 
                            #             src="babymamma_InVision.pdf"),
                            img(class="img-polaroid",
                                src="design.png", width = "1281px", height = "734px")
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
                   ) # tabPanel("About BumpAhead",
                   #) # navbarMenu("More",
        ) # navbarPage("BumpAhead",
) # shinyUI(navbarPage("BumpAhead",        