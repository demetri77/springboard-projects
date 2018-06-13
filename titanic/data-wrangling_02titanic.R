library(readxl)
library(tidyverse)

# Load the data
titanicX <- read_excel("titanic/titanic_original.xls")
write_csv(titanicX, "titanic/titanic_original.csv")
ledger <- read_csv("titanic/titanic_original.csv")

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
for (i in 1:length(ledger$age)) {
  if (is.na(ledger$age[i])) {
    ledger$age[i] <- avgAge
  }
}

# Lifeboat - Fill in missing values
for (i in 1:length(ledger$boat)) {
  if (is.na(ledger$boat[i])) {
    ledger$boat[i] = "None"
  }
}

# Cabin - Investigate missing cabin values
has_cabin_number <- if_else(!is.na(ledger$cabin), 1, 0) 
ledger <- data.frame(ledger, has_cabin_number)

write_csv(ledger, "titanic/titanic_clean.csv")
