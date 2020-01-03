library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(DT)

options(shiny.maxRequestSize=200*1024^2) # 200MB limit on uploads
dataframe <- reactiveValues(A=data.frame(), B=data.frame(), C=data.frame(), ALL=data.frame())
if(file.exists("data/SupplierALL.csv")) dataframe$ALL <- read.csv("data/SupplierALL.csv", header = T)
if(file.exists("data/SupplierA.csv")) dataframe$A <- read.csv("data/SupplierA.csv", header = T)
if(file.exists("data/SupplierB.csv")) dataframe$B <- read.csv("data/SupplierB.csv", header = T)
if(file.exists("data/SupplierC.csv")) dataframe$C <- read.csv("data/SupplierC.csv", header = T)