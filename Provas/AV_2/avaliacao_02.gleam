// Avaliação 2
// Discente: Thiago Henrique Calvi RA: 134955

import gleam/list
import sgleam/check

// 01)
/// Determina as palavras que mais se repetem em uma *lst* de
/// strings, retorna uma lista com as palavra que mais 
/// se repetem em *lst*.
pub fn mais_repetem(lst: List(String)) -> List(String) {
  case lst {
    [] -> []
    [p, ..r] -> {
      list.fold(r, [], fn(acc, x) {
        case q_aparicoes(lst, p) > q_aparicoes(lst, x) {
          True -> [p, ..acc]
          False -> [x, ..acc]
        }
      })
      mais_repetem(r)
    }
  }
}

pub fn mais_repetem_examples() {
  check.eq(mais_repetem([]), [])
  check.eq(mais_repetem(["nada"]), ["nada"])
  check.eq(mais_repetem(["casa", "onde", "talvez", "casa", "nada", "onde"]), [
    "casa", "onde",
  ])
}

/// Calcula a quantidade de vezes que uma string *str*
/// aprece em uma lista *slt*
pub fn q_aparicoes(lst: List(String), str: String) -> Int {
  case lst {
    [] -> 0
    _ ->
      list.fold(lst, 0, fn(acc, x) {
        case x == str {
          True -> acc + 1
          False -> acc
        }
      })
  }
}

pub fn q_aparicoes_examples() {
  check.eq(q_aparicoes([], "nada"), 0)
  check.eq(q_aparicoes(["nada"], "nada"), 1)
  check.eq(
    q_aparicoes(["casa", "onde", "talvez", "casa", "nada", "onde"], "onde"),
    2,
  )
}

// 02)
/// Ordena uma lista *lst* de inteiros em ordem
/// crescente usando ordenação por seleção
/// Analise de tempo: 
/// - Pior caso O(n³)
pub fn ordena(lst: List(Int)) -> List(Int) {
  case lst {
    [] | [_] -> lst
    _ -> {
      let min_lst = minimo(lst)
      let lst_minimos = list.filter(lst, fn(x) { x == min_lst })
      let lst_sem_minimos = list.filter(lst, fn(x) { x > min_lst })
      list.fold_right(lst_minimos, lst_sem_minimos, fn(acc, item) {
        [item, ..ordena(acc)]
      })
    }
  }
}

pub fn ordena_examples() {
  check.eq(ordena([]), [])
  check.eq(ordena([4]), [4])
  check.eq(ordena([1, 3, 5, 4, 0, 2, 1, 6]), [0, 1, 1, 2, 3, 4, 5, 6])
  check.eq(ordena([1, 1, 1]), [1, 1, 1])
}

/// Encontra o valor minimo de uma lista *lst* de
/// inteiros
pub fn minimo(lst: List(Int)) -> Int {
  case lst {
    [p] -> p
    _ -> {
      let #(metade1, metade2) = list.split(lst, { list.length(lst) / 2 })
      let min_metade1 = minimo(metade1)
      let min_metade2 = minimo(metade2)
      case min_metade1 < min_metade2 {
        True -> min_metade1
        False -> min_metade2
      }
    }
  }
}

pub fn minimo_examples() {
  check.eq(minimo([5]), 5)
  check.eq(minimo([2, 4, 6, 1, 2, 1, 1]), 1)
}
