import sgleam/check

pub fn eh_par (n: Int) {
  /// Verificar se um número natural *n* é par
  {n % 2} == 0
}

pub fn eh_par_examples() {
  check.eq(eh_par(2), True)
  check.eq(eh_par(5), False)
  check.eq(eh_par(1), False)
  check.eq(eh_par(3), False)
  check.eq(eh_par(6), True)
}