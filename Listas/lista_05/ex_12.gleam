import sgleam/check

pub fn main() {}

// Verifica se uma *lista* de numeros inteiros está em ordem não decresente
// se estiver retorna True, caso contrario False 
pub fn ordem_crescente(lista: List(Int)) -> Bool {
    case lista {
        [] -> True
        [_] -> True
        [primeiro, segundo, ..resto] -> primeiro <= segundo && ordem_crescente([segundo, ..resto])
    }
}

pub fn ordem_crescente_examples() {
    check.eq(ordem_crescente([1,2,3,4,5,6]), True)
    check.eq(ordem_crescente([1,2,3,1,5,6]), False)
    check.eq(ordem_crescente([]), True)
    check.eq(ordem_crescente([0]), True)

}