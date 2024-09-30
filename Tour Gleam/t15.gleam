import gleam/io

//Oque é definido dentro de um bloco só pode ser acessado dentro do bloco

pub fn main(){
  //Bloco é um conjunto de uma ou mais expressões, que são avaliadas em ordem
  //e o valor da ultima expressão é retornada
  let fahrenheit = {
    let degrees = 64
    degrees
  }
                // valor 64 é retornado
  let celsius = { fahrenheit - 32} * 5 / 9
  io.debug(celsius)
}
