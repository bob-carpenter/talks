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

fitted_models2 = get_theta_log_sigma(fit_cp_0, 0, "theta (centered)", "theta[1]");
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_4, 4, "theta (centered)", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_16, 16, "theta (centered)", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_cp_4096, 4096, "theta (centered)", "theta[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_0, 0, "theta_std (non-centered)", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_4, 4, "theta_std (non-centered)", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_16, 16, "theta_std (non-centered)", "theta_std[1]"));
fitted_models2 = rbind(fitted_models2, get_theta_log_sigma(fit_nc_4096, 4096, "theta_std (non-centered)", "theta_std[1]"));

divs2 = get_fit_divergs(fit_cp_0, 0, "theta (centered)");
divs2 = rbind(divs2, get_fit_divergs(fit_cp_4, 4, "theta (centered)"));
divs2 = rbind(divs2, get_fit_divergs(fit_cp_16, 16, "theta (centered)"));
divs2 = rbind(divs2, get_fit_divergs(fit_cp_4096, 4096, "theta (centered)"));
divs2 = rbind(divs2, get_fit_divergs(fit_nc_0, 0, "theta_std (non-centered)"));
divs2 = rbind(divs2, get_fit_divergs(fit_nc_4, 4, "theta_std (non-centered)"));
divs2 = rbind(divs2, get_fit_divergs(fit_nc_16, 16, "theta_std (non-centered)"));
divs2 = rbind(divs2, get_fit_divergs(fit_nc_4096, 4096, "theta_std (non-centered)"));

# theta centered vs. theta_std non-centered
p4 = ggplot(fitted_models2, aes(x=fitted_models2$theta_par, y=fitted_models2$log_sigma));
p4 = p4 + geom_point(colour="black", size=0.85, alpha=0.1);
p4 = p4 + geom_point(data=divs2, aes(x=divs2$theta, y=divs2$log_sigma), colour="darkred");
p4 = p4 + facet_wrap(par ~ size, nrow=2, ncol=4, scales="free", labeller = labeller(par = label_value, size = label_both));
p4 = p4 + labs(title="centered vs. non-centered parameterization", subtitle="10 groups, 20000 draws", x = "", y = "log sigma");
p4 = p4 + theme(plot.title = element_text(size = 24));

ggsave("theta_cp_vs_theta_std_nc_c12_b4.png", plot=p4, width=8, height=6);

