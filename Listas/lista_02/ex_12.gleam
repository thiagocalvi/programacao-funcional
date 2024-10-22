import sgleam/check

pub fn area_retangulo(lado: Float, base: Float) {
  /// Calcular a area de um retangulo a partir do comprimento do seu
  /// *lado* da sua *base*
  lado *. base
}

pub fn area_retangulo_examples() {
  check.eq(area_retangulo(3.0, 5.0), 15.0)
  check.eq(area_retangulo(2.0, 2.5), 5.0)
}
