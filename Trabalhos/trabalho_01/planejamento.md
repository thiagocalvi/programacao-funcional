# Planejamento do Trabalho 1 de Programação Funcional

## Geral
Tema: Classificação no Brasileirão

Pontuação:
- Cada vitória -> 3 pontos
- Cada empate -> 1 pontos
- Cada derrota -> não gera pontos

Classificação é definidada pela quantidade de pontos, os times são rankeados de forma decresente, o time com a maior quantidade de pontos para o 
time com a menor quantidade de pontos. Em caso de empate na quantidade de pontos de um ou mais times os seguintes critérios são utilizados (nessa ordem):
- Número de vitórias
- Saldo de gols e
- Ordem alfabética

Os dados dos jogos são fornecidos em uma lista de strings, cada string descreve o resultado de um jogo na forma "Anfitrião Gols Visitante Gols", os
nomes dos times não tem espaços. Exemplo de entrada:
Sao-Paulo 1 Atletico-MG 2
Flamengo 2 Palmeiras 1
Palmeiras 0 Sao-Paulo 0
Atletico-MG 1 Flamengo 2

Para essa entra o programa deve produzir a seguinte saída:
Flamengo 6 2 2
Atletico-MG 3 1 0
Palmeiras 1 0 -1
Sao-Paulo 1 0 -1

-> uma lista de strings, com uma string por linha

## Definição dos erros
- No local do número de gol não houver um inteiro
- Número de gols ser negativo
- Falta do número de gols do Anfitrião
- Falta do número de gols do Visitante
- Falta do nome do Anfitrião
- Falta do nome do Visitante
- Formato da string invalido, quantidade de parametros maior que a esperada

## Fluxo do programa
- Receber a lista de strings que representa os resultados dos jogos
- Separar os dados da string, de "Sao-Paulo 1 Atletico-MG 2" para uma lista de strings ["Sao-Paulo", "1", "Atletico-MG", "2"]
- Mapear os nomes dos times de ["Sao-Paulo", "1", "Atletico-MG", "2"] para uma lista de times, não pode haver times repitidos nessa lista
- Mapear esses dados ["Sao-Paulo", "1", "Atletico-MG", "2"] para uma estrutura {time_anfitriao, anfitriao_gols, time_visitantante, visitante_gols}
- Armazenar essa estrutura em uma lista de estruturas
- Criar uma outra estrtura para representar um time na tabela de classificação {nome, pontos, vitorias, saldo_gols}, só deve existe uma representação para cada time
- Também armazenar essa estrutura em uma lista de estruturas
- Calcular a quantidade de pontos de cada time
- Ordenar eles pela quantidade de ponto
- Se houver empate
- Ordenar pelo números de vitórias
- Se houver empate
- Ordenar pelo saldo de gols
- Se houver empate
- Ordenar pela ordem alfabética
- Apresetar o a classificação


## Definição dos tipos de dados
- Representação de um time -> {nome}
- Representação de um time na tabela -> {time, quantidade_pontos, numero_vitorias, saldo_gols}

## Funções
Função 'separar_dados' recebe uma string do tipo "Sao-Paulo 1 Atletico-MG 2" e deve retorna uma lista de strings no formato ["Sao-Paulo", "1", "Atletico-MG", "2"].
Converter o número de gols de string para inteiro

# Programa Atual
1. Receber uma lista de strings que representa os resultados dos jogos do brasileirão
1. Para cada string dessa lista de resultados gerar uma lista de strings contendo 4 elementos [anfitriao, anfitriao_gols, visitante, visitante_gols] e retorna uma 
lista de lista de strigs
1. Com essa lista de lista de strings coletar os times que jogaram durante o campeonato e salvar eles em um lista de times, onde cada time é único
1.







