shinyUI(fluidPage( 
  titlePanel("Sentiment Analysis"), #Title
  textOutput("currentTime"),   #Here, I show a real time clock
  fluidRow(
    # Other Twitter tags of significance: #Hackthepaygap, PayGap,etc
    column(3,
           textInput("searchTag", label = h3("Search Twitter:"), value = "PayGap")),
    column(3,
           sliderInput("numTweet", label = h3("Number of tweets"), min = 0, max = 10000, value = 1500, animate=TRUE)
    )),
  fluidRow(
    h4("Tweets:"),   #Sidebar title
    sidebarLayout(
      sidebarPanel(
        dataTableOutput('tweets_table') #Here I show the users and the sentiment
      ),
      
      mainPanel(
        plotOutput("distPlot"), #Here I will show the bars graph
        sidebarPanel(
          plotOutput("positive_wordcloud") #Cloud for positive words
        ),
        sidebarPanel(
          plotOutput("negative_wordcloud") #Cloud for negative words
        ),
        sidebarPanel(
          plotOutput("neutral_wordcloud") #Cloud for neutral words
        ))))))