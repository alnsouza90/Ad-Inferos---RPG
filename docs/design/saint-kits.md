# Kits dos santos (v1)

Gerado a partir de `docs/balance/saints.csv`, `abilities.csv`, `traits.csv` e `camp_skills.csv` em 03/11/2026. **Os CSVs são a fonte de verdade**; este arquivo é a versão de leitura. Números são proposta inicial, a calibrar pelo simulador.

## 1. Regras de montagem

- 6 habilidades por santo: 4 básicas (custo 0 ou 1) e 2 de Fervor (custo 2); o santo equipa 4. Milagre fixo, custo 3.
- Todo santo tem uma básica de custo 0 utilizável de qualquer posição (P1) e uma básica de dano (P5).
- Todo conjunto equipado precisa ter ao menos uma habilidade de custo 0, para que o santo possa agir em Noite Escura.
- Posições: 1 = vanguarda, 2 = centro, 3 = retaguarda. Alvos inimigos: posições 1 a 4.
- Amparo = ficha que corta o próximo golpe pela metade. Proteção = atributo de armadura.
- Coluna Origem: de onde vem a inspiração (hagiografia, tradição, lenda ou criação do jogo). Nada aqui entra no Martirológio sem pesquisa.
- Melhoria (versão +): regra geral de `specs/village-economy.md` §9.

## 2. Elenco

### São Jorge

Combatente · Protetor · posições 1, 2 · Inicial · afinidade Soldados de Cristo

**Atributos (nível 1):** Vigor 32 · Proteção 2 · Fé 4 · Vontade 1 · por nível +4 Vigor e +1 Fé

**Traço — Duelo:** O primeiro inimigo atingido por Jorge em cada combate entra em Duelo.

**Pouso — Guarda:** Chance de emboscada pela metade neste Pouso.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Estocada ★ | Básica | 0 | 1,2 | Inimigo (1,2) | 7 Golpe | Golpe de lança na linha de frente. | jogo |
| Golpe de Escudo ★ | Básica | 1 | 1 | Inimigo (1) | 4 Golpe · +1 Atordoamento | Golpe curto que atordoa. | jogo |
| Escudo Erguido ★ | Básica | 0 | 1,2,3 | Aliado (1,2,3) | +1 Amparo | Dá 1 Amparo a um aliado. | jogo |
| Arremesso | Básica | 0 | 2,3 | Inimigo (2,3,4) | 5 Golpe | Lança arremessada contra a retaguarda. | jogo |
| Desafio Formal ★ | Fervor | 2 | 1,2 | Inimigo (1,2,3,4) | +1 Duelo · +1 Força (em si) | Desafia um inimigo para o Duelo e ganha 1 Força. | lenda |
| Investida do Cavaleiro | Fervor | 2 | 1 | Inimigo (1,2) | 12 Golpe | Investida pesada contra a frente inimiga. | jogo |
| Lança do Dragão | Milagre | 3 | 1,2 | Inimigo (1,2,3) | 12 Golpe ×2 vs elite/chefe | A lança que venceu o dragão: dano dobrado contra elites e chefes. | lenda |

★ = equipada por padrão.

### São Bento

Exorcista · Protetor · posições 1, 2 · Inicial · afinidade Pais do Monaquismo

**Atributos (nível 1):** Vigor 28 · Proteção 1 · Fé 6 · Vontade 1 · por nível +3 Vigor e +1 Fé

**Traço — Clausura:** Aliados adjacentes a Bento não podem ser deslocados e recebem 20% menos desolação.

