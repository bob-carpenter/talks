library(dplyr)
library(tidyr)
library(rstan)
library(bayesplot)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


#model = stan_model("movies.stan")
genres = read.csv("movies.csv") %>% arrange(movieId) %>%
  mutate(genre = strsplit(as.character(genres), "\\|")) %>% 
  unnest(genre) %>% mutate(lol=1) %>% spread(genre, lol, fill=0) %>%
  select(-genres, -title)
ratings = read.csv("ratings.csv") %>% arrange(movieId)
head(ratings)
user = 253
user_ratings = ratings %>% filter(userId == user)
rated_movies = genres %>% filter(movieId %in% user_ratings$movieId) %>% select(-movieId)

head(rated_movies)
y = user_ratings$rating

fit = sampling(stan_model("movies.stan"),
               list(num_movies=nrow(rated_movies), num_genres=ncol(rated_movies),
                    ratings=user_ratings$rating, genres = rated_movies,
                    num_to_predict=nrow(genres), to_predict = select(genres, -movieId)))
samples = rstan::extract(fit)

ppc_dens_overlay(y, samples$y_ppc[1:100,])
