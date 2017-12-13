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
person = 54
hist(h2samp$hppc[,person], breaks=50)
abline(v=hdata$height[person])

launch_shinystan(h2ppc_fit)

y = hdata$height
h3ppc = stan_model("heights3_ppc.stan")
h3ppc_fit = sampling(h3ppc, list(num_people = nrow(hdata), heights = hdata$height,
                                 weights = hdata$weight, male = hdata$male))
h3samp = extract(h3ppc_fit)
i = 5
hist(h3samp$hppc[,i], breaks=50)
abline(v=hdata$height[i])

launch_shinystan(h3ppc_fit)
