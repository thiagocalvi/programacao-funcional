import sgleam/check
import gleam/int

pub fn main() {}

/// Retorna o valor maximo de uma *lista* de inteiros
pub fn maximo(lista: List(Int)) -> Result(Int, Nil) {
    case lista {
        [] -> Error(Nil)
        [primeiro, ..resto] -> case maximo(resto) {
            Error(Nil) -> Ok(primeiro)
            Ok(maximo_resto) -> Ok(int.max(maximo_resto, primeiro))
        }
    }
}

pub fn maximo_examples() {
    check.eq(maximo([10,20,3,45,0]), Ok(45))
    check.eq(maximo([0,2,-4,5,7]), Ok(7))
    check.eq(maximo([20]), Ok(20))
    check.eq(maximo([]), Error(Nil))

}

