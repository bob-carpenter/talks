library(ggplot2);
library(dplyr);
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
fitted_models = rbind(fitted_models, get_fit_params(fit_cp_4, 4, "centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_cp_16, 16, "centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_cp_64, 64, "centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_cp_1024, 1024, "centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_cp_4096, 4096, "centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_0, 0, "non-centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_4, 4, "non-centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_16, 16, "non-centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_64, 64, "non-centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_1024, 1024, "non-centered"));
fitted_models = rbind(fitted_models, get_fit_params(fit_nc_4096, 4096, "non-centered"));

fitted_models2 = get_theta_log_sigma(fit_cp_0, 0, "centered", "theta[1]");
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_4, 4, "centered", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_16, 16, "centered", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_64, 64, "centered", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_1024, 1024, "centered", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_4096, 4096, "centered", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_0, 0, "non-centered", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_4, 4, "non-centered", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_16, 16, "non-centered", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_64, 64, "non-centered", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_1024, 1024, "non-centered", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_4096, 4096, "non-centered", "theta_std[1]"));

divs = get_fit_divergs(fit_cp_0, 0, "centered");
divs = rbind(divs, get_fit_divergs(fit_cp_4, 4, "centered"));
divs = rbind(divs, get_fit_divergs(fit_cp_16, 16, "centered"));
divs = rbind(divs, get_fit_divergs(fit_cp_64, 64, "centered"));
divs = rbind(divs, get_fit_divergs(fit_cp_1024, 1024, "centered"));
divs = rbind(divs, get_fit_divergs(fit_cp_4096, 4096, "centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_0, 0, "non-centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_4, 4, "non-centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_16, 16, "non-centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_64, 64, "non-centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_1024, 1024, "non-centered"));
divs = rbind(divs, get_fit_divergs(fit_nc_4096, 4096, "non-centered"));


# theta centered vs. theta non-centered
p4_1 = ggplot(fitted_models, aes(x=fitted_models$theta, y=fitted_models$log_sigma));
p4_1 = p4_1 + geom_point(colour="grey", size=0.75, alpha=0.75);
p4_1 = p4_1 + geom_point(data=divs, aes(x=divs$theta, y=divs$log_sigma), colour="black");
p4_1 = p4_1 + scale_x_continuous(limits=c(-20,20)) + scale_y_continuous(limits=c(-20,20)) 
p4_1 = p4_1 + facet_wrap(par ~ size, nrow=2, ncol=6, scales="free", labeller = labeller(par = label_value, size = label_both));
p4_1 = p4_1 + lab(title="theta in centered/non-centered parameterization", x = "theta", y = "log sigma");


# theta_std centered vs. theta_std non-centered
p4_2 = ggplot(fitted_models, aes(x=fitted_models$theta_std, y=fitted_models$log_sigma));
p4_2 = p4_2 + geom_point(colour="grey", size=0.75, alpha=0.75);
p4_2 = p4_2 + geom_point(data=divs, aes(x=divs$theta_std, y=divs$log_sigma), colour="black");
p4_2 = p4_2 + facet_wrap(par ~ size, nrow=2, ncol=6, scales="free", labeller = labeller(par = label_value, size = label_both));
p4_1 = p4_1 + lab(title="theta_std in centered/non-centered parameterization", x = "theta_std", y = "log sigma");

# theta centered vs. theta_std non-centered
p4_3 = ggplot(fitted_models2, aes(x=fitted_models2$theta_par, y=fitted_models$log_sigma));
p4_3 = p4_3 + geom_point(colour="grey", size=0.75, alpha=0.75);
p4_3 = p4_3 + geom_point(data=divs, aes(x=divs$theta, y=divs$log_sigma), colour="black");
p4_3 = p4_3 + facet_wrap(par ~ size, nrow=2, ncol=6, scales="free", labeller = labeller(par = label_value, size = label_both));
p4_1 = p4_1 + lab(title="theta centered vs. theta_std non-centered", x = "theta parameter", y = "log sigma");


# theta centered vs. theta_std non-centered x size

df_small = filter(fitted_models2, size<5);
divs_small = filter(divs, size<5);
p_cp_nc_small = ggplot(df_small, aes(x=df_small$theta, y=df_small$log_sigma));
p_cp_nc_small = p_cp_nc_small + geom_point(colour="grey", size=0.75, alpha=0.75);
p_cp_nc_small = p_cp_nc_small + geom_point(data=divs_small, aes(x=divs_small$theta, y=divs_small$log_sigma), colour="black");
p_cp_nc_small = p_cp_nc_small + scale_x_continuous(limits=c(-10,10)) + scale_y_continuous(limits=c(-12,12)) 
p_cp_nc_small = p_cp_nc_small + facet_wrap(par ~ size, ncol=2, nrow=2, labeller = labeller(par = label_value));
p_cp_nc_small = p_cp_nc_small + labs(x = "theta parameter", y="log sigma");

df_big = filter(fitted_models2, size>4);
divs_big = filter(divs, size>4);
p_cp_nc_big = ggplot(df_big, aes(x=df_big$theta, y=df_big$log_sigma));
p_cp_nc_big = p_cp_nc_big + geom_point(colour="grey", size=0.75, alpha=0.75);
p_cp_nc_big = p_cp_nc_big + geom_point(data=divs_big, aes(x=divs_big$theta, y=divs_big$log_sigma), colour="black");
p_cp_nc_big = p_cp_nc_big + scale_x_continuous(limits=c(-3,2)) + scale_y_continuous(limits=c(-2,2)) 
p_cp_nc_big = p_cp_nc_big + facet_wrap(par ~ size, ncol=4, nrow=2, labeller = labeller(par = label_value));
p_cp_nc_big = p_cp_nc_big + labs(x = "theta parameter", y="log sigma");

## filenames should reflect N_groups, N_obs, base size (4 or 10)
#ggsave("theta_cp_vs_nc_20_pow4.pdf", plot=p4_1);
#unlink("theta_cp_vs_nc_20_pow4.pdf");
#ggsave("theta_std_cp_vs_nc_20_pow4.pdf", plot=p4_2);
#unlink("theta_std_cp_vs_nc_20_pow4.pdf");
#ggsave("theta_cp_vs_theta_std_nc_20_pow4.pdf", plot=p4_2);
#unlink("theta_cp_vs_theta_std_nc_20_pow4.pdf");

