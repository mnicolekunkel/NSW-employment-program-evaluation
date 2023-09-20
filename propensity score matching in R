library(readxl)
library(Matching)
library(cobalt)

# this time I read in the dataset and called it "lalonde_data"

# 1. Practice using the nearest neighbor matching technique to match the Dehejia and Wabba (1999) study using the same dataset.
# Just do a couple of variations. I'd like to look at ATE and ATT to make not of the relevance of ATT to targeted programs, for my own notes and benefit looking back on this
# I'll also compare one-to-one and one-to-many matching.
# For all of this, I'll use the Match package.

# as dataframes
Y <- lalonde_data$re78
Tr <- lalonde_data$treat
X <- lalonde_data$age + lalonde_data$black + lalonde_data$hisp + lalonde_data$married + lalonde_data$nodegree + lalonde_data$educ + lalonde_data$reo74 + lalonde_data$reo75 + lalonde_data$re74 + lalonde_data$re75
Z <- lalonde_data$age + lalonde_data$educ + lalonde_data$re74 + lalonde_data$re75

# By default, Match does one to one matching with replacement and estimates ATT
# This function is capable of both multivariate and propensity score matching

# Vector X contains all of the variables by which I want to match. Bias adjusted covariates are specified in vector Z (covariates that are not factors but on a ratio scale).
# Matching is done with replacement by default 

# ATE estimate with exact matching
ATE_exact <- Match(Y=Y, Tr=Tr, X, Z = Z, estimand = "ATE", BiasAdjust = TRUE, exact = TRUE)
summary(ATE_exact)
# I'm going to pay attention to the matched number of observation line:
# Exact ATE matching matched 274 observations out of 445
# Overall estimated treatment effect = 1840.5 and T and P values indicate a significant treatment effect

# ATT estimate with exact matching
ATT_exact <- Match(Y=Y, Tr=Tr, X, Z = Z, estimand = "ATT", BiasAdjust = TRUE, exact = TRUE)
summary(ATT_exact)
# As expected, ATT exact matched less (107 cases), since only the treated are being matched (out of 185 treated individuals)
# ATT < ATE now; differences in t, p, and SE are virtually indistinguishable
# As expected, ATE is more similar to the OLS estimated treatment effect (1794)

# ATE estimate with one to one nearest neighbor matching with replacement
ATE_nnmatch <- Match(Y=Y, Tr=Tr, X, Z = Z, estimand = "ATE", M = 1, BiasAdjust = TRUE)
summary(ATE_nnmatch)
# Estimated ATE changed dramatically from our exact matching, and we have a much larger SE.
# All cases were matched, as expected

# ATT estimate with one to one nn matching with replacement
ATT_nnmatch <- Match(Y=Y, Tr=Tr, X, Z = Z, estimand = "ATT", M = 1, BiasAdjust = TRUE)
summary(ATT_nnmatch)
# Still a smaller treatment effect and much larger SE
# For ATT estimates, we can note only the treated individuals were matched 


# ATE estimate with one to four nn matching with replacement
ATE_kmatch <- Match(Y=Y, Tr=Tr, X, Z = Z, estimand = "ATE", M = 4, BiasAdjust = TRUE)
summary(ATE_kmatch)
# Notably, we practically got the OLS results (the regression file in this repository, where the treatment coefficient was 1794)
# Our t and p values and SE are closer to the exact matching model that our one to one matching


# ATT estimate with one to four nn matching with replacement
ATT_kmatch <- Match(Y=Y, Tr=Tr, X, Z = Z, estimand = "ATT", M = 4, BiasAdjust = TRUE)
summary(ATT_kmatch)
# Our treatment effect and SE got a little inflated, but we’re not completely off
# Makes sense – ATT estimates are working with a smaller sample, so a larger SE isn’t surprising


# The Match function has way more switches to play with and a very easy to follow guide. I like this way better than MatchIt
# Matching also allows you to match based on propensity score, which is calculated separately, before running the Match function.

# What I'm not sure of is what kind of distance measure Match uses in its routine (i.e. Euclidean or Mahalabobis, etc.)
# I think the default is Mahalanobis from what I've read on the function, but I'm not 100% sure

