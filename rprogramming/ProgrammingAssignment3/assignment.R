loadOutcomes <- function()
{
    outcomes <- read.csv("outcome-of-care-measures.csv", as.is=T)
    outcomes[, 11] <- as.numeric(outcomes[, 11])
    outcomes[, 17] <- as.numeric(outcomes[, 17])
    outcomes[, 23] <- as.numeric(outcomes[, 23])
    outcomes[, c(1:10, 11, 17, 23)]
}

best <- function(state, outcome)
{    
    outcomeData <- loadOutcomes()

    if (! state %in% unique(outcomeData$State))
    {
      stop("invalid state”")
    }

    outcomes2cols <- list(
      "heart attack" = 11,
      "heart failure" = 12,
      "pneumonia" = 13
      )

    colIndex <- outcomes2cols[[outcome]]

    if (is.null(colIndex))
    {
        stop("invalid outcome")
    }

    subsetState <- outcomeData[outcomeData$State == state, ]
    minRate <- min(subsetState[, colIndex], na.rm=T)
    bestHospitals <- subsetState[subsetState[, colIndex] == minRate, "Hospital.Name"]
    sort(bestHospitals)[1]
  
}

rankhospital <- function(state, outcome, rank=1, .data=NULL)
{
    
    outcomeData <- .data
    if (is.null(outcomeData))
    {
        outcomeData <- loadOutcomes()
    }
  
    if (! state %in% unique(outcomeData$State))
    {
      stop("invalid state”")
    }
  
    outcomes2cols <- list(
        "heart attack" = 11,
        "heart failure" = 12,
        "pneumonia" = 13
    )
  
    colIndex <- outcomes2cols[[outcome]]
  
    if (is.null(colIndex))
    {
        stop("invalid outcome")
    }
    subsetState <- subset(outcomeData, State == state)
    outcomeValues <- subsetState[, colIndex]
    subsetState <- subsetState[!is.na(outcomeValues), ]
    outcomeValues <- subsetState[, colIndex]
    outcomeData <- subsetState[order(outcomeValues, subsetState$Hospital.Name), ]
    rankedHospitals <- outcomeData[outcomeData$State == state && !is.na(outcomeData[, colIndex]), "Hospital.Name"]
    if (rank == "worst")
    {
        tail(rankedHospitals, 1)
    }
    else
    {
        outcomeData[outcomeData$State == state, "Hospital.Name"][rank]
    }
}

rankall <- function(outcome, rank)
{
    outcomes <- loadOutcomes()
    rankings <- sapply(unique(outcomes$State), function(state) rankhospital(state, outcome, rank, outcomes))
    as.data.frame(rankings)                 
}