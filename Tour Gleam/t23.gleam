import gleam/io
import gleam/string

pub fn main() {
  //Sem operador de pipeline
  io.debug(string.drop_left(string.drop_right("Hello, Joe!", 1), 7))

  //Com operador de pipeline
  "Hello, Mike!"
  |> string.drop_right(1)
  |> string.drop_left(7)
  |> io.debug

  "1"
  |> string.append("2")
  |> string.append("3", _)
  |> io.debug
  
}
