import gleam/int
import gleam/list
import gleam/string
import sgleam/check

/// Representação dos erros no programa
pub type Erro {
    // Representa um string vazia
    StringVazia

    // Representa uma lista vazia
    ListaVazia

    // Representa a quantidade errada de paramentos
    QuantidadeErradaParamentros(quantidade_obitidada: Int, quantidade_esperada: Int)

    // Representa a quantidade invalidade de Gols (número de gols negativo)
    QuantidadeInvalidaGols

    // Representa a valor invalido para o numero de gols
    ValorInvalidoParaGols

    // Representa um erro generico
    Generico
}

/// Representa um jogo
pub type Jogo {
    Jogo(anfitriao: String, anfitriao_gols: Int, visitante: String, visitante_gols: Int)
}

/// Representa um time
pub type Time {
    Time(nome: String)
}

/// Representa um time na tabela de classificação
pub type TimeTabela {
    TimeTabela(time: Time, numero_pontos: Int, numero_vitorias: Int, saldo_gols: Int)
}

/// Recebe uma string *dado* e divide esse *dado* nos espaços em branco, gerando uma lista de strings. 
/// Retorna um Result Ok contento a lista de strings. Caso ocorra um erro, retorna um Error especificando
/// o erro.
/// Recebe -> "Sao-Paulo 1 Atletico-MG 2"
/// Retorna -> ["Sao-Paulo", "1", "Atletico-MG", "20"]
pub fn separa_dados(dado: String) -> Result(List(String), Erro) {
    case dado {
      "" | " " -> Error(StringVazia)
      _ -> {
        let lista = string.split(dado, on: " ")
        let tamanho_lista = list.length(lista)

        case tamanho_lista > 4 || tamanho_lista < 4 {
          True -> Error(QuantidadeErradaParamentros(tamanho_lista, 4))
          False ->
            case lista {
              [anfitriao, anfitriao_gols, visitante, visitante_gols] ->
                case anfitriao == "" || anfitriao_gols == "" || visitante == "" || visitante_gols == "" {
                  True -> Error(StringVazia)
                  False -> Ok(lista)
								}
              _ -> Error(Generico)
				    }
				}
     }
   }
}

pub fn separa_dados_examples() {
    check.eq(separa_dados("Sao-Paulo 1 Atletico-MG 2"), Ok(["Sao-Paulo", "1", "Atletico-MG", "2"]))
    check.eq(separa_dados("Flamengo 2 Palmeiras 1"), Ok(["Flamengo", "2", "Palmeiras", "1"]))
    check.eq(separa_dados(""), Error(StringVazia))
    check.eq(separa_dados(" "), Error(StringVazia))
    check.eq(separa_dados("   "), Error(StringVazia))
    check.eq(separa_dados("Fla mengo 2 Palmeiras 1"), Error(QuantidadeErradaParamentros(5, 4)))
}

/// Formata uma *lista_jogos* que contem as informações dos jogos do campeonato
/// e retorna as informações dos jogos
pub fn formatar_dados(lista_jogos: List(String)) -> Result(List(List(String)), Erro) {
    case lista_jogos {
      [] -> Error(ListaVazia)
      [primeiro] -> case separa_dados(primeiro) {
          Ok(info) -> Ok([info])
          Error(e) -> Error(e)
      }
      [primeiro, ..resto] -> case separa_dados(primeiro) {
          Ok(info) -> case formatar_dados(resto) {
              Ok(info_resto) -> Ok([info, ..info_resto])
              Error(e) -> Error(e)
          }
          Error(e) -> Error(e)
      }
   }
}