# Match should also be used in conjunction with MatchBalance. I'll do this on my exact match model for calculating ATE, since it's closest to the OLS treatment coefficient
# Do we meet the common support assumption?

# The dependent variable in the formula is the tx variable, all covariates to be checked for balance included
# match.out allows for us to compare balance before and after matching when a model is specified
# nboots are more useful for nonparametric estimates and the Kolmogorov-Smirnov test. When nboots = 0, no bootstrapping is done
MatchBalance(treat ~ age + educ + black + hisp + married + nodegree + re74 + re75 + reo74 + reo75, match.out = ATE_exact, nboots = 500, data = lalonde_data)

# We’re looking for insignificant p values after matching. T tests compare the difference in each covariate between control v treatment groups
# nodegree the least balanced before exact matching to calculate ATE
# hisp, nodegree, educ significantly less balanced after exact matching to calculate ATE

# I'm curious about my one to four matching and its balance, since that seemed to give me a result closer to the OLS result, and I want to focus on ATT since that's more relevant to program implementation

MatchBalance(treat ~ age + educ + black + hisp + married + nodegree + re74 + re75 + reo74 + reo75, match.out = ATT_kmatch, nboots = 500, data = lalonde_data)

# Again, nodegree is the least balanced before matching (this should be the case every time)

# I'm looking at the T-test p value for my nominal variables and bootstrapped p-values for ratio-scale variables:
# After matching, age became unbalanced, education improved but remained unbalanced, and no degree balance became balanced
# So, I think the takeaway here is that matching doesn’t guarantee balance, and weighting may be necessary for multivariate matching.


# 2. Use a propensity-score matching routine of your choice to match the LaLonde treatment cases to counterfactual controls.
# Experiment with variations of your specification to check the sensitivity of your results

# In the Match package, you need to separately estimate the P score by which you want to match
# Here's my first go at a propensity score, replicating that of Dehejia and Wahba (1999):
glm1 <- glm(treat~age + I(age^2) + educ + I(educ^2) + hisp + married + nodegree + re74 + I(re74^2) + re75 + I(re75^2) + reo74 + reo75, family=binomial, data=lalonde_data)

# Now I'm saving each component:
X <- glm1$fitted # So, instead of the covariates, I’m matching on p score, calculated above
Y <- lalonde_data$re78
Tr <- lalonde_data$treat

# One-to-one matching with replacement (the "M=1" option)
pmatch1 <- Match(Y=Y,Tr=Tr,X=X,M=1)
# Without specifying "estimand = ATE", we get ATT as default:
summary(pmatch1)
# Estimated ATT is a bit larger than the OLS 1794 and still statistically significant.

# Let’s compare to my nn matching routine:
summary(ATT_nnmatch)

# The SEs aren’t that different, yet we see way different ATTs and corresponding t and p values

# I'm going to try one to eight matching plus a specified a caliper:
pmatch2 <- Match(Y=Y, Tr=Tr, X, M = 8, caliper=.25)
# caliper=.25 means that all matches not equal to or within .25 standard deviations of each covariate in X are dropped
summary(pmatch2)
# Our estimated ATT dropped some but looks a slightly more significant. In terms of absolute deviation, the pmatch1 is closer to the OLS result.
# 13 treated individuals were dropped by our caliper restriction
# Interestingly, the SE is a little sharper here than in pmatch1. I think it’s hard to say where exactly that came from, using multiple matches or dropping cases because of the caliper restriction. My first guess is the latter, because matching to more cases logically makes me think there’s more “noise”, inherent to each case. 

# There’s a lot to play around with when it comes to this, and for my own future reference, here are some packages for more legit sensitivity analyses when the “true” ATE isn’t known
http://www-stat.wharton.upenn.edu/~rosenbap/packpaper.pdf


#3. I'm going to focus on pmatch1 now. First, looking at the common support:
library(cobalt)
lalonde_data$pscore <- glm1$fitted
bal.plot(pmatch1, formula = treat~pscore, data = lalonde_data, var.name = "pscore")
# And here's a balance table:
MatchBalance(treat ~ glm1$fitted, match.out = pmatch1, nboots = 500, data = lalonde_data)
# Looks like there's no significant difference in propensity scores between treatment and control groups after matching!
