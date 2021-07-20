library(shiny)
library(scales)
library(lattice)
library(plyr)
library(caret)
library(rms)
library(mice)
model<-readRDS('conversionpredictor.rds')

shinyServer(function(input, output){

  inputdata <- reactive({
    procclass<-ifelse(input$proc=='Peptic Ulcer'|input$proc=='Gastric Surg-other','UGI',
                      ifelse(input$proc=='L Colectomy'|input$proc=='R Colectomy'|input$proc=='Subtotal/panproctocolectomy'|input$proc=='Hartmanns','Color','General'))
    
    specc<-ifelse(procclass=='UGI'&input$speccons=='UGI','Yes',
                             ifelse(procclass=='UGI'&input$speccons!='UGI','No',
                                    ifelse(procclass=='Color'&input$speccons=='Colorectal','Yes',
                                           ifelse(procclass=='Color'&input$speccons!='Colorectal','No',
                                                  ifelse(procclass=='General'&input$speccons!='General','Yes',
                                                         ifelse(input$speccons=='General','No',
                                                                NA))))))
    
    data0 <- data.frame(
      Predicted.Blood.Loss = as.factor(input$predBL),
      Time.of.Surgery = as.factor(input$time),
      Specialty.Consultant = as.factor(specc),
      Peritoneal.Soiling = as.factor(input$soil),
      Procedure = as.factor(input$proc),
      Surgeon.Grade = as.factor(input$grade),
      Sex = as.factor(input$gender)
    )
    data0
  })

  output$result <- renderTable({
    data0 = inputdata()
    prob<-predict(model,data0,type='fitted')
    
    L <- predict(model, newdata=data0, se.fit=TRUE)
    se<-plogis(with(L, linear.predictors + 1.96*cbind(- se.fit, se.fit)))

    resultTable = data.frame(
      Result = "Probability of Conversion (95% CI)",
      Percent = paste0(scales::percent(prob,accuracy = 0.1),' (',
                                 scales::percent(se[1,1],accuracy = 0.1),'-',
                                 scales::percent(se[1,2],accuracy = 0.1),')')
    )
    resultTable
  })
})



