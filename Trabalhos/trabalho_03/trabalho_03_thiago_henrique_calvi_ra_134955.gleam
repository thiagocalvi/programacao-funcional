/// Trabalho 03 - Programação Funcional
/// Discente: Thiago Henrique Calvi ra134955
import gleam/int
import gleam/list
import gleam/result
import gleam/string

import sgleam/check

pub type Operacao {
  // Representa operação de Soma
  Soma
  // Representa operação de Subtração
  Subtracao
  // Representa operação de Multiplicação
  Multiplicacao
  // Representa operação de Divisão
  Divisao
}

pub type Simbolo {
  // Representa um numero inteiro
  Operando(num: Int)
  // Representa um operando 
  Operador(op: Operacao)
  // Representa um ")"
  ParentesesR
  // Representa um "("
  ParentesesL
}

pub type Erro {
  // Representa a falta de fechamento de "( )"
  ParentesesSemFechamento
  // Representa um expressão invalida, algum caracter invalido
  ExpressaoInvalida
  // Representa um operador que inesperado
  OperadorInesperado
}

/// Converte uma string *str* para uma lista de strings
/// de 1 caractere.
pub fn string_to_lista(str: String) -> List(String) {
  str
  |> string.split(on: "")
  |> list.filter(fn(x) { x != " " })
}

pub fn string_to_lista_examples() {
  check.eq(string_to_lista("3 + 2"), ["3", "+", "2"])
  check.eq(string_to_lista("2+3(-32)"), ["2", "+", "3", "(", "-", "3", "2", ")"])
}

/// Converte um string *str* para uma estrutura
/// "Simbolo"
pub fn str_to_simbolo(str: String) -> Result(Simbolo, Erro) {
  case str {
    "(" -> Ok(ParentesesL)
    ")" -> Ok(ParentesesR)
    "+" -> Ok(Operador(Soma))
    "-" -> Ok(Operador(Subtracao))
    "*" -> Ok(Operador(Multiplicacao))
    "/" -> Ok(Operador(Divisao))
    _ ->
      case int.parse(str) {
        Ok(simbolo) -> Ok(Operando(simbolo))
        Error(_) -> Error(ExpressaoInvalida)
      }
  }
}

pub fn str_to_simbolo_examples() {
  check.eq(str_to_simbolo("3"), Ok(Operando(3)))
  check.eq(str_to_simbolo("-4"), Ok(Operando(-4)))
  check.eq(str_to_simbolo("*"), Ok(Operador(Multiplicacao)))
}

/// Verifica se *lst* que representa uma expressão possui 
/// todos os fechamentos de parenteses. Retorna True se sim,
/// caso contrario retorna False.
pub fn verifica_fechamento(lst: List(Simbolo)) -> Bool {
  list.fold(lst, 0, fn(acc, simbolo) {
    case simbolo {
      ParentesesL -> acc + 1
      ParentesesR -> acc - 1
      _ -> acc
    }
  })
  == 0
}

pub fn verifica_fechamento_examples() {
  check.eq(
    verifica_fechamento([ParentesesL, Operando(2), Operador(Soma), Operando(2)]),
    False,
  )
  check.eq(
    verifica_fechamento([
      Operando(2),
      Operador(Soma),
      ParentesesL,
      Operando(2),
      ParentesesR,
    ]),
    True,
  )
}

/// Gerencia a inserção de um operador na pilha durante a conversão 
/// para notação pós-fixa. Remove operadores da pilha com precedência igual 
/// ou maior que o operador atual, adicionando-os à saída. Insere o 
/// novo operador na pilha, mantendo a ordem correta de precedência.
fn processa_operador(
  pilha: List(Simbolo),
  saida: List(Simbolo),
  simbolo: Simbolo,
  op: Operacao,
) -> #(List(Simbolo), List(Simbolo)) {
  let nova_pilha =
    list.drop_while(pilha, fn(top) {
      case top {
        Operador(top_op) -> precedencia(top_op) >= precedencia(op)
        ParentesesL -> False
        _ -> False
      }
    })
  let saida_atualizada =
    list.append(
      saida,
      list.take(pilha, list.length(pilha) - list.length(nova_pilha)),
    )
  #(saida_atualizada, [simbolo, ..nova_pilha])
}

/// Lida com "ParentesesL" durante a conversão. Transfere todos os 
/// operadores da pilha para a saída até encontrar um parêntese esquerdo "ParentesesL", 
/// que é removido da pilha sem ser adicionado à saída.
fn processa_parentese_direito(
  pilha: List(Simbolo),
  saida: List(Simbolo),
  _acc: #(List(Simbolo), List(Simbolo)),
) -> #(List(Simbolo), List(Simbolo)) {
  let #(saida_atualizada, nova_pilha) =
    list.fold_until(pilha, #(saida, []), fn(acc, top) {
      case top {
        ParentesesL -> list.Continue(#(acc.0, acc.1))
        _ -> list.Continue(#(list.append(acc.0, [top]), acc.1))
      }
    })
  #(saida_atualizada, nova_pilha)
}

