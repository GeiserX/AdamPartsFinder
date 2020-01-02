library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(DT)

options(shiny.maxRequestSize=200*1024^2) # 200MB limit on uploads

shinyServer(function(input, output, session) {
  
  dataframe <- reactiveValues(A=data.frame(), B=data.frame(), C=data.frame())
  if(file.exists("data/SupplierALL.csv")) dataframe$ALL <- read.csv("data/SupplierALL.csv", header = T)
  if(file.exists("data/SupplierA.csv")) dataframe$A <- read.csv("data/SupplierA.csv", header = T)
  if(file.exists("data/SupplierB.csv")) dataframe$B <- read.csv("data/SupplierB.csv", header = T)
  if(file.exists("data/SupplierC.csv")) dataframe$C <- read.csv("data/SupplierC.csv", header = T)
  
  observeEvent(input$searchButton,{
    if(!is.null(input$searchBox1) && is.numeric(input$searchBox1) && !is.null(input$searchQuantity1) && is.numeric(input$searchQuantity1)){
      found <- dataframe$ALL[dataframe$ALL$PartID %in% input$searchBox1, c(-1,-3)]
      found <- found[found$Quantity > input$searchQuantity1,]
      found <- found[order(found$Cost.Per.Unit), ]
      found <- found[1,]
      if(dim(found)[1] == 0){
        sendSweetAlert(session = session, title = "Error", text = "Could not find a matching Part ID with available stock", type = "error")
      } else {
        if(!is.null(input$searchBox2) && is.numeric(input$searchBox2) && !is.null(input$searchQuantity2) && is.numeric(input$searchQuantity2)){
          found2 <- dataframe$ALL[dataframe$ALL$PartID %in% input$searchBox2, c(-1,-3)]
          found2 <- found2[found2$Quantity > input$searchQuantity2,]
          found2 <- found2[order(found2$Cost.Per.Unit), ]
          found2 <- found2[1,]
          if(!is.null(input$searchBox3) && is.numeric(input$searchBox3) && !is.null(input$searchQuantity3) && is.numeric(input$searchQuantity3)){
            found3 <- dataframe$ALL[dataframe$ALL$PartID %in% input$searchBox3, c(-1,-3)]
            found3 <- found3[found3$Quantity > input$searchQuantity3,]
            found3 <- found3[order(found3$Cost.Per.Unit), ]
            found3 <- found3[1,]
            output$partid_results <- renderDataTable(datatable(rbind(found, found2, found3), options = list(order = list(list(1, 'asc')))))
          } else {
            output$partid_results <- renderDataTable(datatable(rbind(found, found2), options = list(order = list(list(1, 'asc')))))
          }
        } else {
          output$partid_results <- renderDataTable(datatable(found, options = list(order = list(list(1, 'asc'))))) 
        }
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
      rownames(dataframe$ALL) <- NULL
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