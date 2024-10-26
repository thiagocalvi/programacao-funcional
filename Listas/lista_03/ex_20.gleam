/// Verificar se uma *palavra* tem um traço "-" no meio

import sgleam/check
import gleam/string
import gleam/list

pub fn tem_traco(palavra: String) -> Bool {
    //Usando condicional
    let lista_palavra = string.split(palavra, "-")
    let p1 = 
    list.length(lista_palavra) == 2 && {lista_palavra}
}

pub fn tem_traco_examples() {
    check.eq(tem_traco("Lero-lero"), True)
    check.eq(tem_traco("Repo-repo"), True)
    check.eq(tem_traco("Abacate"), False)
    check.eq(tem_traco("-"), False)
    check.eq(tem_traco("-a"), False)
}