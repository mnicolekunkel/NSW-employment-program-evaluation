# first, I read in the data set into R Studio and named it "data". use the first spreadsheet in the excel file (default)

# DID PARTICIPANTS IN THE NSW PROGRAM HAVE GREATER INCOME IN 1978 THAN NON PARTICIPANTS?
# a comparison across the two groups

# I'm carrying out a one sided, two-sample t test with 95% confidence
# H0 is difference in means = 0; alt is that true difference does not equal 0 ("two.sided")
t.test(re78~expstat, data = data, mu = 0, alt = "two.sided", paired = F, var.equal = F, conf.level = 0.95)

# Now here's a linear regression that treats expstat as a factor:
summary(lm(re78~expstat, data=data))


# DOES PARTICIPATING IN THE PROGRAM INCREASE YOUR INCOME OVER TIME?
# a pre/post intervention design

# First, I'll subset the data into those who participated in the program
# tx_data <- subset(data, expstat==1)
# And analyze using a paired t test comparing income in 1978 to income in 1974
t.test(tx_data$re78, tx_data$re74, paired = TRUE, alternative = "two.sided")

# what if i wanted to make a line graph laid out where "before NSW" and "after NSW" is on the x axis and earnings in 1978 are on the y axis?
# it would be much easier to do if the data were restructured so that income from both years are in a single column,
# and the year is dummy coded (0 for 74 and 1 for 78, so: before/after treatment)
# I restructured the data like that in Excel myself in a new sheet.

# read in the second sheet of the excel file as "dummy_data"

summary(lm(income~dummy_year, data=dummy_data))
# to correctly analyze, I'd need to cluster to adjust SEs. Since I have two datapoints from every participant, I'd assume their salaries,
# treatment aside, would be more similar. That similarity between their two datapoints is not accounted for in this model, so I expect these
# SEs to be artificially lower than they should be.
# Here's the correction with clustering:
library(multiwayvcov)
tx_dummy<-lm(income~dummy_year, data=dummy_data)
tx_dummy.vcovCL<-cluster.vcov(tx_dummy, dummy_data$ID)
        # vcolCL = variance-covariance clustering
                # "cluster the variance covariance matrix in the OLS model tx_dummy by ID"
coeftest(tx_dummy, tx_dummy.vcovCL)
