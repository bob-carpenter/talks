data {
  int<lower=1> num_users;
  int<lower=1> num_movies;
  matrix<lower=-1, upper=5>[num_movies, num_users] ratings;

  int<lower=1> num_genres;
  matrix[num_movies, num_genres] genres;
}

parameters {
  vector[num_movies] mu_movie_base;
  vector<lower=0>[num_movies] sigma_movie_base;
  vector[num_movies] movie_base_rating;

  matrix[num_genres, num_users] mu_genre_user;
  cholesky_factor_corr[num_genres] genre_corr;
  vector<lower=0>[num_genres] genre_tau;
  matrix[num_genres, num_users] genre_user_coeff;

  real<lower=0> sigma;
}

transformed parameters {
  cholesky_factor_cov[num_genres] L_genre = quad_form_diag(genre_corr, genre_tau);

  matrix[num_movies, num_users] mu =
      genres * genre_user_coeff
      + rep_matrix(movie_base_rating, num_users);
}

model {
  for (u in 1:num_users)
    genre_user_coeff[,u] ~ multi_normal_cholesky(mu_genre_user[,u], L_genre);

  for (m in 1:num_movies)
    for (u in 1:num_users)
      if (ratings[m, u] != -1)
        ratings[m, u] ~ normal(mu[m, u], sigma);

  // priors
  genre_corr ~ lkj_corr_cholesky(2);
  genre_tau ~ normal(0, 2);

  mu_movie_base ~ normal(0, 4);
  sigma_movie_base ~ normal(0, 4);
  movie_base_rating ~ normal(mu_movie_base, sigma_movie_base);

  to_vector(mu_genre_user) ~ normal(0, 4);

  sigma ~ normal(0, 5);
}