**Pouso — Lectio Divina:** −15 de desolação em toda a equipe.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Cruz de São Bento ★ | Básica | 0 | 1,2,3 | Inimigo (1,2,3) | 6 Exorcismo | Exorcismo com a cruz. | tradição |
| Ora et Labora ★ | Básica | 0 | 1,2,3 | Aliado (1,2,3) | −10 desolação · remove Corrupção | −10 de desolação e −1 de Corrupção num aliado. | tradição |
| A Regra ★ | Básica | 1 | 1,2 | Todos os aliados | +1 Amparo | A Regra ordena a companhia: 1 Amparo para todos. | hagiografia |
| Báculo | Básica | 0 | 1 | Inimigo (1) | 6 Golpe | Golpe de báculo. | jogo |
| Crux Sacra ★ | Fervor | 2 | 1,2 | Grupo (1,2) | 6 Exorcismo | Exorcismo contra a linha de frente. | tradição |
| O Cálice Partido | Fervor | 2 | 1,2,3 | Inimigo (1,2,3,4) | retira fichas positivas · 8 Exorcismo | O cálice envenenado se parte: retira as fichas positivas e fere. | hagiografia |
| Vade Retro | Milagre | 3 | 1,2 | Inimigo (1,2) | 8 Exorcismo · empurra 2 · +1 Atordoamento | Empurra 2 posições e atordoa. | tradição |

★ = equipada por padrão.

### Santa Teresinha

Curador · posições 3, 2 · Inicial · afinidade Carmelo

**Atributos (nível 1):** Vigor 22 · Proteção 0 · Fé 7 · Vontade 1 · por nível +3 Vigor e +1 Fé

**Traço — Pequeno Caminho:** A cada 3 habilidades básicas usadas, a próxima cura de Teresinha custa 0 de Fervor.

**Pouso — Pequenos Sacrifícios:** Cura 15% da vida máxima de toda a equipe.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Oração Ardente ★ | Básica | 0 | 1,2,3 | Inimigo (1,2,3,4) | 4 Exorcismo | Pequeno exorcismo a qualquer distância. | jogo |
| Pétala de Rosa ★ | Básica | 0 | 2,3 | Aliado (1,2,3) | cura 7 | Cura um aliado. | jogo |
| Confiança ★ | Básica | 0 | 2,3 | Aliado (1,2,3) | −12 desolação | −12 de desolação num aliado. | jogo |
| Oferecimento | Básica | 1 | 2,3 | Todos os aliados | cura 3 · −5 desolação | Cura leve e alívio para todos. | jogo |
| Abandono ★ | Fervor | 2 | 2,3 | Aliado caído | levanta com 30% | Levanta um aliado Caído com 30% da vida. | jogo |
| Pequena Flor | Fervor | 2 | 2,3 | Todos os aliados | cura 6 | Cura em área. | jogo |
| Chuva de Rosas | Milagre | 3 | 1,2,3 | Todos os aliados | cura 10 · −15 desolação | Cura todos e alivia a desolação. | tradição |

★ = equipada por padrão.

### São Nicolau de Mira

Intercessor · Protetor · posições 2 · Semana 3 (Natal) · afinidade —

**Atributos (nível 1):** Vigor 28 · Proteção 1 · Fé 6 · Vontade 2 · por nível +3 Vigor e +1 Fé

**Traço — Caridade:** Provisões aplicadas por Nicolau num aliado têm efeito dobrado.

**Pouso — Pão Partilhado:** O descanso neste Pouso não consome o Pão.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Báculo de Mira ★ | Básica | 0 | 1,2,3 | Inimigo (1,2) | 5 Golpe | Golpe com o báculo de bispo. | jogo |
| Trigo dos Navios ★ | Básica | 0 | 1,2,3 | Aliado (1,2,3) | cura 5 | Cura um aliado. Lembra o trigo que Nicolau obteve para Mira na fome. | tradição |
| Repreensão de Niceia ★ | Básica | 1 | 1,2 | Inimigo (1,2) | 5 Exorcismo · remove Força | Exorcismo que retira a Força do alvo. | lenda |
| Acalmar a Tempestade | Básica | 1 | 1,2,3 | Todos os aliados | remove Sangramento · remove Corrupção | Patrono dos marinheiros: remove 1 Sangramento e 1 Corrupção de todos. | tradição |
| Dote Secreto ★ | Fervor | 2 | 1,2,3 | Aliado (1,2,3) | +2 Força | Dá 2 Força a um aliado. | tradição |
| Os Três Inocentes | Fervor | 2 | 1,2,3 | Aliado (1,2,3) | +2 Amparo · remove Atordoamento | Dá 2 Amparo e livra do Atordoamento. | tradição |
| As Três Bolsas | Milagre | 3 | 1,2,3 | Todos os aliados | +1 Força · +1 Amparo | 1 Força e 1 Amparo para todos os aliados. | tradição |

