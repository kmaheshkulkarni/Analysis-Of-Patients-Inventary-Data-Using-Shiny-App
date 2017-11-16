library(shiny)
library(RColorBrewer)
library(lubridate)
library(RSQLite)
library(plotly)
library(leaflet)
library(ggmap)
library(sqldf)
library(DBI)

shinyServer(
  function(input, output){
    
    
    #a$AdmissionMonth<-month(a$`AddmissionDate`,label=TRUE)
    #a$AdmitMonth<-month(a$AdmitDate,label=TRUE)
    # a$dichargemonth<-month(a$DischargeDate,label=TRUE)
    
    x<-reactive({
    a[,as.numeric(input$var1)]
    })
    
    y<-reactive({
      a[,as.numeric(input$var2)]
      
    })
    xy<-reactive({
      a[,as.numeric(input$var12)]
      
    })
    
    output$plot <-renderPlot({
      plot(x(),y(),ylim=c(1,50))
      
    })
    output$down <-downloadHandler(
      filename = function(){
        paste("a",input$var3,sep=".")
        
      },
      content=function(file){
        #open the device
        #create
        #close
        if(input$var3=="png")
          png(file)
        else
          pdf(file)
        plot(x(),y())
        dev.off()
      }
    )
    
    #feedback
    output$plot1 <-renderPlotly({
      #plot(xy())
      #d<-summary(a$Feedback)
      #barplot(d,main="Patient Satisfacation Indicator",xlab="F",ylab="Parameters",horiz=F,border = T,col=c(1:5),legend.text = T,args.legend = list(x ='topright', bty='n'))
       plot_ly(
             x = c("Satisfied", "Very Satisfied","Unsatisfied","Neutral","Very Unsatisfied"),
             y = c(57,31,20,30,34),
             type = "bar",
             color = c("Satisfied", "Very Satisfied","Unsatisfied","Neutral","Very Unsatisfied"),
             showlegend = T )
    })
    output$feed <-downloadHandler(
      filename = function(){
        paste("a",input$var13,sep=".")
        
      },
      content=function(file){
        #open the device
        #create
        #close
        if(input$var3=="png")
          png(file)
        else
          pdf(file)
        plot(x(),y())
        dev.off()
      }
    )
    #Diseases Detected
    
    output$plot2<-renderPlot({
      # aa=a$diseases.symptoms
      #bb=a$Test
      #plot(aa,bb)
      
      d<-summary(a$diseasesDetected)
      #d<-summary(sqldf('select diseasesDetected from a where diseasesDetected in ("accident","Brain Damage","Cancer","Chicken pox","dengue","Heart-attack","malaria","Suger,Hear-tattack","typhoid")'))
      barplot(d,main="Diseases Detected",ylim=c(0,50),xlab="Diseases Name",ylab="No of patient",axisnames = T,horiz=F,border = T,col=c("darkblue","red","grey","yellow","black","white","pink","green","skyblue"),legend.text = T,args.legend = list(x ='topright', bty='n'),cex.names = 0.75,names.arg = c("accident","Brain Damage","Cancer","Chicken pox","dengue","Heart-attack","malaria","Suger,Hear-tattack","typhoid"))
      #barplot(d,main="Diseases Detected",xlab="Diseases Name",ylab="No of patient",horiz=F,border = T,col=c("darkblue","red","grey","yellow","black","white","pink","green","skyblue"),legend.text = T,args.legend = list(x ='topleft', bty='n', inset=c(-0.25,0)))
      })
    
    #symptoms and Diseases 
 output$blood <- renderText({
      
      #bt<-sqldf('select Test from a where diseasesSymptoms ="Fever" group by Test')
      bt<- sqldf('select diseasesSymptoms from a where Test="Blood tests"')
     # Ut<- sqldf('select diseasesSymptoms from a where Test="Urine tests"')
   #  St <- sqldf('select diseasesSymptoms from a where Test="Stool tests"')
     summary(bt)
      
  #  barplot(bt)
      #barplot(s,xlab="Test Name",ylab="Symptoms of patient",horiz=F,border = T,col=c("darkblue","red","grey","yellow","black","white","pink","green","skyblue"),legend.text = T,args.legend = list(x ='topright', bty='n'),cex.names = 2)
     #plot(bt,Ut,St)
    })
 output$urine <- renderText({
   
   
  # bt<- sqldf('select diseasesSymptoms from a where Test="Blood tests"')
   Ut<- sqldf('select diseasesSymptoms from a where Test="Urine tests"')
  # St <- sqldf('select diseasesSymptoms from a where Test="Stool tests"')
   summary(Ut)
   
   #plot(bt,Ut,St)
 })
 output$stool <- renderText({
   
   
  # bt<- sqldf('select diseasesSymptoms from a where Test="Blood tests"')
   #Ut<- sqldf('select diseasesSymptoms from a where Test="Urine tests"')
   St <- sqldf('select diseasesSymptoms from a where Test="Stool tests"')
   summary(St)
   #plot(bt,Ut,St)
 })
 
    #PERCENTAGE OF PATIENT
 output$plot4 <-renderPlot({
   
   s=stat$AddmissionStatus
   s.freq=table(s)
   pie(s.freq,label=as.character(s.freq),  col=rainbow(length(s.freq)),border="brown",clockwise=TRUE,main="Pie Chart")
   #legend(1.5, 0.5,legend=(list(x ='topright', bty='n')))#, fill=col,cex=0.8,bty='n',horiz=TRUE)
   legend(0.5, 0.5, c("Appointment","No","Yes"), cex=0.8,fill=rainbow(length(s.freq)))
 })
 output$pat_sum <- renderText({
   s=a$AddmissionStatus
   #s.freq=table(s)
   summary(s)
   
  
 })
 #Dashboard
 output$totpatient <- renderValueBox({
   
   count <- sqldf('select count(*) from a where AddmissionStatus is "Yes"')
   
   valueBox(count,"Patient Served",icon = icon("flag-o"), color = 'green') })
 
 
 output$totfeedback <- renderValueBox({
   sat <- sqldf('select count(*) from a where Feedback="Satisfied" OR Feedback="Very Satisfied" OR Feedback="Neutral"')
   valueBox(sat,"Patient Satisfied",icon = icon("globe"), color = 'red') })
 

 output$totper <- renderValueBox({
   count <- sqldf('select count(*) from a where AddmissionStatus is "Yes"')
   sat <- sqldf('select count(*) from a where Feedback="Satisfied" OR Feedback="Very Satisfied" OR Feedback="Neutral"')
   as<-round(sat/count*100)
   valueBox(as,"Percent people satisfied",icon = icon("bank"), color = 'purple') })
 
 

#Month
output$plot5<-renderPlot({
  x<-as.character(a$AddmissionDate)
  a$AdMonth<-month(x,label=TRUE)
  
  ad<-summary(a$AdMonth)
  #sb=a$AdMonth
  #sb.freq=table(sb)
 #s=as.numeric(sb.freq)
  
  barplot(ad,ylim = c(0,35),xlab = "Month",col = rainbow(ad))
})
output$winter <- renderValueBox({
  count1 <- sqldf('select count(*) from a where Admonth = "Jan" or Admonth = "Feb" or Admonth = "Nov" or Admonth = "Dec"')
  sat1 <- sqldf('select count(*) from a')
  as1<-round(sat1/count1*100)
  valueBox(count1,"Percent people Addmit in Winter",icon = icon("bank"), color = 'aqua') })
  
output$summer <- renderValueBox({
  count2 <- sqldf('select count(*) from a where Admonth = "Mar" or Admonth = "Apr" or Admonth = "May" or Admonth = "June"')
  sat2 <- sqldf('select count(*) from a')
  as2<-round(sat2/count2*100)
  valueBox(count2,"Percent people Addmit in Summer",icon = icon("bank"), color = 'yellow') })

output$rain <- renderValueBox({
  count3 <- sqldf('select count(*) from a where Admonth = "Jul" or Admonth = "Aug" or Admonth = "Sep" or Admonth = "Oct"')
  sat3 <- sqldf('select count(*) from a')
  as3<-round(sat3/count3*100)
  valueBox(count3,"Percent people Addmit in Raniy",icon = icon("bank"), color = 'light-blue') })


#Map Location
lon<-as.numeric(loc$lon)
lat<-as.numeric(loc$lat)
m <- leaflet() %>%
  addTiles() %>%
  setView(76.761,19.217, zoom = 8)%>%addMarkers(lon,lat,clusterOptions=markerClusterOptions(),
  popup = paste("Diseases", a$diseasesDetected,"<br>","Location","<br>",a$Address,"Name",a$FirstName,a$LastName))


output$m <-renderLeaflet(m)


})