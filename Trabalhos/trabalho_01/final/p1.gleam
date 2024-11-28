import gleam/string
import gleam/list
import sgleam/check

pub fn main() {todo}


/// Recebe uma lista de string que representa os *jogos* do campeonato 
/// e sapara as informações de cada string em uma lista de strings
/// retornando uma lista de lista com as informações formatadas
pub fn formata_dados(jogos: List(String)) -> Result(List(List(String), String) {todo}
pub fn formata_dados() {todo}

/// Separa uma string *dado* nos espeços em banco e retorna uma lista de strings
/// contendo os dados separados
pub fn separa_dados(dado: String) -> List(String) {todo}
pub fn separa_dados_examples() {
    check.eq(separa_dados("Sao-Paulo 1 Atletico-MG 2"), ["Sao-Paulo", "1", "Atletico-MG", "2"])
		check.eq(separa_dados(""), [""])
		check.eq(separa_dados(" "), ["", ""])
}