★ = equipada por padrão.

### Santo Antão

Exorcista · Combatente · posições 1, 2 · Círculo 2 · afinidade Pais do Monaquismo

**Atributos (nível 1):** Vigor 30 · Proteção 1 · Fé 7 · Vontade 2 · por nível +4 Vigor e +1 Fé

**Traço — Ermitão:** +10% de dano a cada 25 de desolação que Antão carrega (máximo +40%).

**Pouso — Trabalho Manual:** +30 Esmolas garantidas (Antão trançava cestos no deserto).

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Sinal da Cruz ★ | Básica | 0 | 1,2,3 | Inimigo (1,2,3) | 6 Exorcismo | Os demônios fogem do sinal da cruz. | hagiografia |
| Cajado em Tau ★ | Básica | 0 | 1,2 | Inimigo (1,2) | 7 Golpe | Golpe com o cajado do eremita. | tradição |
| Vigília no Deserto ★ | Básica | 0 | 1,2,3 | Si | +8 desolação · +2 Força | Aceita a provação: +8 de desolação e 2 Força. | hagiografia |
| Desprezo do Inimigo | Básica | 1 | 1,2,3 | Inimigo (1,2,3,4) | retira fichas positivas · 4 Exorcismo | Zomba do demônio: retira as fichas positivas e fere. | hagiografia |
| As Feras do Sepulcro ★ | Fervor | 2 | 1,2 | Grupo (1,2) | 7 Golpe | Enfrenta os demônios em forma de fera. | hagiografia |
| Perseverança | Fervor | 2 | 1,2,3 | Si | +2 Amparo · −10 desolação | 2 Amparo e −10 de desolação. | hagiografia |
| Combate no Sepulcro | Milagre | 3 | 1,2 | Todos os inimigos | 8 Exorcismo · cura 8 (em si) | Exorcismo em todos os inimigos; Antão recupera 8 de vida. | hagiografia |

★ = equipada por padrão.

### Santa Joana d'Arc

Combatente · Intercessor · posições 1, 2 · Círculo 3 · afinidade Soldados de Cristo

**Atributos (nível 1):** Vigor 30 · Proteção 2 · Fé 5 · Vontade 2 · por nível +4 Vigor e +1 Fé

**Traço — Estandarte:** Enquanto Joana está na posição 1, os aliados causam 10% a mais de dano.

**Pouso — Conselho de Guerra:** A equipe começa o próximo combate com 1 Força.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Espada de Fierbois ★ | Básica | 0 | 1,2 | Inimigo (1,2) | 7 Golpe | Golpe com a espada achada em Fierbois. | hagiografia |
| Haste do Estandarte ★ | Básica | 0 | 1,2,3 | Inimigo (1,2) | 5 Golpe | Joana preferia o estandarte à espada. | hagiografia |
| Avançar | Básica | 1 | 2,3 | Inimigo (1,2) | avança 1 (em si) · 6 Golpe | Avança uma posição e golpeia. | jogo |
| A Flecha de Les Tourelles ★ | Básica | 1 | 1,2 | Si | cura 6 · +1 Força | Ferida, volta à luta: cura 6 e ganha 1 Força. | hagiografia |
| Ordem de Batalha ★ | Fervor | 2 | 1,2,3 | Todos os aliados | +1 Força | 1 Força para todos os aliados. | jogo |
| Rumo a Reims | Fervor | 2 | 1,2,3 | Todos os aliados | cura 4 · −10 desolação | Cura 4 e −10 de desolação em todos. | hagiografia |
| Libertação de Orléans | Milagre | 3 | 1,2 | Todos os inimigos | 7 Golpe | Golpe em todos os inimigos. | hagiografia |

