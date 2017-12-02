library(rstan)
library(shinystan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

hdata = read.csv("heights.csv")
hist(hdata$height, breaks=50)

###### Simple distribution
model1 = stan_model("heights1.stan")
fit = sampling(model1, list(num_people=nrow(hdata), heights=hdata$height))
print(fit)

###### Regression on weight
model2 = stan_model("heights2.stan")
fit2 = sampling(model2, list(num_people = nrow(hdata), heights = hdata$height,
                             weights = hdata$weight))
print(fit2)

##### Regression with weight and male
model3 = stan_model("heights3.stan")
fit3 = sampling(model3, list(num_people = nrow(hdata), heights = hdata$height,
                             weights = hdata$weight, male = hdata$male))
print(fit3)

###### PPC
y = hdata$height
h1ppc = stan_model("heights1_ppc.stan")
h1ppc_fit = sampling(h1ppc, list(num_people=nrow(hdata), heights=hdata$height))
launch_shinystan(h1ppc_fit)


h2ppc = stan_model("heights2_ppc.stan")
h2ppc_fit = sampling(h2ppc, list(num_people = nrow(hdata), heights = hdata$height,
                                 weights = hdata$weight))
h2samp = extract(h2ppc_fit)
hist(h2samp$hppc[,1], breaks=50)
abline(v=hdata$height[1])
hist(h2samp$hppc[,2], breaks=50)
abline(v=hdata$height[2])

hist(h2samp$hppc[,3], breaks=50)
abline(v=hdata$height[3])

hist(h2samp$hppc[,4], breaks=50)
abline(v=hdata$height[4])

launch_shinystan(h2ppc_fit)


h3ppc = stan_model("heights3_ppc.stan")
h3ppc_fit = sampling(h3ppc, list(num_people = nrow(hdata), heights = hdata$height,
                                 weights = hdata$weight, male = hdata$male))
h3samp = extract(h2ppc_fit)
hist(h3samp$hppc[,1], breaks=50)
abline(v=hdata$height[1])
hist(h3samp$hppc[,2], breaks=50)
abline(v=hdata$height[2])

hist(h3samp$hppc[,3], breaks=50)
abline(v=hdata$height[3])

hist(h3samp$hppc[,4], breaks=50)
abline(v=hdata$height[4])

launch_shinystan(h3ppc_fit)
