library(readr)
library(dplyr)
library(tidyr)

library(readr)
titanic_original <- read_csv("~/Desktop/Springboard/titanic_original.csv")
View(titanic_original)

# Replace emabarked NAs with 'S'

titanic_original <- titanic_original %>% replace_na(list(embarked = "S"), embarked)

# Replace age NAs with mean of age

mean_age <- mean(titanic_original$age, na.rm = TRUE)
titanic_original <- titanic_original %>% replace_na(list(age = mean_age), age)

# Replace missing values in boat column with dummy value 'None'

titanic_original <- titanic_original %>%  replace_na(list(boat = "None"), boat)

# Create new column to show if passenger has_cabin_number (1), or not (0)

titanic_original <- titanic_original %>% mutate(has_cabin_number = ifelse(is.na(cabin), 0, 1))

# Save cleaned data as CSV 

write_csv(titanic_original, "titanic_clean.csv")
