
# Nutrient Calculator Application

[Nutrient Calculator Shiny App link](http://discovery2.mynetgear.com:3838/FoodCalculatorPSQL/)

__Application summary:__ 

This Application loads the USDA food database and perform a simple addition of macro-nutrients. You can sort through food group, food name and weight measurements to add the ingredient to your recipe. The application will build a list of ingredients and measurement as well as a summary table of the macro-nutrients for the ingredients in your basket.

__Application Usage:__

Generate a quick view for home cook meals of macro-nutrient levels. 

__Application Build:__

The application is built using a package called shiny in R. Shiny wraps HTML code around R-programs to allow for web page development. 
The data is stored in a custom built PostgreSQL database. The logic for building ingredients list and the macro-nutrients summary table is directly built-in the database in SQL code as a PostgreSQL function.
