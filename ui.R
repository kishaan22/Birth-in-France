
shinyUI( fluidPage(
  
  # Theme bslib
  theme = bs_theme (
    version = 5,
    bg = "#FFFFFF",
    fg = "#112446",
    primary = "#112446",
    "well-bg" = "#FFF",
    base_font = font_google("Poppins")
  ),
  
  h1("Births in France", align = "center"),
  
  tags$head(
    # Custom CSS styles 
    tags$link(rel="stylesheet", type="text/css", href="css_custom_styles.css"),
  ),
  
  navlistPanel(
    id = "tabs",
    selected = "General",
    widths = c(2, 10),
    
    header = tagList(
      
      conditionalPanel(
        condition = "input.tabs == 'General' | input.tabs == 'Data'",
        
        fluidRow(
          column(
            width = 9,
            
            radioGroupButtons(
              inputId = "level",
              label = "Display :",
              choices = list(
                "France" = "fra",
                "Region" = "reg",
                "Departement" = "dep"),
              selected = "fra",
              justified = TRUE
            )
          ), 
          
          column(
            width = 3,
            
            conditionalPanel(
              condition = "input.level == 'dep' | input.level == 'reg'",
              selectizeInput(
                inputId = "region_or_dep",
                label = NULL,
                choices = NULL
              )
            )
            
          )
        )
      )
    ), 
    
    
    ########## First page : GENERAL ##########
    
    tabPanel(
      title = "General",
      
      fluidRow(
        column(
          width = 4,
          statiCard(
            value = 0,
            subtitle = "Number of births in 2020",
            icon = icon("child"),
            color = "#112446",
            animate = TRUE,
            id = "card_n_births"
          )
        ),
        
        column(
          width = 4,
          statiCard(
            value = 0,
            subtitle = "Birth rate in 2020",
            icon = icon("chart-line"),
            color = "#112446",
            animate = TRUE,
            id = "card_natality"
          )
        ),
        column(
          width = 4,
          statiCard(
            value = 0,
            subtitle = "Peak of births",
            icon = icon("arrow-up"),
            color = "#112446",
            animate = TRUE,
            id = "card_pic"
          )
        )
      ),
      
      fluidRow(
        
        column(
          width = 6,
          apexchartOutput(outputId = "number_births_time")
        ),
        column(
          width = 6,
          apexchartOutput(outputId = "birth_rate")
        )
      )
    ),
    
    
    ########## Second page : Map ##########
    
    tabPanel(
      title = "Map",
      
      fluidRow(
        
        column(
          width = 9,
          radioGroupButtons(
            inputId = "map_level",
            label = "Display :",
            choices = list("Region" = "region", "Departement" = "departement"),
            selected = "region",
            justified = TRUE
          )
        ),
        
        column(
          width = 3,
          awesomeRadio(
            inputId = "variable",
            label = "Choice of variable:",
            choices = list(
              "Number of births",
              "Birth-rate",
              "Mean age of mother"),
            selected = "Number of births"
          )
        )
      ), 
      
      br(),
      
      leafletOutput(outputId = "map", width = "100%", height = 600)    
      
    ),
    ########## Third page : DATA ##########
    
    tabPanel(
      title = "Data",
      downloadButton(outputId = "export_data", label = "Exporter", class = "mb-3"),
      reactableOutput(outputId = "array_data")
    )
  )
)

)
