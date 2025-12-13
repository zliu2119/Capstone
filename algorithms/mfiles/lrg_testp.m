# your original data
day = [4, 5, 6, 8]
temp = [97, 100, 98, 80]
humidity = [62, 46, 50, 55]

# create the design matrix
# intercept (1s), day and humidity as predictors
X = [1, 1, 1, 1; day; humidity]'
# linear parameter estimates
b = inv(X'*X)*X'*temp'
# residuals
R = temp' - (X * b)
# residual variance
v = (R'*R)/(4 - 3)
# variance covariance matrix of parameters
Sigma = v * inv(X'*X)
# standard errors of parameters (b vector)
se = sqrt(diag(Sigma))

# new data for prediction, constant
# day is 7 and 9, humidity is 80
newdata = [1, 7, 80; 1, 9, 80]
# predicted values for day 7 and 9
pred = newdata * b