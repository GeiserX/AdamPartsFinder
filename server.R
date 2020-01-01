library(shiny)
library(shinydashboard)
library(shinyWidgets)

options(shiny.maxRequestSize=200*1024^2) # 200MB limit on uploads

shinyServer(function(input, output, session) {
  
  dataframe <- reactiveValues(A=data.frame(), B=data.frame(), C=data.frame())
  if(file.exists("data/SupplierALL.csv")) dataframe$ALL <- read.csv("data/SupplierALL.csv", header = T)
  if(file.exists("data/SupplierA.csv")) dataframe$A <- read.csv("data/SupplierA.csv", header = T)
  if(file.exists("data/SupplierB.csv")) dataframe$B <- read.csv("data/SupplierB.csv", header = T)
  if(file.exists("data/SupplierC.csv")) dataframe$C <- read.csv("data/SupplierC.csv", header = T)
  
  observeEvent(input$searchButton,{
    if(!is.null(input$searchBox) && is.numeric(input$searchBox) ){
      found <- dataframe$ALL[dataframe$ALL$PartID %in% input$searchBox, c(-1,-3, -4)]
      if(dim(found)[1] == 0){
        sendSweetAlert(session = session, title = "Error", text = "Could not find a matching Part ID", type = "error")
      } else {
        output$partid_results <- renderDataTable(found, options = list(order = list(list(1, 'asc')))) 
      }
    } else {
      sendSweetAlert(session = session, title = "Error", text = "Please, introduce a number before searching", type = "error")
    }
  })
  
  observeEvent(input$uploadButton, {
    if(is.null(input$fileUpload$name)){
      sendSweetAlert(session = session, title = "Error", text = "You haven't selected any file", type = "error")
    } else {
      dataframe$`input$selectSupplier` <- read.csv(input$fileUpload$datapath, header = T)
      write.csv(dataframe$`input$selectSupplier`, paste0("data/Supplier", input$selectSupplier, ".csv"))
      
      dataframe$ALL <- rbind(cbind(Supplier="Supplier A", dataframe$A),
                             cbind(Supplier="Supplier B", dataframe$B), 
                             cbind(Supplier="Supplier C", dataframe$C))
      write.csv(dataframe$ALL, "data/SupplierALL.csv")
      sendSweetAlert(session = session, title = "Done", text = "Data imported successfully", type = "success")
      
      output$read_columns <- renderDataTable(dataframe$`input$selectSupplier`)
    }
  })
  
  observeEvent(input$selectFile,{
    if(file.exists(paste0("data/Supplier", input$selectFile, ".csv"))){
      show <- read.csv(paste0("data/Supplier", input$selectFile, ".csv"), header = T, row.names = 1)
      output$read_columns_filesystem <- renderDataTable(show) 
    } else {
      sendSweetAlert(session = session, title = "Error", text = "There is no file for this supplier", type = "error")
    }
  })
})