import numpy as np

def simulate_times(N, sigma, length, height):
    g = 9.81  # gravitational acceleration in m/s^2
    s = np.sqrt(length**2 + height**2)
    h = height
    t = np.sqrt((14 * s**2) / (5 * g * h))
    t_obs = np.random.lognormal(mean=np.log(t), sigma=sigma, size=N)
    return {
        'length': length, 'height': height,
        'N': N, 't_obs': t_obs
    }

data = simulate_times(N=100, sigma=0.1, length=5, height=2.5)

import cmdstanpy as csp
m = csp.CmdStanModel(stan_file='galileo.stan')
draws = m.sample(data = data)
print(draws.summary())

import pandas as pd
import plotnine as pn

df = pd.DataFrame('g': draws.stan_variables('m'),
                      'sigma': draws.stan_variables('sigma'))
df = pd.DataFrame(draws.stan_variables())
plot = (pn.ggplot(df, pn.aes(x='g', y='sigma'))
            + pn.geom_point()
            + pn.theme(aspect_ratio=1)
            + pn.geom_hline(yintercept=0.10, color='blue', size=1)
            + pn.geom_vline(xintercept=9.81, color='red', size=1)
            )
plot.show()

