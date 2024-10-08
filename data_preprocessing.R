library(readr)
library(tidyverse)
library(dplyr)

user_file <- "data/reduced/yelp_academic_dataset_user_reduced.csv"
business_file <- "data/reduced/yelp_academic_dataset_business_reduced.csv"
review_file <- "data/reduced/yelp_academic_dataset_review_reduced.csv"

# review_file1 <- "data/reduced/yelp_academic_dataset_review_reduced1.csv"
# review_file2 <- "data/reduced/yelp_academic_dataset_review_reduced2.csv"

# user_file <- "data/test/user_reduced_test.csv"
# business_file <- "data/test/business_test.csv"
# review_file <- "data/test/review_reduced_test.csv"

review <- read_csv(review_file)
user <- read_csv(user_file)
business <- read_csv(business_file)

# review1 <- read_csv(review_file1)
# review2 <- read_csv(review_file2)
# review <- rbind(review1, review2)

# View(user)
# View(business)
# View(review)

new_user <- subset(user, select = c(fans, average_stars, elite,
                                    review_count, user_id, compliments))
new_user <- mutate(new_user, elite = as.integer(str_length(elite) > 3))

new_business <- subset(business, select = c(business_id))
new_review <- subset(review, select = c(business_id, user_id, stars, useful, word_count))
new_review <- right_join(new_review, new_business, by = "business_id")

new <- new_review %>%
  group_by(user_id) %>%
  summarise(
    average_useful = mean(useful),
    total_useful = sum(useful),
    extreme_ratings = sum(stars == 1) + sum(stars == 5),
    extreme_ratings_ratio = mean(stars == 1 | stars == 5),
    average_word_count = mean(word_count)
  )

data <- left_join(new, new_user, by = "user_id")
View(head(data))

write.csv(data, "yelp_data_new.csv", row.names = FALSE)