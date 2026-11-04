# Ad Inferos: A Companhia dos Santos

RPG tático por turnos para Android. Uma companhia de três santos segue um Peregrino pelos nove círculos do Inferno de Dante para libertar sua alma. Fantasia sombria de inspiração católica, classificação 18 anos, projeto de portfólio.

## Onde está cada coisa

| Pasta ou arquivo | Conteúdo |
| --- | --- |
| `CLAUDE.md` | Instruções permanentes para o agente de desenvolvimento |
| `docs/gdd/` | Game Design Document v1.1 (visão e intenção) |
| `docs/art/` | Direção de Arte v1.1 e pipeline técnico de assets |
| `docs/specs/` | Especificações exatas de cada sistema |
| `docs/data-schemas.md` | Formato dos dados do jogo |
| `docs/balance/` | Todos os números, em CSV |
| `docs/architecture.md` | Organização do código |
| `docs/adr/` | Registros de decisões técnicas |
| `docs/glossary.md` | Termos oficiais em português e em inglês |
| `docs/ui/screens.md` | Telas, navegação e layout do combate |
| `docs/narrative/` | Guia de roteiro e textos do jogo |
| `docs/testing.md` | Plano de testes e critérios de validação |
| `docs/roadmap.md` | Marcos M0 a M4 |
| `docs/backlog/` | Tarefas de cada marco, prontas para o agente |
| `game/` | Projeto Godot |
| `art_source/` | Arquivos originais de arte (fora do projeto Godot) |
| `tools/` | Scripts externos (arte, balanceamento) |

## Primeiros passos (configuração)

1. Instalar o Godot 4 estável (série 4.7) e confirmar com `godot --version`.
2. Instalar o Git e o Git LFS (`git lfs install`).
3. Clonar este repositório.
4. Abrir o Claude Code na raiz do repositório e começar pela tarefa `T00` de `docs/backlog/m0.md`.

## Jogar a versão de teste

### No navegador (qualquer aparelho)

Abra https://alnsouza90.github.io/Ad-Inferos---RPG/ com o celular deitado. A página é atualizada a cada mudança aprovada (`.github/workflows/pages.yml`).

### No Android (APK)

1. No celular, abra https://github.com/alnsouza90/Ad-Inferos---RPG/releases/tag/teste-android
2. Em "Assets", toque em **ad-inferos.apk** para baixar.
3. Abra o arquivo baixado. Na primeira vez o Android pede para **permitir instalar apps desta fonte** (o navegador ou o gerenciador de arquivos): permita e volte.
4. Toque em **Instalar**. Se o Play Protect avisar que o app é desconhecido, escolha **Instalar mesmo assim**: é a versão de teste, assinada com uma chave de depuração.
5. Para atualizar, repita os passos: a nova versão instala por cima da antiga. Se o Android recusar ("conflito de pacote"), desinstale a anterior antes.

O APK é montado pelo GitHub a cada mudança aprovada (`.github/workflows/android.yml`).

### O que tem na versão de teste (M0)

- **Arena:** escolha um dos 4 encontros e a semente (o "número da sorte" que define os desempates e os testes de Fé) e toque em **Começar**.
- **Combate:** toque no santo, na ação, no alvo para ver a prévia e no alvo de novo para confirmar.
- **Botões de teste** (só nesta versão): +25 e −25 de desolação e Consolação para o santo escolhido, para ver a auréola mudar.

## Estado atual

Marco **M0 — protótipo de combate** em andamento: combate completo com Jorge, Bento e Teresinha contra a Família A, tela de combate, auréola e a arte piloto de São Jorge. Andamento detalhado em `docs/memory/progress.md`.
