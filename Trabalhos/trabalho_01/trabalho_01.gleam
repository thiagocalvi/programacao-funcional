/// ************************************************************
/// * 4 Semestre do Curso de Ciência da Computação - UEM 2024  *
/// * Primeiro trabalho da disciplica de Programação Funcional *
/// * Acadêmico: Thiago Henrique Calvi ra: 134955              *
/// ************************************************************

// Imports
import gleam/int
import gleam/string
import gleam/order
import sgleam/check


/// Definição dos erros que podem ocorrer no programa
pub type Erro {
				// Representa uma string vazia passada como parametro
				StringVazia

				// Representa uma lista vazia
				ListaVazia

				// Representa quantidade invalida de parametros
				QuantidadeInvalidaParametros

				// Representa um valor invalido para gols
				ValorInvalidoGols

				// Representa um valor invaldo
				ValorInvalido

				// Representa um time não encontrado
				TimeNaoEncontrado

				// Representa times incopativeis
				TimesIncompativeis

				// Representa dois times iguais em um mesmo jogo
				TimesIguais

}

/// Representa um time participante do compeonato
pub type Time {
				Time(nome: String)
}

/// Representa um time na tabela de classificação
pub type TimeTabela {
				TimeTabela(time: Time, numero_pontos: Int, numero_vitorias: Int, saldo_gols: Int)
}

/// Representa um jogo do campeonato
pub type Jogo {
				Jogo(anfitriao: Time, anfitriao_gols: Int, visitante: Time, visitante_gols: Int)
}

/// Representa o resultado de um jogo (confronto entre dois times)
pub type ResultadoJogo {
				// Representa a vitória de um time
				Vitoria(time_vencedor: Time, vencedor_gols: Int, time_perdedor: Time, perdedor_gols: Int)
				
				// Representa o empate entre dois times 
				Empate(jogo: Jogo)
}

pub type ResultadoTime {
				VitoriaParcial
				DerrotaParcial
				EmpateParcial
}

/// Representa o reultado parcial de um time
pub type ResultadoParcial {
				ResultadoParcial(time: Time, saldo_gols_parcial: Int, resultado: ResultadoTime)
}

/// Receber uma string `dados_jogo` contendo informações de um jogo no formato 
/// "anfitriao anfitriao_gols visitante visitante_gols", separá-la em uma lista de strings 
/// `[anfitriao, anfitriao_gols, visitante, visitante_gols]`, e validar os dados.
/// - Se `dados_jogo` for uma string vazia ou contiver apenas espaços, retorna `Error(StringVazia)`.
/// - Se algum dos campos (anfitrião, anfitriao_gols, visitante, visitante_gols) for vazio, 
/// retorna `Error(ValorInvalido)`.
/// - Se a quantidade de parâmetros for diferente de quatro, retorna `Error(QuantidadeInvalidaParametros)`.
/// Caso os dados sejam válidos, retorna `Ok` com a lista de strings extraída.
pub fn separa_dados(dados_jogo: String) -> Result(List(String), Erro) {
				case dados_jogo {
								"" | " " -> Error(StringVazia)
								_ -> {
												case string.split(dados_jogo, on: " ") {
																[anfitriao, anfitriao_gols, visitante, visitante_gols] -> case anfitriao == "" || anfitriao_gols == "" || visitante == "" || visitante_gols == "" {
																				True -> Error(ValorInvalido)
																				False -> Ok([anfitriao, anfitriao_gols, visitante, visitante_gols])
																}
																[_, _, _, _, ..] -> Error(QuantidadeInvalidaParametros)
																[] | [_] | [_, _] | [_, _, _] -> Error(QuantidadeInvalidaParametros)
												}
								}
				}
}
pub fn separa_dados_examples() {
				check.eq(separa_dados(""), Error(StringVazia))
				check.eq(separa_dados(" "), Error(StringVazia))
				check.eq(separa_dados("Flamengo 2 Palmeiras "), Error(ValorInvalido))
				check.eq(separa_dados("Flamengo 2 Palmeiras 1 b"), Error(QuantidadeInvalidaParametros))
				check.eq(separa_dados("Flamengo Palmeiras 1"), Error(QuantidadeInvalidaParametros))
				check.eq(separa_dados("Flamengo b"), Error(QuantidadeInvalidaParametros))
				check.eq(separa_dados("Palmeiras"), Error(QuantidadeInvalidaParametros))
				check.eq(separa_dados("Sao-Paulo 1 Atletico-MG 2"), Ok(["Sao-Paulo", "1", "Atletico-MG", "2"]))
				check.eq(separa_dados("Atletico-MG 1 Flamengo 2"), Ok(["Atletico-MG", "1", "Flamengo", "2"]))
}

