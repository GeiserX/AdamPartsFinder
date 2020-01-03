dashboardPage(
    skin = "blue", title = "Parts Finder",
    dashboardHeader(title = tags$img(src='logo.png', height="100%", width="100%", align="left"), titleWidth = 150),
    dashboardSidebar(
        width = 150,
        sidebarMenu(
            menuItem("Search", tabName = "tab1", icon = shiny::icon("search-dollar")),
            menuItem("Upload", tabName = "tab2", icon = shiny::icon("upload")),
            menuItem("Browse files", tabName = "tab3", icon = shiny::icon("search"))
        )
    ),
    dashboardBody(
        tags$head(tags$style(HTML('
        .skin-blue .main-header .logo {
            background-color: #3689D7 !important;
        }
        .skin-blue .main-header .logo:hover {
            background-color: #3689D7 !important;
        }
        .box-primary .box-header {
            background-color: #3689D7 !important;
        }
        .navbar {
            background-color: #3689D7 !important;
        }'))),
            fluidRow(
                tabItems(
                    tabItem(tabName = "tab1",
                            box(width = 4, status = "primary", title = "Search", solidHeader = T,
                                fluidRow( 
                                    column(6, numericInput("searchBox1", label = "Introduce Part No.*", value = NA)),
                                    column(6, numericInput("searchQuantity1", label = "Introduce Quantity*", value = NA)),
                                    column(6, numericInput("searchBox2", label = "Introduce Part No.", value = NA)),
                                    column(6, numericInput("searchQuantity2", label = "Introduce Quantity", value = NA)),
                                    column(6, numericInput("searchBox3", label = "Introduce Part No.", value = NA)),
                                    column(6, numericInput("searchQuantity3", label = "Introduce Quantity", value = NA))
                                ),
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
                                selectInput("selectFile", choices = c("Main file" = "ALL", "Supplier A" = "A",
                                                                      "Supplier B" = "B", "Supplier C" = "C"),
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
