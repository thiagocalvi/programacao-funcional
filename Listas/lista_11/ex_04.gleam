import gleam/string
import sgleam/check

/// Inverte os caracteres de um string *str*
pub fn inverte(str: String) -> String{
    case string.length(str) > 1 {
        False -> str
        True -> {
            let primeiro = string.slice(str, 0, 1)
            let ultimo = string.slice(str, -1, 1)
            ultimo <> inverte(string.slice(str, 1, {string.length(str) - 2})) <> primeiro
        }
    }
}

pub fn inverte_examples() {
    check.eq(inverte(""), "")
    check.eq(inverte("a"), "a")
    check.eq(inverte("abc"), "cba")
    check.eq(inverte("abcd"), "dcba")
}