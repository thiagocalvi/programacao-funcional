import sgleam/check

pub fn main() {
        
}


//Conta a quantidade de elementos em uma *lista* de numeros inteiro
pub fn quantidade_elementos(lista: List(Int)) -> Int {
    case lista {
        [] -> 0
        [_] -> 1
        [_, ..resto] -> 1 + quantidade_elementos(resto)
    }
}

pub fn quantidade_elementos_examples() {
    check.eq(quantidade_elementos([]), 0)
    check.eq(quantidade_elementos([1,2,4,5,8,1]), 6)
    check.eq(quantidade_elementos([0,2,2,12]), 4)
    check.eq(quantidade_elementos([2,5,6,321,44,22,-4,85]), 8)
}