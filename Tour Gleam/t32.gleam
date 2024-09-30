import gleam/io

pub fn main() {
  io.debug(factorial(5))
  io.debug(factorial(7))
}

pub fn factorial(x: Int) -> Int {
  factorial_loop(x, 1)
}

fn factorial_loop(x: Int, accumulator: Int) -> Int {
  case x {
    0 -> accumulator
    1 -> accumulator
    _ -> factorial_loop(x - 1, accumulator * x)
  }
}
