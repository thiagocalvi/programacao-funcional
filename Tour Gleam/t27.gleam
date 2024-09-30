import gleam/io
import gleam/int

pub fn main() {
  let x = int.random(5)
  io.debug(x)

  let result = case x {
    //Match para valores especificos
    0 -> "Zero"
    1 -> "One"

    //Match para qualquer outro valor
    _ -> "Other"
  }

  io.debug(result)
}
