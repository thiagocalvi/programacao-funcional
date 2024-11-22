import sgleam/check

/// Estrutura para represetar as direções Norte, Leste, Oeste e Sul
pub type Direcao {
    Norte
    Leste
    Oeste
    Sul
}

/// Retorna a direção oposta a *direcao* informada
pub fn direcao_oposta(direcao: Direcao) -> Direcao{
  case direcao {
    Norte -> Sul
    Leste -> Oeste
    Sul -> Norte
    Oeste -> Leste
  }
}

pub fn direcao_oposta_examples() {
    check.eq(direcao_oposta(Norte), Sul)
    check.eq(direcao_oposta(Leste), Oeste)
    check.eq(direcao_oposta(Sul), Norte)
    check.eq(direcao_oposta(Oeste), Leste)
}

/// Retorna a direção que está a 90 graus no setido horário da *direcao* informada
pub fn direcao_90_graus_horario(direcao: Direcao) -> Direcao {
    case direcao {
        Norte -> Leste
        Leste -> Sul
        Sul -> Oeste
        Oeste -> Norte
    }
}

pub fn direcao_90_graus_horario_examples() {
    check.eq(direcao_90_graus_horario(Norte), Leste)
    check.eq(direcao_90_graus_horario(Leste), Sul)
    check.eq(direcao_90_graus_horario(Sul), Oeste)
    check.eq(direcao_90_graus_horario(Oeste), Norte)
}


/// Retorna a direção que está a 90 graus no setido anti-horário da *direcao* informada
pub fn direcao_90_graus_anti_horario(direcao: Direcao) -> Direcao {
    case direcao {
        Norte -> Oeste
        Leste -> Norte
        Sul -> Leste
        Oeste -> Sul
    }
}

pub fn direcao_90_graus_anti_horario_examples() {
    check.eq(direcao_90_graus_anti_horario(Norte), Oeste)
    check.eq(direcao_90_graus_anti_horario(Leste), Norte)
    check.eq(direcao_90_graus_anti_horario(Sul), Leste)
    check.eq(direcao_90_graus_anti_horario(Oeste), Sul)
}

/// Retorna quantos graus um pessoa deve virar a partir de uma *direcao_atual* para 
/// chegar em uma *direcao_destino* no sentido horaŕio
pub fn orientacao(direcao_atual: Direcao, direcao_destino: Direcao) -> String {
    case direcao_atual, direcao_destino {
        Norte, Leste | Leste, Sul | Sul, Oeste | Oeste, Norte -> "90° graus"
        Norte, Sul | Leste, Oeste | Sul, Norte | Oeste, Leste -> "180° graus"
        Norte, Oeste | Leste, Norte | Sul, Leste | Oeste, Sul -> "270° graus"
        Norte, Norte | Leste, Leste | Sul, Sul | Oeste, Oeste -> "0° graus"
    }
} 

pub fn orientacao_exaples() {
    check.eq(orientacao(Norte, Leste), "80° graus")
    check.eq(orientacao(Norte, Sul), "180° graus")
    check.eq(orientacao(Norte, Oeste), "270° graus")
    check.eq(orientacao(Norte, Norte), "0° graus")

}