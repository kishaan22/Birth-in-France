


shinyServer (function(input, output, session) {
  
  # Reactive filter on the choice of data
  births_r <- reactive({
    if (input$level == "fra") {
      births_france
    } else if (input$level == "dep") {
      req(input$region_or_dep %in% births_department$GEO)
      births_department %>%
        filter(GEO == input$region_or_dep)
    } else {
      req(input$region_or_dep %in% births_region$GEO)
      births_region %>%
        filter(GEO == input$region_or_dep)
    }
  })
  
  
  ########## First page : GENERAL ##########
  
  observeEvent(input$level, {
    if (input$level == "dep") {
      updateSelectInput(
        session,
        inputId = "region_or_dep",
        label = "Departement: ",
        choices = unique(births_department$GEO)
      )
    } else if (input$level == "reg") {
      updateSelectInput(
        session,
        inputId = "region_or_dep",
        label = "Region: ",
        choices = unique(births_region$GEO)
      )
    }
  })
  
  
  # Card 1 : "Number of births in 2020"
  
  observeEvent(births_r(),  {
    value_r <- births_r() %>%
      filter(YEAR == "2020") %>% 
      pull(NUMBER_BIRTH)
    updateStatiCard(
      id = "card_n_births",
      value = format(value_r, big.mark = " ")
    )
  })
  
  
  # Card 2 : "Birth rate in 2020"
  
  observeEvent(births_r(), {
    value_r <- births_r() %>%
      filter(YEAR == "2020") %>% 
      pull(BIRTH_RATE)
    updateStatiCard(
      id = "card_natality",
      value = value_r
    )
  })
  
  
  # Card 3 : "Peak of births"
  
  observeEvent(births_r(), {
    value_r <- births_r() %>% 
      slice_max(NUMBER_BIRTH, n = 1) %>% 
      pull(YEAR)
    updateStatiCard(
      value = value_r,
      id = "card_pic"
    )
  })
  
  
  # Curve of the "Number of births" with the apexcharter package
  
  output$number_births_time <- renderApexchart({
    
    # if the geo level chosen is France, aggregated data is used,    
    # else the reactive object with the selected department or the selected region    
    apex(
      data = births_r(),
      type = "line",
      mapping = aes(x = as.Date(paste0(YEAR, "-01-01"), format = "%Y-%m-%d"), y = NUMBER_BIRTH)
    ) %>% 
      ax_xaxis(labels = list(format = "yyyy")) %>% 
      ax_tooltip(
        x = list(format = "yyyy")
      )  %>%
      ax_title(
        text = "Number of births between 1975 and 2020" 
      ) %>% 
      ax_colors("#112446")
    
  })
  
  # Barplot "Birth rate" with apexcharter package
  
  output$birth_rate <- renderApexchart({
    
    # if the geo level chosen is France, aggregated data is used,
    # else the reactive object with the selected department or the selected region
    apex(
      data = births_r(), 
      type = "column", 
      mapping = aes(x =  as.Date(paste0(YEAR, "-01-01"), format = "%Y-%m-%d"), y = BIRTH_RATE)
    ) %>%
      ax_xaxis(labels = list(format = "yyyy")) %>% 
      ax_tooltip(
        x = list(format = "yyyy")
      ) %>% 
      ax_title(
        text = "Birth-rate"
      ) %>% 
      ax_colors("#112446")
    
  })
  
  
  ########## Second page : MAP ##########
  
  # Map initialization with Leaflet
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(
        lng = 2.80,
        lat = 46.80,
        zoom = 5
      ) %>%
      addProviderTiles(providers$OpenStreetMap.France)
  })
  
  # Map update via proxy
  
  observe({
    
    input$tabs
    
    if (input$map_level == "region") {
      contour <- contour_regions
    } else {
      contour <- contour_departements
    }
    
    if (input$variable == "Number of births") {
      value <- contour %>% 
        pull(NBRE_NAISSANCES)
      colour <- "Blues"
      popup <- "Number of births :"
      legend <- "Number of births in 2020"
    } else if (input$variable == "Birth-rate") {
      value <- contour %>%
        pull(TAUX_NATALITE)
      colour <- "Greens"
      popup <- "Birth-rate :"
      legend <- "Birth rate in 2020"
    } else {
      value <- contour %>% 
        pull(AGE_MOYEN_MERE)
      colour <- "RdPu"
      popup <- "Mean age of mother :"
      legend <- "Average age of mother in 2020"
    }
    
    pal <- colorNumeric(
      palette = colour,
      domain = value
    )
    
    leafletProxy("map") %>%
      clearShapes() %>%
      addPolygons(
        data = contour,
        fill = TRUE,
        fillColor = pal(value),
        fillOpacity = 0.7,
        color = "#424242",
        opacity = 0.8,
        weight = 2,
        highlightOptions = highlightOptions(color = "white", weight = 2),
        popup = paste0(popup, value)
      ) %>%
      clearControls() %>%
      addLegend(
        position = "bottomright",
        title = legend,
        pal = pal,
        values = value,
        opacity = 1
      )
  })
  
  ########## Third page : DATA ##########
  
  # Table display
  output$array_data <-renderReactable({
    reactable(births_r(), bordered = TRUE)
  })
  
  # Data export module
  output$export_data <- downloadHandler(
    filename = function() {
      "export_births.csv"
    },
    content = function(file) {
      write.csv2(x = births_r(), file = file, row.names = FALSE)
    }
  )
  
})





