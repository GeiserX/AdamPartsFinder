shinyServer(function(input, output, session) {
  
  observeEvent(input$searchButton,{
    if(!is.null(input$searchBox1) && is.numeric(input$searchBox1) 
       && !is.null(input$searchQuantity1) && is.numeric(input$searchQuantity1)){
      if(file.exists("data/SupplierALL.csv")) {
        dataframe$ALL <- read.csv("data/SupplierALL.csv", header = T)
        found <- dataframe$ALL[dataframe$ALL$PartID %in% input$searchBox1, ]
        found$X.1 <- NULL
        found$X <- NULL
        found <- found[found$Quantity > input$searchQuantity1,]
        found <- found[order(found$Cost.Per.Unit), ]
        found <- found[1,]
        if(dim(found)[1] == 0){
          sendSweetAlert(session = session, title = "Error",
                         text = "Could not find a matching Part ID with available stock", type = "error")
        } else {
          if(!is.null(input$searchBox2) && is.numeric(input$searchBox2) 
             && !is.null(input$searchQuantity2) && is.numeric(input$searchQuantity2)){
            found2 <- dataframe$ALL[dataframe$ALL$PartID %in% input$searchBox2, ]
            found2$X.1 <- NULL
            found2$X <- NULL
            found2 <- found2[found2$Quantity > input$searchQuantity2,]
            found2 <- found2[order(found2$Cost.Per.Unit), ]
            found2 <- found2[1,]
            if(!is.null(input$searchBox3) && is.numeric(input$searchBox3) &&
               !is.null(input$searchQuantity3) && is.numeric(input$searchQuantity3)){
              found3 <- dataframe$ALL[dataframe$ALL$PartID %in% input$searchBox3, ]
              found3$X.1 <- NULL
              found3$X <- NULL
              found3 <- found3[found3$Quantity > input$searchQuantity3,]
              found3 <- found3[order(found3$Cost.Per.Unit), ]
              found3 <- found3[1,]
              foundALL <- datatable(rbind(found, found2, found3), rownames=F)
              output$partid_results <- renderDataTable(foundALL)
            } else {
              foundALL <- datatable(rbind(found, found2), rownames=F)
              output$partid_results <- renderDataTable(foundALL)
            }
          } else {
            foundALL <- datatable(found, rownames=F)
            output$partid_results <- renderDataTable(foundALL)
          }
        }
      }
      else {
        sendSweetAlert(session = session, title = "Error",
                       text = "Please, introduce any CSV into the software before searching", type = "error")
      }
    } else {
      sendSweetAlert(session = session, title = "Error", text = "Please, introduce a number before searching", type = "error")
    }
  })
  
  observeEvent(input$uploadButton, {
    if(is.null(input$fileUpload$name)){
      sendSweetAlert(session = session, title = "Error", text = "You haven't selected any file", type = "error")
    } else {
      if(input$selectSupplier == "A"){
        dataframe$A <- read.csv(input$fileUpload$datapath, header = T, row.names = NULL)
        dataframe$A <- cbind(Supplier="Supplier A", dataframe$A)
        write.csv(dataframe$A, "data/SupplierA.csv", row.names = F)
        output$read_columns <- renderDataTable(datatable(dataframe$A))
      } else if(input$selectSupplier == "B"){
        dataframe$B <- read.csv(input$fileUpload$datapath, header = T, row.names = NULL)
        dataframe$B <- cbind(Supplier="Supplier B", dataframe$B)
        write.csv(dataframe$B, "data/SupplierB.csv", row.names = F)
        output$read_columns <- renderDataTable(datatable(dataframe$B))
      } else {
        dataframe$C <- read.csv(input$fileUpload$datapath, header = T, row.names = NULL)
        dataframe$C <- cbind(Supplier="Supplier C", dataframe$C)
        write.csv(dataframe$C, "data/SupplierC.csv", row.names = F)
        output$read_columns <- renderDataTable(datatable(dataframe$B))
      }
      dataframe$ALL <- rbind(dataframe$A, dataframe$B, dataframe$C)
      
      write.csv(dataframe$ALL, "data/SupplierALL.csv", row.names = F)
      sendSweetAlert(session = session, title = "Done", text = "Data imported successfully", type = "success")
      
      # Sys.sleep(2)
      # session$reload()
    }
  })
  
  observeEvent(input$selectFile,{
    if(file.exists(paste0("data/Supplier", input$selectFile, ".csv"))){
      show <- read.csv(paste0("data/Supplier", input$selectFile, ".csv"), header = T)
      output$read_columns_filesystem <- renderDataTable(show) 
    } else {
      sendSweetAlert(session = session, title = "Error", text = "There is no file for this supplier", type = "error")
    }
  })
})