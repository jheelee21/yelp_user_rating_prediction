```{r}
library(readr)
library(tidyverse)
library(dplyr)
library(MASS)
# install.packages("car")
library(car)
```

```{r}
# Data Loader
data <- read.csv("yelp_data.csv")
data <- data[complete.cases(data), ]

# Filtering the data
n <- sum(data$fans > 100)
data <- subset(data, fans > 100)
sprintf("Number of samples: %i", n)
```

```{r}
predictors = c("fans", "compliments", "average_useful", "extreme_ratings_ratio", "elite")
```

```{r, fig.width = 10, fig.height = 3}
og_model <- lm(data = data, average_word_count ~
                 fans + compliments + average_useful +
                 extreme_ratings_ratio + elite)

par(mfrow = c(1, 3))

# Residuals versus fitted values
plot(x = fitted(og_model), y = resid(og_model), main = "Residual vs Fitted",
     xlab = "Fitted", ylab = "Residuals")

# Normal Quantile-Quantile (QQ) plot
qqnorm(resid(og_model))
qqline(resid(og_model))

# Histogram of response variable
hist(data$average_word_count, xlab = "Average Word Count", 
     main = "Histogram of Response Variable")
```

```{r, fig.width = 10, fig.height = 6}
# Histogram of predictors
par(mfrow = c(2, 3))
hist(data$fans, xlab = "Number of Fans", 
     xlim = c(0, 3000), breaks = 70,
     main = "Histogram of Number of Fans")
hist(data$compliments, xlab = "Number of Compliments", 
     xlim = c(0, 30000), breaks = 200,
     main = "Histogram of Number of Compliments")
hist(data$average_useful, xlab = "Average Number of Useful Votes for Each Reviews", 
     xlim = c(0, 100), breaks = 70,
     main = "Histogram of Average Number of Useful Votes")
hist(data$extreme_ratings_ratio, xlab = "Extreme Ratings Ratio", 
     breaks = 15,
     main = "Histogram of Extreme Ratings Ratio")
hist(data$elite, xlab = "Has Been Elite",
     main = "Histogram of Has Been Elite")
```


```{r, fig.width = 5, fig.height = 5}
# Response versus fitted values
plot(data$average_word_count ~ fitted(og_model),
     xlab = "Fitted", ylab = "Average Word Count",
     main = "Response versus Fitted Values")
```

```{r, fig.width = 8, fig.height = 6}
# Pair-wise scatter plots
df <- data[predictors]
pairs(df, main = "Pair-wise Scatter Plots for Predictors")
```

```{r, fig.width = 10, fig.height = 6}
# Residuals versus each predictor 
r <- resid(og_model)
par(mfrow = c(2, 3))
plot(x = data$fans, y = r, main = "Residual versus Number of Fans",
       xlab = "Number of Fans", ylab = "Residuals")
plot(x = data$compliments, y = r, main = "Residual versus Number of Compliments",
       xlab = "Number of Compliments", ylab = "Residuals")
plot(x = data$total_useful, y = r, main = "Residual versus Average Number of Useful Votes",
       xlab = "Average Number of Useful Votes", ylab = "Residuals")
plot(x = data$extreme_ratings, y = r, main = "Residual versus Extreme Ratings Ratio",
       xlab = "Extreme Ratings Ratio", ylab = "Residuals")
boxplot(r ~ data$elite, main = "Residual versus Elite",
       xlab = "", ylab = "Residuals", names=c("Never Been Elite", "Has Been Elite"))
```

```{r}
# Transforming variables
temp_data <- data
temp_data$fans[temp_data$fans == 0] = 0.000001
temp_data$compliments[temp_data$compliments == 0] = 0.000001
temp_data$average_useful[temp_data$average_useful == 0] = 0.000001
temp_data$extreme_ratings_ratio[temp_data$extreme_ratings_ratio == 0] = 0.000001
temp_data$elite[temp_data$elite == 0] = 0.000001

summary(powerTransform(cbind(temp_data[, c("average_word_count", predictors)])))
```

```{r}
bc_average_word_count <- data$average_word_count ** 1/3
bc_fans <- data$fans ** (-1)
bc_average_useful <- data$average_useful ** 1/3
bc_extreme_ratings_ratio <- data$extreme_ratings_ratio ** 1/3
bc_elite <- data$elite ** 4/3
```

```{r}
model1 <- lm(data = data, bc_average_word_count ~
                 fans + compliments + average_useful +
                 extreme_ratings_ratio + elite)

par(mfrow = c(1, 3))

# Residuals versus fitted values
plot(x = fitted(model1), y = resid(model1), main = "Residual vs Fitted",
     xlab = "Fitted", ylab = "Residuals")

# Normal Quantile-Quantile (QQ) plot
qqnorm(resid(model1))
qqline(resid(model1))

# Histogram of response variable
hist(bc_average_word_count, xlab = "Transformed Average Word Count", 
     main = "Histogram of Transformed Response Variable")
```

