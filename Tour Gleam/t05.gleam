import gleam/io
import gleam/int

pub fn main(){
  //Aritimetica com inteiros
  io.debug(1 + 1)
  io.debug(5 - 5)
  io.debug(5 / 2)
  io.debug(3 * 3)
  io.debug(5 % 2)

  //Comparação entre inteiros
  io.debug(2 > 1)
  io.debug(2 < 1)
  io.debug(2 >= 1)
  io.debug(2 <= 1)

  //Igualdade de tipos (funciona para qualquer tipo de dado)
  io.debug(1 == 1)
  io.debug(2 == 1)

  //Funções com inteiros da biblioteca int
  io.debug(int.max(42, 77))
  io.debug(int.clamp(5, 10, 20))
}
