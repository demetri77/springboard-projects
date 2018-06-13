#titanic <- read.csv(file="titanic_original.csv", header=TRUE, sep=",")
#library(readxl)
library(tidyverse)

# Load the data
titanicX <- read_excel("titanic_original.xls")
write_csv(titanicX, "titanic_original.csv")
ledger <- read_csv("titanic_original.csv")

# Port of embarkation, replace unknown embarkation with Southampton
missEntry <- 0
for (i in 1:length(ledger$embarked)) {
  if (is.na(ledger$embarked[i])) {
    missEntry <- missEntry + 1
    ledger$embarked[i] <- "S"
  }
}

# Age
# Calcuate average age and median age
avgAge <- mean(ledger$age, na.rm = TRUE)
medAge <- median(ledger$age, na.rm = TRUE)
# Fill in missing values for Age
missAge <- 0
for (i in 1:length(ledger$age)) {
  if (is.na(ledger$age[i])) {
    missAge <- missAge + 1
    ledger$age[i] <- avgAge
  }
}

# Lifeboat
# Fill in missing values
missBoat <- 0
for (i in 1:length(ledger$boat)) {
  if (is.na(ledger$boat[i])) {
    missBoat <- missBoat + 1
    ledger$boat[i] = "None"
  }
}

# Cabin
# Investigate missing cabin values
has_cabin_number <- if_else (!is.na(ledger$cabin), 1, 0) 
ledger <- data.frame(ledger, has_cabin_number)

write_csv(ledger, "titanic_clean.csv")