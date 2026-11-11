# Dossiê de contexto · Ad Inferos

Versão 1.0 · 11/11/2026 · resumo para um consultor (modelo de IA) que vai analisar o jogo sem ler o projeto inteiro. Tudo aqui vem dos documentos do repositório. Quando precisar de detalhe, abra **só** o arquivo indicado no §9.

---

## 1. O jogo em poucas linhas

- **O que é:** RPG tático por turnos para **Android, em paisagem**, feito em **Godot 4.7** (GDScript tipado). Classificação 18 anos.
- **Modelo:** projeto de portfólio, sem compras no jogo.
- **Premissa:** uma companhia de **três santos católicos** segue um **Peregrino** vivo (alegoria de toda pessoa) pelos **nove círculos do Inferno de Dante** para resgatar sua alma.
- **A verdade da história:** o Peregrino está morrendo numa cama, e a viagem é a alegoria das falhas da vida dele. O jogo segue a *Comédia*: Inferno, Purgatório e Paraíso, com final único (D-198, D-199).
- **Responsável:** Alan decide design, narrativa, tom, arte e prioridades. Ele não é programador: fale em **português do Brasil**, em linguagem simples.
- **Implementação:** um agente (Claude) implementa e testa. Cada decisão fica em `docs/memory/decisions.md` (D-xxx).
- **Referências declaradas** (GDD §1):
  - **Darkest Dungeon I e II:** posições, mover gasta a ação, vila com instalações, tocha, acampamento, estresse. Ficam de fora a morte permanente e os heróis descartáveis.
  - **Slay the Spire:** mapa de nós e intenções visíveis, energia por turno, Ascensão.
  - **Sir Brante:** escolhas com requisitos visíveis.
  - **Fear & Hunger:** risco visível nas Tentações, sem crueldade aleatória.

**Princípios do GDD:**
1. Base nas fontes (Dante, Escritura, tradição), sempre como alegoria.
2. Divergências das fontes são registradas, não viram mecânica.
3. Simplicidade: uma ideia só vira mecânica se melhorar uma decisão do jogador.
4. Reverência: a vitória final pertence a Cristo.
5. Legibilidade no celular.

## 2. Regras que não podem ser quebradas

1. **Combate determinístico** (ADR-0003, reconfirmado em D-262):
   - habilidades sempre acertam; não há esquiva nem erro;
   - crítico só por efeito explícito;
   - a pré-visualização mostra o resultado exato;
   - o acaso fica no teste de Fé, nas Tentações, nas recompensas e no mapa.
2. **Santos nunca pecam**, nunca são sexualizados e **nunca perdem o controle** das próprias ações. Desolação é provação, não queda (`writing-guide.md` §1, `desolation.md`).
3. **Figuras sagradas** (Deus, Cristo, Nossa Senhora, São José) nunca viram unidade, atributo ou fonte de bônus. Aparecem só como cena.
4. **Sufrágios nunca são gastos**: avançam a Trilha do Purgatório como "gratidão das almas", nunca como compra.
5. **Santos nunca são comprados.** Cada santo chega por uma **mecânica de desbloqueio**, inclusive os de expansões futuras (D-262).
6. Nenhuma criança como vítima, nenhum ato sexual explícito. Todo texto de lore indica a origem (Escritura, tradição, lenda, Dante, apócrifo, demonologia ou criação do jogo).
7. **O agente não inventa** regras, números, textos narrativos, citações, fatos de santos, orações ou relíquias: propõe, e Alan aprova.
8. **Arquitetura:**
   - regras puras em `game/core/` (sem cena, sem arquivo);
   - apresentação em `game/scenes/`, que nunca decide regra;
   - conteúdo em dados (`docs/balance/*.csv` → Resources);
   - todo número de balanceamento só nos CSVs;
   - toda ação do jogador vira comando registrado em log;
   - todo acaso usa RNG com semente;
   - só 3 serviços globais.

## 3. Laço de jogo

```text
Vila (Átrio, fora do tempo) ──semana──► Planejar a semana ──► Mapa do Inferno ──► Expedição
   ▲                                                                              │
   └──── volta: Esmolas, experiência, ferimentos, desolação, Conselho ◄───── Chefe / Retirada / Derrota
```

- **Campanha:** ano litúrgico de **20 semanas** (Advento, Natal, Tempo Comum, Quaresma, Páscoa), com efeitos por tempo e festas dos santos. Cada expedição ou **Retiro** avança uma semana.
- **Ritmo de cada círculo:**
  1. flashback antes (a tentação);
  2. expedição (combates, Tentações, Encontro com uma alma);
  3. chefe;
  4. flashback depois (queda e lição, com o testemunho dos santos);
  5. vinheta do leito;
  6. Conselho da vila.
