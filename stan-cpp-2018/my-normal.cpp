#include <stan/math/rev/mat.hpp>
#include <iostream>

template <typename T>
T my_normal(const T& y, double mu, double sigma) {
  using std::log;  // allow std::log as candidate for log(sigma)
  return - 0.5 * log(2 * stan::math::pi())
      - 2 * log(sigma)
      - 0.5 * pow((y - mu) / sigma, 2);
}

int main() {
  stan::math::var y = 1.2;
  double mu = 0.3;
  double sigma = 0.5;
  stan::math::var lp = my_normal(y, mu, sigma);
  lp.grad();
  std::cout << "val = " << lp.val()
            << "; d.val/d.y = " << y.adj() << std::endl;
}

/*
clang++ -O0 -std=c++1y -isystem ~/stan/lib/stan_math/lib/eigen_3.3.3 -isystem ~/stan/lib/stan_math/lib/boost_1.66.0 -isystem ~/stan/lib/stan_math/lib/sundials_3.1.0/include -isystem ~/stan/lib/stan_math my-normal.cpp
*/
