import sgleam/check

pub fn ordem(a: Int, b: Int, c: Int) {
    /// Determinar se a sequencia de *a*, *b* e *c* esta
    /// em ordem crescente, decrescente ou sem ordem
    case a > b && b > c {
        True -> "decrescente"
        False -> case a < b && b < c {
            True -> "crescente"
            False -> "sem ordem"
        }
    }   
}

pub fn ordem_examples() {
    check.eq(ordem(3, 8, 12), "crescente")
    check.eq(ordem(3, 1, 4), "sem ordem")
    check.eq(ordem(3, 1, 0), "decrescente")
    check.eq(ordem(3, 3, 3), "sem ordem")

}