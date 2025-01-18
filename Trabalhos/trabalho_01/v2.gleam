/// ************************************************************
/// * 4 Semestre do Curso de Ciência da Computação - UEM 2024  *
/// * Primeiro trabalho da disciplica de Programação Funcional *
/// * Discente: Thiago Henrique Calvi ra: 134955               *
/// ************************************************************

// Imports
import gleam/int
import gleam/order
import gleam/string
import sgleam/check

/// Representação dos erros que podem ocorrer no programa
pub type Erro {
  // Representa uma string vazia passada como parametro
  StringVazia

  // Representa uma lista vazia passada como parametro
  ListaVazia

  // Representa quantidade invalida de parametros
  QuantidadeInvalidaParametros

  // Representa um valor invalido para gols
  ValorInvalidoGols

  // Representa um valor invaldo passada como parametro
  ValorInvalido

  // Representa dois times iguais em um mesmo jogo
  TimesIguais
}

/// Representa um time participante do compeonato
pub type Time {
  Time(nome: String)
}

/// Representa um time na tabela de classificação
pub type TimeTabela {
  TimeTabela(
    time: Time,
    numero_pontos: Int,
    numero_vitorias: Int,
    saldo_gols: Int,
  )
}

/// Representa um jogo do campeonato
pub type Jogo {
  Jogo(
    anfitriao: Time,
    anfitriao_gols: Int,
    visitante: Time,
    visitante_gols: Int,
  )
}

/// Representa o resultado de um jogo (confronto entre dois times)
pub type ResultadoJogo {
  // Representa a vitória de um time
  Vitoria(
    time_vencedor: Time,
    vencedor_gols: Int,
    time_perdedor: Time,
    perdedor_gols: Int,
  )

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
  ResultadoParcial(
    time: Time,
    saldo_gols_parcial: Int,
    resultado: ResultadoTime,
  )
}

