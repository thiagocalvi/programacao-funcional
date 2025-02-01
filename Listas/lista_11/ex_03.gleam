import sgleam/check

/// Converte um número natural *n* para uma string
pub fn int_to_string(n: Int) -> String { 
    case n {
        0 -> "0" 
        1 -> "1"
        2 -> "2"
        3 -> "3"
        4 -> "4"
        5 -> "5"
        6 -> "6"
        7 -> "7"
        8 -> "8"
        9 -> "9"
        _ -> {
            let ult_dg = n % 10
            let dm_dg = n / 10
            int_to_string(dm_dg) <> int_to_string(ult_dg)
        }
    }
}

pub fn int_to_string_examples() {
    check.eq(int_to_string(1), "1")
    check.eq(int_to_string(10), "10")
    check.eq(int_to_string(122), "122")
}