- **Virtudes do Peregrino:** Fé, Esperança e Caridade, de 0 a 5. Mudam nas escolhas e definem a versão do ato de contrição e o tempo no Purgatório.

## 4. Sistemas e números-chave

(fonte: `docs/specs/` e `docs/balance/constants.csv`)

**Combate**
- **Formação:**
  - santos nas posições 1 a 3, inimigos de 1 a 4 (inimigo grande ocupa 2 ou 3 posições);
  - trocar de posição gasta a ação de quem se move;
  - empurrar e puxar são movimentos forçados.
- **Rodada:**
  1. início (+3 de Fervor, máximo 6; inimigos escolhem e **mostram** as intenções);
  2. turno da equipe (cada santo age uma vez, na ordem escolhida);
  3. turno dos inimigos;
  4. ambiente do círculo (`HAZARD`).
- **Santos:**
  - 6 habilidades, das quais 4 equipadas (sempre pelo menos uma de custo 0);
  - 1 milagre de Fervor;
  - 1 traço passivo;
  - 2 Carismas no nível 3.
- **Dano:**
  - tipos: Golpe, Exorcismo, sem tipo;
  - inimigos Corpóreos são fracos a Golpe (×1,25 / ×0,75); Espirituais, o contrário;
  - Proteção (`armor` 0–3) reduz; mínimo de 1;
  - multiplicadores: Força ×1,25, Amparo ×0,5, Duelo de Jorge ×1,25, afinidades ×1,1.
- **Condições:** Atordoamento, Sangramento, Corrupção (dá desolação), Amparo, Força, Provocação, Duelo, Congelamento (Círculo 9), Fúria (inimigos, Círculo 5), Torpor (santos, Círculo 5). No máximo 3 ícones por personagem.
- **Queda:**
  - um santo Caído pode ser levantado em até 2 rodadas;
  - derrota com os 3 caídos;
  - quem caiu sai com ferimento leve, ou grave se cair duas vezes.
- **Afinidades** (2 membros na equipe): Carmelo (desolação ×0,85), franciscanos (+1 de Fervor), monges (Exorcismo ×1,1), soldados (Golpe ×1,1).
- **Restos ocupando a posição:** existe no motor; Alan decidiu ligar em **todos os Corpóreos** (D-262).

**Desolação** (cada santo, de 0 a 200, persistente)
- **Ganhos:**
  - fim de combate: 20 (elite 20, chefe 35);
  - aliado caído: 15;
  - Corrupção: 3 por pilha;
  - ações espirituais dos inimigos (inclusive em área);
  - multiplicadores: Lume baixo ×1,3, Quaresma ×1,25, Consolação ×0,5.
- **Aos 100, teste de Fé:** chance = mínimo(60%, 10% + 4% × Fé).
  - Sucesso: **Consolação** (desolação volta a 50; dano e cura ×1,15; ganho de desolação ×0,5).
  - Falha: **Noite Escura** (só habilidades de custo 0; acaba abaixo de 50 e gera Purificação, com +25% de experiência).
- **Aos 200, Prostração:** cai sem levantar, ferimento grave e volta a 150.
- **Recuperação:** Vigília −20, Água Benta −15, Capela −15 por semana, Jardim −50 por semana, habilidades.
- **Meta de calibração:** de 0,5 a 1,5 Noites Escuras por expedição longa (D-126).

**Expedição** (cada círculo tem 3 trechos)
- **Mapa:** em camadas, de 8 a 12 espaços, com bifurcações. A visibilidade depende do Portão e do Incenso.
- **Nós:** combate, elite, Tentação, Encontro com alma, relíquia (30% guardada), Pouso, Vigília, chefe.
- **Lume:**
  - começa em 100 (75 ao retomar de um Pouso); perde 5 por nó; a Vela dá +25;
  - de 75 a 100: emboscada no Pouso ×0,5;
  - de 25 a 74: neutro;
  - de 0 a 24: desolação ×1,3, inimigos +10% de dano, Esmolas ×1,5.
  - **Alan acha o Lume fraco.** Vão ser simuladas 4 variantes (D-262): desolação ao andar no escuro, uma faixa de "Escuridão", o efeito da faixa visível na tela e −7 por nó.
- **Provisões:** 8, 10 ou 12 espaços pelo nível do Portão, 1 unidade por espaço; no combate, no máximo 1 por turno, sem gastar ação.
  - Pão: cura 5 e é o descanso do Pouso.
  - Vela: +25 de Lume.
  - Água Benta: tira Corrupção e −15 de desolação.
  - Ataduras: tiram Sangramento.
  - Incenso: revela uma camada ou anula a emboscada.
