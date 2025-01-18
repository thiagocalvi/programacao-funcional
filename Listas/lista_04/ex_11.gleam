import sgleam/check

pub type EstadoElevador {
    Parado
    Subindo
    Descendo
}

/// Determina a situção do elevador a partir
/// do *andar_atual* e *andar_solicitado* retorna
/// uma *SituacaoElevador*
pub fn situacao_elevador(andar_atual: Int, andar_solicitado: Int) -> EstadoElevador{
    case andar_atual > andar_solicitado {
        True -> Descendo
        False -> case andar_atual < andar_solicitado {
            True -> Subindo
            False -> Parado
            }
    }
}

pub fn situacao_elevador_examples() {
    check.eq(situacao_elevador(1, 3), Subindo)
    check.eq(situacao_elevador(5, 5), Parado)
    check.eq(situacao_elevador(6, 2), Descendo)
}

/// Verifica se o elevador pode mudar de estado
/// recebe o *estado_autal* do elevador e *proximo_estado*
/// retorna True se for possivel mudar de estado caso contrario
/// False
pub fn mudanca_estado_valida(estado_autal: EstadoElevador, proximo_estado: EstadoElevador) -> Bool {
    case estado_autal, proximo_estado {
        Parado, _ |  _, Parado -> True
        _, _ -> False
    }
}

pub fn mudanca_estado_valida_examples() {
    check.eq(mudanca_estado_valida(Subindo, Descendo), False)
    check.eq(mudanca_estado_valida(Subindo, Parado), True)
    check.eq(mudanca_estado_valida(Descendo, Subindo), False)
    check.eq(mudanca_estado_valida(Parado, Descendo), True)
    check.eq(mudanca_estado_valida(Parado, Parado), True)


}