library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

hd = read.csv("heights.csv")
hist(hd$height, breaks=100)

model = stan_model("heights.stan")
fit = sampling(model, list(num_people = nrow(hd), heights = hd$height,
                           weights = hd$weight, male = hd$male))
fit
plot(height ~ weight, hd)