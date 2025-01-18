import sgleam/check
import gleam/string
import gleam/int



/// Representa uma data com dia, mes e ano
pub type Data {
    Data(dia: Int, mes: Int, ano: Int)
} 

/// Converte uma string *data* no formato "dd/mm/aaaa" 
/// para um estrutura Data e retorna essa estrutura.
pub fn to_data(data: String) -> Result(Data, Nil) {
    case int.parse(string.slice(data, 0, 2)), int.parse(string.slice(data, 3, 2)), int.parse(string.slice(data, 6, 4)) {
        Ok(dia), Ok(mes), Ok(ano) -> Ok(Data(dia, mes, ano))
        _, _, _ -> Error(Nil)
    }

}
pub fn to_data_examples() {
    check.eq(to_data("10/12/2022"), Ok(Data(10, 12, 2022)))
    check.eq(to_data("a/12/2022"), Error(Nil))

}

/// Verifica se uma *data* (Data) é o ultimo dia do ano
/// se for retorna True, caso contrario, False
pub fn ultimo_dia_ano(data: Data) -> Bool {
    case data {
        Data(dia, mes, _) -> dia == 31 && mes == 12
    }
}
pub fn ultimo_dia_ano_examples() {
    check.eq(ultimo_dia_ano(Data(10, 03, 2022)), False)
    check.eq(ultimo_dia_ano(Data(31, 12, 2022)), True)
}

/// Recebe *data_um* e *data_dois* produz True
/// se a *data_um* vem antes de *data_dois*, caso contrario
/// produz false
pub fn vem_antes(data_um: Data, data_dois: Data) -> Bool { 
    case data_um, data_dois {
        _, _ if data_um.ano < data_dois.ano -> {True}
        _, _ if data_um.ano == data_dois.ano && data_um.mes < data_dois.mes -> {True}
        _, _ if data_um.dia < data_dois.dia -> {True}
        _, _ -> False
    } 
    
}

pub fn vem_antes_examples() {
    check.eq(vem_antes(Data(10, 10, 2025), Data(05, 09, 2024)), False)
    check.eq(vem_antes(Data(03, 06, 2024), Data(01, 06, 2024)), True)
}