★ = equipada por padrão.

### São João da Cruz

Intercessor · posições 2, 3 · Construção do Carmelo · afinidade Carmelo

**Atributos (nível 1):** Vigor 24 · Proteção 0 · Fé 9 · Vontade 2 · por nível +3 Vigor e +1 Fé

**Traço — Noite Escura:** Enquanto João está na equipe, os aliados têm +20% de chance de Consolação no teste de Fé.

**Pouso — Direção Espiritual:** −35 de desolação num aliado.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Palavra Ardente ★ | Básica | 0 | 1,2,3 | Inimigo (1,2,3,4) | 4 Exorcismo | Pequeno exorcismo a qualquer distância. | jogo |
| Nada, nada, nada ★ | Básica | 0 | 1,2,3 | Aliado (1,2,3) | −10 desolação | O caminho do desapego: −10 de desolação. | hagiografia |
| Fuga de Toledo | Básica | 1 | 2,3 | Aliado (1,2,3) | troca de lugar · +1 Amparo | Troca de lugar com um aliado e dá 1 Amparo a ele; o aliado não gasta ação. | hagiografia |
| Cântico Espiritual ★ | Básica | 1 | 2,3 | Todos os aliados | −6 desolação | −6 de desolação em todos. | hagiografia |
| Na Noite Escura ★ | Fervor | 2 | 1,2,3 | Aliado (1,2,3) | −25 desolação | −25 de desolação num aliado; −40 se ele estiver em Noite Escura. | hagiografia |
| Subida do Monte Carmelo | Fervor | 2 | 1,2,3 | Aliado (1,2,3) | +1 Força · +1 Amparo · −10 desolação | 1 Força, 1 Amparo e −10 de desolação. | hagiografia |
| Chama Viva de Amor | Milagre | 3 | 1,2,3 | Todos os aliados | −20 desolação · 5 Exorcismo (inimigos) | −20 de desolação em todos e exorcismo em todos os inimigos. | hagiografia |

★ = equipada por padrão.

### São Padre Pio

Exorcista · Curador · posições 2 · Círculo 4 · afinidade Franciscanos

**Atributos (nível 1):** Vigor 26 · Proteção 1 · Fé 8 · Vontade 2 · por nível +3 Vigor e +1 Fé

**Traço — Bilocação:** Uma vez por rodada, Pio troca de lugar com um aliado adjacente sem gastar ação.

**Pouso — Alívio do Sofrimento:** Cura 50% da vida máxima de um aliado.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| O Terço ★ | Básica | 0 | 1,2,3 | Inimigo (1,2,3) | 6 Exorcismo | "O terço é a arma": exorcismo. | tradição |
| Bênção do Frade ★ | Básica | 0 | 1,2,3 | Aliado (1,2,3) | cura 6 | Cura um aliado. | jogo |
| Confessionário ★ | Básica | 1 | 1,2,3 | Aliado (1,2,3) | remove Corrupção · −6 desolação | Remove toda a Corrupção e −6 de desolação. | hagiografia |
| Leitura das Almas | Básica | 1 | 1,2,3 | Inimigo (1,2,3,4) | retira fichas positivas · 3 Exorcismo | Vê através do disfarce: retira as fichas positivas e fere. | hagiografia |
| Casa Alívio do Sofrimento | Fervor | 2 | 1,2,3 | Todos os aliados | cura 6 | Cura 6 em todos. | hagiografia |
| Combate Espiritual ★ | Fervor | 2 | 1,2,3 | Inimigo (1,2,3) | 11 Exorcismo | As lutas noturnas contra o demônio: exorcismo forte. | hagiografia |
| Estigmas | Milagre | 3 | 1,2,3 | Todos os inimigos | custa 15% da vida · 8 Exorcismo · cura 6 (aliados) | Custa 15% da vida de Pio: exorcismo em todos os inimigos e cura 6 em todos os aliados. | hagiografia |

