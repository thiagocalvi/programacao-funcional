import gleam/io

pub fn main(){
  io.debug(calculate(1, 2, 3))

  io.debug(calculate(1, add: 2, multiply: 3))

  io.debug(calculate(1, multiply: 3, add: 2))
}
                           //interno    //externo
fn calculate(value: Int, add addend: Int, multiply multipliter: Int) {
  value * multipliter + addend
}
