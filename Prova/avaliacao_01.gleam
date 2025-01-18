/// Thiago Henrique Calvi 
/// Ra: 134955

import gleam/string
import sgleam/check

/// Questão 01
/// Representa um comando de edição no editor de linha
pub type ComandoEditor {
    /// Representa o comando de mover o curso para direita na linha
    MoverCursorDireita
    
    /// Representa o comando de mover o curso para esquerda na linha
    MoverCursorEsquerda

    /// Representa o comando de apagar o caractere anterir a posição atual do curso na linha
    ApagarCaractereAnterior
    
    /// Representa o comando de insererir um *catactere* na posição atual do cursor na linha
    InserirCaracterePosicaoAtual(caractere: String)
}
/// O estado de um editor de linha.
/// - esquerda é o conteúdo da linha a esquerda do cursor
/// - direita é o conteúdo da linha a direita do cursor
pub type Editor {
    Editor(esquerda: String, direita: String)
}

/// Atualiza o estado do *editor* segundo um *comando* do editor e 
/// retorna o *editor* com estado atulizado.
pub fn atualiza_estado_editor(editor: Editor, comando: ComandoEditor) -> Editor {
    case comando {
        MoverCursorDireita -> 
            Editor(editor.esquerda <> string.slice(editor.direita, 0, 1), string.slice(editor.direita, 1, string.length(editor.direita)))
        
        MoverCursorEsquerda -> 
            Editor(
                string.slice(editor.esquerda, 0, string.length(editor.esquerda) - 1), 
                string.slice(editor.esquerda, string.length(editor.esquerda) - 1, 1) <> editor.direita)
        
        ApagarCaractereAnterior -> 
            Editor(
                ..editor,
                esquerda: string.slice(editor.esquerda, 0, string.length(editor.esquerda) - 1))
        
        InserirCaracterePosicaoAtual(caractere) -> 
            Editor(..editor, esquerda: editor.esquerda <> caractere)
    }
}
pub fn atualiza_estado_editor_examples() {
    check.eq(atualiza_estado_editor(Editor("Exempl", " de teste"), MoverCursorDireita), 
    Editor("Exempl ", "de teste"))
    
    check.eq(atualiza_estado_editor(Editor("Exempl", " de teste"), MoverCursorEsquerda), 
    Editor("Exemp", "l de teste"))
   
    check.eq(atualiza_estado_editor(Editor("Exempl", " de teste"), ApagarCaractereAnterior), 
    Editor("Exemp", " de teste"))
    
    check.eq(atualiza_estado_editor(Editor("Exempl", " de teste"), InserirCaracterePosicaoAtual("o")), 
    Editor("Exemplo", " de teste"))
    
}

/// Questão 02
/// Conta a quantidade de vezes que um numero *n* aparece em uma *lista*
/// de numeros e retorna essa quantidade. *n* pode ser um Float ou Int,
/// os elementos de *lista* devem ser do mesmo tipo de *n*.
pub fn quantidade_aparicoes(n: a, lista: List(a)) -> Int {
    case lista {
        [] -> 0
        [primeiro, ..resto] if primeiro == n -> 1 + quantidade_aparicoes(n, resto)
        [_, ..resto] -> quantidade_aparicoes(n, resto)
        
    }
}
pub fn quantidade_aparicoes_examples() {
    check.eq(quantidade_aparicoes(1, []), 0)
    check.eq(quantidade_aparicoes(4, [1, 2, 5, -8, 4, 1]), 1)
    check.eq(quantidade_aparicoes(1.2, [8.2, 1.2, 7.0, 3.7, 1.2]), 2)
}

/// Determina o maximo de repetições dentro de uma *lista* de numeros
pub fn max_repeticoes(lista: List(a)) -> Int {
    case lista {
        [] -> 0
        [primeiro, ..resto] -> todo
    }
}
pub fn max_repeticoes_examples() {
    check.eq(max_repeticoes([]), 0)
    check.eq(max_repeticoes([1,1,2,3,4]), 2)
    check.eq(max_repeticoes([1,2,3,4]), 0)
}