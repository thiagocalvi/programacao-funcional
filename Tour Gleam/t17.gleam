import gleam/io

//Constantes
const ints: List(Int) = [1, 2, 3]

const floats = [1.0, 2.0, 3.0]

pub fn main(){
  io.debug(ints)
  io.debug(ints == [1, 2, 3])
  
  io.debug(floats)
  io.degun(floats == [1.0, 2.0, 3.0])
}
