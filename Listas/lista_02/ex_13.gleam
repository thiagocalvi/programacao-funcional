import sgleam/check

pub fn produto_anterior_posterior(n: Int) {
  /// Calcular o produto de um numero interio *n* com seu antesesor e com seu posterio
  /// n * (n + 1) * (n - 1)
  n * {n + 1} * {n - 1}
}

pub fn produto_anterior_posterior_examples(){
  check.eq(produto_anterior_posterior(3), 24)
  check.eq(produto_anterior_posterior(1), 0)
  check.eq(produto_anterior_posterior(-2), -6)
}
