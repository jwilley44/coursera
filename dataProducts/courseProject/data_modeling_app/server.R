library(shiny)
library(ggplot2)
library(tidyverse)
library(caret)
library(randomForest)

data(iris)
data(mtcars)

loadDataSet <- function(name) eval(parse(text=name))

testPlot <- function() qplot(x=1:10, y=1:10)

plotResults <- function(dataset, outcome, rf_model, isClassification=TRUE)
{
    dataset$prediction <- predict(rf_model, dataset)
    if (isClassification)
    {
       ggplot(data=dataset, aes_string(x=outcome)) + 
            geom_bar(aes(fill=prediction == eval(parse(text=outcome))), position="dodge") +
            labs(fill="Correctly Predicted") + 
            facet_wrap(~set, ncol=1) +
            theme_bw()
    } else
    {
        ggplot(data=dataset, aes_string(y=outcome)) + geom_point(aes(x=prediction)) + 
            facet_wrap(~set, ncol=1) + 
            theme_bw()
    }
}

buildFormula <- function(outcome, predictors) parse(text=paste(outcome, "~", paste(collapse=" + ", predictors)))

buildRandomForest <- function(outcome, predictors, training_set, filterTraining)
{
    training_set <- filter(training_set, set == "training") %>% select(-set)
    randomForest(formula=eval(buildFormula(outcome, predictors)), data=training_set)
}

getHelpDoc <- function()
{
    paste(sep="<br/>", 
          "1. Select a dataset, either the iris or mtcars dataset.",
          "2. Select the property that you wish to predict. Likely the Species or the mpg from the iris or mtcars datasets respectively.",
          "3. Select the properties that you want to use to build a model. You must select at least one.",
          "4. Check whether you want to create leave 20% of the data out of the model for testing.",
          "5. Click build model.",
          "6. Select either the Model Summary or Predictions Plot to view and download the results.",
          "7. To build a new model select the Data tab and repeat the steps 1-6.")
}

shinyServer(
    function(input, output, session)
    {
        output$help_doc <- renderUI({HTML(getHelpDoc())})
        dataset <- reactive({loadDataSet(input$dataset_name)})
        observe({updateSelectInput(session, "to_predict", choices=colnames(dataset()))})
        available_predictors <- reactive({
            cols <- colnames(dataset())
            cols[cols != input$to_predict]
        })
        output$dataset_table <- renderDataTable(dataset())
        observe({updateSelectInput(session, "predictors", choices=available_predictors())})
        predictors <- reactive({input$predictors})
        outcome <- reactive({input$to_predict})
        splitset <- reactive(
            {
                ds <- loadDataSet(input$dataset_name)
                ds$set <- "training"
                if (input$use_test_set)
                {
                    set.seed(1234)
                    tr <- createDataPartition(ds[[input$to_predict]], p=0.8)
                    ds$set <- 1:nrow(ds) %in% tr$Resample1
                    ds <- mutate(ds, set=ifelse(set, "training", "test"))
                }
                return(ds)
            })
        rf_run <- eventReactive(input$build_model, 
            {
                withProgress(message="Building Model", {buildRandomForest(outcome(), predictors(), splitset())})
            })
        output$model_summmary <- renderUI({HTML(paste(capture.output(rf_run()), collapse="<br/>"))})
        useClassification <- reactive(
            {
                values <- loadDataSet(input$dataset_name)[[input$to_predict]]
                is.factor(values) | is.character(values)
            })
        output$predictions_plot <- renderPlot(plotResults(splitset(), outcome(), rf_run(), isClassification = useClassification()))
        
        output$download_model <- downloadHandler(
            filename=function() paste(input$dataset_name, input$to_predict, "model", sep="."),
            content=function(file) saveRDS(rf_run(), file) )
        output$download_plot <- downloadHandler(
            filename=function() paste(input$dataset_name, input$to_predict, "png", sep="."),
            content=function(file) ggsave(file, plotResults(splitset(), outcome(), rf_run(), isClassification = useClassification())))
    }
)