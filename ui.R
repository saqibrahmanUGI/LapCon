library(shiny)
library(qs)

proc<-c("Washout only","Peptic Ulcer","Gastric Surg-other","Small Bowel Resection",
        "L Colectomy","R Colectomy","Subtotal/panproctocolectomy","Hartmanns","Other","Adhesionolysis",
        "Drainage of Abscess","Stoma Formation")

fluidPage(
  titlePanel("Probability of conversion for laparoscopic attempted emergency general surgery"),
  sidebarLayout(
    sidebarPanel(

    selectInput("predBL", "Predicted Blood Loss (ml)", choices = c("<100","101-500","501-999",">1000")),
    selectInput("time", "Time of Surgery", choices = c("In hours", "Out of hours")),
    selectInput("soil", "Peritoneal Soiling", choices = c("None","Serous Fluid","Localised Pus","Free pus, blood or bowel contents")),
    selectInput("proc", "Procedure", 
                choices = proc),
    selectInput("speccons", "Consultant Specialty", choices = c('General','UGI','Colorectal')),
    selectInput("grade", "Grade of senior surgeon", choices = c('Consultant','Non-Consultant')),
    selectInput("gender", "Gender", choices = c('Male','Female'))
    ),
    mainPanel(
      # Output: Table
      tableOutput("result")
    )
  )
)

