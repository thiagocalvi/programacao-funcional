import sgleam/check
import gleam/float

/// Representa uma figura que pode ser
/// um circulo ou retangulo
pub type Figura{
    Circulo(raio: Float)
    Retangulo(largura: Float, altura: Float)
}

/// Calcula a area de uma *fugura*
pub fn area(figura: Figura) -> Float {
    case figura {
        Retangulo(largura, altura) -> largura *. altura
        Circulo(raio) -> 3.14 *. {raio *. raio} 
    }
}
pub fn area_examples() {
    check.eq(area(Circulo(2.0)), 12.56)
    check.eq(area(Retangulo(2.0, 1.)), 2.0)
}

/// Verifica se uma *figura_um* cabe dentro de 
/// uma *figura_dois*, retorna True se *figura_um*
/// couber dentro de *figura_dois*, caso contro retorna
/// False
pub fn cabe_dentro(figura_um: Figura, figura_dois: Figura) -> Bool {
    case figura_um, figura_dois {
        Retangulo(largura1, altura1), Retangulo(largura2, altura2) -> 
            largura1 <. largura2 && altura1 <. altura2
        
        Retangulo(largura, altura), Circulo(raio) -> 
            case float.square_root({largura *. largura} +. {altura *. altura}) { 
                Ok(diagonal) -> diagonal <. {raio *. 2.0}
                Error(_) -> False
            }
        
        Circulo(raio), Retangulo(largura, altura) -> {raio *. 2.0} <. largura && {raio *. 2.0} <. altura 
        
        Circulo(raio1), Circulo(raio2) -> {raio1 *. 2.0} <. {raio2 *. 2.0}
    }
}
/// retangulo1 - retangulo2 -> diagonal do retangulo1 for menor que retangulo2
/// retangulo1 - circulo -> diagonal retangulo1 é menor que o diametro do circulo
/// circulo - retangulo -> se o raio * 2 do circulo e menor que a altura e largura do retangulo
/// circulo1 - circulo2 -> circulo1 tem raio menor que circulo2
pub fn cabe_dentro_examples() {
    check.eq(cabe_dentro(Retangulo(2.0, 3.0), Retangulo(4.0, 5.0)), True)
    check.eq(cabe_dentro(Retangulo(6.0, 7.0), Retangulo(4.0, 5.0)), False)
    check.eq(cabe_dentro(Retangulo(2.0, 2.0), Circulo(2.5)), True)
    check.eq(cabe_dentro(Circulo(1.5), Circulo(2.0)), True)
}