/// Recebe uma string `dados_jogo` contendo informações de um jogo no formato 
/// "anfitriao anfitriao_gols visitante visitante_gols", separa a string em uma lista de strings 
/// `[anfitriao, anfitriao_gols, visitante, visitante_gols]`.
/// - Se `dados_jogo` for uma string vazia ou contiver apenas espaços, retorna `Error(StringVazia)`.
/// - Se algum dos campos (anfitrião, anfitriao_gols, visitante, visitante_gols) for vazio, 
/// retorna `Error(ValorInvalido)`.
/// - Se a quantidade de parâmetros for diferente de quatro, retorna `Error(QuantidadeInvalidaParametros)`.
/// Caso os dados sejam válidos, retorna `Ok([anfitriao, anfitriao_gols, visitante, visitante_gols])`.
pub fn separa_dados(dados_jogo: String) -> Result(List(String), Erro) {
  case dados_jogo {
    "" | " " -> Error(StringVazia)
    _ -> {
      case string.split(dados_jogo, on: " ") {
        [anfitriao, anfitriao_gols, visitante, visitante_gols] ->
          case
            anfitriao == ""
            || anfitriao_gols == ""
            || visitante == ""
            || visitante_gols == ""
          {
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
  check.eq(separa_dados("Flamengo 2 Palmeiras "), Error(ValorInvalido))
  check.eq(separa_dados("Flamengo 2 Palmeiras 1 3"), Error(QuantidadeInvalidaParametros))
  check.eq(separa_dados("Flamengo Palmeiras 1"), Error(QuantidadeInvalidaParametros))
  check.eq(separa_dados("Sao-Paulo 1 Atletico-MG 2"), Ok(["Sao-Paulo", "1", "Atletico-MG", "2"]))
}

/// Recebe uma lista de strings `lista_jogos`, onde cada string contém informações de um jogo no formato 
/// "anfitriao anfitriao_gols visitante visitante_gols", e retornar uma lista de listas de strings, onde cada sublista 
/// contém os dados formatados `[anfitriao, anfitriao_gols, visitante, visitante_gols]`.
/// - Se `lista_jogos` estiver vazia, retorna `Error(ListaVazia)`.
/// - Se algum elemento em `lista_jogos` não puder ser separado corretamente (de acordo com `separa_dados`), retorna o erro correspondente.
/// - Caso todos os elementos sejam válidos, retorna `Ok` com a lista de dados formatados.
pub fn formata_dados(
  lista_jogos: List(String),
) -> Result(List(List(String)), Erro) {
  case lista_jogos {
    [] -> Error(ListaVazia)
    [primeiro] ->
      case separa_dados(primeiro) {
        Ok(dado_jogo) -> Ok([dado_jogo])
        Error(e) -> Error(e)
      }
    [primeiro, ..resto] ->
      case separa_dados(primeiro) {
        Ok(dado_jogo) ->
          case formata_dados(resto) {
            Ok(info_resto) -> Ok([dado_jogo, ..info_resto])
            Error(e) -> Error(e)
          }
        Error(e) -> Error(e)
      }
  }
}
pub fn formata_dados_examples() {
  check.eq(formata_dados([]), Error(ListaVazia))
  check.eq(formata_dados([""]), Error(StringVazia))
  check.eq(formata_dados(["Palmeiras 3 Sao-Paulo 1 c"]), Error(QuantidadeInvalidaParametros))
  check.eq(formata_dados(["Flamengo 2 Sao-Paulo "]), Error(ValorInvalido))
  check.eq(formata_dados(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0"]),
  Ok([["Sao-Paulo", "1", "Atletico-MG", "2"], ["Flamengo", "2", "Palmeiras", "1"], ["Palmeiras", "0", "Sao-Paulo", "0"]]))
}

/// Recebe uma lista de strings `dado_jogo` contendo informações sobre um jogo no formato `[anfitriao, anfitriao_gols, visitante, visitante_gols]`
/// e retorna uma lista com os dois times `[Time(anfitriao), Time(visitante)]`.
/// - Se anfitriao e visitante forem iguais, retorna `Error(TimesIguais)`
/// - Se `dado_jogo` não contiver exatamente 4 elementos, retorna `Error(QuantidadeInvalidaParametros)`.
/// - Caso contrário, retorna `Ok` com os times extraídos.
pub fn extrai_times(dado_jogo: List(String)) -> Result(List(Time), Erro) {
  case dado_jogo {
    [anfitriao, _, visitante, _] ->
      case anfitriao == visitante {
        True -> Error(TimesIguais)
        False -> Ok([Time(anfitriao), Time(visitante)])
      }
    [..] -> Error(QuantidadeInvalidaParametros)
  }
}
pub fn extrai_time_examples() {
  check.eq(
    extrai_times(["Sao-Paulo", "1", "Sao-Paulo", "2"]),
    Error(TimesIguais),
  )
  check.eq(
    extrai_times(["Sao-Paulo", "1", "Atletico-MG", "2"]),
    Ok([Time("Sao-Paulo"), Time("Atletico-MG")]),
  )
   check.eq(
    extrai_times(["Flamengo", "2", "Palmeiras", "1", "Atletico-MG"]),
    Error(QuantidadeInvalidaParametros),
  )
}

/// Determina se um `time` está presente em uma `lista_times`.
/// - Retorna `True` se o `time.nome` corresponder ao nome de algum time na lista.
/// - Retorna `False` caso contrário ou se a lista estiver vazia.
pub fn contem_time(time: Time, lista_times: List(Time)) -> Bool {
  case lista_times {
    [] -> False
    [primeiro, ..resto] -> primeiro.nome == time.nome || contem_time(time, resto)
  }
}
pub fn contem_time_examples() {
  check.eq(contem_time(Time("Sao-Paulo"), []), False)
  check.eq(contem_time(Time("Palmeiras"), [Time("Atletico-MG")]), False)
  check.eq(
    contem_time(Time("Botafogo"), [Time("Atletico-MG"), Time("Botafogo")]),
    True,
  )
}

/// Coleta todos os times de uma lista `dados_jogos` e adiciona em uma lista de times `lista_times`.
/// - Para cada jogo, extrai os times anfitrião e visitante.
/// - Adiciona os times à lista se eles ainda não estiverem presentes.
/// - Retorna a lista final de times ou um erro caso ocorra alguma inconsistência nos dados.
pub fn coleta_times(dados_jogos: List(List(String))) -> Result(LIst(Time), Erro) {
  case dados_jogos {
    [primeiro] -> case extrai_times(primeiro) {
      Ok([t1, t2]) -> todo
      Error(e) -> Error(e)
    }
    [primeiro, ..resto] -> todo
  }
}


/// Cria a classificação final do compeonato
/// Recebe `jogos`, uma lista de strings que contem as informações dos jogos que ocorreram no campeonato.
/// - Retorna
///   - Ok(List(String)), lista de string contendo as classificação final dos times que participaram do campeonato. 
///   - Error(e), erro propagada pelas funções auxiliares. 
pub fn main(jogos: List(String)) -> Result(List(String), Erro) {
  // Formata os dados de entrada
  let dados_formatados = formata_dados(jogos)

  // Coleta os times que participaram do campeonato
  let lista_times = case dados_formatados {
    Ok(dados) -> coleta_times(dados)
    Error(e) -> Error(e)
  }
}