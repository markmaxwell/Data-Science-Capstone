library(shiny)

  
shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("NLP Text Prediction"),
    sidebarPanel(
      p("This Shiny application is used by inputting a phrase into the text box. A prediction of your next work will be returned when the phrase is submitted."),
      br(),
      textInput(inputId = 'phrase',label =  'Your Phrase'),
      submitButton('Submit')
    ),

    mainPanel(
      h4('You Phrase With Prediction'),
      verbatimTextOutput("prediction")
    )
  )
)