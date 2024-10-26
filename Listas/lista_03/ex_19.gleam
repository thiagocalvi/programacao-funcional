/// Adicionar um ponto final a uma *frase* caso ela não acabe com um

import sgleam/check
import gleam/string

pub fn adicionar_ponto(frase: String) -> String {
    let tamanho_frase: Int = string.length(frase)
    let ultimo_caracter: String = string.slice(frase, tamanho_frase - 1, 1)
    case ultimo_caracter == "." {
        True -> frase
        False -> string.concat([frase, "."])
    }
}

pub fn adicionar_ponto_examples() {
    check.eq(adicionar_ponto("Hoje está chovendo"), "Hoje está chovendo.")
    check.eq(adicionar_ponto("Acho que ele não vem mais."), "Acho que ele não vem mais.")
    check.eq(adicionar_ponto("Gleam está vindo com tudo!"), "Gleam está vindo com tudo!.")

}