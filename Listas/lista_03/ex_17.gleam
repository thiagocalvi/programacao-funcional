/// Calcular um aumento de uma determinada *porcentagem* sobre 
/// o *valor* dado. {1.0 + *porcentagem* / 100}

import sgleam/check

pub fn aumenta(valor: Float, porcentagem: Float) -> Float {
  valor *. {1.0 +. porcentagem /. 100.0}
}

pub fn aumenta_examples() {
    check.eq(aumenta(10.2, 2.0), 10.404)
    check.eq(aumenta(13.2, 4.6), 13.8072)
    check.eq(aumenta(122.5, 55.90), 190.9775)
    check.eq(aumenta(0.0, 3.5), 0.0)
}