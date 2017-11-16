library(leaflet)
library(ggmap)
library(shiny)
library(shinydashboard)
library(sqldf)
library(RColorBrewer)
library(plotly)
library(lubridate)
library(RSQLite)
library(DBI)

dashboardPage(
  dashboardHeader(title = h3("Patient Data Analytics")),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard1", tabName = "dashboard1", icon = icon("dashboard")),
      menuItem("Feedback", tabName = "feedback", icon = icon("")),
      #menuItem("DataEntry", tabName = "dataentry", icon = icon("")),
      menuItem("Symptoms and medical test relation", tabName = "test", icon = icon("")),
      menuItem("Readmission", tabName = "readmission", icon = icon("")),
      menuItem("Percentage of patient who left without treatment", tabName = "pat", icon = icon("")),
      menuItem("Diseases Detected", tabName = "dd", icon = icon("")),
      menuItem("Location", tabName = "loc", icon = icon("")),
      menuItem("Download The Reports", tabName = "download", icon = icon(""))
      #menuItem("Upload The files", tabName = "upload", icon = icon(""))
    )),
  
  
  
  dashboardBody(tabItems(
   
    tabItem(tabName = "dashboard1",
            fluidPage(
              title = "DB",
              fluidRow(
                column(width = 8,
                       box(
                         style = "font-size: 110%;",
                         width = 18,
                         height = 200,
                         background = "light-blue",
                         solidHeader = FALSE,
                         collapsible = FALSE,
                         collapsed = FALSE,
                         h2("Analysis of Parient Inventory Data Using R"),
                         p("The purpose of this project is to analyze patient’s inventory data captured by hospital and to generate various reports required by hospital management."))),
                
                
                
                column(width = 7,
                       height = 200,
                       fluidRow(
                         box(
                           title = "Observations That we Are Consodering",
                           status = "primary",
                           solidHeader = TRUE,
                           collapsible = TRUE,
                           width = 19,
                           height = 200,
                           
                           
                             tags$ol("
                                     1. No of patient admitted and discharged in month."),
                             
                             
                             
                             tags$ol("2.	Inpatient days of care delivered  that is how many patient visit hospital a day"),
                             
                             
                             tags$ol("3.	Percentage of patient who left without treatment"),
                             
                             tags$ol("4.	Symptoms and medical test relation")
                             
                             )
                         
                         
                         
                         
                       ))
                
                
                         )
              
              
                )),
    tabItem(tabName = "dd",
            fluidPage(
              titlePanel("Diseases Detected"),
              
              mainPanel(
                plotOutput("plot2")
                
              )
            )),
    
    
    tabItem(tabName = "loc",
            fluidPage(
              titlePanel("In which city/area Patient find"),
              mainPanel(
                leafletOutput("m"),
                fluidRow(column(4, tableOutput('table')))
                
              )
            )),
    
    
    tabItem(tabName = "readmission",
            fluidPage(fluidRow(
              column(width = 12,
                     valueBoxOutput("winter", width = 3),
                     valueBoxOutput("summer", width = 3),
                     valueBoxOutput("rain", width = 3))),
              titlePanel("Month"),
              
              mainPanel(
                plotOutput("plot5")
                
              )
            )),
    
    
    tabItem(tabName = "download",
            fluidPage(
              titlePanel("Download base plot in shiny"),
              sidebarLayout(
                sidebarPanel(
                  selectInput(inputId="var1",label="Select X variable",choices=c("Addmission Status"=5,"phoneno"=6,"Height"=7,"weight"=8,"DOB"=9,"Age"=10,"BloodGRoup"=11,"Address"=11,"diseases Detected"=14,"diseases symptoms"=13,"Addmission Date"=19,"Readmission.Status"=20,"Test"=22,"Test Report"=23,"Feedback"=27,"Addmonth"=28)),
                  selectInput(inputId="var2",label="Select y variable",choices=c("Addmission Status"=5,"phoneno"=6,"Height"=7,"weight"=8,"DOB"=9,"Age"=10,"BloodGRoup"=11,"Address"=11,"diseases Detected"=14,"diseases symptoms"=13,"Addmission Date"=19,"Readmission.Status"=20,"Test"=22,"Test Report"=23,"Feedback"=27,"Addmonth"=28)),
                  radioButtons(inputId="var3",label="select the file type", choices = list("png","pdf"))
                  
                ),
                mainPanel(
                  
                  
                  plotOutput("plot"),
                  downloadButton(outputId="down",label="download the plot")
                  
                )
              )
            )),

    tabItem(tabName = "test",
            fluidPage(
              titlePanel("Symptoms and Test relation"),
mainPanel( #plotOutput("urine"),
                tabsetPanel(type="tab",
                                   tabPanel("BloodTest",verbatimTextOutput("blood")),
                            tabPanel("Urine Test",verbatimTextOutput("urine")),
                            tabPanel("StoolTest",verbatimTextOutput("stool"))
                                   
                                      
                                      
              )
                
                
              )
            )),

tabItem(tabName = "pat",
        fluidPage(
          titlePanel("Addmission"),
          
          mainPanel(
            tabsetPanel(type="tab",
                        tabPanel("Summary",verbatimTextOutput("pat_sum")),
                        tabPanel("Graph",plotOutput("plot4"))
                        
                        
                        
                        
            )
          )
        )),
    tabItem(tabName = "feedback",
            fluidPage(fluidRow(
              column(width = 12,
                     valueBoxOutput("totpatient", width = 3),
                     valueBoxOutput("totfeedback", width = 3),
                     valueBoxOutput("totper", width = 3))),
              titlePanel("Download base plot in shiny"),
              
              mainPanel(
                
                
                plotlyOutput("plot1"),
                downloadButton(outputId="feed",label="download the plot")
                
                
              )
            ))
    
  )))
