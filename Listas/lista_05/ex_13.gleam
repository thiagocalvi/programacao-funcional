import sgleam/check

pub fn main() {}

// Adiciona um *elemento* (int) ao final de uma *lista* de inteiros e
// retorna a uma lista com todos os elementos mais o novo elemento no final
pub fn append(lista: List(Int), elemento: Int) -> List(Int) {
    case lista {
        [] -> [elemento]
        [primeiro] -> [primeiro, elemento]
        [primeiro, ..resto] -> [primeiro, ..append(resto, elemento)]
    }
}

pub fn append_examples() {
    check.eq(append([10,20,30], 4), [10,20,30,4])
    check.eq(append([], 4), [4])
    check.eq(append([30], 4), [30,4])
}

// Recebe uma *lista* de inteiros e retorna essa mesma *lista* no
// ordem contraria.
pub fn inverte_lista(lista: List(Int)) -> List(Int) {
    case lista {
        [] -> []
        [primeiro] -> [primeiro]
        [primeiro, ..resto] -> append(inverte_lista(resto), primeiro)
    }
}

pub fn inverte_lista_examples() {
    check.eq(inverte_lista([0,20,30,40]), [40,30,20,0])
    check.eq(inverte_lista([]), []) 
    check.eq(inverte_lista([40]), [40]) 
}