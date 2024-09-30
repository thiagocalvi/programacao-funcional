//Funções generiacas

import gleam/io

pub fn main(){
  let add_one = fn(x) { x + 1 }
  let exclaim = fn(x) { x <> "!"}

  io.debug(twice(10, add_one))

  io.debug(twice("Hello", exclaim))
}

// 'value' refere a multiplos tipos ao mesmo tempo
fn twice(argument: value, my_function: fn(value) -> value) -> value {
  my_function(my_function(argument))

}
