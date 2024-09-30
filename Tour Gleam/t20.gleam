import gleam/io

pub fn main(){
  let add_one = fn(a) { a + 1 }
  io.debug(twice(1, add_one))

  io.debug(twice(1, fn(a) { a * 2 }))

  let secret_number = 42
  let secret = fn() { secret_number }
  io.debug(secret())
}

fn twice(argument: Int, my_function: fn(Int) -> Int) -> Int {
  my_function(my_function(argument))
}
