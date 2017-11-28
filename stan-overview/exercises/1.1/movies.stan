data {
  int<lower=1> num_movies;
  vector<lower=0, upper=5>[num_movies] ratings;

  int<lower=1> num_genres;
  matrix[num_movies, num_genres] genres;

  int<lower=1> num_to_predict;
  matrix[num_to_predict, num_genres] to_predict;
}

parameters {
  vector[num_genres] genre_coeff;
  real base_rating;
  real<lower=0> rating_variability;
}

model {
  // XXX explain genres * genre_coeff
  // XXX add year of movie?
  ratings ~ normal(genres * genre_coeff + base_rating, rating_variability);

  // priors
  genre_coeff ~ normal(0, 1);
  base_rating ~ normal(0, 3);
  rating_variability ~ normal(0, 3);


  // hierarchical
  // prune number of genres down to a reasonable number
  //Buser ~ multi_normal(u, E);
}


// ============================================================================
generated quantities {
  vector[num_movies] y_ppc;
  vector[num_to_predict] y_pred;

  for (i in 1:num_movies)
    y_ppc[i] = normal_rng(genres[i] * genre_coeff + base_rating, rating_variability);

  for (i in 1:num_to_predict)
    y_pred[i] = normal_rng(to_predict[i] * genre_coeff + base_rating, rating_variability);

  // XXX loo package, cross validation

  // normal_rng vs ~
}