★ = equipada por padrão.

### Santa Rita de Cássia

Curador · Protetor · posições 2 · Círculo 5 · afinidade —

**Atributos (nível 1):** Vigor 26 · Proteção 1 · Fé 7 · Vontade 2 · por nível +3 Vigor e +1 Fé

**Traço — Causas Impossíveis:** Curas e Amparo de Rita valem o dobro num aliado abaixo de 25% de vida.

**Pouso — Cuidado das Feridas:** Remove o ferimento leve de um aliado.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Espinho ★ | Básica | 0 | 1,2,3 | Inimigo (1,2,3) | 5 Exorcismo | A ferida do espinho na fronte: exorcismo. | hagiografia |
| Bálsamo ★ | Básica | 0 | 1,2,3 | Aliado (1,2,3) | cura 5 | Cura um aliado. | jogo |
| Paciência | Básica | 0 | 1,2,3 | Aliado (1,2,3) | +1 Amparo | Dá 1 Amparo a um aliado. | hagiografia |
| Pacificadora ★ | Básica | 1 | 2,3 | Inimigo (1,2,3) | 3 Exorcismo · +1 Atordoamento | Apazigua o inimigo: fere e atordoa. | hagiografia |
| Última Esperança ★ | Fervor | 2 | 1,2,3 | Aliado (1,2,3) | cura 12 | Cura forte num aliado. | jogo |
| As Abelhas de Cássia | Fervor | 2 | 1,2,3 | Todos os inimigos | 3 Golpe | Abelhas brancas picam todos os inimigos. | lenda |
| Rosa no Inverno | Milagre | 3 | 1,2,3 | Aliado (1,2,3) | levanta com 40% | Levanta um aliado Caído com 40% da vida; num aliado de pé, cura 40% da vida. | lenda |

★ = equipada por padrão.

### Santo Antônio de Pádua

Intercessor · Exorcista · posições 2, 3 · Círculo 6 · afinidade Franciscanos

**Atributos (nível 1):** Vigor 24 · Proteção 0 · Fé 8 · Vontade 2 · por nível +3 Vigor e +1 Fé

**Traço — Achados:** Em cada combate, a primeira provisão usada pela equipe não é consumida.

**Pouso — Achados:** Revela o conteúdo da próxima camada do mapa.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Pregação ★ | Básica | 0 | 1,2,3 | Inimigo (1,2,3,4) | 5 Exorcismo | Exorcismo a qualquer distância. | hagiografia |
| Pão dos Pobres ★ | Básica | 0 | 1,2,3 | Aliado (1,2,3) | cura 4 · −4 desolação | Cura 4 e −4 de desolação. | tradição |
| Martelo dos Hereges ★ | Básica | 1 | 1,2,3 | Inimigo (1,2,3,4) | 8 Exorcismo | Exorcismo forte. | tradição |
| Achar o Perdido | Básica | 0 | 1,2,3 | Si | +1 Fervor | +1 de Fervor para a equipe. Uma vez por combate. 1×/combate. | tradição |
| Conversão ★ | Fervor | 2 | 1,2,3 | Inimigo (1,2,3,4) | 6 Exorcismo · +1 Atordoamento | Fere e atordoa. | hagiografia |
| O Saltério Roubado | Fervor | 2 | 1,2,3 | Todos os inimigos | retira fichas positivas | Retira as fichas positivas de todos os inimigos. | lenda |
| Sermão aos Peixes | Milagre | 3 | 1,2,3 | 2 posições escolhidas | 6 Exorcismo · +1 Atordoamento | Atordoa e fere os inimigos de duas posições escolhidas. | lenda |

★ = equipada por padrão.

### São Sebastião

Protetor · posições 1 · Círculo 7 · afinidade Soldados de Cristo

**Atributos (nível 1):** Vigor 34 · Proteção 3 · Fé 5 · Vontade 1 · por nível +5 Vigor e +1 Fé

