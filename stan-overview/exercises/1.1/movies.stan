data {
  int<lower=1> numMovies;
  vector<lower=0, upper=5>[numMovies] ratings;

  int<lower=1> numGenres;
  matrix<lower=0, upper=1>[numMovies, numGenres] genres;
}

parameters {
  vector[numGenres] genre_coeff;
  real base_rating;
  real<lower=0> rating_variability;
}

model {
  // XXX explain genres * genre_coeff
  // XXX add year of movie?
  // XXX
  ratings ~ normal(genres * genre_coeff + base_rating, rating_variability);

  // priors
  genre_coeff ~ normal(0, 1);
  base_rating ~ normal(0, 3);
  rating_variability ~ normal(0, 3);


  // hierarchical
  // prune number of genres down to a reasonable number
  Buser ~ multi_normal(u, E);
}


// ============================================================================
generated quantities {
  vector[numMovies] y_ppc;
  for (i in 1:numMovies)
    y_ppc[i] = normal_rng(genres[i] * genre_coeff + base_rating, rating_variability);

  // XXX Add predictions for the unseen movies.

  // XXX loo package, cross validation

  // normal_rng vs ~
}
