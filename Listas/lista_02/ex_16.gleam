import sgleam/check

pub fn tem_tres_digitos(n: Int) {
  /// Verificar se um número natural *n* tem exatamente tres digitos
  n < 1000 && n >= 100 
}

pub fn tem_tres_digitos_examples() {
  check.eq(tem_tres_digitos(99), False)
  check.eq(tem_tres_digitos(100), True)
  check.eq(tem_tres_digitos(999), True)
  check.eq(tem_tres_digitos(1000), False)
}