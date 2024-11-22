import sgleam/check

pub fn main() {

}

//Remove os numeros zeros de uma *lista* de numeros inteiros
pub fn remove_zeros(lista: List(Int)) -> List(Int) {
    case lista {
        [] -> []
        [primeiro] -> case primeiro == 0 {
            True -> []
            False -> [primeiro]
        }
        [primeiro, ..resto] -> case primeiro != 0 {
            True -> [primeiro, ..remove_zeros(resto)]
            False -> remove_zeros(resto)
        }
    }
}

pub fn remove_zeros_examples() {
    check.eq(remove_zeros([]), [])
    check.eq(remove_zeros([0,1,2]), [1,2])
    check.eq(remove_zeros([0,2,0,2,3,2,0,5]), [2,2,3,2,5])
    check.eq(remove_zeros([0,0,0,0,0]), [])
}