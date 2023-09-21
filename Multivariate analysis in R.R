# first I read in the data set and called it "data"

library(plyr)
library(ggplot2)

# WHAT RELEVANT FEATURES CAN EFFECT EARNINGS IN 1978?

# Making all of the categorical variables into factors:
data$black <- as.factor(data$black)
data$hisp <- as.factor(data$hisp)
data$married <- as.factor(data$married)
data$nodegree <- as.factor(data$nodegree)

# let's first check that features are balanced across individuals who did versus did not participate in the NSW program

# density plot for age
mu <- ddply(data, "expstat", summarise, grp.mean=mean(age))
head(mu)
ggplot(data, aes(x=age, color=expstat, fill = expstat)) +
  theme_classic() +
  geom_density(alpha = 0.3) +
  geom_vline(data=mu, aes(xintercept=grp.mean, color=expstat),
             linetype="dashed") +
  scale_color_manual(values=c("black", "firebrick"), guide = "none")+
  scale_fill_manual(values=c("black", "firebrick"), labels=c('non participant', 'participant'), name = "") +
  scale_y_continuous(expand = c(0,0)) +
  scale_x_continuous(expand = c(0,0))

# density plot for educational attainment
mu <- ddply(data, "expstat", summarise, grp.mean=mean(educ))
ggplot(data, aes(x=educ, color=expstat, fill = expstat)) +
  theme_classic() +
  geom_density(alpha = 0.3) +
  geom_vline(data=mu, aes(xintercept=grp.mean, color=expstat),
             linetype="dashed") +
  scale_color_manual(values=c("black", "firebrick"), guide = "none")+
  scale_fill_manual(values=c("black", "firebrick"), labels=c('non participant', 'participant'), name = "") +
  scale_y_continuous(expand = c(0,0)) +
  scale_x_continuous(expand = c(0,0)) +
  labs(x = "educational attainment")

# for the other features, I quickly plugged in the # of participants versus non participants that fell into each category into excel to make stacked bar charts quickly.

# to quantitatively do a quality check on this, we can analyze group assignment as an outcome variable with OLS/Linear probability models:
data$expstat <- as.numeric(data$expstat) # outcome variable will need to be read as a numeric variable, as this is a linear model
summary(lm(expstat~age, data=data))
summary(lm(expstat~educ, data=data))
summary(lm(expstat~black, data=data))
summary(lm(expstat~hisp, data=data))
summary(lm(expstat~married, data=data))
summary(lm(expstat~reo74, data=data))
summary(lm(expstat~reo75, data=data))

# Now to run multivariate models on earnings:
data$expstat <- as.factor(data$expstat) # make this a categorical variable again
summary(lm(re78~expstat+age, data=data))
summary(lm(re78~expstat+educ, data=data))
summary(lm(re78~expstat+black, data=data))
summary(lm(re78~expstat+hisp, data=data))
summary(lm(re78~expstat+married, data=data))
summary(lm(re78~expstat+nodegree, data=data))
summary(lm(re78~expstat+reo74, data=data))
summary(lm(re78~expstat+reo75, data=data))


