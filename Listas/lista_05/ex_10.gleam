import sgleam/check

pub fn main() {}

/// Verifica se todos os elmentos de uma *list* são true ou a *lista é vazia*
/// e retorna True, caso contrario retorna False
pub fn todos_true(lista: List(Bool)) -> Bool {
    case lista {
        [] -> True
        [primeiro, ..resto] -> primeiro && todos_true(resto)

    }
}

pub fn todos_true_examples() {
    check.eq(todos_true([True, True, False]), False)
    check.eq(todos_true([]), True)
    check.eq(todos_true([True, True, True]), True)
    check.eq(todos_true([True]), True)

}