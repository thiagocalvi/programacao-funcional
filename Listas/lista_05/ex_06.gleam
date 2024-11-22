import sgleam/check

pub fn main() {

}

//Cancatena as strings de uma *lista* em uma única string
pub fn concatena_lista(lista: List(String)) -> String {
    case lista {
        [] -> ""
        [primeiro, segundo] -> primeiro <> segundo
        [primeiro, ..resto] -> primeiro <> concatena_lista(resto)
    }    
}

pub fn concatena_lista_examples(){
    check.eq(concatena_lista(["nome", "primeiro", "segundo"]), "nomeprimeirosegundo")
    check.eq(concatena_lista([]), "")
    check.eq(concatena_lista(["primeiro", "segundo"]), "primeirosegundo")

}