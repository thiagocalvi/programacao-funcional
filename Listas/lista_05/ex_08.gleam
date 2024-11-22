
import sgleam/check
import gleam/int

pub fn main() {

}

//Converte uma *lista* de strings para uma lista de numeros inteiros
pub fn lista_strings_para_numeros(lista: List(String)) -> Result(List(Int), Nil) {
    case lista {
        [] -> Ok([])
        [primeiro, ..resto] -> case int.parse(primeiro) {
            Ok(primeiro) -> case lista_strings_para_numeros(resto) {
                Ok(resto) -> Ok(primeiro, ..resto)
                _ -> Error(Nil)
            }
            _ -> Error(Nil)
        }
    }
}

pub fn lista_strings_para_numeros_examples() {
    check.eq(lista_strings_para_numeros([]), Ok([]))
    check.eq(lista_strings_para_numeros(["1"]), Ok([1]))
    check.eq(lista_strings_para_numeros(["1", "2"]), Ok([1, 2]))
    check.eq(lista_strings_para_numeros(["1", "2", "-2", "4"]), Ok([1, 2, -2, 4]))
    check.eq(lista_strings_para_numeros(["a"]), Error(Nil))
}