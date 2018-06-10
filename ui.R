#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(scales) 
library(rsconnect)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Observations about Campaign Finance, Money Raised by Candidates"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(fluid = TRUE,

    sidebarPanel(
      
      conditionalPanel(
        'input.dataset === "Home"',
        strong("Background:"),
        fluidRow("Campaign finance practices have attracted a great amount of attention lately. This webpage aims to provide some insight about money associated with different types of races and candidates. Importantly, the graphics shown here are intended to stimulate the viewer's curiosity about the subject of money in politics."),
        fluidRow("Disclaimer: The data used to generate figures was webscraped from https://www.opensecrets.org. The author of the webpage is not aware about the completeness and any other attributes pertaining to the quality of the data."),
        br(),
        
        strong("Summary:"),
        fluidRow("Tremendous sums of money are involved in U.S. elections."),
        br(),
        fluidRow("Data supports the commonly held belief that people tend to like their own representative/senator and dislike the congress in general."),
        fluidRow("Winners are able to raise twice or thrice or even higher amount of sums compared to their competitors. Incumbents win more often than not."),
        br(),
        fluidRow("Role of money in electioneering must be probed and communicated to the public."),
        fluidRow("Why is the need to spend so much money, especially if the results can be predicted? Moreover, who contributes the bulk of money and why?")
        
      ),
      
      conditionalPanel(
        'input.dataset === "Senate Races Loop Up"',
        selectInput('yr', 'Choose a Year:', choices = senate$year),
        selectInput('st', 'Choose a State:',choices = senate$state),
        actionButton("update", "Change")
      ),
        
        conditionalPanel(
  'input.dataset === "Incumbent Candidates"',
  fluidRow("No Incumbent Democrat Lost in 2006. First time in the history of the Republican party, it did NOT defeat an incumbent democrat. The pattern repeated in 2008, 2012, and 2016 senate elections."),
  fluidRow("Similarly, no Incumbent Republican lost in 2010 and 2014 senate elections."),
  fluidRow("In 2016, only two incumbents lost their seats in Senate, Kelly Ayotte to Maggie Hassan (NH) and Mark Kirk to Tammy Duckworth (IL)."),
  fluidRow("Only 2 candidates have won a US Congressional district as a third party/independent incumbent candidate in the 21st century."),
  fluidRow("(1) Bernie Sanders from VT in 2000, 2002, (2) Virgil Goode from VA in 2000.")
  )
  ),  
    
    
    # Show a plot of the generated distribution
    mainPanel(
        tabsetPanel(
                  id = 'dataset',
          tabPanel("Home", 
                   fluidRow(
                   ),
                       plotOutput("gS_WL"),plotOutput("gH_WL")
                   ),
          tabPanel("States", 
         plotOutput("all_states_house_alltime"),
         plotOutput("all_states_senate_alltime"),
         plotOutput("relative_senate_amount")
          ),
         
          tabPanel("Senate Races Loop Up", 
                   fluidRow(
                   ),
                     verbatimTextOutput("text1"),
                     DT::dataTableOutput("mytable1"),
                     plotOutput("senate_bar")
          ),
 		   tabPanel("Incumbent Candidates", 
                   fluidRow(),
                     plotOutput("Incumbent1"),plotOutput("Incumbent2")
 		   ),
 		   tabPanel("Senate Races", 
 		            DT::dataTableOutput("senate_table")
        ),
 		   tabPanel("House Races", 
 		            DT::dataTableOutput("house_table")
        )
 		   
        )    
    )
  )
))
