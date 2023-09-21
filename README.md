# NSW-Employment-Program-Evaluation
Here, I share how I went about evaluating the NSW Employment Program. I used linear regressions, multivariate analyses, clustering, bootstrapping, to answer my questions outlined in the NSW Program Evaluation PDF, which I recommend reading next and using to navigate to what you may be interested in learning about more in depth.

##  tools: 
    - R
    - MATLAB
## libraries: 
    - plyr
    - ggplot2, 
    - multiwayvcov
    - Matching
    - cobalt

## Data Overview
note: To follow along with any of this code, you will need to use the Lalonde.xls file.

    - expstat: 0 for not included in the employment program, 1 if they participated in the program
    - age: age of participant
    - educ: highest grade level of schooling completed by participant
    - black: 0 if the participant is not Black, 1 if the participant is Black
    - hisp: 0 if the participant is not Hispanic, 1 if the participant is Hispanic
    - married: 0 if the participant is not married, 1 if the participant is married
    - nodegree: 0 if the participant has a degree, 1 if the participant has no degree
    - moa: unknown
    - re74: earnings in 1974
    - re75: earnings in 1975
    - re78: earnings in 1978
    - reo74: 0 if the participant was employed in 1974, 1 if the participant was unemployed in 1974
    - reo75: 0 if the participant was employed in 1975, 1 if the participant was unemployed in 1975
