import gleam/io

pub fn main(){
  let ints = [1, 2, 3]

  io.debug(ints)

  //Não altera a lista original
  io.debug([-1, 0, ..ints])

  io.debug(ints) //Não foi alterada


