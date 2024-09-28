import gleam/io

pub fn main(){
  //os nomes das variaveis são escritas no padrão snake_case
  let x = "Original"
  io.debug(x)

  //y assinado com o valor de x
  let y = x
  io.debug(y)

  //x assinado com um novo valor
  let x = "New"
  io.debug(x)

  //y referencia o valor original de x
  io.debug(y)
}