- **Pouso:**
  - consagra e garante as Esmolas;
  - descansar custa 1 Pão;
  - atividades: Vigília, Partilha (cura 30% de um aliado), Oração (+1 de Fervor) ou a atividade própria do santo;
  - emboscada com 25% de chance.
  - Reordenar a equipe só no Pouso e na luta (D-262).
- **Recompensas** (Esmolas):
  - valores: combate 70, elite 160, chefe 300, primeira conclusão do círculo 200;
  - multiplicadores por faixa de círculo: ×1, ×2,2, ×3,6;
  - as Esmolas ficam "não garantidas" até o Pouso.
- **Retirada e derrota:**
  - retirada planejada no Pouso: sem custo;
  - retirada de emergência: perde 50% das Esmolas não garantidas, +25 de desolação e ferimento;
  - derrota: perde as Esmolas não garantidas e as relíquias.
- **Ambiente por círculo:**
  - Círculo 2, Vendaval: troca duas posições anunciadas;
  - Círculo 3, Fome: cura ×0,5 até usar Pão;
  - Círculo 4, Ouro Maldito;
  - Círculo 5, Fúria e Torpor;
  - Círculo 6, Túmulos;
  - Círculo 7, Contrapasso;
  - Círculo 8, intenções veladas;
  - Círculo 9, Congelamento.
- **Revisitas:** Escalada em 5 níveis; a recompensa cai até 25% no mesmo tempo litúrgico.

**Vila** (especificada, ainda não feita)
- **Planejar a semana:** equipe e ordem; santos na Capela ou no Jardim; níveis; Forja; relíquias; compras; Enfermaria; escolha do círculo.
- **Instalações** (3 níveis cada):

  | Instalação | Função | Abre em |
  | --- | --- | --- |
  | Capela | Sufrágios e −desolação | início |
  | Enfermaria | Ferimentos | início |
  | Despensa | Provisões | início |
  | Portão | Espaços e revelação | início |
  | Casa de Exercícios | Níveis e Carismas | após o Prólogo |
  | Forja | Equipamento | após o Prólogo |
  | Biblioteca de Santo Tomás | Arquivo (o "bestiário") e Martirológio | Círculo 3 |
  | Carmelo | Abre João da Cruz e as 7 Moradas, com bônus pequenos | Círculo 3, por 1.500 |
  | Relicário | Relíquias | Círculo 4 |
  | Jardim | −50 de desolação por semana | Círculo 5 |

  O Carmelo fica em **ruínas desde o início** e é "reformado" (D-262).
- **Economia:**
  - Esmolas são a única moeda gasta: instalações 1.500 e 2.500; equipamento 300 e 800; leito 300; provisões de 15 a 35;
  - meta: pagar 70–80% do essencial na campanha.
- **Progressão:**
  - nível 1 a 5 (experiência 40, 100, 180, 280), com melhoria de habilidade sem custo;
  - 2 espaços de equipamento (Instrumento e Hábito, 3 níveis);
  - relíquias: 1 espaço, 2 no nível 4; 25 nos dados.
- **Ferimentos:** leve (−10% num atributo, 1 semana) e grave (−20% em vida e Fé, 3 semanas, 1 com leito).
- **Santos (12):**
  - iniciais: Jorge, Bento, Teresinha;
  - Nicolau chega no Natal (semana 3);
  - Antão, Joana, Pio, Rita, Antônio e Sebastião chegam ao concluir os Círculos 2 a 7;
  - João da Cruz chega com o Carmelo;
  - Gertrudes, no marco 3 da Trilha do Purgatório.
- **Decididos para depois (D-262):**
  - relatório da semana por São Cristóvão;
  - vitrais da Capela como capítulos da história;
  - uma seção de **conquistas opcionais** num edifício, para incentivar jogar de novo;
  - falas curtas dos santos aprovadas por Alan;
  - Vestígios (objetos, obstáculos e armadilhas num só sistema, M3).

**Conteúdo da campanha:** 9 círculos, cada um com mecânica de ambiente, um guardião, um Pecado Encarnado e um chefe.
- **Chefes:** Caronte, Asmodeu (Tobias e Rafael), Belzebu, Mamom, Belfegor, Belial, Moloque, Azazel, Lúcifer (São Miguel na fase final).
- **Inimigos comuns:** em 3 famílias de 6 funções (bruto, guarda, atirador, corruptor, manipulador, invocador).
- **Números:** 19 comuns, 16 elites, 9 chefes no total.

## 5. Estado atual (11/11/2026)