pub fn formatar_dados_examples() {
  check.eq(formatar_dados(["Sao-Paulo 1 Atletico-MG 2"]), Ok([["Sao-Paulo", "1", "Atletico-MG", "2"]]))
  check.eq(formatar_dados(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1"]), Ok([["Sao-Paulo", "1", "Atletico-MG", "2"], ["Flamengo", "2", "Palmeiras", "1"]]))
}

/// Mapeia um *jogo* para uma estrutura Jogo
pub fn mapear_jogo(jogo: List(String)) -> Result(Jogo, Erro) {
  case jogo {
    [] -> Error(ListaVazia)
    [anfitriao, anfitriao_gols, visitante, visitante_gols] ->
      case int.parse(anfitriao_gols), int.parse(visitante_gols) {
        Ok(gols_anfitriao), Ok(gols_visitante) ->
          case gols_anfitriao < 0 && gols_visitante < 0 {
            True -> Error(ValorInvalidoParaGols)
            False ->
              Ok(Jogo(anfitriao, gols_anfitriao, visitante, gols_visitante))
          }	
        Error(_), Error(_) -> Error(ValorInvalidoParaGols)
        _, _ -> Error(ValorInvalidoParaGols)
      }
    _ -> Error(Generico)
  }
}

pub fn mapear_jogo_examples() {
  check.eq(mapear_jogo(["Sao-Paulo", "1", "Atletico-MG", "2"]), Ok(Jogo("Sao-Paulo", 1, "Atletico-MG", 2)))
  check.eq(mapear_jogo([]), Error(ListaVazia))
  check.eq(mapear_jogo(["Sao-Paulo", "b", "Atletico-MG", "2"]), Error(ValorInvalidoParaGols))
}


/// Recebe uma *lista_jogos* com os resultados das partidas do campeonato, para cada resultado
/// de jogo cria um Jogo com as informações da partida, e retorna uma lista de Jogo
pub fn map_dados_jogo(lista_jogos: List(List(String))) -> Result(List(Jogo), Erro) {
  case lista_jogos {
    [] -> Error(ListaVazia)
    [primeiro] ->
      case mapear_jogo(primeiro) {
        Ok(jogo) -> Ok([jogo])
        Error(e) -> Error(e)
      }
    [primeiro, ..resto] ->
      case mapear_jogo(primeiro) {
        Ok(jogo) ->
          case map_dados_jogo(resto) {
            Ok(info) -> Ok([jogo, ..info])
            Error(e) -> Error(e)
          }
        Error(e) -> Error(e)
      }
  }
}

pub fn map_dados_jogo_examples() {
  check.eq(
    map_dados_jogo([["Sao-Paulo", "1", "Atletico-MG", "2"]]),
    Ok([Jogo("Sao-Paulo", 1, "Atletico-MG", 2)]),
  )
  check.eq(
    map_dados_jogo([
      ["Sao-Paulo", "1", "Atletico-MG", "2"],
      ["Flamengo", "2", "Palmeiras", "1"],
    ]),
    Ok([
      Jogo("Sao-Paulo", 1, "Atletico-MG", 2),
      Jogo("Flamengo", 2, "Palmeiras", 1),
    ]),
  )
}

/// Insere um *Time* no incio de uma lista_times, se o time já estiver na lista não faz nada
pub fn inserir_time(time: Time, lista_times: List(Time)) -> Result(List(Time), Erro) {
  case contem_time(time, lista_times) {
    True -> Ok(lista_times)
    False ->
      case lista_times {
        [] -> Ok([time])
        _ -> Ok([time, ..lista_times])
      }
  }
}

pub fn inserir_time_examples() {
  check.eq(inserir_time(Time("Palmeiras"), []), Ok([Time("Palmeiras")]))
  check.eq(inserir_time(Time("Sao-Paulo"), [Time("Palmeiras")]), Ok([Time("Sao-Paulo"), Time("Palmeiras")]))
}

/// Coletar os times que participaram do compeonato a partir de uma *lista_jogos* e salva em uma *lista_times*
pub fn coletar_times(lista_jogos: List(Jogo), lista_times: List(Time)) -> Result(List(Time), Erro) {
    case lista_jogos {
        [] -> Error(ListaVazia)
				[primeiro] -> case inserir_time(Time(primeiro.anfitriao), lista_times) {
				    Ok(n_lista) -> case inserir_time(Time(primeiro.visitante), n_lista) {
						    Ok(f_lista) -> Ok(f_lista)
								Error(e) -> Error(e)
						}
						Error(e) -> Error(e)
				}
				[primeiro, ..resto] -> case inserir_time(Time(primeiro.anfitriao), lista_times) {
            Ok(n_lista) -> case inserir_time(Time(primeiro.visitante), n_lista) {
                Ok(p_lista) -> coletar_times(resto, p_lista)
								Error(e) -> Error(e)
						}
						Error(e) -> Error(e)
				}
		}
}

pub fn coletar_times_examples() {
    check.eq(coletar_times([Jogo("Sao-Paulo", 1, "Atletico-MG", 2)], []), Ok([Time("Atletico-MG"), Time("Sao-Paulo")]))
    check.eq(coletar_times([Jogo("Sao-Paulo", 1, "Atletico-MG", 2)], [Time("Sao-Paulo")]), Ok([Time("Atletico-MG"), Time("Sao-Paulo")]))
}

/// Verifica se existe um time em uma lista de times
pub fn contem_time(time: Time, lista_times: List(Time)) -> Bool {
  case lista_times {
    [] -> False
    [primeiro] ->
      case primeiro.nome == time.nome {
        True -> True
        False -> False
      }
    [primeiro, ..resto] ->
      case primeiro.nome == time.nome {
        True -> True
        False -> contem_time(time, resto)
      }
  }
}

/// Insere um *time* no inicio da *tabela* de classificacao
pub fn insere_time_tabela(time_tabela: TimeTabela, tabela: List(TimeTabela)) -> Result(List(TimeTabela), Erro) {
    case tabela {
        [] -> Ok([time_tabela])
				[primeiro] -> Ok([time_tabela, primeiro])
				[primeiro, ..resto] -> Ok([time_tabela, primeiro, ..resto]) 
		}
}

pub fn insere_time_tabela_examples() {
    check.eq(insere_time_tabela(TimeTabela(Time("Palmeiras"), 0, 0, 0), []), Ok([TimeTabela(Time("Palmeiras"), 0, 0, 0)]))
}

/// Cria a tabela de classificação do compeonato, inicialmente todos os time tem os valores de 
/// pontos, numero vitorias e numero de gols zerado
pub fn criar_tabela(times: List(Time), tabela: List(TimeTabela)) -> Result(List(TimeTabela), Erro) {
    case times {
        [] -> Error(ListaVazia)
				[primeiro] -> case insere_time_tabela(TimeTabela(primeiro, 0, 0, 0), tabela) {
				    Ok(info) -> Ok(info)
						Error(e) -> Error(e)
				}
				[primeiro, ..resto] -> case insere_time_tabela(TimeTabela(primeiro, 0, 0, 0), tabela) {
				    Ok(info) -> criar_tabela(resto, info)
						Error(e) -> Error(e)
				}
		}
}

pub fn criar_tabela_examples() {
    check.eq(criar_tabela([Time("Palmeiras")], []), Ok([TimeTabela(Time("Palmeiras"), 0, 0, 0)]))
    check.eq(criar_tabela([Time("Palmeiras"), Time("Sao-Paulo")], []), Ok([TimeTabela(Time("Sao-Paulo"), 0, 0, 0), TimeTabela(Time("Palmeiras"), 0, 0, 0)]))
}


/// Represeta o resultado de uma partida entre dois times
pub type ResultadoPartida {
  Vitoria(
    vencedor: String,
    vencedor_gols: Int,
    perdedor: String,
    perdedor_gols: Int,
  )
  Empate(jogo: Jogo)
}

/// Define o resultado de uma *partida*
pub fn resultado_partida(partida: Jogo) -> ResultadoPartida {
  case partida.anfitriao_gols == partida.visitante_gols {
    True -> Empate(partida)
    False ->
      case partida.anfitriao_gols > partida.visitante_gols {
        True ->
          Vitoria(
            partida.anfitriao,
            partida.anfitriao_gols,
            partida.visitante,
            partida.visitante_gols,
          )
        False ->
          Vitoria(
            partida.visitante,
            partida.visitante_gols,
            partida.anfitriao,
            partida.anfitriao_gols,
          )
      }
  }
}

pub fn resultado_partida_examples() {
    check.eq(resultado_partida(Jogo("Sao-Paulo", 1, "Atletico-MG", 2)), Vitoria("Atletico-MG", 2, "Sao-Paulo", 1))
	  check.eq(resultado_partida(Jogo("Sao-Paulo", 1, "Atletico-MG", 1)), Empate(Jogo("Sao-Paulo", 1, "Atletico-MG", 1)))
}

/// Atualiza as informações de um time na tabela de classificação baseado no resultado de uma partida.
//pub fn atualiza_dados(tabela_classficacao: List(TimeTabela), resultado_partida: ResultadoPartida) -> Result(List(TimeTabela), Erro) {todo}
//pub fn atualiza_dados_examples() {check.eq()}
