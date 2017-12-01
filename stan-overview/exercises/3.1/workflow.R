library(dplyr)
library(tidyr)
library(rstan)
library(bayesplot)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

genres = read.csv("movies.csv") %>% arrange(movieId) %>%
  mutate(genre = strsplit(as.character(genres), "\\|")) %>% 
  unnest(genre) %>% mutate(lol=1) %>% spread(genre, lol, fill=0) %>%
  select(-genres, -title)
ratings = read.csv("ratings.csv") %>% arrange(movieId)

ratings_mat = ratings %>% select(-timestamp) %>%
  filter(userId < 20) %>%
  spread(userId, rating, fill=-1)
all_rated_movies = genres %>% filter(movieId %in% ratings_mat$movieId) %>% select(-movieId)

#filter genres out

ratings_mat = ratings_mat %>% select(-movieId)

fit = stan(file = "movies.stan",
           data = list(num_movies=nrow(all_rated_movies), num_genres=ncol(all_rated_movies),
                       num_users = ncol(ratings_mat),
                       ratings=ratings_mat, genres = all_rated_movies))
samples = rstan::extract(fit)

ppc_dens_overlay(y, samples$y_ppc[1:100,])
