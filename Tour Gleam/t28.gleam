import gleam/io
import gleam/int

pub fn main() {
  let result = case int.random(5) {
    //Match especifico
    0 -> "Zero"
    1 -> "One"

    //Match para qualquer outro tipo e assinado para um variavel
    other -> "It is " <> int.to_string(other) 
  }

  io.debug(result)
}
