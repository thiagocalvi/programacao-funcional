import gleam/list
import sgleam/check

/// Ordena uma lista de números *lst* em ordem crescente
pub fn ordena(lst: List(Int)) -> List(Int) {
    case lst {
        [] -> []
        _ -> {
            let min = min_lista(lst)
            let lst_min = list.filter(lst, fn(x){x == min})
            let lst_sem_min = list.filter(lst, fn(x){x > min})
            list.concat([lst_min, ordena(lst_sem_min)])
        }
    }
}
pub fn ordena_examples() {
    check.eq(ordena([]), [])
    check.eq(ordena([1,2,1,5,4,9]), [1,1,2,4,5,9])
}

/// Encontro o minimo de uma lista não vazia de numeros inteiros
pub fn min_lista(lst: List(Int)) -> Int {
    case lst {
        [a] -> a
        _ -> {
            let #(metade_1, metade_2) = list.split(lst, {list.length(lst) / 2})
            let min_1 = min_lista(metade_1)
            let min_2 = min_lista(metade_2)
            case min_1 < min_2 {
                True -> min_1
                False -> min_2
            }
        }
    }
}

pub fn min_lista_examples() {
    check.eq(min_lista([1]), 1)
    check.eq(min_lista([1,2,3,4]), 1)
    check.eq(min_lista([5,8,-1,9,9,0]), -1)
}