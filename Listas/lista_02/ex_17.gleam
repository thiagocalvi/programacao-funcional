import sgleam/check

pub fn maximo(a: Int, b: Int) {
  /// Encontrar o valor maximo entre dois números inteiros *a* e *b*
  case a > b {
    True -> a
    False -> b
  }
}

pub fn maximo_examples() {
    check.eq(maximo(3, 5), 5)
    check.eq(maximo(8, 4), 8)
    check.eq(maximo(6, 6), 6)
}