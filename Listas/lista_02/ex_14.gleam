import sgleam/check
import gleam/string

pub fn so_primeira_maiuscula(palavra: String) {
  /// Converter um string *palavra* não vazia para uma string com a primeira letra 
  /// em maiúscula e o restante em minúscula
  
  string.concat([string.uppercase(string.slice(palavra, 0, 1)), string.lowercase(string.slice(palavra, 1, string.length(palavra)))])
}

pub fn so_primeira_maiuscula_examples() {
  check.eq(so_primeira_maiuscula("paula"), "Paula")
  check.eq(so_primeira_maiuscula("ALFREDO"), "Alfredo")
}
