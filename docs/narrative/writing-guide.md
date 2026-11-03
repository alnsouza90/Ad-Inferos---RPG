# Guia de roteiro e conteúdo

Versão 1.0 · base: GDD v1.1 §9 e §10 · vale para **todo** texto exibido no jogo

## 1. Quem escreve

- O responsável (Alan) decide e aprova todo texto narrativo, com apoio de IA.
- O agente de código **nunca** escreve texto narrativo final, citação, oração, fato sobre santo ou relíquia. Ele usa marcadores `[[TEXTO A ESCREVER: descrição]]` e avisa.
- Textos de interface (botões, descrições de habilidade) podem ser propostos pelo agente, mas ficam marcados para revisão.

## 2. Hierarquia de fontes

| Nível | Fonte | Uso |
| --- | --- | --- |
| 1 | Sagrada Escritura e Catecismo | Fundamentos da fé |
| 2 | Tradição, Padres da Igreja, liturgia, hagiografia | Vidas dos santos (separando fato, tradição e lenda) |
| 3 | Literatura apocalíptica (ex.: 1 Enoque, não canônico) | Anjos caídos |
| 4 | Dante, *Divina Comédia* | Geografia e simbolismo, nunca doutrina |
| 5 | Demonologia histórica (Binsfeld, Weyer, Collin de Plancy) | Figuras demoníacas, como tradições |
| 6 | Licença poética | Criações do jogo, sempre identificadas |

Todo texto de lore declara `origin` (`narrative-system.md` §6).

## 3. Regras firmes

1. **Nunca inventar** citações, martírios, milagres, relíquias, orações ou datas. Sem fonte confiável, não entra; ou entra marcado como criação do jogo.
2. Citações bíblicas com livro, capítulo e versículo; tradução de domínio público ou própria.
3. Orações com autoria indicada (do próprio santo, tradicional, devoção posterior). Nunca como fórmula mágica.
4. Figuras sagradas (Deus, Cristo, Nossa Senhora, São José) nunca dão bônus nem viram unidade.
5. Santos nunca pecam, nunca são sexualizados e não perdem a santidade; desolação é provação, não queda.
6. Demônios podem blasfemar, mas o texto nunca dá razão a eles.
7. Almas condenadas mostradas com humanidade, sem relativizar o pecado e sem caricatura.
8. Proibido: ato sexual explícito, criança como vítima, método de suicídio, profanação de santos e figuras sagradas, figuras de outras religiões.
9. Fora do Martirológio, nenhuma explicação doutrinal passa de **três frases**.
10. As almas inspiradas em Dante **não** usam o nome original do poema; a inspiração fica no Arquivo.

## 4. Tom e estilo

- Português do Brasil, registro sóbrio e um pouco solene, sem arcaísmos forçados.
- Frases curtas na tela de combate; no máximo 3 linhas por página de diálogo em evento.
- Demônios: tentadores, sedutores, irônicos; nunca cômicos.
- Santos: falam a partir da própria vida e escritos; cada um tem voz reconhecível (Jorge direto e cavaleiresco; Bento sereno e firme; Teresinha simples e confiante).
- Resistir à tentação é sempre apresentado como vitória.

## 5. Formatos

### 5.1 Eventos

Formato YAML de `narrative-system.md` §3, um arquivo por evento em `docs/narrative/events/<circulo>/`.

### 5.2 Testemunho no flashback

Uma fala por santo presente, de 1 a 2 frases, ligada a um fato ou escrito do santo (com a origem anotada em comentário no arquivo).

### 5.3 Ficha do Martirológio (santos e arcanjos)

```markdown
# <Nome> — <título>
- Época e lugar:
- Contexto:
- Biografia (fatos documentados):
- Tradição e lenda (marcadas como tal):
- Virtudes:
- Obras e escritos:
- Martírio (se houver):
- Memória litúrgica (data real):
- Relação com o jogo:
- Oração ou referência devocional (com autoria):
- Relíquias com fundamento:
- Divergências do jogo em relação às fontes:
- Fontes consultadas:
```

### 5.4 Entrada do Arquivo de Santo Tomás

Nome · descrição · origem · divergências do jogo · fontes.

## 6. Lista de textos a produzir (versão 1)

| Tipo | Quantidade | Marco |
| --- | --- | --- |
| Prólogo e cena dos portões de Dite | 2 cenas | M2 / M3 |
| Flashbacks (um por círculo) com testemunhos | 9 | M2–M4 |
| Encontros com almas | 9 | M2–M3 |
| Tentações (pelo menos 1 por círculo) | 9+ | M1–M3 |
| Conselhos da vila | 9 | M2–M4 |
| Missões de Intercessão | 2 | M4 |
| Finais e epílogo | 3 + 1 | M4 |
| Fichas do Martirológio | 12 santos + 3 arcanjos + guardiões | M2–M4 |
| Entradas do Arquivo | Demônios, almas, lugares | M3–M4 |
| Descrições de habilidades, relíquias e condições | Todas | Revisão no M2 |

## 7. Revisão

- Revisão teológica antes do M4 por pessoa com formação (a definir).
- Checklist antes de aprovar um texto: fonte indicada · regra 3 respeitada · tamanho dentro do limite · voz do santo coerente.