```{r}
model2 <- lm(data = data, average_word_count ~
                 bc_fans + compliments + bc_average_useful +
                 bc_extreme_ratings_ratio + bc_elite)

par(mfrow = c(1, 3))

# Residuals versus fitted values
plot(x = fitted(model2), y = resid(model2), main = "Residual vs Fitted",
     xlab = "Fitted", ylab = "Residuals")

# Normal Quantile-Quantile (QQ) plot
qqnorm(resid(model2))
qqline(resid(model2))

# Histogram of response variable
hist(data$average_word_count, xlab = "Average Word Count", 
     main = "Histogram of Response Variable")
```

```{r}
model3 <- lm(data = data, bc_average_word_count ~
                 bc_fans + compliments + bc_average_useful +
                 bc_extreme_ratings_ratio + bc_elite)

par(mfrow = c(1, 3))

# Residuals versus fitted values
plot(x = fitted(model3), y = resid(model3), main = "Residual vs Fitted",
     xlab = "Fitted", ylab = "Residuals")

# Normal Quantile-Quantile (QQ) plot
qqnorm(resid(model3))
qqline(resid(model3))

# Histogram of response variable
hist(bc_average_word_count, xlab = "Transformed Average Word Count", 
     main = "Histogram of Response Variable")
```

```{r, fig.width=10, fig.height=10}
# Plots to compare the original and transformed models
par(mfrow = c(3, 4))
plot(resid(model3) ~ fitted(model3), main = "All Transformed", xlim=c(0, 500), ylim=c(-300,800))
plot(resid(model2) ~ fitted(model2), main = "Transformed X", xlim=c(0, 500), ylim=c(-300,800))
plot(resid(model1) ~ fitted(model1), main = "Transformed Y", xlim=c(0, 500), ylim=c(-300,800))
plot(resid(og_model) ~ fitted(og_model), main = "Untransformed", xlim=c(0, 500), ylim=c(-300,800))

plot(resid(model3) ~ bc_average_word_count, main = "All Transformed", xlim=c(-50, 1000), ylim=c(-300,800))
plot(resid(model2) ~ data$average_word_count, main = "Transformed X", xlim=c(-50, 1000), ylim=c(-300,800))
plot(resid(model1) ~ bc_average_word_count, main = "Transformed Y", xlim=c(-50, 1000), ylim=c(-300,800))
plot(resid(og_model) ~ data$average_word_count, main = "Untransformed", xlim=c(-50, 1000), ylim=c(-300,800))

plot(resid(model3) ~ bc_average_word_count, main = "All Transformed", xlim=c(-50, 1000), ylim=c(-300,800))
plot(resid(model2) ~ data$average_word_count, main = "Transformed X", xlim=c(-50, 1000), ylim=c(-300,800))
plot(resid(model1) ~ bc_average_word_count, main = "Transformed Y", xlim=c(-50, 1000), ylim=c(-300,800))
plot(resid(og_model) ~ data$average_word_count, main = "Untransformed", xlim=c(-50, 1000), ylim=c(-300,800))
```

```{r}
# We choose model3 to carry forward

new_predictors = c("bc_fans", "compliments", "bc_average_useful", "bc_extreme_ratings_ratio", "bc_elite")

new <- data
new$bc_average_word_count <- new$average_word_count ** 1/3
new$bc_fans <- new$fans ** (-1)
new$bc_average_useful <- new$average_useful ** 1/3
new$bc_extreme_ratings_ratio <- new$extreme_ratings_ratio ** 1/3
new$bc_elite <- new$elite ** 4/3
new <- subset(as.data.frame(new), select = c("bc_average_word_count", new_predictors))

new <- new[complete.cases(new),]
```

```{r}
full <- lm(data = new, bc_average_word_count ~
                 bc_fans + compliments + bc_average_useful +
                 bc_extreme_ratings_ratio + bc_elite)

summary(full)
full_model_f_value <- summary(full)$fstatistic[1]
proportion_full <- summary(full)$r.squared
```

```{r}
reduced1 <- lm(data = new, bc_average_word_count ~
                 bc_fans + compliments + bc_average_useful + bc_elite)

anova(reduced1, full)
qf(0.95, 5, 3632)

print(full_model_f_value > qf(0.95, 5, 3632))
# Prints True; fail to reject H0 - significant linear relationship between the response and any of the predictors DNE, so we should prefer full model
```

```{r}
e_hat <- resid(full_model)
y_hat <- fitted(full_model)
pairs(new)
```

```{r, fig.width=8, fig.height=11}
par(mfrow=c(3, 3))
plot(new$bc_average_word_count ~ y_hat, ylab="Transformed Response", xlab="Fitted")
plot(e_hat ~ y_hat, ylab="Residuals", xlab="Fitted")
for(p in new_predictors){
 plot(e_hat ~ new[,c(p)], ylab="Residuals", xlab=p)
}
plot(e_hat, ylab="Residuals", xlab="Observation number")
qqnorm(e_hat)
qqline(e_hat)
```

```{r}
vif(full_model)
# VIF > 1 means some multicolinearity is present, but not severe as < 5
```

```{r}
# dealing with outliers
```

```{r}
# hypothesis testing
```