/// Receber uma lista de strings `lista_jogos`, onde cada string contém informações de um jogo no formato 
/// "anfitriao anfitriao_gols visitante visitante_gols", e retornar uma lista de listas de strings, onde cada sublista 
/// contém os dados formatados `[anfitriao, anfitriao_gols, visitante, visitante_gols]`.
/// - Se `lista_jogos` estiver vazia, retorna `Error(ListaVazia)`.
/// - Se algum elemento em `lista_jogos` não puder ser separado corretamente (de acordo com `separa_dados`), retorna o erro correspondente.
/// - Caso todos os elementos sejam válidos, retorna `Ok` com a lista de dados formatados.
pub fn formata_dados(lista_jogos: List(String)) -> Result(List(List(String)), Erro) {
				case lista_jogos {
								[] -> Error(ListaVazia)
								[primeiro] -> case separa_dados(primeiro) {
												Ok(dado_jogo) -> Ok([dado_jogo])
												Error(e) -> Error(e)
								}
								[primeiro, ..resto] -> case separa_dados(primeiro) {
												Ok(dado_jogo) -> case formata_dados(resto) {
																Ok(info_resto) -> Ok([dado_jogo, ..info_resto])
																Error(e) -> Error(e)
												}
												Error(e) -> Error(e)
								}
				}
}
pub fn formata_dados_examples() {
				check.eq(formata_dados([]), Error(ListaVazia))
				check.eq(formata_dados(["Palmeiras 0 Sao-Paulo 0 c"]), Error(QuantidadeInvalidaParametros))
				check.eq(formata_dados(["Palmeiras 0 Sao-Paulo "]), Error(ValorInvalido))
				check.eq(formata_dados([""]), Error(StringVazia))
				check.eq(formata_dados(["Palmeiras 0 Sao-Paulo 0", ""]), Error(StringVazia))
				check.eq(formata_dados(["Palmeiras 0 Sao-Paulo 0"]), Ok([["Palmeiras", "0", "Sao-Paulo", "0"]]))
				check.eq(formata_dados(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0"]), Ok([["Sao-Paulo", "1", "Atletico-MG", "2"], ["Flamengo", "2", "Palmeiras", "1"], ["Palmeiras", "0", "Sao-Paulo", "0"]]))
}


/// Receber uma lista de strings `dado_jogo` contendo informações sobre um jogo no formato `[anfitriao, anfitriao_gols, visitante, visitante_gols]`
/// e retornar uma lista com os dois times `[Time(anfitriao), Time(visitante)]`.
/// - Se `dado_jogo` estiver vazia, retorna `Error(ListaVazia)`.
/// - Se `dado_jogo` não contiver exatamente 4 elementos, retorna `Error(QuantidadeInvalidaParametros)`.
/// - Se anfitriao e visitante forem iguais, retorna `Error(TimesIguais)`
/// - Caso contrário, retorna `Ok` com os times extraídos.
pub fn extrai_times(dado_jogo: List(String)) -> Result(List(Time), Erro) {
				case dado_jogo {
								[] -> Error(ListaVazia)
								[_, _, _, _, _, ..]| [_, _, _] | [_, _] | [_] -> Error(QuantidadeInvalidaParametros)
								[anfitriao, _, visitante, _] -> case anfitriao == visitante {
									True -> Error(TimesIguais)
									False -> Ok([Time(anfitriao), Time(visitante)])
								} 
				}
}
pub fn extrai_time_examples() {
				check.eq(extrai_times([]), Error(ListaVazia))
				check.eq(extrai_times(["Flamengo", "2", "Palmeiras", "1", "Atletico-MG"]), Error(QuantidadeInvalidaParametros))
				check.eq(extrai_times(["Sao-Paulo", "1", "Sao-Paulo", "2"]), Error(TimesIguais))
				check.eq(extrai_times(["Sao-Paulo", "1", "Atletico-MG", "2"]), Ok([Time("Sao-Paulo"), Time("Atletico-MG")]))
}


/// Determinar se um time específico `time` está presente em uma lista de times `lista_times`.
/// - Retorna `True` se o nome do time `time.nome` corresponder ao nome de algum time na lista.
/// - Retorna `False` caso contrário ou se a lista estiver vazia.
pub fn contem_time(time: Time, lista_times: List(Time)) -> Bool {
				case lista_times {
								[] -> False
								[primeiro] -> case primeiro.nome == time.nome {
												True -> True
												False -> False
								}
								[primeiro, ..resto] -> case primeiro.nome == time.nome {
												True -> True
												False -> contem_time(time, resto)
								}
				}
}
pub fn contem_time_examples() {
				check.eq(contem_time(Time("Sao-Paulo"), []), False)
				check.eq(contem_time(Time("Palmeiras"), [Time("Atletico-MG")]), False)
				check.eq(contem_time(Time("Botafogo"), [Time("Atletico-MG"), Time("Botafogo")]), True)
}

/// Adicionar um time `time` a uma lista de times `lista_times`, caso o time ainda não esteja presente.
/// - Se o time já estiver na lista, retorna a lista inalterada.
/// - Caso contrário, adiciona o time ao final da lista.
pub fn append_time(time: Time, lista_times: List(Time)) -> List(Time) {
				case contem_time(time, lista_times) {
								True -> lista_times
								False -> case lista_times {
												[] -> [time]
												[primeiro] -> [primeiro, time]
												[primeiro, ..resto] -> [primeiro, ..append_time(time, resto)] 
								}
				}
}
pub fn append_time_examples() {
				check.eq(append_time(Time("Flamengo"), []), [Time("Flamengo")])
				check.eq(append_time(Time("Santos"), [Time("Sao-Paulo")]), [Time("Sao-Paulo"), Time("Santos")])
				check.eq(append_time(Time("Vitoria"), [Time("Sao-Paulo"), Time("Palmeiras"), Time("Internacional")]), [Time("Sao-Paulo"), Time("Palmeiras"), Time("Internacional"), Time("Vitoria")])
				check.eq(append_time(Time("Botafogo"), [Time("Sao-Paulo"), Time("Botafogo")]), [Time("Sao-Paulo"), Time("Botafogo")])
}

/// Coletar todos os times únicos de uma lista de jogos `dados_jogos` e adicioná-los à lista de times `lista_times`.
/// - Para cada jogo, extrai os times anfitrião e visitante.
/// - Adiciona os times à lista se eles ainda não estiverem presentes.
/// - Retorna a lista final de times ou um erro caso ocorra alguma inconsistência nos dados.
pub fn coleta_times(dados_jogos: List(List(String)), lista_times: List(Time)) -> Result(List(Time), Erro) {
				case dados_jogos {
								[] -> Error(ListaVazia)
								[primeiro] -> {
												case extrai_times(primeiro) {
																Ok([anfitriao, visitante]) -> Ok(append_time(visitante, append_time(anfitriao, lista_times)))
																Ok([]) | Ok([_, _, _, ..]) | Ok([_]) -> Error(ValorInvalido)
																Error(e) -> Error(e)
												}
								}
								[primeiro, ..resto] -> {
												case extrai_times(primeiro) {
																Ok([anfitriao, visitante]) -> coleta_times(resto, append_time(visitante, append_time(anfitriao, lista_times)))
																Ok([]) | Ok([_, _, _, ..]) | Ok([_]) -> Error(ValorInvalido)
																Error(e) -> Error(e)
												}
								}
				}
}
pub fn coleta_times_examples() {
				check.eq(coleta_times([["Sao-Paulo", "1", "Atletico-MG", "2"]], []), Ok([Time("Sao-Paulo"), Time("Atletico-MG")]))
				check.eq(coleta_times([["Sao-Paulo", "1", "Atletico-MG", "2"], ["Flamengo", "2", "Palmeiras", "1"]], []), Ok([Time("Sao-Paulo"), Time("Atletico-MG"), Time("Flamengo"), Time("Palmeiras")]))
				// TODO: Adicinar mais exemplos
}

/// Criar uma estrutura `TimeTabela` para um `time` específico, inicializando os campos relacionados à pontuação, vitórias e saldo de gols com zero.
/// - Recebe um `time` do tipo `Time`.
/// - Retorna um `TimeTabela` com o `time` especificado e os valores padrão inicializados.
pub fn cria_time_tabela(time: Time) -> TimeTabela {
				TimeTabela(time, 0, 0, 0)
}
pub fn cria_time_tabela_examples() {
				check.eq(cria_time_tabela(Time("Palmeiras")), TimeTabela(Time("Palmeiras"), 0, 0, 0))
				check.eq(cria_time_tabela(Time("Botafogo")), TimeTabela(Time("Botafogo"), 0, 0, 0))
}

/// Adicionar um novo `TimeTabela` ao final da `tabela_de_classificacao` existente.
/// - Recebe 
///   - `time_tabela` representando `TimeTabela` a ser adicionado.
///   - `tabela_classificacao` representando a tabela de classificação (lista de `TimeTabela`).
/// - Retorna `tabela_classificacao` contendo o time adicionado ao final da tabela.
pub fn append_time_tabela(time_tabela: TimeTabela, tabela_classificacao: List(TimeTabela)) -> List(TimeTabela) {
				case tabela_classificacao {
								[] -> [time_tabela]
								[primeiro] -> [primeiro, time_tabela]
								[primeiro, ..resto] -> [primeiro, ..append_time_tabela(time_tabela, resto)]
				}
}
pub fn append_time_tabela_examples() {
				check.eq(append_time_tabela(TimeTabela(Time("Palmeiras"), 0, 0, 0), []), [TimeTabela(Time("Palmeiras"), 0, 0, 0)])
				check.eq(append_time_tabela(TimeTabela(Time("Palmeiras"), 0, 0, 0), [TimeTabela(Time("Santos"), 0, 0, 0)]), [TimeTabela(Time("Santos"), 0, 0, 0), TimeTabela(Time("Palmeiras"), 0, 0, 0)])
}

/// Construir a tabela de classificação inicial a partir de uma lista de times.
/// - Recebe 
///   - `lista_times`, lista de `Time` representando os times participantes do campeonato.
///   - `tabela_classificacao`, lista de `TimeTabela` representando a tabela de classificação.
/// - Retorna 
///   - `Ok(List(TimeTabela))` contendo a tabela de classificação atualizada com todos os times convertidos para o formato `TimeTabela`.
///   - `Error(ListaVazia)` se a lista de times fornecida estiver vazia.
pub fn cria_tabela_classificacao(lista_times: List(Time), tabela_classificacao: List(TimeTabela)) -> Result(List(TimeTabela), Erro) {
				case lista_times {
								[] -> Error(ListaVazia)
								[primeiro] -> Ok(append_time_tabela(cria_time_tabela(primeiro), tabela_classificacao))
								[primeiro, ..resto] -> cria_tabela_classificacao(resto, append_time_tabela(cria_time_tabela(primeiro), tabela_classificacao))
				}
}
pub fn cria_tabela_classificacao_examples() {
				check.eq(cria_tabela_classificacao([Time("Santos")], []), Ok([TimeTabela(Time("Santos"), 0, 0, 0)]))
				check.eq(cria_tabela_classificacao([Time("Santos"), Time("Flamengo")], [TimeTabela(Time("Botafogo"), 0, 0, 0)]), Ok([TimeTabela(Time("Botafogo"), 0, 0, 0), TimeTabela(Time("Santos"), 0, 0, 0), TimeTabela(Time("Flamengo"), 0, 0, 0)]))
}

/// Converter as strings de gols dos times para valores inteiros.
/// - Recebe 
///   - `anfitriao_gols`, String representando os gols do time anfitrião.
///   - `visitante_gols`, String representando os gols do time visitante.
/// - Retona 
///   - `Ok(List(Int))` contendo uma lista com os gols do time anfitrião e do time visitante em formato inteiro.
///   - `Error(ValorInvalidoGols)` se algum dos valores de gols for inválido (menor que 0 ou não for um valor válido).
pub fn converte_gols(anfitriao_gols: String, visitante_gols: String) -> Result(List(Int), Erro) {
				case int.parse(anfitriao_gols), int.parse(visitante_gols) {
								Ok(a_gols), Ok(v_gols) -> case a_gols < -1 || v_gols < -1 {
												True -> Error(ValorInvalidoGols)
												False -> Ok([a_gols, v_gols])
								}
								Error(_), Ok(_) | Ok(_), Error(_) | Error(_), Error(_) -> Error(ValorInvalidoGols)
				}
}
pub fn converte_gols_examples() {
				check.eq(converte_gols("a", "2"), Error(ValorInvalidoGols))
				check.eq(converte_gols("-1", "-3"), Error(ValorInvalidoGols))
				check.eq(converte_gols("0", "2"), Ok([0, 2]))
}

/// Converter uma lista de strings representando os dados de um jogo para um objeto `Jogo`.
/// - Reccebe
///   - `dado_jogo`, lista de strings com os dados do jogo, incluindo os times e os gols de cada um.
/// - Retorna
///   - `Ok(Jogo)` contendo o jogo com os times e os gols convertidos em inteiros.
///   - `Error(ListaVazia)` se a lista de dados for vazia.
///   - `Error(ValorInvalido)` se os dados da lista não forem válidos.
///   - `Error(QuantidadeInvalidaParametros)` se a lista de dados não contiver as informações necessárias.
pub fn to_jogo(dado_jogo: List(String)) -> Result(Jogo, Erro) {
				case dado_jogo {
								[] -> Error(ListaVazia)
								[anfitriao, anfitriao_gols, visitante, visitante_gols] -> {
												case converte_gols(anfitriao_gols, visitante_gols) {
																Ok([a_gols, v_gols]) -> Ok(Jogo(Time(anfitriao), a_gols, Time(visitante), v_gols))
																Ok([]) | Ok([_, _, _, ..]) | Ok([_]) -> Error(QuantidadeInvalidaParametros)
																Error(e) -> Error(e)
												}
								}
								[_, _, _, _, _, ..] | [_, _, _] | [_, _] | [_] -> Error(QuantidadeInvalidaParametros)
								}
}
pub fn to_jogo_examples() {
				check.eq(to_jogo([]), Error(ListaVazia))
				check.eq(to_jogo(["Sao-Paulo", "1", "Atletico-MG", "2"]), Ok(Jogo(Time("Sao-Paulo"), 1, Time("Atletico-MG"), 2)))
				check.eq(to_jogo(["Sao-Paulo", "1", "Atletico-MG"]), Error(QuantidadeInvalidaParametros))
}

/// Adiciona um jogo a uma lista de jogos.
/// - Recebe
///   - `jogo` a ser adicionado.
///   - `lista_jogos`, lista de jogos existente.
/// - Retorna
///   - Lista contendo todos os jogos da lista original, com o jogo fornecido adicionado ao final.
pub fn append_jogo(jogo: Jogo, lista_jogos: List(Jogo)) -> List(Jogo) {
				case lista_jogos {
								[] -> [jogo]
								[primeiro] -> [primeiro, jogo]
								[primeiro, ..resto] -> [primeiro, ..append_jogo(jogo, resto)]
				}
}
pub fn append_jogo_examples() {
				check.eq(append_jogo(Jogo(Time("Sao-Paulo"), 2, Time("Palmeiras"), 3), []), [Jogo(Time("Sao-Paulo"), 2, Time("Palmeiras"), 3)])
				check.eq(append_jogo(Jogo(Time("Sao-Paulo"), 2, Time("Palmeiras"), 3), [Jogo(Time("Vitória"), 1, Time("Flamento"), 2)]), [Jogo(Time("Vitória"), 1, Time("Flamento"), 2), Jogo(Time("Sao-Paulo"), 2, Time("Palmeiras"), 3)])
}

/// Constrói uma lista de jogos a partir de uma lista de dados de jogos.
/// - Recebe
///   - `dados_jogos`, lista de listas de strings, onde cada sublista representa os dados de um jogo.
///   - `lista_jogos`, lista de jogos existente.
/// - Retorna
///   - `Ok(List(Jogo))`, lista de jogos criada a partir dos dados fornecidos.
///   - `Error(ListaVazia)` se lista `dados_jogos` é vazia.
///   - `Error(e)` erro da funcão `to_jogo`
pub fn cria_jogos(dados_jogos: List(List(String)), lista_jogos: List(Jogo)) -> Result(List(Jogo), Erro){
				case dados_jogos {
								[] -> Error(ListaVazia)
								[primeiro] -> case to_jogo(primeiro) {
												Ok(jogo) -> Ok(append_jogo(jogo, lista_jogos))
												Error(e) -> Error(e)
								}
								[primeiro, ..resto] -> case to_jogo(primeiro) {
												Ok(jogo) -> cria_jogos(resto, append_jogo(jogo, lista_jogos))
												Error(e) -> Error(e)
								}
				}
}
pub fn cria_jogos_examples() {
				check.eq(cria_jogos([], []), Error(ListaVazia))
				check.eq(cria_jogos([["Sao-Paulo", "1", "Atletico-MG", "2"]], []), Ok([Jogo(Time("Sao-Paulo"), 1, Time("Atletico-MG"), 2)]))
				check.eq(cria_jogos([["Sao-Paulo", "1", "Atletico-MG", "2"], ["Flamengo", "3", "Palmeiras", "1"]], []), Ok([Jogo(Time("Sao-Paulo"), 1, Time("Atletico-MG"), 2), Jogo(Time("Flamengo"), 3, Time("Palmeiras"), 1)]))
				check.eq(cria_jogos([["Sao-Paulo", "1", "Atletico-MG"], ["Flamengo", "3", "Palmeiras", "1"]], []), Error(QuantidadeInvalidaParametros))
				check.eq(cria_jogos([["Flamengo", "3", "Botafogo", "5"]], [Jogo(Time("Sao-Paulo"), 1, Time("Atletico-MG"), 2)]), Ok([Jogo(Time("Sao-Paulo"), 1, Time("Atletico-MG"), 2), Jogo(Time("Flamengo"), 3, Time("Botafogo"), 5)]))
}

/// Determina o resultado de um jogo com base nos número gols marcados pelos times.
/// - Recebe
///   - `jogo` contendo os times anfitrião e visitante, e seus respectivos gols.
/// - Retorna
///   - Um valor do tipo `ResultadoJogo`:
///   - `Empate(Jogo)`, indica que o jogo terminou empatado.
///   - `Vitoria(Time vencedor, Int gols_vencedor, Time perdedor, Int gols_perdedor)`, indica qual time venceu e os placares.
pub fn define_resultado_jogo(jogo: Jogo) -> ResultadoJogo {
				case jogo.anfitriao_gols == jogo.visitante_gols {
								True -> Empate(jogo)
								False -> case jogo.anfitriao_gols > jogo.visitante_gols {
												True -> Vitoria(jogo.anfitriao, jogo.anfitriao_gols, jogo.visitante, jogo.visitante_gols)
												False -> Vitoria(jogo.visitante, jogo.visitante_gols, jogo.anfitriao, jogo.anfitriao_gols)
								}
				}
}
pub fn define_resultado_jogo_examples() {
				check.eq(define_resultado_jogo(Jogo(Time("Flamengo"), 2, Time("Palmeiras"), 2)), Empate(Jogo(Time("Flamengo"), 2, Time("Palmeiras"), 2)))
				check.eq(define_resultado_jogo(Jogo(Time("Sao-Paulo"), 3, Time("Atletico-MG"), 1)), Vitoria(Time("Sao-Paulo"), 3, Time("Atletico-MG"), 1))
				check.eq(define_resultado_jogo(Jogo(Time("Cruzeiro"), 1, Time("Gremio"), 2)), Vitoria(Time("Gremio"), 2, Time("Cruzeiro"), 1))
}

/// Adiciona um resultado de jogo a uma lista de resultados.
/// - Recebe
///   - `resultado_jogo`, resultado de um jogo a ser adicionado.
///   - `lista_resultados`, lista de resultados existente.
/// - Retorna
///   - Uma nova lista contendo todos os resultados anteriores mais o novo resultado no final.
pub fn append_resultado_jogo(resultado_jogo: ResultadoJogo, lista_resultados: List(ResultadoJogo)) -> List(ResultadoJogo) {
				case lista_resultados {
								[] -> [resultado_jogo]
								[primeiro] -> [primeiro, resultado_jogo]
								[primeiro, ..resto] -> [primeiro, ..append_resultado_jogo(resultado_jogo, resto)]
				}
}
pub fn append_resultado_jogo_examples() {
				check.eq(append_resultado_jogo(Vitoria(Time("Atletico-MG"), 2, Time("Sao-Paulo"), 1), []), [Vitoria(Time("Atletico-MG"), 2, Time("Sao-Paulo"), 1)])
				
				check.eq(append_resultado_jogo(Empate(Jogo(Time("Flamengo"), 3, Time("Palmeiras"), 3)), [Vitoria(Time("Atletico-MG"), 2, Time("Sao-Paulo"), 1)]),
				[Vitoria(Time("Atletico-MG"), 2, Time("Sao-Paulo"), 1),Empate(Jogo(Time("Flamengo"), 3, Time("Palmeiras"), 3))])
				
				check.eq(append_resultado_jogo( Vitoria(Time("Bahia"), 3, Time("Fortaleza"), 0), [Vitoria(Time("Atletico-MG"), 2, Time("Sao-Paulo"), 1), Empate(Jogo(Time("Flamengo"), 3, Time("Palmeiras"), 3))]),
				[Vitoria(Time("Atletico-MG"), 2, Time("Sao-Paulo"), 1), Empate(Jogo(Time("Flamengo"), 3, Time("Palmeiras"), 3)), Vitoria(Time("Bahia"), 3, Time("Fortaleza"), 0)])
}

/// Define os resultados dos jogos a partir de uma lista de jogos.
/// - Recebe
///   - `lista_jogos` contendo os jogos a serem processados.
///   - `lista_resultados` para armazenar os resultados dos jogos.
/// - Retorna
///   - `Ok(List(ResultadoJogo))`, lista de resultados de jogos atualizada.
///   - `Error(ListaVazia)` se a lista de jogos estiver vazia.
pub fn cria_resultado_jogos(lista_jogos: List(Jogo), lista_resultados: List(ResultadoJogo)) -> Result(List(ResultadoJogo), Erro) {
				case lista_jogos {
								[] -> Error(ListaVazia)
								[primeiro] -> Ok(append_resultado_jogo(define_resultado_jogo(primeiro), lista_resultados))
								[primeiro, ..resto] -> case cria_resultado_jogos(resto, append_resultado_jogo(define_resultado_jogo(primeiro), lista_resultados)) {
												Ok(lista) -> Ok(lista)
												Error(e) -> Error(e)
								}
				}	
}
pub fn cria_resultado_jogos_examples() {
				check.eq(cria_resultado_jogos([], []), Error(ListaVazia))
				check.eq(cria_resultado_jogos([Jogo(Time("Sao-Paulo"), 1, Time("Atletico-MG"), 2)], []), Ok([Vitoria(Time("Atletico-MG"), 2, Time("Sao-Paulo"), 1)]))
				check.eq(cria_resultado_jogos([Jogo(Time("Sao-Paulo"), 1, Time("Atletico-MG"), 2), Jogo(Time("Flamengo"), 3, Time("Palmeiras"), 3)], []), Ok([Vitoria(Time("Atletico-MG"), 2, Time("Sao-Paulo"), 1), Empate(Jogo(Time("Flamengo"), 3, Time("Palmeiras"), 3))]))
				check.eq(cria_resultado_jogos([Jogo(Time("Flamengo"), 3, Time("Palmeiras"), 3)], [Vitoria(Time("Atletico-MG"), 2, Time("Sao-Paulo"), 1)]), Ok([Vitoria(Time("Atletico-MG"), 2, Time("Sao-Paulo"), 1), Empate(Jogo(Time("Flamengo"), 3, Time("Palmeiras"), 3))]))
}

/// Calcula os resultados parciais para os times de um jogo com base no resultado final.
/// - Recebe
///   - `resultado_jogo`, resultado de um jogo (`Vitoria` ou `Empate`).
/// - Retorna
///   - Uma lista com dois elementos, representando os resultados parciais dos dois times envolvidos no jogo.
pub fn calcula_resultado_parcial(resultado_jogo: ResultadoJogo) -> List(ResultadoParcial) {
				case resultado_jogo {
								Vitoria(time_vencedor, vencedor_gols, time_perdedor, perdedor_gols) -> [
												ResultadoParcial(time_vencedor, vencedor_gols - perdedor_gols, VitoriaParcial),
												ResultadoParcial(time_perdedor, perdedor_gols - vencedor_gols, DerrotaParcial)]
								Empate(jogo) -> [
												ResultadoParcial(jogo.anfitriao, jogo.anfitriao_gols, EmpateParcial),
												ResultadoParcial(jogo.visitante, jogo.visitante_gols, EmpateParcial)]
				}
}
pub fn calcula_resultado_parcial_examples() {
				check.eq(calcula_resultado_parcial(Vitoria(Time("Bahia"), 3, Time("Fortaleza"), 0)), 
				[ResultadoParcial(Time("Bahia"), 3, VitoriaParcial), ResultadoParcial(Time("Fortaleza"), -3, DerrotaParcial)])

				check.eq(calcula_resultado_parcial(Empate(Jogo(Time("Bahia"), 0, Time("Fortaleza"), 0))), 
				[ResultadoParcial(Time("Bahia"), 0, EmpateParcial), ResultadoParcial(Time("Fortaleza"), 0, EmpateParcial)])
}

/// Adiciona os elementos de uma lista de resultados parciais a uma lista existente de resultados parciais.
/// - Recebe
///   - `resultado_parcial`, lista de resultados parciais a serem adicionados.
///   - `lista_resultados_parcial`, lista existente de resultados parciais.
/// - Retorna
///   - Uma nova lista contendo todos os elementos da lista existente mais os novos resultados parciais no final.
pub fn append_resultado_parcial(resultado_parcial: List(ResultadoParcial), lista_resultados_parcial: List(ResultadoParcial)) -> List(ResultadoParcial) {
				case lista_resultados_parcial {
								[] -> resultado_parcial
								[primeiro] -> [primeiro, ..resultado_parcial]
								[primeiro, ..resto] -> [primeiro, ..append_resultado_parcial(resultado_parcial, resto)] 
				}
}
pub fn append_resultado_parcial_examples() {
		check.eq(append_resultado_parcial([ResultadoParcial(Time("Palmeiras"), -1, DerrotaParcial), ResultadoParcial(Time("Sao-Paulo"), 2, VitoriaParcial)], []),
		[ResultadoParcial(Time("Palmeiras"), -1, DerrotaParcial), ResultadoParcial(Time("Sao-Paulo"), 2, VitoriaParcial)])

  check.eq(
    append_resultado_parcial(
      [ResultadoParcial(Time("Flamengo"), 3, VitoriaParcial), ResultadoParcial(Time("Atletico-MG"), 1, EmpateParcial)],
      [ResultadoParcial(Time("Sao-Paulo"), 2, VitoriaParcial)]
    ),
    [
      ResultadoParcial(time: Time("Sao-Paulo"), saldo_gols_parcial: 2, resultado: VitoriaParcial),
      ResultadoParcial(time: Time("Flamengo"), saldo_gols_parcial: 3, resultado: VitoriaParcial),
      ResultadoParcial(time: Time("Atletico-MG"), saldo_gols_parcial: 1, resultado: EmpateParcial)]
  )
}

/// Converte uma lista de resultados de jogos em uma lista de resultados parciais.
/// - Recebe
///   - `lista_resultados`: Uma lista de `ResultadoJogo`, contendo os resultados completos de jogos.
///   - `lista_resultados_parcial`: Uma lista acumuladora de `ResultadoParcial`, que inicialmente pode estar vazia.
/// - Retorna:
///   - `Ok(List(ResultadoParcial))` contendo a lista completa de resultados parciais gerada a partir da lista de resultados de jogos.
///   - `Error(ListaVazia)` se a lista de resultados de jogos (`lista_resultados`) estiver vazia.
pub fn cria_lista_resultados_parcial(lista_resultados: List(ResultadoJogo), lista_resultados_parcial: List(ResultadoParcial)) -> Result(List(ResultadoParcial), Erro) {
				case lista_resultados {
								[] -> Error(ListaVazia)
								[primeiro] -> Ok(append_resultado_parcial(calcula_resultado_parcial(primeiro), lista_resultados_parcial))
								[primeiro, ..resto] -> cria_lista_resultados_parcial(resto, append_resultado_parcial(calcula_resultado_parcial(primeiro), lista_resultados_parcial))
				}
}

pub fn cria_lista_resultados_parcial_examples() {
				check.eq(cria_lista_resultados_parcial([], []), Error(ListaVazia))
				
				check.eq(cria_lista_resultados_parcial([Vitoria(Time("Bahia"), 3, Time("Fortaleza"), 0)], []), 
				Ok([ResultadoParcial(Time("Bahia"), 3, VitoriaParcial), ResultadoParcial(Time("Fortaleza"), -3, DerrotaParcial)]))

				check.eq(cria_lista_resultados_parcial([Empate(Jogo(Time("Sao-Paulo"), 1, Time("Palmeiras"), 1))], []),
				Ok([ResultadoParcial(Time("Sao-Paulo"), 1, EmpateParcial), ResultadoParcial(Time("Palmeiras"), 1, EmpateParcial)]))

				check.eq(cria_lista_resultados_parcial([Vitoria(Time("Flamengo"), 4, Time("Corinthians"), 2), Empate(Jogo(Time("Atletico-MG"), 3, Time("Cruzeiro"), 3))], []),
				Ok([ResultadoParcial(Time("Flamengo"), 2, VitoriaParcial), ResultadoParcial(Time("Corinthians"), -2, DerrotaParcial), ResultadoParcial(Time("Atletico-MG"), 3, EmpateParcial), ResultadoParcial(Time("Cruzeiro"), 3, EmpateParcial)]))

				check.eq(cria_lista_resultados_parcial([Empate(Jogo(Time("Atletico-MG"), 3, Time("Cruzeiro"), 3))],[ResultadoParcial(Time("Flamengo"), 2, VitoriaParcial), ResultadoParcial(Time("Corinthians"), -2, DerrotaParcial)]),
				Ok([ResultadoParcial(Time("Flamengo"), 2, VitoriaParcial), ResultadoParcial(Time("Corinthians"), -2, DerrotaParcial), ResultadoParcial(Time("Atletico-MG"), 3, EmpateParcial), ResultadoParcial(Time("Cruzeiro"), 3, EmpateParcial)]))
}

/// Procura um time específico na tabela de classificação.
/// - Recebe
///   - Um time (`time`) que se deseja buscar.
///   - Uma lista de entradas da tabela de classificação (`tabela`), onde cada entrada é um `TimeTabela`.
/// - Retorna:
///   - `Ok(TimeTabela)` contendo a entrada correspondente ao time, caso ele seja encontrado na tabela.
///   - `Error(ListaVazia)` se a tabela estiver vazia.
///   - `Error(TimeNaoEncontrado)` se o time não for encontrado na tabela.
pub fn busca_na_tabela(time: Time, tabela: List(TimeTabela)) -> Result(TimeTabela, Erro) {
				case tabela {
								[] -> Error(ListaVazia)
								[primeiro] -> case time == primeiro.time {
												True -> Ok(primeiro)
												False -> Error(TimeNaoEncontrado)
								}
								[primeiro, ..resto] -> case time == primeiro.time {
												True -> Ok(primeiro)
												False -> busca_na_tabela(time, resto)
								}
				}
}
pub fn busca_na_tabela_examples() {
				check.eq(busca_na_tabela(Time("Palmeiras"), []), Error(ListaVazia))

				check.eq(busca_na_tabela(Time("Palmeiras"), [TimeTabela(Time("Flamengo"), 6, 2, 4)]), Error(TimeNaoEncontrado))
				
				check.eq(busca_na_tabela(Time("Palmeiras"), [TimeTabela(Time("Flamengo"), 6, 2, 4), TimeTabela(Time("Palmeiras"), 10, 3, 7)]), Ok(TimeTabela(Time("Palmeiras"), 10, 3, 7)))

				check.eq(busca_na_tabela(Time("Flamengo"), [TimeTabela(Time("Flamengo"), 6, 2, 4), TimeTabela(Time("Palmeiras"), 10, 3, 7)] ), Ok(TimeTabela(Time("Flamengo"), 6, 2, 4)))
}


/// Atualiza as informações de um time na tabela de classificação com base no resultado parcial de um jogo.
/// - Recebe
///   - `time_tabela`, time na tabela de classificação contendo pontos, vitórias e saldo de gols.
///   - `resultado_parcial`, um resultado parcial indicando o saldo de gols e o resultado (`VitoriaParcial`, `EmpateParcial` ou `DerrotaParcial`) do time.
/// - Retorna
///   - `Ok(TimeTabela)` com as informações atualizadas do time, caso o time no resultado parcial corresponda ao time na tabela.
///   - `Error(TimesIncompativeis)` se o time do resultado parcial não corresponder ao time da tabela.
pub fn atualiza_info_time(time_tabela: TimeTabela, resultado_parcial: ResultadoParcial) -> Result(TimeTabela, Erro) {
				case time_tabela.time == resultado_parcial.time {
								True -> case resultado_parcial.resultado {
												VitoriaParcial -> 
																Ok(TimeTabela(..time_tabela, numero_pontos: time_tabela.numero_pontos + 3, numero_vitorias: time_tabela.numero_vitorias + 1,  saldo_gols: time_tabela.saldo_gols + resultado_parcial.saldo_gols_parcial))
												EmpateParcial -> 
																Ok(TimeTabela(..time_tabela, numero_pontos: time_tabela.numero_pontos + 1))
												DerrotaParcial -> 
																Ok(TimeTabela(..time_tabela, saldo_gols: time_tabela.saldo_gols + resultado_parcial.saldo_gols_parcial))
								}
								False -> Error(TimesIncompativeis)
				}
}
pub fn atualiza_info_time_examples() {
				check.eq(atualiza_info_time(TimeTabela(Time("Palmeiras"), 10, 3, 5), ResultadoParcial(Time("Palmeiras"), 2, VitoriaParcial)), Ok(TimeTabela(Time("Palmeiras"), 13, 4, 7))) 
				check.eq(atualiza_info_time(TimeTabela(Time("Flamengo"), 6, 2, 4), ResultadoParcial(Time("Flamengo"), 1, EmpateParcial)), Ok(TimeTabela(Time("Flamengo"), 7, 2, 4)))

				check.eq(atualiza_info_time(TimeTabela(Time("São Paulo"), 8, 2, 3), ResultadoParcial(Time("São Paulo"), -2, DerrotaParcial)), Ok(TimeTabela(Time("São Paulo"), 8, 2, 1)))

				check.eq(atualiza_info_time(TimeTabela(Time("Corinthians"), 5, 1, -1), ResultadoParcial(Time("Palmeiras"), 2, VitoriaParcial)), Error(TimesIncompativeis))
}

/// Atualiza a tabela de classificação substituindo as informações de um time específico.
/// - Recebe
///   - `time_tabela`: As novas informações do time a serem atualizadas na tabela.
///   - `tabela`: Uma lista de `TimeTabela` representando a tabela de classificação atual.
/// - Retorna:
///   - `Ok(List(TimeTabela))` com a tabela atualizada, onde as informações do time foram substituídas por `time_tabela`, caso o time seja encontrado.
///   - `Error(ListaVazia)` se a tabela estiver vazia.
///   - `Error(TimeNaoEncontrado)` se o time não for encontrado na tabela.
pub fn atualiza_time_tabela(time_tabela: TimeTabela, tabela: List(TimeTabela)) -> Result(List(TimeTabela), Erro) {
				case tabela {
								[] -> Error(ListaVazia)
								[primeiro] -> case primeiro.time == time_tabela.time {
												True -> Ok([time_tabela])
												False -> Error(TimeNaoEncontrado)
								}
								[primeiro, ..resto] -> case primeiro.time == time_tabela.time {
												True -> Ok([time_tabela, ..resto])
												False -> case atualiza_time_tabela(time_tabela, resto) {
																Ok(info) -> Ok([primeiro, ..info])
																Error(e) -> Error(e)
												}
								}
				}
}
pub fn atualiza_time_tabela_examples() {
				check.eq(atualiza_time_tabela(TimeTabela(Time("Palmeiras"), 13, 4, 7), []), Error(ListaVazia))

				check.eq(atualiza_time_tabela(TimeTabela(Time("Palmeiras"), 13, 4, 7), [TimeTabela(Time("Flamengo"), 6, 2, 4)]), Error(TimeNaoEncontrado))

				check.eq(atualiza_time_tabela(TimeTabela(Time("Palmeiras"), 13, 4, 7), [TimeTabela(Time("Flamengo"), 6, 2, 4), TimeTabela(Time("Palmeiras"), 10, 3, 5)]),
				Ok([TimeTabela(Time("Flamengo"), 6, 2, 4), TimeTabela(Time("Palmeiras"), 13, 4, 7)]))

				check.eq(atualiza_time_tabela(TimeTabela(Time("Flamengo"), 7, 2, 5), [TimeTabela(Time("Flamengo"), 6, 2, 4), TimeTabela(Time("Palmeiras"), 10, 3, 5)]),
				Ok([TimeTabela(Time("Flamengo"), 7, 2, 5), TimeTabela(Time("Palmeiras"), 10, 3, 5)]))
}

/// Atualiza a tabela de classificação com base nos resultados parciais dos jogos.
/// - Recebe
///   - `tabela_classificacao`: A lista existente representando a tabela de classificação.
///   - `lista_resultados_parcial`: Lista contendo os resultados parciais a serem aplicados à tabela.
/// - Retorna
///   - `Ok` com a tabela de classificação atualizada.
///   - `Error(ListaVazia)` se a lista de resultados parciais estiver vazia.
///   - Propaga os erros retornados pelas funções internas (`busca_na_tabela`, `atualiza_info_time`, `atualiza_time_tabela`).
pub fn atualiza_tabela_classificacao(tabela_classificacao: List(TimeTabela), lista_resultados_parcial: List(ResultadoParcial)) -> Result(List(TimeTabela), Erro) {
 				case lista_resultados_parcial {
								[] -> Error(ListaVazia)
								[primeiro] -> case busca_na_tabela(primeiro.time, tabela_classificacao) {
												Ok(time_tabela) -> case atualiza_info_time(time_tabela, primeiro) {
																Ok(time_tabela_atualizado) -> case atualiza_time_tabela(time_tabela_atualizado, tabela_classificacao) {
																				Ok(tabela_atualizada) -> Ok(tabela_atualizada)
																				Error(e) -> Error(e)
																}
																Error(e) -> Error(e)
												}
												Error(e) -> Error(e)
								}
								[primeiro, ..resto] -> case busca_na_tabela(primeiro.time, tabela_classificacao) {
												Ok(time_tabela) -> case atualiza_info_time(time_tabela, primeiro) {
																Ok(time_tabela_atualizado) -> case atualiza_time_tabela(time_tabela_atualizado, tabela_classificacao) {
																				Ok(tabela_atualizada) -> case atualiza_tabela_classificacao(tabela_atualizada, resto) {
																								Ok(info) -> Ok(info)
																								Error(e) -> Error(e)
																				}
																				Error(e) -> Error(e)
																}
																Error(e) -> Error(e)
												}
												Error(e) -> Error(e)
								}
 				}
}
pub fn atualiza_tabela_classificacao_examples() {
				check.eq(atualiza_tabela_classificacao([TimeTabela(Time("Palmeiras"), 10, 3, 5), TimeTabela(Time("Flamengo"), 6, 2, 4)], []), Error(ListaVazia))

				check.eq(atualiza_tabela_classificacao([TimeTabela(Time("Palmeiras"), 10, 3, 5), TimeTabela(Time("Flamengo"), 6, 2, 4)], [ResultadoParcial(Time("Palmeiras"), 2, VitoriaParcial)]),
				Ok([TimeTabela(Time("Palmeiras"), 13, 4, 7), TimeTabela(Time("Flamengo"), 6, 2, 4)]))

				check.eq(atualiza_tabela_classificacao([TimeTabela(Time("Palmeiras"), 10, 3, 5), TimeTabela(Time("Flamengo"), 6, 2, 4)], [ResultadoParcial(Time("Palmeiras"), 2, VitoriaParcial), ResultadoParcial(Time("Flamengo"), 1, EmpateParcial)]),
				Ok([TimeTabela(Time("Palmeiras"), 13, 4, 7), TimeTabela(Time("Flamengo"), 7, 2, 4)]))

				check.eq(atualiza_tabela_classificacao([TimeTabela(Time("Palmeiras"), 10, 3, 5), TimeTabela(Time("Flamengo"), 6, 2, 4)], [ResultadoParcial(Time("Sao-Paulo"), 2, VitoriaParcial)]), 
				Error(TimeNaoEncontrado))
}

/// Ordena dois times na tabela de classificação em ordem alfabética pelo nome do time.
/// - Recebe
///   - `t1`: O primeiro time na tabela.
///   - `t2`: O segundo time na tabela.
/// - Retorna
///   - Uma lista contendo os dois times ordenados em ordem alfabética.
pub fn ordena_ordem_alfabetica(t1: TimeTabela, t2: TimeTabela) -> List(TimeTabela) {
	case string.compare(t1.time.nome, t2.time.nome) {
		order.Lt -> [t1 , t2]
		order.Eq -> [t1, t2] 
		order.Gt -> [t2, t1]
	}
}
pub fn ordena_ordem_alfabetica_examples() {
  check.eq(
    ordena_ordem_alfabetica(
      TimeTabela(Time("Palmeiras"), 10, 3, 5),
      TimeTabela(Time("Flamengo"), 8, 2, 4)
    ),
    [TimeTabela(Time("Flamengo"), 8, 2, 4), TimeTabela(Time("Palmeiras"), 10, 3, 5)]
  )

  check.eq(
    ordena_ordem_alfabetica(
      TimeTabela(Time("São Paulo"), 12, 4, 8),
      TimeTabela(Time("Santos"), 11, 3, 6)
    ),
    [TimeTabela(Time("Santos"), 11, 3, 6), TimeTabela(Time("São Paulo"), 12, 4, 8)]
  )

  check.eq(
    ordena_ordem_alfabetica(
      TimeTabela(Time("Atlético-MG"), 15, 5, 10),
      TimeTabela(Time("Atlético-MG"), 12, 4, 7)
    ),
    [TimeTabela(Time("Atlético-MG"), 15, 5, 10), TimeTabela(Time("Atlético-MG"), 12, 4, 7)]
  )
}

/// Ordena dois times na tabela de classificação em ordem decresente pelo numero de gols.
/// - Recebe
///   - `t1`: O primeiro time na tabela.
///   - `t2`: O segundo time na tabela.
/// - Retorna
///   - Uma lista contendo os dois times ordenados em ordem decresente pelo número de gols.
/// Se os dois times `t1` e `t2` tiverem o mesmo número de gols, chama `ordena_ordem_alfabetica`
pub fn ordena_numero_gols(t1: TimeTabela, t2: TimeTabela) -> List(TimeTabela) {
	case t1.saldo_gols > t2.saldo_gols {
		True -> [t1, t2]
		False -> case t1.saldo_gols < t2.saldo_gols {
			True -> [t2, t1]
			False -> ordena_ordem_alfabetica(t1, t2)
		}
	}
}
pub fn ordena_numero_gols_examples() {
  check.eq(
    ordena_numero_gols(
      TimeTabela(Time("Palmeiras"), 10, 3, 5),
      TimeTabela(Time("Flamengo"), 8, 2, 4)
    ),
    [TimeTabela(Time("Palmeiras"), 10, 3, 5), TimeTabela(Time("Flamengo"), 8, 2, 4)]
  )

  check.eq(
    ordena_numero_gols(
      TimeTabela(Time("São Paulo"), 12, 4, 6),
      TimeTabela(Time("Santos"), 11, 3, 8)
    ),
    [TimeTabela(Time("Santos"), 11, 3, 8), TimeTabela(Time("São Paulo"), 12, 4, 6)]
  )

}

/// Ordena dois times na tabela de classificação em ordem decresente pelo numero de vitótias.
/// - Recebe
///   - `t1`: O primeiro time na tabela.
///   - `t2`: O segundo time na tabela.
/// - Retorna
///   - Uma lista contendo os dois times ordenados em ordem decresente pelo número de vitórias.
/// Se os dois times `t1` e `t2` tiverem o mesmo número de vitórias, chama `ordena_numero_gols`
pub fn ordena_numero_vitorias(t1: TimeTabela, t2: TimeTabela) -> List(TimeTabela) {
	case t1.numero_vitorias > t2.numero_vitorias {
		True -> [t1, t2]
		False -> case t1.numero_vitorias < t2.numero_vitorias {
			True -> [t2, t1]
			False -> ordena_numero_gols(t1, t2)
		}
	}
}
pub fn ordena_numero_vitorias_examples() {
  check.eq(
    ordena_numero_vitorias(
      TimeTabela(Time("Palmeiras"), 10, 6, 5),
      TimeTabela(Time("Flamengo"), 8, 5, 4)
    ),
    [TimeTabela(Time("Palmeiras"), 10, 6, 5), TimeTabela(Time("Flamengo"), 8, 5, 4)]
  )

  check.eq(
    ordena_numero_vitorias(
      TimeTabela(Time("São Paulo"), 12, 4, 6),
      TimeTabela(Time("Santos"), 11, 5, 8)
    ),
    [TimeTabela(Time("Santos"), 11, 5, 8), TimeTabela(Time("São Paulo"), 12, 4, 6)]
  )

  check.eq(
    ordena_numero_vitorias(
      TimeTabela(Time("Atlético-MG"), 15, 5, 10),
      TimeTabela(Time("Atlético-MG"), 12, 5, 8)
    ),
    [TimeTabela(Time("Atlético-MG"), 15, 5, 10), TimeTabela(Time("Atlético-MG"), 12, 5, 8)]
  )
}

/// Insere um time ordenado em uma tabela de classificação, levando em consideração o número de pontos, número de vitórias e, em caso de empate, a ordem alfabética dos times.
/// - Recebe
///   - `time_tabela`, time a ser inserido na tabela.
///   - `tabela`, lista de times da tabela de classificação.
/// - Retorna
///   - Tabela com o time inserido na posição correta conforme as regras de ordenação.
pub fn insere_ordenado(time_tabela: TimeTabela, tabela: List(TimeTabela)) -> List(TimeTabela) {
  case tabela {
    [] -> [time_tabela]
    [primeiro, ..resto] -> case primeiro.numero_pontos > time_tabela.numero_pontos {
		True -> [primeiro, ..insere_ordenado(time_tabela, resto)]
		False -> case primeiro.numero_pontos < time_tabela.numero_pontos {
			True -> [time_tabela, ..insere_ordenado(primeiro, resto)]
			False -> case ordena_numero_vitorias(primeiro, time_tabela) {
				[a, b] -> [a, ..insere_ordenado(b, resto)]
				[] | [_, _, _, ..] | [_] -> []
			} 
		}
	}
	
	}
}

pub fn insere_ordenado_examples() {
  check.eq(
    insere_ordenado(
      TimeTabela(Time("Palmeiras"), 13, 4, 7),
      []
    ),
    [TimeTabela(Time("Palmeiras"), 13, 4, 7)]
  )

  check.eq(
    insere_ordenado(
      TimeTabela(Time("Palmeiras"), 15, 4, 7),
      [
        TimeTabela(Time("Flamengo"), 15, 5, 8),
        TimeTabela(Time("Sao-Paulo"), 10, 3, 5)
      ]
    ),
    [
      TimeTabela(Time("Flamengo"), 15, 5, 8),
      TimeTabela(Time("Palmeiras"), 15, 4, 7),
      TimeTabela(Time("Sao-Paulo"), 10, 3, 5)
    ]
  )

  check.eq(
    insere_ordenado(
      TimeTabela(Time("Flamengo"), 15, 5, 8),
      [
        TimeTabela(Time("Palmeiras"), 13, 4, 7),
        TimeTabela(Time("Sao-Paulo"), 10, 3, 5)
      ]
    ),
    [
      TimeTabela(Time("Flamengo"), 15, 5, 8),
      TimeTabela(Time("Palmeiras"), 13, 4, 7),
      TimeTabela(Time("Sao-Paulo"), 10, 3, 5)
    ]
  )

  check.eq(
    insere_ordenado(
      TimeTabela(Time("Sao-Paulo"), 10, 3, 5),
      [
        TimeTabela(Time("Flamengo"), 15, 5, 8),
        TimeTabela(Time("Palmeiras"), 13, 4, 7)
      ]
    ),
    [
      TimeTabela(Time("Flamengo"), 15, 5, 8),
      TimeTabela(Time("Palmeiras"), 13, 4, 7),
      TimeTabela(Time("Sao-Paulo"), 10, 3, 5)
    ]
  )
}

/// Ordena `tabela_classificacao` com base nas regras estabelecidas.
/// 1. Primeiro, os times são ordenados pelo número de pontos (de forma decrescente).
/// 2. Em caso de empate no número de pontos, os times são ordenados pelo número de vitórias (também de forma decrescente).
/// 3. Se o número de pontos e vitórias for o mesmo, os times são ordenados alfabeticamente.
/// - Recebe 
///   - `tabela_classificacao` a ser ordena.
/// - Retorna
///   - `tabela_classificacao` ordena.
pub fn ordena_tabela_classificacao(tabela_classificacao: List(TimeTabela)) -> List(TimeTabela) {
				case tabela_classificacao {
								[] -> []
								[primeiro, ..resto] -> insere_ordenado(primeiro, ordena_tabela_classificacao(resto))
				}
}
pub fn ordena_tabela_classificacao_examples() {
	check.eq(
  ordena_tabela_classificacao([
    TimeTabela(Time("Palmeiras"), 12, 4, 7),
    TimeTabela(Time("Flamengo"), 9, 3, 5),
    TimeTabela(Time("São Paulo"), 10, 3, 6)
  ]),
  [
    TimeTabela(Time("Palmeiras"), 12, 4, 7),
    TimeTabela(Time("São Paulo"), 10, 3, 6),
    TimeTabela(Time("Flamengo"), 9, 3, 5)
  ]
)

check.eq(
  ordena_tabela_classificacao([
    TimeTabela(Time("Fluminense"), 15, 5, 8),
    TimeTabela(Time("Atlético-MG"), 12, 4, 8),
    TimeTabela(Time("Vasco"), 9, 3, 6),
    TimeTabela(Time("Botafogo"), 9, 4, 3)
  ]),
  [
    TimeTabela(Time("Fluminense"), 15, 5, 8),
    TimeTabela(Time("Atlético-MG"), 12, 4, 8),
    TimeTabela(Time("Botafogo"), 9, 4, 3),
    TimeTabela(Time("Vasco"), 9, 3, 6)
  ]
)

check.eq(
  ordena_tabela_classificacao([
    TimeTabela(Time("Grêmio"), 10, 3, 5),
    TimeTabela(Time("Internacional"), 10, 3, 6),
    TimeTabela(Time("Cruzeiro"), 10, 2, 7)
  ]),
  [
    TimeTabela(Time("Internacional"), 10, 3, 6),
    TimeTabela(Time("Grêmio"), 10, 3, 5),
    TimeTabela(Time("Cruzeiro"), 10, 2, 7)
  ]
)

check.eq(
  ordena_tabela_classificacao([
    TimeTabela(Time("Corinthians"), 8, 2, 4),
    TimeTabela(Time("Santos"), 8, 2, 4),
    TimeTabela(Time("Bahia"), 8, 2, 4)
  ]),
  [
    TimeTabela(Time("Bahia"), 8, 2, 4),
    TimeTabela(Time("Corinthians"), 8, 2, 4),
    TimeTabela(Time("Santos"), 8, 2, 4)
  ]
)

check.eq(
  ordena_tabela_classificacao([]),
  []
)

}

/// Converte um `TimeTabela` em uma string representando as informações do time na tabela de classificação.
/// - Recebe
///   - `time_tabela`, representação das informações de classificação de um time.
/// - Retorna
///   - String que representa o `time_tabela` no formato de string.
pub fn time_tabela_to_string(time_tabela: TimeTabela) -> String {
	time_tabela.time.nome <> " " <> int.to_string(time_tabela.numero_pontos) <> " " <> int.to_string(time_tabela.numero_vitorias) <> " " <> int.to_string(time_tabela.saldo_gols)
}

/// Converte a `tabela_classificacao` em uma lista de strings onde cada string representa as informações
/// de classificação de um time da `tabela_classificacao`. A ordenação da tabela não é alterada.
/// - Recebe
///   - `tabela_classificacao`, tabela de classificação do campeonato.
/// - Retorna
///   - Lista de strings onde cada string representa as informaçẽso de um time da `tabela_classificacao` 
pub fn tabela_to_string(tabela_classificacao: List(TimeTabela)) -> List(String) {
	case tabela_classificacao {
		[] -> []
		[primeiro] -> [time_tabela_to_string(primeiro)]
		[primeiro, ..resto] -> [time_tabela_to_string(primeiro), ..tabela_to_string(resto)]
	}
}

pub fn tabela_to_string_examples() {
	check.eq(
	tabela_to_string([
    TimeTabela(Time("Palmeiras"), 12, 4, 7),
    TimeTabela(Time("São Paulo"), 10, 3, 6),
	TimeTabela(Time("Flamengo"), 9, 3, 5)
  ]),
  [
    "Palmeiras 12 4 7",
    "São Paulo 10 3 6",
	"Flamengo 9 3 5"
  ]
)
}

/// Cria a classificação final do compeonato
/// - Recebe 
///   - `jogos`, lista de strings que contem as informações dos jogos que ocorreram no campeonato.
/// - Retorna
///   - Ok(List(String)), lista de string contendo as classificação final dos times que participaram do campeonato. 
///   - Error(e), erro propaga pela funções auxiliares.
pub fn main(jogos: List(String)) -> Result(List(String), Erro) {
	
	// Formatar os dados de entrada
	let dados_formatados = case formata_dados(jogos) {
		Ok(dados) -> Ok(dados)
		Error(e) ->  Error(e)
	}
	
	// Coletar os times que participaram do campeonato
	let times = case dados_formatados {
		Ok(dados) -> case coleta_times(dados, []) {
			Ok(lista_times) -> Ok(lista_times)
			Error(e) -> Error(e)
		}
		Error(e) -> Error(e)
	}
	
	// Criar os jogos
	let lista_jogos = case dados_formatados {
		Ok(dados) -> case cria_jogos(dados, []) {
			Ok(jogos) -> Ok(jogos)
			Error(e) -> Error(e)
		}
		Error(e) -> Error(e)
	}

	// Criar a tabela de classificação
	let tabela_classificacao = case times {
		Ok(lista_times) -> case cria_tabela_classificacao(lista_times, []) {
			Ok(tabela) -> Ok(tabela)
			Error(e) -> Error(e)
		}
		Error(e) -> Error(e)
	}
	
	// Cria os resultados dos jogos 
	let resultado_jogo = case lista_jogos {
		Ok(jogos) -> case cria_resultado_jogos(jogos, []) {
			Ok(result_jogos) -> Ok(result_jogos)
			Error(e) -> Error(e) 
		}
		Error(e) -> Error(e)
	}

	// Cria os resultados parciais
	let resultados_parciais = case resultado_jogo {
		Ok(dados) -> case cria_lista_resultados_parcial(dados, []) {
			Ok(lista_resultados_parcial) -> Ok(lista_resultados_parcial)
			Error(e) -> Error(e)
		}
		Error(e) -> Error(e)
	}
	
	// Atualiza a tabela de classificação
	let tabela_atualizada = case tabela_classificacao, resultados_parciais {
		Ok(tabela), Ok(res_par) -> case atualiza_tabela_classificacao(tabela, res_par) {
			Ok(tab_at) -> Ok(tab_at)
			Error(e) -> Error(e)
		} 
		Error(_), Error(e) | Error(e), Error(_) |   Error(e), Ok(_) | Ok(_), Error(e) -> Error(e)
	}

	// Converte a tabela de classificação para uma lista de strings
	case tabela_atualizada {
		Ok(dados) -> Ok(tabela_to_string(ordena_tabela_classificacao(dados)))
		Error(e) -> Error(e)
	}

}

pub fn main_examples() {
 	check.eq(main(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"]), 
 	Ok(["Flamengo 6 2 2", "Atletico-MG 3 1 0", "Palmeiras 1 0 -1", "Sao-Paulo 1 0 -1"]))

	check.eq(main([]), Error(ListaVazia))

	check.eq(main(["Sao-Paulo  Atletico-MG 2", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"]), 
 	Error(ValorInvalido))

	check.eq(main(["Sao-Paulo 1 Atletico-MG b", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"]), 
 	Error(ValorInvalidoGols))

	check.eq(main(["Sao-Paulo 1 Atletico-MG", "2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"]), 
 	Error(QuantidadeInvalidaParametros))
}