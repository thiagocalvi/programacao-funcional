//Formatos de numeros
import gleam/io

pub fn main(){
  //Forma de facilitar a leitura dos numeros
  io.debug(1_000_000) //int
  io.debug(1_000.01) //float

  io.debug(0b00001111) //binario
  io.debug(0o17) //octal
  io.debug(0xF) //literal int em hexadecimal

  //Notação cientifica
  io.debug(7.0e7)
  io.debug(3.0e-4)
}