| Marco | Situação |
| --- | --- |
| **M0** · combate | Feito: combate completo, simulador, arena de teste, APK |
| **M1** · trecho | Feito: mapa, Lume, provisões, Tentação, Pouso, salvamento e retomada exata |
| **M2** · fatia vertical (Prólogo + Círculo 2 + vila mínima, 45–60 min no Android) | **Em andamento.** Feitos: T33 (especificar a caminhada), T34 (pedido de arte), T35 (animação por quadros de todos os personagens do Círculo 2), **T36 (combate e mapa no clima Darkest Dungeon: preto e cinza, ferro forjado, fonte Pirata One, Lume como lamparina, auréolas no motor; PR #55)**. Faltam: T37 (caminhada interativa), T38–T44 (Círculo 2 completo, elites, Asmodeu, narrativa), T45–T50 (vila e campanha), T51 (Prólogo), T52–T54 (arte e áudio finais), T55–T57 (simulador, caça a exploits, teste no Android) |
| **M3** · produção por família | Futuro |
| **M4** · narrativa e acabamento | Futuro |

- **Testes:** 509 automáticos (GUT) passando.
- **CI:** testes, APK e versão no navegador.
- **Arte:** gerada por IA (estilo Darkest Dungeon, tinta de quadrinho, Mignola), originais em `art_source/` e no Google Drive.
- **Animação:** por quadros (stop motion), com o motor ligando as poses.

## 6. Decisões recentes que mudam o design

- **D-256 a D-261:** leiaute do combate no clima Darkest Dungeon.
  - Campo nos 720 px de cima, painel de ferro embaixo.
  - Ficha do inimigo tocado à direita.
  - Mapa da caminhada em salas e corredores.
  - Mulheres com 93% da altura dos homens.
  - Contorno vermelho no alvo da intenção.
- **D-262:** respostas de Alan à análise de Darkest Dungeon (`docs/design/analise-referencias-dd.md`); resumo nos §§2, 4 e 7 deste dossiê.
- **D-190 e D-191:** Prólogo só com cenas, sem combate de ensino; dicas curtas na primeira vez.
- **D-198 e D-199:** o Peregrino no leito de morte; final único.

## 7. Perguntas abertas

- **Tentação:** os pecados agem como **assédio dos inimigos** (condições visíveis, o santo resiste) ou ficam só como eventos do Peregrino?
- **Ordem da abertura:** abertura → título → Prólogo?
- **Santos de expansões:** qual mecânica de desbloqueio para cada um?
- **Conquistas opcionais:** em qual edifício e com que lista?
- **Variantes do Lume:** a decidir pela simulação.
- **Pendências de Alan:** kits completos de Nicolau e Gertrudes; números dos inimigos e fases dos chefes; roteiros (flashbacks, Encontros, Tentações, Conselhos); festas no ano de 20 semanas; preço do download.

## 8. O que se espera do consultor

- **Analisar e propor; não implementar.** Não edite código, dados, testes nem documentos existentes. Escreva só em `docs/fable/`.
- Respeite o §2. Uma proposta que quebre uma regra do §2 deve dizer isso e oferecer uma alternativa.
- Para cada proposta, informe:
  - o problema que resolve;
  - o impacto no jogador;
  - os sistemas afetados;
  - o custo (baixo, médio ou alto);
  - o risco;
  - se precisa de simulação.
- Números novos são **propostas** para o simulador, nunca valores finais.
- Escreva para Alan: português simples, frases curtas, sem jargão (ou com o jargão explicado).

## 9. Onde está cada coisa (abra só se precisar)

| Assunto | Arquivo |
| --- | --- |
| Regras do agente e arquitetura | `CLAUDE.md`, `docs/architecture.md` |
| Visão completa | `docs/gdd/gdd-v1.1.md` (longo; use os §§ citados aqui) |
| Combate | `docs/specs/combat.md` |
| Condições | `docs/specs/conditions.md` |
| Desolação | `docs/specs/desolation.md` |
| IA inimiga e intenções | `docs/specs/enemy-ai.md` |
| Expedição, Lume, provisões, Pouso | `docs/specs/expedition.md` |
| Narrativa, eventos, Tentação | `docs/specs/narrative-system.md` |
| Vila, calendário, economia, progressão | `docs/specs/village-economy.md` |
| Salvamento | `docs/specs/save-load.md` |
| Telas e leiaute | `docs/ui/screens.md` |
| Kits dos santos (leitura fácil) | `docs/design/saint-kits.md` |
| Números | `docs/balance/*.csv` (`constants`, `abilities`, `enemies`, `enemy_actions`, `economy`, `relics`) |
| Análise de Darkest Dungeon | `docs/design/analise-referencias-dd.md` |
| Regras de texto e tom | `docs/narrative/writing-guide.md` |
| Direção de arte | `docs/art/art-direction.md` (a parte de interface foi substituída por D-257/D-258) |
| Backlog do M2 | `docs/backlog/m2.md` |
| Decisões, lições, pendências | `docs/memory/decisions.md`, `lessons.md`, `open-questions.md` |
| Decisões técnicas | `docs/adr/0001`–`0012` |
