# Load the data
#dataset <- read.csv(file="refine_original.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
library(tidyverse)
dataset <- read_csv("refine_original.csv")

# Clean up brand names: philips, akzo, van houten, and unilever
company_clean <- tolower(dataset$company)

search_replace <- function(pattern, replacement, x) {
  positions <- grep(pattern, x)
  for (i in positions) {
    x[i] <- replacement
  }
  return(x)
}
company_clean <- search_replace("^a.*", "akzo", company_clean)
company_clean <- search_replace("*.ps$", "philips", company_clean)
company_clean <- search_replace("^u*.*r$", "unilever", company_clean)
company_clean <- search_replace("^van\\s", "van houten", company_clean)
dataset$company <- company_clean

# Separate product code and number
dataset <- separate(dataset, "Product code / number", c("prodCode", "prodNum"), sep = "-")

# Add product category, p=Smartphone, v=TV, x=Laptop, q=Tablet
#prodCat <- rep("Smartphone", times=25)
for (i in 1:length(dataset$prodCode)) {
  if (dataset$prodCode[i] == "p") {
    prodCat[i] <- "Smartphone"
  } else if (dataset$prodCode[i] == "v") {
    prodCat[i] <- "TV"
  } else if (dataset$prodCode[i] == "x") {
    prodCat[i] <- "Laptop"
  } else if (dataset$prodCode[i] == "q") {
    prodCat[i] <- "Tablet"
  }
}

dataset <- data.frame(dataset, prodCat)
#dataset <- data.frame(dataset$company, dataset$prodCode, dataset$prodNum, prodCat, tolower(dataset$address), dataset$city, dataset$country, dataset$name)

# Add full address for geocoding
dataset$address <- tolower(dataset$address)
dataset <- unite(dataset, full_address, address, city, country, sep=", ", remove = FALSE)

# Add binary value for companies: akzo, philips, unilever, van houten
isAkzo <- if_else(dataset$company == "akzo", 1, 0)
isPhilips <- if_else(dataset$company == "philips", 1, 0)
isUnilever <- if_else(dataset$company == "unilever", 1, 0)
isVanHouten <- if_else(dataset$company == "van houten", 1, 0)
dataset <- data.frame(dataset, isAkzo, isPhilips, isUnilever, isVanHouten)

# Add binary value for product category: Smartphone, TV, Laptop, Tablet
isSmartphone <- if_else(dataset$prodCode == "p", 1, 0)
isTV <- if_else(dataset$prodCode == "v", 1, 0)
isLaptop <- if_else(dataset$prodCode == "x", 1, 0)
isTablet <- if_else(dataset$prodCode == "q", 1, 0)
dataset <- data.frame(dataset, isSmartphone, isTV, isLaptop, isTablet)

write_csv(dataset, "refine_clean.csv")
