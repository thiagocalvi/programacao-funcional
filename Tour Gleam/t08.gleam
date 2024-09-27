import gleam/io
import gleam/string

pub fn main(){
  io.debug(
  "multiplas
  linhas
  string"
  )

  io.debug("\u{1F600}")

  io.println("\"X\" marks the spot")

  //concatenação de string
  io.debug("One" <> "Two")

  //String functions
  io.debug(string.reverse("1 2 3 4 5"))
  io.debug(string.append("abc", "def"))
}
