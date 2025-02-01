import gleam/list
import sgleam/check

/// Encontro o máximo de uma lista não vazia de numeros inteiros
pub fn max_lista(lst: List(Int)) -> Int {
    case lst {
        [a] -> a
        _ -> {
            let #(metade_1, metade_2) = list.split(lst, {list.length(lst) / 2})
            let max_1 = max_lista(metade_1)
            let max_2 = max_lista(metade_2)
            case max_1 > max_2 {
                True -> max_1
                False -> max_2
            }
        }
    }
}

pub fn max_lista_examples() {
    check.eq(max_lista([1]), 1)
    check.eq(max_lista([1,2,3,4]), 4)
    check.eq(max_lista([5,8,-1,9,9,0]), 9)
}