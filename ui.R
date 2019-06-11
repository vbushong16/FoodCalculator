library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Food Composition"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      uiOutput(outputId = "FoodGroupInput"),
      uiOutput(outputId = "FoodName"),
      uiOutput(outputId = "WeightMeasure"),
      actionButton('addRecipeIngredient','Add Ingredient to Recipe')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("IngredientList"),
      tableOutput("FoodComposition")
    )
  )
))