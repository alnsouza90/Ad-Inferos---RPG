# ADR-0008 · Auréola como elemento do motor

**Situação:** Aceita

## Contexto

Auréolas geradas na imagem variam entre santos e estados e não acompanham a desolação em tempo real.

## Decisão

Uma única textura de auréola presa à cabeça; os estados (normal, desolação, Noite Escura, Consolação) mudam parâmetros de um shader. Sprites são gerados sem auréola.

## Por quê

- Uniformidade e troca de estado instantânea.
- Menos imagens por santo.

## Consequências

- Cada personagem precisa de um ponto de cabeça definido.
