import sgleam/check

/// Represeta as direções que o personagem pode estar virado.
pub type Direcao {
    Norte
    Sul
    Leste
    Oeste
}

/// Represeta a posição do personagem no tabuleiro.
pub type Posicao {
    Posicao(numero_linha: Int, numero_coluna: Int, virado_para: Direcao)
}

/// Represeta as ações que o jogar pode aplicar no personagem
pub type Acao {
    ViraEsquerda
    ViraDireita
    Avanca(numero_casas: Int)
}

/// Representa o persogem do jogo
pub type Personagem {
    Personagem(posicao_atual: Posicao)
}

/// Diz para qual direção o personagem vai estar virado quando aplicado
/// uma *acao* de ViraEsquerda ou ViraDireita baseado na *direcao_atual*
pub fn nova_direcao(acao: Acao, direcao_atual: Direcao) -> Direcao {
    case acao {
        ViraDireita -> case direcao_atual {
            Norte -> Leste
            Leste -> Sul
            Sul -> Oeste
            Oeste -> Norte
        }
        
        ViraEsquerda -> case direcao_atual {
            Norte -> Oeste
            Leste -> Norte
            Sul -> Leste
            Oeste -> Sul
        }
    }
}

/// Calcula a nova posição do personagem no tabuleiro, recebe a *posicao*
/// atual do personagem e *numero_casas* que o personagem deve andar, retorna a
/// nova *posicao* do personagem no tabuleiro, caso a nova posição utrapase o limite
/// do tabuleiro, o estado do personagem não é alterado
pub fn nova_posicao(posicao: Posicao, numero_casas: Int) -> Posicao {
    case posicao.virado_para {
        Norte | Sul if posicao.numero_linha + numero_casas <= 10 -> 
            Posicao(..posicao, numero_linha: posicao.numero_linha + numero_casas)

        Leste | Oeste if posicao.numero_coluna + numero_casas <= 10 ->
            Posicao(..posicao, numero_coluna: posicao.numero_coluna + numero_casas)
    }
}

/// Recebe o *personagem* do jogo e um *comando* (Acao) aplica o comando no personagem
/// e retorna *personagem* com a posição atualizado no tabuleiro
pub fn jogar(personagem: Personagem, comando: Acao) -> Personagem {
    case comando {
        ViraDireita -> Personagem(Posicao(..personagem.posicao_atual, virado_para: nova_direcao(ViraDireita, persogem.posicao_atual.virado_para)))
        ViraEsquerda ->  Personagem(Posicao(..personagem.posicao_atual, virado_para: nova_direcao(ViraEsquerda, persogem.posicao_atual.virado_para)))
        Avanca(n_casas) -> Personagem(nova_posicao(personagem.posicao_atual, n_casas))
    }
}
pub fn jogar_examples() {
    check.eq(
  jogar(Personagem(Posicao(1, 1, Norte)), ViraDireita),
  Personagem(Posicao(1, 1, Leste))
)

}