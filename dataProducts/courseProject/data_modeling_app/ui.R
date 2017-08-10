library(shiny)

shinyUI(
    fluidPage(
        titlePanel('Simple Random Forest Modeling'),
        sidebarLayout(
            sidebarPanel(
                radioButtons("dataset_name", label="Select the dataset", selected="iris", choices=c("iris", "mtcars")),
                selectInput("to_predict", "What do you want to predict?", ""),
                selectInput("predictors", "Choose the predictors you want to include.", "", multiple=TRUE),
                checkboxInput("use_test_set", "Holdout 20% of the data for testing?", value=FALSE),
                actionButton("build_model", "Build Model")),
        mainPanel(
            tabsetPanel(
                tabPanel("Data", dataTableOutput("dataset_table")),
                tabPanel("Model Summary",
                    downloadButton("download_model", "Download Model"),
                    htmlOutput("model_summmary")),
                tabPanel("Predictions Plot",
                    downloadButton("download_plot", "Download Plot"),
                    plotOutput("predictions_plot")),
                tabPanel("Help",
                    htmlOutput("help_doc"))))
        )
    )
)