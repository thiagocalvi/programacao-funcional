/// ************************************************************
/// * 4 Semestre do Curso de Ciência da Computação - UEM 2024  *
/// * Segundo trabalho da disciplica de Programação Funcional  *
/// * Discente : Thiago Henrique Calvi ra: 134955              *
/// ************************************************************
import gleam/int
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import sgleam/check

/// Representação dos erros do programa
pub type Erro {
  QuantidadeInvalidaParametros
  ValorInvalido
  TimesIguais
}

/// Representação de um "time" que participa do campeonato 
pub type Time {
  Time(nome: String)
}

/// Representação de um "jogo" do campeonato, contendo
/// anfitriao, gols anfitriao, visitante e gols visitante
pub type Jogo {
  Jogo(
    anfitriao: Time,
    gols_anfitriao: Int,
    visitante: Time,
    gols_visitante: Int,
  )
}

/// Representa o resultado de um time em um "Jogo"
pub type Resultado {
  Empate(time: Time, saldo_gols: Int, soma_pontos: Int)
  Derrota(time: Time, saldo_gols: Int, soma_pontos: Int)
  Vitoria(time: Time, saldo_gols: Int, soma_pontos: Int)
}

/// Representa um time na tabela de classificação
pub type TimeTabela {
  TimeTabela(time: Time, n_pontos: Int, n_vitorias: Int, saldo_gols: Int)
}

/// Processa os dados de uma *string_jogo* que representa as informações
/// de um jogo, *string_jogo* contem "anfitriao gols visitante gols", os
/// dados são separados nos espaços em branco, retorna um Ok com o *Jogo*,
/// caso tenha algum erro retorna um Erro
pub fn processa_dados(string_jogo: String) -> Result(Jogo, Erro) {
  case string.split(string_jogo, on: " ") {
    [anfitriao, anfitriao_gols, visitante, visitante_gols] ->
      case
        anfitriao == ""
        || anfitriao_gols == ""
        || visitante == ""
        || visitante_gols == ""
      {
        True -> Error(ValorInvalido)
        False -> cria_jogo(anfitriao, anfitriao_gols, visitante, visitante_gols)
      }
    _ -> Error(QuantidadeInvalidaParametros)
  }
}

pub fn processa_dados_examples() {
  check.eq(processa_dados("Flamengo 2 Palmeiras "), Error(ValorInvalido))
  check.eq(
    processa_dados("Flamengo Palmeiras 1"),
    Error(QuantidadeInvalidaParametros),
  )
  check.eq(
    processa_dados("Sao-Paulo 1 Atletico-MG 2"),
    Ok(Jogo(Time("Sao-Paulo"), 1, Time("Atletico-MG"), 2)),
  )
}

/// Recebe uma string *str* com as informações de um jogo "time1 gols1 time2 gols2"
/// e cria um estrutura Jogo com as informações do jogo armazenadas na string e retorna
/// esse estrutura Jogo, caso tenha algum erro retorna Erro
pub fn cria_jogo(
  anfitriao: String,
  anfitriao_gols: String,
  visitante: String,
  visitante_gols: String,
) -> Result(Jogo, Erro) {
  use #(a_gols, v_gols) <- result.try(converte_gols(
    anfitriao_gols,
    visitante_gols,
  ))
  use #(time_anfitriao, time_visitante) <- result.try(verifica_times(
    anfitriao,
    visitante,
  ))
  Ok(Jogo(time_anfitriao, a_gols, time_visitante, v_gols))
}

pub fn cria_jogo_examples() {
  check.eq(
    cria_jogo("Sao-Paulo", "1", "Atletico-MG", "2"),
    Ok(Jogo(Time("Sao-Paulo"), 1, Time("Atletico-MG"), 2)),
  )
}

