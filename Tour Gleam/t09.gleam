import gleam/bool
import gleam/io

pub fn main(){
  //Operadores bool
  io.debug(True && False)
  io.debug(True && True)
  io.debug(False || False)
  io.debug(False || True)

  //Funções bool
  io.debug(bool.to_string(True))
  io.debug(bool.to_int(False))
}
