import sgleam/check
import gleam/string
import gleam/list

/// Representa os erros que podem acontecer no programa
pub type Erro {
    // Representa um string vazia
    StringVazia(msg: String)

    // Representa uma lista vazia
		ListaVazia(msg: String)

		// Representa a quantidade errada de paramentos
    QuantidadeErradaParamentros(quantidade_obitidada: Int, quantidade_esperada: Int)

		// Representa que o time anfitrião não está presente
    AnfitriaoAusente(msg: String)

		// Representa que o time visitante não está presente
		VisitanteAusente(msg: String)

		// Representa a quantidade invalidade de Gols
		QuantidadeInvalidaGols(mgs: String)
}

/// Recebe uma *lista_jogos* contendo uma lista de strings com ""anfitriao gols visitante gols" em cada string
/// e separa esses dados de cada string em uma lista de strings
pub fn tratar_dados(lista_jogos: List(String)) -> Result(List(List(String)), String) {
    case lista_jogos {
        [] -> Error("Lista vazia")
				[primeiro] -> case separa_dados(primeiro) {
				    Ok(dados_jogo) -> Ok([dados_jogo])
						Error(_) -> Error("AA")
				}
				[primeiro, ..resto] -> case separa_dados(primeiro) {
            Ok(dados_jogo) -> Ok([dados_jogo, ..case tratar_dados(resto) {
                Ok(info_jogo) -> info_jogo
								Error(_) -> todo
						}])
						Error(_) -> Error("BB")
				}
		}
}
pub fn tratar_dados_examples() {
    check.eq(tratar_dados(["Sao-Paulo 1 Atletico-MG 2"]), [["Sao-Paulo", "1", "Atletico-MG", "2"]])
    check.eq(tratar_dados(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1"]), [["Sao-Paulo", "1", "Atletico-MG", "2"], ["Flamengo", "2", "Palmeiras", "1"]])
} 

/// Recebe uma string *dado* e divide esse *dado* nos espaços em branco, gerando uma lista de strings. 
/// Retorna um Result Ok contento a lista de strings. Caso não seja possivel separado os dados, ou a 
/// a string seja vazia ou tenha mais/menos que 4 elementos depois de separada ou todos os elementos
/// depois de saparado sejam strings vazias retorna um Error.
/// Recebe -> "Sao-Paulo 1 Atletico-MG 2"
/// Retorna -> ["Sao-Paulo", "1", "Atletico-MG", "20"]
pub fn separa_dados(dado: String) -> Result(List(String), Erro) {
		case dado {
        "" | " " -> Error(StringVazia("A string não pode ser vazia"))
				_ -> {
				    let lista = string.split(dado, on: " ")
						let tamanho_lista = list.length(lista)
						
						case tamanho_lista > 4 || tamanho_lista < 4 {
				        True -> Error(QuantidadeErradaParamentros(tamanho_lista, 4))
								False -> case lista {
								    [anfitriao, anfitriao_gols, visitante, visitante_gols] ->
										case anfitriao == " " || anfitriao_gols == " " || visitante == " " || visitante_gols == " " {
								        True -> Error(StringVazia("A string não pode ser composta somente de espaços")) // Pensar em uma mensagem melhor para esse erro
												False -> Ok(lista)
										}
										_ -> Error(StringVazia("Ivalido"))
								}
				    }
				}
		}
}

pub fn separa_dados_examples() {
    check.eq(separa_dados("Sao-Paulo 1 Atletico-MG 2"), Ok(["Sao-Paulo", "1", "Atletico-MG", "2"]))
		check.eq(separa_dados("Flamengo 2 Palmeiras 1"), Ok(["Flamengo", "2", "Palmeiras", "1"]))
    check.eq(separa_dados(""), Error(StringVazia("A string não pode ser vazia")))
    check.eq(separa_dados(" "), Error(StringVazia("A string não pode ser vazia")))
    check.eq(separa_dados("   "), Error(StringVazia("A string não pode ser composta somente de espaços")))
    check.eq(separa_dados(""), Error(StringVazia("A string não pode ser vazia")))
}