/// Coverte o valor dos gols dos time de uma partida de string
/// para inteiro, recebe duas strings *anfitriao_gols* e *visitante_gols*
/// coverte esses valores para inteiro,  verifica se os valores convertidos 
/// são validos para gols, inteiros não negativo. Retorna os valores convertidos 
/// em uma tupla, caso tenha algum, erro retorna Erro 
pub fn converte_gols(
  anfitriao_gols: String,
  visitante_gols: String,
) -> Result(#(Int, Int), Erro) {
  case int.parse(anfitriao_gols), int.parse(visitante_gols) {
    Ok(a_gols), Ok(v_gols) ->
      case a_gols >= 0 && v_gols >= 0 {
        True -> Ok(#(a_gols, v_gols))
        False -> Error(ValorInvalido)
      }
    _, _ -> Error(ValorInvalido)
  }
}

pub fn converte_gols_examples() {
  check.eq(converte_gols("1", "0"), Ok(#(1, 0)))
  check.eq(converte_gols("1", "a"), Error(ValorInvalido))
}

/// Verifica se dois times *anfitriao* e *visitante* são iguais, se forem retorna um Erro
/// caso contrario retorna uma tupla com os dois times, cada um em uma estrutura "Time"
pub fn verifica_times(anfitriao, visitante) -> Result(#(Time, Time), Erro) {
  case anfitriao == visitante {
    True -> Error(TimesIguais)
    False -> Ok(#(Time(anfitriao), Time(visitante)))
  }
}

pub fn verifica_times_examples() {
  check.eq(verifica_times("Sao-Paulo", "Sao-Paulo"), Error(TimesIguais))
  check.eq(
    verifica_times("Sao-Paulo", "Atletico-MG"),
    Ok(#(Time("Sao-Paulo"), Time("Atletico-MG"))),
  )
}

/// Recebe um estrutura *jogo* do tipo "Jogo" e define o resultado do jogo,
/// atribui os resultados para os times do *jogo* e retorna a uma lista 
/// com os Resultado de cada time, se acontecer algum erro, retorna Erro
pub fn resultado_jogo(jogo: Jogo) -> Result(List(Resultado), Erro) {
  case jogo {
    Jogo(time_anfitriao, gols_anfitriao, time_visitante, gols_visitante)
      if gols_anfitriao > gols_visitante
    ->
      Ok([
        Vitoria(time_anfitriao, gols_anfitriao - gols_visitante, 3),
        Derrota(time_visitante, gols_visitante - gols_anfitriao, 0),
      ])
    Jogo(time_anfitriao, gols_anfitriao, time_visitante, gols_visitante)
      if gols_anfitriao < gols_visitante
    ->
      Ok([
        Vitoria(time_visitante, gols_visitante - gols_anfitriao, 3),
        Derrota(time_anfitriao, gols_anfitriao - gols_visitante, 0),
      ])
    Jogo(time_anfitriao, _, time_visitante, _) ->
      Ok([Empate(time_anfitriao, 0, 1), Empate(time_visitante, 0, 1)])
  }
}

pub fn resultado_jogo_examples() {
  check.eq(
    resultado_jogo(Jogo(Time("Sao-Paulo"), 7, Time("Atletico-MG"), 2)),
    Ok([Vitoria(Time("Sao-Paulo"), 5, 3), Derrota(Time("Atletico-MG"), -5, 0)]),
    
  )

  check.eq(
    resultado_jogo(Jogo(Time("Sao-Paulo"), 2, Time("Atletico-MG"), 2)),
    Ok([Empate(Time("Sao-Paulo"), 0, 1), Empate(Time("Atletico-MG"), 0, 1)]),
  )
}

/// Recebe uma string *jogo_str* com as informações de um jogo do campeonato,
/// cria e retorna uma lista com duas estrutura "Resultado" uma para cada 
/// time de *jogo_str*, cada estrutura Resultado representa o resultado do time
/// no jogo, caso tenha algum erro retorna esse erro
pub fn cria_resultado_parciais(
  jogo_str: String,
) -> Result(List(Resultado), Erro) {
  use jogo <- result.try(processa_dados(jogo_str))
  use res_parcial <- result.try(resultado_jogo(jogo))
  Ok(res_parcial)
}

pub fn cria_resultado_parciais_examples() {
  check.eq(
    cria_resultado_parciais("Flamengo 1 Santos 0"),
    Ok([
      Vitoria(time: Time(nome: "Flamengo"), saldo_gols: 1, soma_pontos: 3),
      Derrota(time: Time(nome: "Santos"), saldo_gols: -1, soma_pontos: 0),
    ]),
  )
}

/// Atualiza as informações do *time_tabela* com os dados de *resultado*
/// e retorna *time_tabela* com as informações atuliazadas
pub fn atualiza_info_time_tabela(
  time_tabela: TimeTabela,
  resultado: Resultado,
) -> TimeTabela {
  case resultado {
    Empate(_, gols, pontos) | Derrota(_, gols, pontos) ->
      TimeTabela(
        ..time_tabela,
        n_pontos: time_tabela.n_pontos + pontos,
        saldo_gols: time_tabela.saldo_gols + gols,
      )
    Vitoria(_, gols, pontos) ->
      TimeTabela(
        ..time_tabela,
        n_pontos: time_tabela.n_pontos + pontos,
        n_vitorias: time_tabela.n_vitorias + 1,
        saldo_gols: time_tabela.saldo_gols + gols,
      )
  }
}

pub fn atualiza_info_time_tabela_examples() {
  check.eq(
    atualiza_info_time_tabela(
      TimeTabela(Time("Flamento"), 3, 1, 2),
      Vitoria(Time("Flamento"), 1, 3),
    ),
    TimeTabela(Time("Flamento"), 6, 2, 3),
  )
}

/// Cria a tabela de classificão do brasileirão, se o time de *resultado* já estiver
/// em *tabela_acc* atualiza as informações do time em *tabela_acc*, caso contrario,
/// insere o time em *tabela_acc* com as informações de *resultado*
pub fn cria_tabela(
  tabela_acc: List(TimeTabela),
  resultado: Resultado,
) -> List(TimeTabela) {
  case list.find(tabela_acc, fn(x) { x.time == resultado.time }) {
    Ok(time_tabela) -> [
      atualiza_info_time_tabela(time_tabela, resultado),
      ..list.filter(tabela_acc, fn(x) { x.time != resultado.time })
    ]
    _ -> [
      atualiza_info_time_tabela(TimeTabela(resultado.time, 0, 0, 0), resultado),
      ..tabela_acc
    ]
  }
}

pub fn cria_tabela_examples() {
  check.eq(
    cria_tabela(
      [],
      Empate(time: Time(nome: "Palmeiras"), saldo_gols: 0, soma_pontos: 1),
    ),
    [TimeTabela(Time("Palmeiras"), 1, 0, 0)],
  )

  check.eq(
    cria_tabela(
      [
        TimeTabela(Time("Palmeiras"), 1, 0, 0),
        TimeTabela(Time("Flamengo"), 3, 1, 2),
      ],
      Vitoria(time: Time(nome: "Flamengo"), saldo_gols: 1, soma_pontos: 3),
    ),
    [
      TimeTabela(Time("Flamengo"), 6, 2, 3),
      TimeTabela(Time("Palmeiras"), 1, 0, 0),
    ],
  )
}

/// Faz a comparação entre dois times *a* e *b*, retorna True se
/// *a* deve vir antes de *b* na ordenação. Compara incialmente
/// a quantide de pontos, se empate, compara o numero de vitórias,
/// se empate, compara em ordem alfabetica
pub fn compara_times(a: TimeTabela, b: TimeTabela) -> Bool {
  case int.compare(a.n_pontos, b.n_pontos) {
    order.Eq -> {
      case int.compare(a.n_vitorias, b.n_vitorias) {
        order.Eq -> string.compare(a.time.nome, b.time.nome) == order.Lt
        outro -> outro == order.Gt
      }
    }
    outro -> outro == order.Gt
  }
}

pub fn compara_times_examples() {
  check.eq(
    compara_times(
      TimeTabela(
        time: Time(nome: "Fluminense"),
        n_pontos: 8,
        n_vitorias: 2,
        saldo_gols: 4,
      ),
      TimeTabela(
        time: Time(nome: "Flamengo"),
        n_pontos: 8,
        n_vitorias: 2,
        saldo_gols: 1,
      ),
    ),
    False,
  )
}

/// Ordena a *tabela* de forma decrescente pela quantidade de pontos dos times, 
/// caso tenha empate, ordena de forma decrescente pela quantidade de vitoria,
/// se ainda tiver empate ordena pelo nome do time em ordem alfabetica. Retorna
/// a *tabela* ordenada
pub fn ordena_tabela(tabela: List(TimeTabela)) -> List(TimeTabela) {
  list.fold(tabela, [], fn(acc, time_atual) {
    // Encontra a posição correta para inserir o time atual
    let #(times_anteriores, times_posteriores) =
      list.partition(acc, fn(t) { compara_times(t, time_atual) })

    //times_anteriores + time_atual + times_posteriores
    list.flatten([times_anteriores, [time_atual], times_posteriores])
  })
}

pub fn ordena_tabela_examples() {
  check.eq(
    ordena_tabela([
      TimeTabela(
        time: Time(nome: "Fluminense"),
        n_pontos: 7,
        n_vitorias: 2,
        saldo_gols: 4,
      ),
      TimeTabela(
        time: Time(nome: "Vasco"),
        n_pontos: 17,
        n_vitorias: 2,
        saldo_gols: 2,
      ),
      TimeTabela(
        time: Time(nome: "Botafogo"),
        n_pontos: 2,
        n_vitorias: 0,
        saldo_gols: -2,
      ),
      TimeTabela(
        time: Time(nome: "Palmeiras"),
        n_pontos: 8,
        n_vitorias: 2,
        saldo_gols: 3,
      ),
    ]),
    [
      TimeTabela(
        time: Time(nome: "Vasco"),
        n_pontos: 17,
        n_vitorias: 2,
        saldo_gols: 2,
      ),
      TimeTabela(
        time: Time(nome: "Palmeiras"),
        n_pontos: 8,
        n_vitorias: 2,
        saldo_gols: 3,
      ),
      TimeTabela(
        time: Time(nome: "Fluminense"),
        n_pontos: 7,
        n_vitorias: 2,
        saldo_gols: 4,
      ),
      TimeTabela(
        time: Time(nome: "Botafogo"),
        n_pontos: 2,
        n_vitorias: 0,
        saldo_gols: -2,
      ),
    ],
  )
}

// Calcula a largura necessária para cada coluna da tabela (nome, pontos, vitórias e saldo de gols)
// analisando o tamanho máximo que cada tipo de dado ocupa em toda a lista de *times*.
// Retorna uma tupla com as 4 larguras máximas encontradas.
fn larguras_maximas(times: List(TimeTabela)) -> #(Int, Int, Int, Int) {
  list.fold(times, #(0, 0, 0, 0), fn(acc, time) {
    let #(nome_max, pontos_max, vitorias_max, saldo_gols_max) = acc
    let nome_len = string.length(time.time.nome)
    let pontos_len = string.length(int.to_string(time.n_pontos))
    let vitorias_len = string.length(int.to_string(time.n_vitorias))
    let saldo_gols_len = string.length(int.to_string(time.saldo_gols))

    #(
      int.max(nome_max, nome_len),
      int.max(pontos_max, pontos_len),
      int.max(vitorias_max, vitorias_len),
      int.max(saldo_gols_max, saldo_gols_len),
    )
  })
}

pub fn larguras_maximas_examples() {
  check.eq(
    larguras_maximas([
      TimeTabela(
        time: Time(nome: "Fluminense"),
        n_pontos: 12,
        n_vitorias: 2,
        saldo_gols: 4,
      ),
      TimeTabela(
        time: Time(nome: "Vasco"),
        n_pontos: 7,
        n_vitorias: 2,
        saldo_gols: 2,
      ),
    ]),
    #(10, 2, 1, 1),
  )
}

/// Converte cada time da *tabela* em uma string formatada onde todos os dados estão
/// alinhados. Os nomes são alinhados à esquerda, enquanto números são alinhados à direita.
/// Retorna uma lista onde cada elemento é uma string formatada representando as
/// informações de classificação de um time.
pub fn formata_tabela(tabela: List(TimeTabela)) -> List(String) {
  let #(nome_width, pontos_width, vitorias_width, saldo_width) =
    larguras_maximas(tabela)

  list.map(tabela, fn(time) {
    string.concat([
      string.pad_right(time.time.nome, nome_width, " "),
      " ",
      string.pad_left(int.to_string(time.n_pontos), pontos_width, " "),
      " ",
      string.pad_left(int.to_string(time.n_vitorias), vitorias_width, " "),
      " ",
      string.pad_left(int.to_string(time.saldo_gols), saldo_width, " "),
    ])
  })
}

pub fn formata_tabela_examples() {
  check.eq(
    formata_tabela([
      TimeTabela(
        time: Time(nome: "Fluminense"),
        n_pontos: 12,
        n_vitorias: 2,
        saldo_gols: 4,
      ),
      TimeTabela(
        time: Time(nome: "Vasco"),
        n_pontos: 7,
        n_vitorias: 2,
        saldo_gols: 2,
      ),
    ]),
    ["Fluminense 12 2 4", "Vasco       7 2 2"],
  )
}

/// A partir de uma lista de strings *dados_jogos* que representa as informações dos
/// jogos do campeonato cria a tabela de classificação dos times que participaram
/// do campeonato.
pub fn main(dados_jogos: List(String)) -> Result(List(String), Erro) {
  case result.all(list.map(dados_jogos, cria_resultado_parciais)) {
    Ok(res) ->
      Ok(
        list.flatten(res)
        |> list.fold([], cria_tabela)
        |> ordena_tabela()
        |> formata_tabela(),
      )
    Error(e) -> Error(e)
  }
}

pub fn main_examples() {
  check.eq(
    main([
      "Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1",
      "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2",
      "Corinthians 3 Santos 1", "Internacional 1 Gremio 1",
      "Fluminense 2 Botafogo 0", "Cruzeiro 0 Vasco 1", "Sao-Paulo 2 Flamengo 2",
      "Atletico-MG 0 Palmeiras 3", "Santos 1 Sao-Paulo 1",
      "Flamengo 3 Corinthians 2", "Gremio 0 Fluminense 2",
      "Botafogo 1 Internacional 1", "Vasco 2 Atletico-MG 1",
      "Palmeiras 1 Cruzeiro 0", "Flamengo 1 Santos 0",
      "Internacional 3 Corinthians 3", "Botafogo 0 Vasco 0",
      "Fluminense 2 Palmeiras 2",
    ]),
    Ok([
      "Flamengo      13 4  4", "Palmeiras      8 2  3", "Fluminense     7 2  4",
      "Vasco          7 2  2", "Corinthians    4 1  1", "Atletico-MG    3 1 -4",
      "Internacional  3 0  0", "Sao-Paulo      3 0 -1", "Botafogo       2 0 -2",
      "Gremio         1 0 -2", "Santos         1 0 -3", "Cruzeiro       0 0 -2",
    ]),
  )
}
