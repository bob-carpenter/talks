library(ggplot2);
library(rstan);
options(mc.cores = 2);


get_fit_params = function(x, sz, parzn)  {
  log_sigma = log(as.vector(as.array(x, pars=c("sigma"))));
  theta = as.vector(as.array(x, pars=c("theta[1]")));
  theta_std = as.vector(as.array(x, pars=c("theta_std[1]")));
  return(data.frame(size=sz, par=as.character(parzn),
         log_sigma=log_sigma, theta=theta, theta_std=theta_std));
}

get_theta_log_sigma = function(x, sz, parzn, theta_par)  {
  log_sigma = log(as.vector(as.array(x, pars=c("sigma"))));
  theta = as.vector(as.array(x, pars=theta_par));
  return(data.frame(size=sz, par=as.character(parzn),
         log_sigma=log_sigma, theta_par=theta));
}

get_fit_divergs = function(x, sz, parzn) {
  divergs = vector("numeric");
  nchains = length(attributes(x)$stan_args);
  for (i in 1:nchains) {
    ds = get_sampler_params(x, inc_warmup=FALSE)[[i]][,'divergent__'];
    divergs = append(divergs,ds);
  }
  d_idxs = which(divergs==1);
  if (length(d_idxs) == 0) {
    return(data.frame(size=sz, par=as.character(parzn),
                      log_sigma=NA, theta=NA, theta_std=NA));
 }
 log_sigma_all = log(as.vector(as.array(x, pars=c("sigma"))));
 theta_all = as.vector(as.array(x, pars=c("theta[1]")));
 theta_std_all = as.vector(as.array(x, pars=c("theta_std[1]")));
 log_sigma=log_sigma_all[d_idxs];
 theta=theta_all[d_idxs];
 theta_std=theta_std_all[d_idxs];
 return(data.frame(size=sz, par=as.character(parzn),
         log_sigma=log_sigma, theta=theta, theta_std=theta_std));
}

fitted_models = get_fit_params(fit_cp_0, 0, "centered");
fitted_models = rbind(fitted_models, get_fit_params(fit_cp_10, 10, "centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_cp_100, 100, "centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_cp_1000, 1000, "centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_cp_10000, 10000, "centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_0, 0, "non-centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_10, 10, "non-centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_100, 100, "non-centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_1000, 1000, "non-centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_10000, 10000, "non-centered"));

fitted_models2 = get_theta_log_sigma(fit_cp_0, 0, "centered", "theta[1]");
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_10, 10, "centered", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_100, 100, "centered", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_1000, 1000, "centered", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_10000, 10000, "centered", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_0, 0, "non-centered", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_10, 10, "non-centered", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_100, 100, "non-centered", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_1000, 1000, "non-centered", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_10000, 10000, "non-centered", "theta_std[1]"));

divs = get_fit_divergs(fit_cp_0, 0, "centered");
divs = rbind(divs, get_fit_divergs(fit_cp_10, 10, "centered"));
divs = rbind(divs, get_fit_divergs(fit_cp_100, 100, "centered"));
divs = rbind(divs, get_fit_divergs(fit_cp_1000, 1000, "centered"));
divs = rbind(divs, get_fit_divergs(fit_cp_10000, 10000, "centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_0, 0, "non-centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_10, 10, "non-centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_100, 100, "non-centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_1000, 1000, "non-centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_10000, 10000, "non-centered"));


# theta centered vs. theta non-centered
p1 = ggplot(fitted_models, aes(x=fitted_models$theta, y=fitted_models$log_sigma));
p1 = p1 + geom_point(colour="grey", size=0.75, alpha=0.75);
p1 = p1 + geom_point(data=divs, aes(x=divs$theta, y=divs$log_sigma), colour="black");
p1 = p1 + facet_wrap(par ~ size, nrow=2, ncol=5, scales="free", labeller = labeller(par = label_value, size = label_both));


# theta_std centered vs. theta_std non-centered
p2 = ggplot(fitted_models, aes(x=fitted_models$theta_std, y=fitted_models$log_sigma));
p2 = p2 + geom_point(colour="grey", size=0.75, alpha=0.75);
p2 = p2 + geom_point(data=divs, aes(x=divs$theta_std, y=divs$log_sigma), colour="black");
p2 = p2 + facet_wrap(par ~ size, nrow=2, ncol=5, scales="free", labeller = labeller(par = label_value, size = label_both));


# theta centered vs. theta_std non-centered
p3 = ggplot(fitted_models2, aes(x=fitted_models2$theta_par, y=fitted_models$log_sigma));
p3 = p3 + geom_point(colour="grey", size=0.75, alpha=0.75);
p3 = p3 + geom_point(data=divs, aes(x=divs$theta, y=divs$log_sigma), colour="black");
p3 = p3 + facet_wrap(par ~ size, nrow=2, ncol=5, scales="free", labeller = labeller(par = label_value, size = label_both));

## edit filenames to match N_group
ggsave("theta_cp_vs_nc_20.pdf", plot=p1);
unlink("theta_cp_vs_nc_20.pdf");
ggsave("theta_std_cp_vs_nc_20.pdf", plot=p2);
unlink("theta_std_cp_vs_nc_20.pdf");
ggsave("theta_cp_vs_theta_std_nc_20.pdf", plot=p3);
unlink("theta_cp_vs_theta_std_nc_20.pdf");
