// Tipo enumerado
 type Combustivel {
    Alcool
    Gasolina
 }

 // Estruturas
type Ponto {
    Ponto(x: Int, y: Int)   
}
// Construção
let p1: Ponto = Ponto(1, 2)
let p2 = Ponto(3, 4)
// Destruturação
//-> Pela posiçção
let Ponto(x, y) = p2
// > x
// 3

// Pelo rótulo
let Ponto(y: a, ..) = p2
// > a
// 4
let Ponto(y:, ..) = p2
// > y
// 4
