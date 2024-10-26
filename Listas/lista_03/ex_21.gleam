/// Encontrar o maior valor entre *a*, *b* e *c*

import sgleam/check

pub fn maximo(a: Int, b: Int, c: Int) -> Int {
    case a >= b && a >= c {
        True -> a
        False -> case b >= a && b >= c {
            True -> b
            False -> c
        }
    }
}

pub fn maximo_examples() {
    check.eq(maximo(1,2,3), 3)
    check.eq(maximo(4,1,1), 4)
    check.eq(maximo(2,7,6), 7)
    check.eq(maximo(-12,12,23), 23)
    check.eq(maximo(1,2,3), 3)
    check.eq(maximo(10,10,5), 10)

}