**Traço — Sobrevivente:** Na primeira queda de cada combate, Sebastião se levanta com 1 de vida.

**Pouso — Sentinela:** A equipe começa o próximo combate com 1 Amparo.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Gládio ★ | Básica | 0 | 1,2 | Inimigo (1,2) | 6 Golpe | Golpe do soldado da guarda. | tradição |
| Escudo da Guarda ★ | Básica | 0 | 1,2,3 | Si | +1 Amparo | Ganha 1 Amparo. | jogo |
| Tribuno da Guarda ★ | Básica | 1 | 1,2 | Si | +1 Provocação · +1 Amparo | Provocação e 1 Amparo: os inimigos miram Sebastião. | tradição |
| Encorajar os Presos | Básica | 0 | 1,2,3 | Aliado (1,2,3) | −8 desolação | Como encorajou os cristãos presos: −8 de desolação. | tradição |
| Os Cuidados de Irene ★ | Fervor | 2 | 1,2,3 | Si | cura 12 · remove Sangramento | Cura 12 e remove o Sangramento. | tradição |
| Diante do Imperador | Fervor | 2 | 1 | Inimigo (1,2) | 9 Golpe · +1 Provocação (em si) | Golpe forte e Provocação. | tradição |
| Muralha de Flechas | Milagre | 3 | 1,2 | Si | +1 Provocação · +3 Amparo · +1 Amparo (aliados) | Provocação e 3 Amparo em Sebastião; 1 Amparo nos aliados. | tradição |

★ = equipada por padrão.

### Santa Gertrudes

Curador · Intercessor · posições 3 · Marco 3 do Purgatório · afinidade Pais do Monaquismo

**Atributos (nível 1):** Vigor 22 · Proteção 0 · Fé 8 · Vontade 2 · por nível +3 Vigor e +1 Fé

**Traço — Almas Benditas:** No início de cada rodada, remove 1 pilha de condição negativa do aliado com mais pilhas.

**Pouso — Ofício dos Defuntos:** +1 Sufrágio ao fim da expedição.

| Habilidade | Tipo | Custo | De | Alvo | Números | Efeito | Origem |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Salmodia ★ | Básica | 0 | 1,2,3 | Inimigo (1,2,3,4) | 4 Exorcismo | O canto do coro: pequeno exorcismo. | hagiografia |
| Purificar ★ | Básica | 0 | 2,3 | Aliado (1,2,3) | remove 2 pilha(s) negativa(s) | Remove 2 pilhas de condições negativas. | jogo |
| O Arauto ★ | Básica | 1 | 2,3 | Aliado (1,2,3) | remove 10 pilha(s) negativa(s) · cura 3 | Remove todas as condições negativas e cura 3. | hagiografia |
| Lembrança dos Defuntos | Básica | 0 | 1,2,3 | Aliado (1,2,3) | −8 desolação | −8 de desolação. | tradição |
| Coro de Helfta ★ | Fervor | 2 | 1,2,3 | Todos os aliados | remove 1 pilha(s) negativa(s) · cura 4 | Remove 1 pilha negativa e cura 4 em todos. | hagiografia |
| Oração pelas Almas | Fervor | 2 | 1,2,3 | Todos os aliados | −12 desolação | −12 de desolação em todos. | tradição |
| Sufrágio | Milagre | 3 | 1,2,3 | Todos os aliados | cura 6 +1/marco · remove 10 pilha(s) negativa(s) | Cura 6 (+1 por marco do Purgatório) e remove todas as condições negativas. | tradição |

★ = equipada por padrão.

## 3. Pendências

- **Carismas:** os 2 Carismas de cada santo (nomes no GDD §3) trocam até 2 habilidades e o traço; as variantes serão propostas antes do M3.
- **Pesquisa:** confirmar as origens marcadas como tradição ou lenda antes do Martirológio (ex.: espada de Fierbois, Passio de São Sebastião, episódio de Niceia).
- **Almas Benditas (Gertrudes):** ajustado para o início de cada **rodada**; no início do combate não há condições a remover.
