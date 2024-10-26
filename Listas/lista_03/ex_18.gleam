/// Clasificar um *nome* em 'curto' se tem 4 letras ou menos, 
/// em 'médio' se tem 10 letras ou menos, caso seja maior
/// que 10 letras classificar em 'longo'

import sgleam/check
import gleam/string

pub fn tamanho_nome(nome: String) -> String {
  case string.length(nome) <= 4 {
    True -> "curto"
    False -> case string.length(nome) <= 10 {
               True -> "médio"
               False -> "longo"
            }
  }
}

pub fn tamanho_nome_examples() {
    check.eq(tamanho_nome("Pedro"), "médio")
    check.eq(tamanho_nome("Mariana Melia"), "longo")
    check.eq(tamanho_nome("josé"), "curto")


}