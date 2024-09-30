import gleam/io

pub fn main() {
  io.debug(factorial(5))
  io.debug(factorial(7))
}

pub fn factorial(x: Int) -> Int {
  case x {
    0 -> 1
    1 -> 1

    
    _ -> x * factorial(x - 1)
  }
}
