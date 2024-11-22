import sgleam/check

pub fn main() {}

/// Associação entre cheve e valor
pub type Par {
    Par(chave: String, valor: Int)
}


/// Recebe uma *lista* de associações, com chave (string) e um valor (int)
/// e um *Par(chave, valor)* e atualiza (adiciona) à *lista* de associações se a *chave* não estiver presente,
/// ou se a chave estiver presente atualiza o valor associado a chave
pub fn modifica_associacoes(lista: List(Par), par: Par) -> List(Par) {
    case lista {
        [] -> [par]
        [primeiro] -> case primeiro.chave == par.chave {
            True -> [Par(par.chave, par.valor)]
            False -> [primeiro, par]
        }
        [primeiro, ..resto] -> case primeiro.chave == par.chave {
            True -> [Par(par.chave, par.valor), ..resto]
            False -> [primeiro, ..modifica_associacoes(resto, par)]
        }
    }
}

pub fn modifica_associacoes_examples() {
    check.eq(modifica_associacoes([Par("A", 1), Par("B", 2), Par("C", 3)], Par("B", 0)), [Par("A", 1), Par("B", 0), Par("C", 3)])
    check.eq(modifica_associacoes([Par("A", 1)], Par("B", 2)), [Par("A", 1), Par("B", 2)])
    check.eq(modifica_associacoes([], Par("V", 10)), [Par("V", 10)])
}