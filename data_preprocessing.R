library(readr)
library(tidyverse)
library(dplyr)

user_file <- "data/yelp_csv/yelp_academic_dataset_user_reduced.csv"
business_file <- "data/yelp_csv/yelp_academic_dataset_business.csv"
review_file1 <- "data/yelp_csv/yelp_academic_dataset_review_reduced1.csv"
review_file2 <- "data/yelp_csv/yelp_academic_dataset_review_reduced2.csv"

# user_file <- "data/test/user_reduced_test.csv"
# business_file <- "data/test/business_test.csv"
# review_file <- "data/test/review_reduced_test.csv"

user <- read_csv(user_file)
business <- read_csv(business_file)
review1 <- read_csv(review_file1)
review2 <- read_csv(review_file2)
review <- rbind(review1, review2)
# review <- read_csv(review_file)

# View(user)
# View(business)
# View(review)

new_user <- subset(user, select = c(fans, average_stars, elite,
                                    review_count, user_id))
new_user <- mutate(new_user, elite = as.integer(str_length(elite) > 3))

new_business <- subset(business, select = c(business_id, review_count))

new_review <- subset(review, select = c(business_id, user_id, stars, useful))
new_review <- left_join(new_review, new_business, by = "business_id")
# new_review <- new_review %>% rename(stars = stars.x, business_stars = stars.y)

new <- new_review %>%
  group_by(user_id) %>%
  summarise(
    average_business_review_count = mean(review_count),
    average_useful = mean(useful)
  )

data <- left_join(new, new_user, by = "user_id")
View(head(data))

write.csv(data, "yelp_data.csv", row.names = FALSE)