/// Recebe uma lista *lst* que representa a expressão matemática
/// no formato infixa, converte *lst* para uma lista de "Simbolo"
/// que representa a expressão matemática no formato posfixa.
pub fn infixa_to_posfixa(lst: List(Simbolo)) -> List(Simbolo) {
  list.fold(lst, #([], []), fn(acc, simbolo) {
    let #(saida, pilha) = acc
    case simbolo {
      Operando(_) -> #(list.append(saida, [simbolo]), pilha)
      ParentesesL -> #(saida, [simbolo, ..pilha])
      Operador(op) -> processa_operador(pilha, saida, simbolo, op)
      ParentesesR -> processa_parentese_direito(pilha, saida, acc)
    }
  })
  |> fn(resultado) {
    let #(saida, pilha) = resultado
    list.append(saida, pilha)
  }
}

pub fn infixa_to_posfixa_examples() {
  check.eq(infixa_to_posfixa([Operando(5), Operador(Soma), Operando(4)]), [
    Operando(5),
    Operando(4),
    Operador(Soma),
  ])

  check.eq(
    infixa_to_posfixa([
      ParentesesL,
      Operando(2),
      Operador(Subtracao),
      Operando(1),
      ParentesesR,
      Operador(Multiplicacao),
      Operando(5),
    ]),
    [
      Operando(2),
      Operando(1),
      Operador(Subtracao),
      Operando(5),
      Operador(Multiplicacao),
    ],
  )
}

// Verificar a precedência dos operadores
fn precedencia(op: Operacao) -> Int {
  case op {
    Soma -> 1
    Subtracao -> 1
    Multiplicacao -> 2
    Divisao -> 2
  }
}

/// Executa uma *operacao* como dois operandos, *operando_a* e *operando_b*
/// retorna um inteiro que é o resultado da operação.
pub fn aplica_operacao(
  operando_a: Int,
  operando_b: Int,
  operacao: Operacao,
) -> Int {
  case operacao {
    Soma -> operando_a + operando_b
    Subtracao -> operando_a - operando_b
    Multiplicacao -> operando_a * operando_b
    Divisao -> operando_a / operando_b
  }
}

pub fn aplica_operacao_examples() {
  check.eq(aplica_operacao(5, 6, Multiplicacao), 30)
}

/// Calcula o resultado de um operação *op* aplica nos dois operando do
/// topo de *pilha*
pub fn calcula(pilha: List(Int), op: Operacao) -> Result(List(Int), Erro) {
  case pilha {
    [a, b, ..resto] -> Ok([aplica_operacao(b, a, op), ..resto])
    _ -> Error(ExpressaoInvalida)
  }
}

pub fn calcula_examples() {
  check.eq(calcula([], Soma), Error(ExpressaoInvalida))
  check.eq(calcula([5, 2], Multiplicacao), Ok([10]))
}

/// Avalia uma lista de "Simbolo" que representa uma *expressao*
/// no formato posfixa e retorna o resultado dessa *expressao*
pub fn avalia_expressao(expressao: List(Simbolo)) -> Result(Int, Erro) {
  list.fold(expressao, Ok([]), fn(pilha_acc, simbolo) {
    case simbolo, pilha_acc {
      Operando(num), Ok(pilha) -> Ok([num, ..pilha])
      Operador(op), Ok(pilha) -> calcula(pilha, op)
      _, _ -> Error(ExpressaoInvalida)
    }
  })
  |> result.try(fn(pilha) {
    case pilha {
      [resultado] -> Ok(resultado)
      _ -> Error(ExpressaoInvalida)
    }
  })
}

pub fn avalia_expressao_examples() {
  check.eq(
    avalia_expressao([
      Operando(5),
      Operando(6),
      Operador(Multiplicacao),
      Operando(3),
      Operador(Soma),
    ]),
    Ok(33),
  )
  check.eq(
    avalia_expressao([
      Operando(5),
      Operando(45),
      Operando(10),
      Operando(1),
      Operador(Subtracao),
      Operador(Multiplicacao),
      Operador(Soma),
    ]),
    Ok(410),
  )
  check.eq(
    avalia_expressao([
      Operando(5),
      Operando(3),
      Operador(Soma),
      Operando(6),
      Operando(2),
      Operador(Subtracao),
      Operador(Multiplicacao),
      Operando(4),
      Operador(Divisao),
    ]),
    Ok(8),
  )
}
