/// Substituir os *n* primeiros caracteres de um *texto*
/// por *n* letras "x"

import sgleam/check
import gleam/string

pub fn substitui_letras(texto: string, n: Int) -> String {
  
}

pub fn substitui_letras_examples() {
    check.eq(substitui_letras("Um texto para teste", 3), "xxxtexto para teste")
}