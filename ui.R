library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(DT)

dashboardPage(
    dashboardHeader(title = "Parts Finder"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Search", tabName = "tab1", icon = shiny::icon("search-dollar")),
            menuItem("Upload", tabName = "tab2", icon = shiny::icon("upload")),
            menuItem("Browse files", tabName = "tab3", icon = shiny::icon("search"))
        )
    ),
    dashboardBody(
            fluidRow(
                tabItems(
                    tabItem(tabName = "tab1",
                            box(width = 4, status = "primary", title = "Search", solidHeader = T,
                                numericInput("searchBox", label = "Introduce Part No.", value = NA),
                                actionButton("searchButton", "Search", shiny::icon("search-dollar"))
                            ),
                            box(width = 8, status = "info", title = "Search results", solidHeader = T,
                                dataTableOutput("partid_results")
                            )
                    ),
                    tabItem(tabName = "tab2",
                            box(width = 4, status = "primary", title = "Upload", solidHeader = T,
                                selectInput("selectSupplier", choices = c("Supplier A" = "A", "Supplier B" = "B", "Supplier C" = "C"),
                                            multiple = F, selectize = T, label = "Select a Supplier"),
                                fileInput("fileUpload", label = "Select a CSV", buttonLabel = "Browse...",
                                        placeholder = "No files selected yet...", multiple = F,
                                        accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
                                actionButton("uploadButton", "Upload", icon = shiny::icon("upload"))
                            ),
                            box(width = 8, status = "info", title = "Uploaded data", solidHeader = T,
                                dataTableOutput("read_columns")
                            )
                    ),
                    tabItem(tabName = "tab3",
                            box(width = 4, status = "primary", title = "Select CSV to visualize", solidHeader = T,
                                selectInput("selectFile", choices = c("Supplier A" = "A", "Supplier B" = "B", "Supplier C" = "C"),
                                            multiple = F, selectize = T, label = "Select a Supplier")
                            ),
                            box(width = 8, status = "info", title = "System data", solidHeader = T,
                                dataTableOutput("read_columns_filesystem")
                            )
                    )
                )
            )
        )
    
)
