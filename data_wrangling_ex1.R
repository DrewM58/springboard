# Import Data Set

library(readr)
refine_original <- read_csv("~/refine_original.csv")
View(refine_original)

library(dplyr)
library(tidyr)

# Clean up company names

refine_original$company <- tolower(refine_original$company)

refine_original$company <- gsub("^[p|f].*", "philips", refine_original$company)
refine_original$company <- gsub("^a.*", "akzo", refine_original$company)
refine_original$company <- gsub("^v.*", "van_houten", refine_original$company)
refine_original$company <- gsub("^u.*", "unilever", refine_original$company)


# Separate product code and product number

refine_original <- refine_original %>% separate("Product code / number", c("product_code", "product_number"),"-")


# Create a function to convert product codes to categories

category <- function(a) {
    if (a == "p") {
      return("smartphone")
    } else if (a == "v") { 
      return("tv")
    } else if (a == "x") {
      return("laptop")
    } else {
      return("tablet")
    }
}
  

# Add product categories
  
refine_original <- mutate(refine_original, product_category = unlist(lapply(refine_original$product_code, category)))


# Create full address

refine_original <- refine_original %>% unite(address, city, country, col="full_address", sep=", ", remove = TRUE)


# Create dummy variables for company

refine_original <- rename(refine_original, company_name = company)
refine_original <- mutate(refine_original, company = company_name)

refine_original <- spread(refine_original, company, company, fill = "0", sep = "_")

refine_original$company_akzo <- ifelse(refine_original$company_akzo == "0", 0, 1)
refine_original$company_philips <- ifelse(refine_original$company_philips == "0", 0, 1)
refine_original$company_unilever <- ifelse(refine_original$company_unilever == "0", 0, 1)
refine_original$company_van_houten <- ifelse(refine_original$company_van_houten == "0", 0, 1)


# Create dummy variables for product category

refine_original <- mutate(refine_original, category = product_category)
refine_original <- spread(refine_original, category, category, fill = "0", sep = "_")
                                    
refine_original$category_laptop <- ifelse(refine_original$category_laptop == "0", 0, 1)
refine_original$category_smartphone <- ifelse(refine_original$category_smartphone == "0", 0, 1)
refine_original$category_tablet <- ifelse(refine_original$category_tablet == "0", 0, 1)
refine_original$category_tv <- ifelse(refine_original$category_tv == "0", 0, 1)


# Save cleaned data as CSV file

write_csv(refine_original, "refine_clean.csv")
