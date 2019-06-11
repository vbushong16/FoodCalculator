
# library(odbc)
library(shiny)
# library(RODBC)
library(odbc)
library(DBI)



cone <- DBI::dbConnect(odbc::odbc(),
                       driver = "PostgreSQL",
                       UID = "Username",
                       PWD ="Password",
                       database = "Database Name",
                       server = "Server Location",
                       port = "Port Number")



# odbcDataSources()
# close(cone)

### SQL Queries

# sqlQuery(cone,"DROP TABLE ingredient_temp")

# QueryFoodGroup = paste0("SELECT food_group_description, food_group_code FROM food_group_table")
# FoodGroupQuery = sqlQuery(cone,QueryFoodGroup,as.is=TRUE)

QueryFoodGroup = paste0("SELECT food_group_description, food_group_code FROM food_group_table")
result = dbSendQuery(cone,QueryFoodGroup,as.is=TRUE)
FoodGroupQuery <- dbFetch(result)

# QueryFoodName = paste0("SELECT ndb_no,long_description,food_group_code FROM food_description_table")
# FoodNameQuery = sqlQuery(cone,QueryFoodName,as.is=TRUE)

QueryFoodName = paste0("SELECT ndb_no,long_description,food_group_code FROM food_description_table")
result = dbSendQuery(cone,QueryFoodName,as.is=TRUE)
FoodNameQuery <- dbFetch(result)

# QueryWeightMeasure = paste0("SELECT ndb_no, measure_description FROM weight_definition_table")
# WeightMeasureQuery = sqlQuery(cone,QueryWeightMeasure,as.is=TRUE)

QueryWeightMeasure = paste0("SELECT ndb_no, measure_description FROM weight_definition_table")
result = dbSendQuery(cone,QueryWeightMeasure,as.is=TRUE)
WeightMeasureQuery <- dbFetch(result)




shinyServer(function(input, output) {
  
  
  ###
  ###  data inputting
  
  output$FoodGroupInput <- renderUI({
    
    selectInput(inputId = "FoodGroupInput",
                label = "Select Food Group",
                choices = unique(FoodGroupQuery$food_group_description))
  })
  
  output$FoodName <- renderUI({

    selectInput(inputId = "FoodName",
                label = "Select Food Name",
                choices = FoodNameQuery[FoodNameQuery$food_group_code %in% (FoodGroupQuery[FoodGroupQuery$food_group_description %in% input$FoodGroupInput,"food_group_code"]),"long_description"])
  })

  output$WeightMeasure <- renderUI({

    selectInput(inputId = "WeightMeasure",
                label = "Select Weight Measure",
                choices =   WeightMeasureQuery[WeightMeasureQuery$ndb_no %in% (FoodNameQuery[FoodNameQuery$long_description %in% input$FoodName,"ndb_no"]),"measure_description"])
  })
  
  
  # ADDING Foods to my Ingredient list
  
  myRecipe <- reactiveValues()
  myMeasurements <- reactiveValues()
  
  observeEvent(input$addRecipeIngredient,{


    # paste0("select * from select_temp_data('",FoodToAdd,"', '",input$WeightMeasure,"');")


    isolate({

      FoodToAdd = FoodNameQuery[FoodNameQuery$long_description %in% input$FoodName,"ndb_no"]
      # FoodCompositionTable <- sqlQuery(cone, paste0("select * from select_temp_data('",FoodToAdd,"', '",input$WeightMeasure,"');"), as.is=T)

      # FoodToAdd = "20453"
      # WeightMeasure = "cup"
            
      # functionQuery = paste0("select * from select_temp_data('",FoodToAdd,"', '",WeightMeasure,"');")
      functionQuery = paste0("select * from select_temp_data('",FoodToAdd,"', '",input$WeightMeasure,"');")
      result <- dbSendQuery(cone,functionQuery , as.is=T)
      FoodCompositionTable <- dbFetch(result)
      
      output$FoodComposition <- renderTable({
        FoodCompositionTableOut = FoodCompositionTable
        return(FoodCompositionTableOut)

      })

      isolate({
        myRecipe$dList <- c(myRecipe$dList, input$FoodName)
        myMeasurements$dList <- c(myMeasurements$dList, input$WeightMeasure)

        output$IngredientList <- renderTable({

          out1 = cbind(myRecipe$dList,myMeasurements$dList)
          output <- as.data.frame(out1)
          col <- c("MyIngredients","MyMeasurements")
          colnames(output)<-col
          return(output)
        })

      })

    })
  })
  
  
})
