# Memória do projeto

O projeto atravessa muitas sessões do agente. **A conversa no chat não é memória**: ela é compactada (resumida) quando fica longa e some quando a sessão acaba. Tudo o que precisa sobreviver mora aqui, no repositório, e é carregado automaticamente no início de cada sessão (gancho em `.claude/settings.json`).

## Arquivos

| Arquivo | O que guarda | Quando escrever |
| --- | --- | --- |
| `progress.md` | Onde estamos: marco, próxima tarefa, ambiente, arte | Ao fim de cada tarefa |
| `decisions.md` | **Registro de decisões**, numerado e só acrescentado (nunca apagar nem reescrever) | No mesmo PR em que a decisão é aplicada |
| `owner.md` | Quem é Alan, como prefere trabalhar e receber pedidos | Quando ele expressar uma preferência nova |
| `open-questions.md` | Pendências: o que espera decisão, arte ou outro marco | Quando surgir; riscar quando resolver |
| `lessons.md` | Lições técnicas que custaram tempo (armadilhas do Godot, do GUT, do ambiente) | Logo depois de descobrir |
| `sessions.md` | Resumo curto de cada sessão do agente | Ao fim da sessão, ou antes de a conversa ficar longa |

As fontes de verdade continuam as de `CLAUDE.md` §3 (specs, CSVs, ADRs, backlog). A memória **aponta** para elas e guarda o que não cabe nelas: o porquê das decisões, preferências, pendências e o caminho percorrido.

## Protocolo do agente

1. **Início da sessão:** os arquivos desta pasta chegam pelo gancho; leia-os antes de qualquer trabalho. Se o gancho falhar, leia-os à mão.
2. **Decisão de Alan, ou técnica relevante:** registre em `decisions.md` **antes** de encerrar a resposta em que ela foi aplicada, com data, quem decidiu, o que foi decidido e onde está aplicada. Decisão revista ganha uma nova entrada que cita a anterior.
3. **Fim de tarefa:** atualize `progress.md`, a caixa no backlog e, se houver, `open-questions.md`.
4. **Conversa longa:** quando passar de mais ou menos dois terços do contexto, registre o resumo da sessão em `sessions.md` e proponha a Alan continuar numa sessão nova.
5. **Nada importante só no chat.** Se Alan disser algo que vale para o futuro, vai para um destes arquivos no mesmo dia.
6. **Todo PR** confirma no checklist (`.github/pull_request_template.md`) que a memória foi atualizada.
