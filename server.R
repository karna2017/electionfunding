#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
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

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$st)
      })
    })
  })
  
  
  output$senate_bar = renderPlot({

   sample = senate[(senate$state==input$st & senate$year==input$yr & senate$amount>0 ),]
   sample = sample[c("candidate","amount","party","incumbent","win","state","year")]
   sample_winner = sample$candidate[sample$win=="Winner"]
   sample_party = sample$party[sample$win=="Winner"]
   text_y = sample$amount[sample$win=="Winner"]
   win_info = paste("Winner:",sample_winner,"(",sample_party,")")
   
   output$mytable1 <- DT::renderDataTable({
     DT::datatable(sample, options = list(lengthMenu = c(10, 15, 20), 
                                         pageLength = 10,class = 'white-space: nowrap'))
   })
   output$text1<-renderPrint({
     if(nrow(sample) == 0){
       "No Senate Election for the selected State and Year"
     }else if (length(sample_winner)>1) {
       "Two Senate Runs. Sorry! Bar charts are not available."
     } else{
       win_info
     }
     })
   if (length(sample_winner)==1){
   ggplot(sample, aes(fill=party, y=amount, x=year)) +labs(x = "year", y="Associate Amount (Million USD)")  +geom_bar(position="dodge", stat="identity",width=0.5) +
     scale_fill_manual("legend", values = c("Democratic" = "blue","other" = "green","Republican" = "red"))+
     theme_minimal()
   } else{}
   

#  sample = filter(senate, state==input$year & year==input$state)
#  text_y = sample$amount[sample$win=="Winner"]+0.5
# 
  })
  
  output$Incumbent1 <- renderPlot({
    ggplot(incumbent_lost_H_no_other, aes(fill=party, y=lost_percent, x=year)) +labs(x = "year", y="Percent of Seats Lost by Incumbents") +
      geom_bar(position="dodge", stat="identity") + annotate("text", x =2, y = 20, label = "House",color="black",size=6) +
      scale_fill_manual("legend", values = c("Democratic" = "blue","Republican" = "red"))+
      theme_minimal()
  })
  
  output$Incumbent2 <- renderPlot({
    ggplot(incumbent_lost_S_no_other, aes(fill=party, y=lost_percent, x=year)) +labs(x = "year", y="Percent of Seats Lost by Incumbents") +
      geom_bar(position="dodge", stat="identity") + annotate("text", x =7, y = 40, label = "Senate",color="black",size=6) + 
      scale_fill_manual("legend", values = c("Democratic" = "blue","Republican" = "red"))+
      theme_minimal()
  })
  
  output$gS_WL <- renderPlot({
    gS_WL =ggplot(data=senate_W_L_yearly,aes(fill=win, x=year,y=total_sum))+labs(x = "year", y="Total Amount (Million USD)")+scale_y_continuous(labels = dollar)
  gS_WL + geom_bar(position="dodge", stat="identity",width=0.4) +scale_fill_manual("legend", values = c("Winner" = "darkorange","Not a Winner" = "darkorchid"))+ theme(axis.text.x = element_text(size=20), axis.text.y= element_text(size=20))+theme_minimal()
  })
  
  output$gH_WL <- renderPlot({
    gH_WL =ggplot(data=house_W_L_yearly,aes(fill=win, x=year,y=total_sum))+labs(x = "year", y="Total Amount (Million USD)")+scale_y_continuous(labels = dollar)
  gH_WL + geom_bar(position="dodge", stat="identity",width=0.4) +scale_fill_manual("legend", values = c("Winner" = "darkorange","Not a Winner" = "darkorchid"))+ theme(axis.text.x = element_text(size=20), axis.text.y= element_text(size=20))+theme_minimal()
  })
  
  output$all_states_house_alltime <- renderPlot({
    gH_states=ggplot(data=house_state,aes(x=state,y=total_funds))+labs(x = "State", y="Total Amount (Million USD)")+scale_y_continuous(labels = dollar)
    gH_states + geom_bar(stat="identity",width=0.4,color="red4", fill="mistyrose")+ theme_minimal()+coord_flip()
   })
  
  output$all_states_senate_alltime <- renderPlot({
    gS_states=ggplot(data=senate_state,aes(x=state,y=total_funds))+labs(x = "State", y="Total Amount (Million USD)")+scale_y_continuous(labels = dollar)
    gS_states + geom_bar(stat="identity",width=0.4,color="darkmagenta", fill="thistle1")+ theme_minimal()+coord_flip()
  })

  output$relative_senate_amount <- renderPlot({
    g12=ggplot(data=relatively_expensive_senate_races,aes(x=state,y=median_relative_amount))+labs(x = "state", y="median amount per congressional district (Million)")+scale_y_continuous(labels = dollar)
    g12 + geom_bar(stat="identity",width=0.4,color="orangered4", fill="lightyellow")+ theme_minimal()+coord_flip()
  })
  
  output$house_table <- DT::renderDataTable({
    DT::datatable(house_win, options = list(lengthMenu = c(10, 15, 20), 
                                        pageLength = 5,class = 'white-space: nowrap'))
  })
  
  output$senate_table <- DT::renderDataTable({
    DT::datatable(senate_win, options = list(lengthMenu = c(10, 15, 20), 
                                        pageLength = 5,class = 'white-space: nowrap'))
  })
  
})

  