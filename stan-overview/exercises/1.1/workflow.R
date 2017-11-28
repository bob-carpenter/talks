library(dplyr)
library(tidyr)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


#model = stan_model("movies.stan")
genres = read.csv("movies.csv")
ratings = read.csv("ratings.csv")
head(ratings)
user = 547
user_ratings = ratings %>% filter(userId == user) %>% arrange(movieId)
rated_genres = genres %>% filter(movieId %in% user_ratings$movieId) %>% 
  mutate(genre = strsplit(as.character(genres), "\\|")) %>% unnest(genre) %>% arrange(movieId) %>%
  select(movieId, genre) %>% mutate(lol=1) %>% spread(genre, lol, fill=0) %>% select(-movieId)

y = user_ratings$rating

data = list(numMovies=nrow(user_ratings), numGenres=ncol(rated_genres), 
            ratings=user_ratings$rating, genres = rated_genres)
fit = sampling(stan_model("movies.stan"), data)
samples = rstan::extract(fit)

plot_ppc = function(index) {
  hist(samples$y_ppc[,index], main=filter(genres, movieId == user_ratings[index,]$movieId)$title)
  abline(v=y[index])
}

plot_ppc(4)