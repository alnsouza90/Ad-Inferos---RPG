# Prompts de animação dos personagens (M2)

Versão 1.0 · 05/11/2026 · D-194, D-196, D-197 · testado com São Jorge no Meta AI

Prompts **completos, prontos para colar**, um bloco por clipe. Nada para substituir.

## Como usar

1. **Imagem de partida:** a imagem padrão aprovada do personagem (`body_idle`), de corpo inteiro, de lado, fundo cinza liso. Para os inimigos da Família A, se possível, regere antes o `body_idle` em PNG com fundo liso (os de agora têm o xadrez pintado).
2. **Gere cada clipe separado** no Meta AI e baixe o **GIF** (ou MP4, se tiver).
3. **Confira antes de mandar:** a arma e o escudo ficam sempre na mesma mão; o personagem não muda de tamanho nem sai do lugar; nenhum quadro com borrão, rastro ou objeto trocado de lado. Se um quadro vier errado, gere de novo só aquele clipe.
4. **Mande pelo chat** dizendo o personagem e o clipe (ex.: "Bento · andar").

**Santos:** 3 clipes (parado, andar, ações). **Inimigos, elites e chefe:** 2 clipes (parado, ações): eles não andam no corredor; a chegada é feita pelo motor.

O motor faz o resto: deslizar até o alvo, câmera, tremor, clarão, queda até o chão, auréola, partículas (pétalas, fumaça, moscas).

---

## São Jorge (`saint_george`) · feito

Os três clipes de Jorge já foram aprovados (05/11/2026). Os prompts ficam aqui para refazer, se for preciso.

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing right. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
Subtle idle breathing loop of Saint George, a young Roman officer with a red cape: standing still in a relaxed stance, the long spear held upright in his right hand and the round shield on his left arm the whole time. Only small movements: the chest slowly rising and falling, a slight shift of weight, one slow blink. The red cape always stays behind his back with the same shape; only its lower edge sways gently, never in front of the body or the shield. The feet never move. The last frame matches the first frame for a seamless loop.
```

**Andar**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing right. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A walk cycle of Saint George shown as 8 sequential key frames, each held briefly, walking in place without leaving the center of the frame. In every frame the long spear stays upright in his right hand and the round shield stays on his left arm, and the red cape trails behind him with the same shape.
1. contact: right foot forward touching the ground with the heel, left foot back on its toes;
2. down: right foot flat, knees slightly bent, body at its lowest;
3. passing: left leg swinging forward past the right leg, body rising;
4. up: standing tall on the right leg, left foot lifted just above the ground;
5. contact: left foot forward touching the ground with the heel, right foot back on its toes;
6. down: left foot flat, knees slightly bent, body at its lowest;
7. passing: right leg swinging forward past the left leg, body rising;
8. up: standing tall on the left leg, right foot lifted just above the ground, ready to loop back to frame 1.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing right. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A sequence of clear key poses by Saint George, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: spear upright and round shield at his side;
2. attack wind-up: raises the spear over the shoulder, body coiled back;
3. attack strike: lunges forward and thrusts the spear toward the right;
4. back to the ready stance;
5. defend: raises the round shield in front of the body, braced, knees bent;
6. hit reaction: recoils backward, head snapping back, grimace of pain;
7. collapse: drops to one knee, the spear and shield slipping to the ground;
8. down: slumped on the ground on his side, head bowed, motionless.
```

---

## São Bento (`saint_benedict`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing right. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
Subtle idle breathing loop of Saint Benedict, an elderly abbot with a long white beard in a black Benedictine habit: standing still in a relaxed stance, the abbot's crozier held upright in his right hand, the book of the Rule at his belt and the raven on his shoulder the whole time. Only small movements: the chest slowly rising and falling, a slight shift of weight, one slow blink. The black habit and hood keep the same shape; only the hem sways gently. The feet never move. The last frame matches the first frame for a seamless loop.
```

**Andar**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing right. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A walk cycle of Saint Benedict shown as 8 sequential key frames, each held briefly, walking in place without leaving the center of the frame. In every frame the crozier stays upright in his right hand and the raven stays on his shoulder, and the black habit sways with the same shape.
1. contact: right foot forward touching the ground with the heel, left foot back on its toes;
2. down: right foot flat, knees slightly bent, body at its lowest;
3. passing: left leg swinging forward past the right leg, body rising;
4. up: standing tall on the right leg, left foot lifted just above the ground;
5. contact: left foot forward touching the ground with the heel, right foot back on its toes;
6. down: left foot flat, knees slightly bent, body at its lowest;
7. passing: right leg swinging forward past the left leg, body rising;
8. up: standing tall on the left leg, right foot lifted just above the ground, ready to loop back to frame 1.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing right. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A sequence of clear key poses by Saint Benedict, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: crozier upright, the raven on his shoulder;
2. attack wind-up: draws the crozier close to the chest, eyes closed in prayer;
3. attack strike: steps forward and thrusts the crozier toward the right, the free hand raised in a commanding gesture of exorcism;
4. back to the ready stance;
5. defend: raises the crozier across his body with both hands, braced;
6. hit reaction: recoils backward, head snapping back, grimace of pain;
7. collapse: drops to one knee, leaning on the crozier;
8. down: slumped on the ground, head bowed, the crozier beside him, motionless.
```

---

## Santa Teresinha (`saint_therese`)

Gesto sempre devocional: o crucifixo nunca é usado como arma (D-211). As pétalas de rosa são feitas pelo motor.

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing right. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
Subtle idle breathing loop of Saint Therese, a young Carmelite nun in a brown habit, white mantle and black veil: standing still in a relaxed stance, the crucifix wrapped in roses held close to her chest the whole time. Only small movements: the chest slowly rising and falling, a slight shift of weight, one slow blink. The white mantle and the veil keep the same shape; only their edges sway gently. The feet never move. The last frame matches the first frame for a seamless loop.
```

**Andar**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing right. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A walk cycle of Saint Therese shown as 8 sequential key frames, each held briefly, walking in place without leaving the center of the frame. In every frame the crucifix wrapped in roses stays close to her chest, and the white mantle and the veil sway with the same shape.
1. contact: right foot forward touching the ground with the heel, left foot back on its toes;
2. down: right foot flat, knees slightly bent, body at its lowest;
3. passing: left leg swinging forward past the right leg, body rising;
4. up: standing tall on the right leg, left foot lifted just above the ground;
5. contact: left foot forward touching the ground with the heel, right foot back on its toes;
6. down: left foot flat, knees slightly bent, body at its lowest;
7. passing: right leg swinging forward past the left leg, body rising;
8. up: standing tall on the left leg, right foot lifted just above the ground, ready to loop back to frame 1.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing right. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A sequence of clear key poses by Saint Therese, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: crucifix wrapped in roses held close to the chest;
2. attack wind-up: draws the crucifix close, eyes closed in prayer;
3. attack strike: steps forward, the crucifix raised high in one hand and the other open hand extended toward the right in a blessing;
4. back to the ready stance;
5. defend: turns slightly away and shields herself with her raised arm, the crucifix held close;
6. hit reaction: recoils backward, head snapping back, grimace of pain;
7. collapse: drops to her knees, the crucifix held close;
8. down: slumped on the ground, head bowed, the crucifix in her hands, motionless.
```

---

# Inimigos da Família A

Todos olham para a **esquerda**. Dois clipes cada: parado e ações.

## Diabo de Lodo (`enemy_mud_devil`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
Subtle idle loop of the mud demon, a hulking hunched mud demon with long dragging arms and a toothed mouth in its chest: staying in place with only small movements, a slow breathing or pulsing, a slight sway. Black filth drips slowly from its arms. It never leaves its place. The last frame matches the first frame for a seamless loop.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A sequence of clear key poses by the mud demon, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: hunched, long arms hanging;
2. attack wind-up: rears back raising both long arms high;
3. attack strike: swings both long arms down in a crushing overhead slam toward the left, the chest mouth roaring;
4. back to the ready stance;
5. defend: hunches and covers its head with its long arms;
6. hit reaction: recoils backward, the chest mouth gaping in pain;
7. collapse: slumps forward onto its knees, arms dragging;
8. down: collapsed in a heap of mud, motionless.
```

## Escaravelho Infernal (`enemy_infernal_scarab`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
Subtle idle loop of the infernal beetle, a man-sized infernal beetle standing on its hind legs with a thick cracked carapace and serrated mandibles: staying in place with only small movements, a slow breathing or pulsing, a slight sway. Its antennae twitch slightly. It never leaves its place. The last frame matches the first frame for a seamless loop.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A sequence of clear key poses by the infernal beetle, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: standing on its hind legs, mandibles slightly open;
2. attack wind-up: draws back, mandibles spread wide;
3. attack strike: lunges forward snapping its serrated mandibles toward the left;
4. back to the ready stance;
5. defend: pulls its head in and turns its thick carapace forward like a shield;
6. hit reaction: recoils backward, legs flailing;
7. collapse: topples onto its back legs;
8. down: lying on its back, legs curled, motionless.
```

## Moscardo (`enemy_gadfly`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The body stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
Subtle idle loop of the gadfly demon, a gaunt insect-man hybrid with membranous wings, a long proboscis and too many joints: staying in place with only small movements, a slow breathing or pulsing, a slight sway. Its wings buzz in place. It never leaves its place. The last frame matches the first frame for a seamless loop.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The body stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A sequence of clear key poses by the gadfly demon, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: hovering low, wings buzzing, proboscis pointed forward;
2. attack wind-up: pulls its head back, proboscis curled;
3. attack strike: jerks its head forward and spits a volley of stingers from its proboscis toward the left;
4. back to the ready stance;
5. defend: folds its wings around its body;
6. hit reaction: recoils backward in the air, limbs twitching;
7. collapse: falls from the air onto the ground;
8. down: lying on the ground, wings crumpled, motionless.
```

## Sombra do Desejo (`enemy_shade_of_desire`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The base of the body stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
Subtle idle loop of the shade, a tall faceless silhouette of smoke and ink with many elongated reaching hands: staying in place with only small movements, a slow breathing or pulsing, a slight sway. Its body of smoke drifts slowly, keeping the same silhouette. It never leaves its place. The last frame matches the first frame for a seamless loop.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The base of the body stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A sequence of clear key poses by the shade, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: floating upright, the long hands hanging;
2. attack wind-up: swells and draws back, hands spreading;
3. attack strike: surges forward with all its long hands reaching to grasp toward the left;
4. back to the ready stance;
5. defend: shrinks and wraps itself in its own hands;
6. hit reaction: recoils backward, its smoke torn apart;
7. collapse: sinks low, the hands going limp;
8. down: a low pool of fading smoke on the ground.
```

## Sopro Errante (`enemy_wandering_breath`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The base of the whirlwind stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
Subtle idle loop of the wandering breath, a swirling whirlwind of smoke and ink with screaming faces trapped inside it: staying in place with only small movements, a slow breathing or pulsing, a slight sway. The whirlwind turns slowly, keeping the same size and shape. It never leaves its place. The last frame matches the first frame for a seamless loop.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The base of the whirlwind stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A sequence of clear key poses by the wandering breath, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: the whirlwind spinning slowly in place;
2. attack wind-up: the whirlwind tightens and draws back;
3. attack strike: a violent gust bursts forward out of the whirlwind toward the left, the trapped faces screaming;
4. back to the ready stance;
5. defend: the whirlwind shrinks and spins faster;
6. hit reaction: the whirlwind is torn and staggers backward;
7. collapse: the whirlwind loses speed and sinks;
8. down: a few faint wisps of smoke on the ground.
```

## Mãe-Enxame (`enemy_swarm_mother`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
Subtle idle loop of the swarm mother, a bloated swollen demon covered in flies with open hive-like sores across its body: staying in place with only small movements, a slow breathing or pulsing, a slight sway. Its bloated body pulses slowly. It never leaves its place. The last frame matches the first frame for a seamless loop.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The feet stay on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A sequence of clear key poses by the swarm mother, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: bloated and swaying, sores pulsing;
2. attack wind-up: convulses and swells, sores opening;
3. attack strike: lurches forward toward the left, sores gaping wide as if releasing a swarm;
4. back to the ready stance;
5. defend: hunches and wraps its arms around its bloated body;
6. hit reaction: recoils backward, the sores spasming;
7. collapse: sags to the ground;
8. down: a collapsed bloated heap, motionless.
```

## Enxame (`enemy_swarmling`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The body stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
Subtle idle loop of the swarmling, a small infernal fly-larva demon the size of a dog with a pale bloated grub body, tiny clawed legs and a ring of teeth: staying in place with only small movements, a slow breathing or pulsing, a slight sway. Its body wriggles slightly. It never leaves its place. The last frame matches the first frame for a seamless loop.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The body stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur.
A sequence of clear key poses by the swarmling, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: crouched low on its tiny legs;
2. attack wind-up: crouches lower, ready to pounce;
3. attack strike: leaps forward toward the left with its ring of teeth wide open;
4. back to the ready stance;
5. defend: curls up into a ball;
6. hit reaction: flips backward, legs flailing;
7. collapse: rolls onto its side;
8. down: curled up on its back, motionless.
```

---

# Elite e chefe

Olham para a **esquerda**. Use proporção mais larga (1:1 ou 4:3) para caber a figura inteira.

## Minos (`elite_minos`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame, the whole body including the tail and wings always inside the frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The base of the figure stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur. Slow, heavy, powerful motion.
Subtle idle loop of Minos, a towering crowned demonic king seated on a stone seat of judgment with an enormous serpent tail coiled around his body: staying in place with only small movements, slow breathing and a slight sway. The serpent tail shifts slowly, keeping the same coils. The last frame matches the first frame for a seamless loop.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame, the whole body including the tail and wings always inside the frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The base of the figure stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur. Slow, heavy, powerful motion.
A sequence of clear key poses by Minos, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: seated on the seat of judgment, one clawed hand pointing in condemnation;
2. attack wind-up: rears back, the serpent tail rising;
3. attack strike: lashes his serpent tail forward like a whip toward the left while roaring a sentence;
4. back to the ready stance;
5. defend: the serpent tail coils up around him like armor;
6. hit reaction: recoils backward on the seat, roaring in pain;
7. collapse: slumps sideways on the seat, the tail going limp;
8. down: fallen from the seat, the tail sprawled, motionless.
```

## Vertigem (`elite_sin_vertigo`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame, the whole body including the tail and wings always inside the frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The base of the figure stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur. Slow, heavy, powerful motion.
Subtle idle loop of Vertigo, a tall elegant demon of dark smoke and flowing ink with a beautiful face and hypnotic pale empty eyes, the body completely covered by long veils of dark smoke, non-sexualized: staying in place with only small movements, slow breathing and a slight sway. The veils of smoke drift slowly, always covering the body completely. The last frame matches the first frame for a seamless loop.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame, the whole body including the tail and wings always inside the frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The base of the figure stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur. Slow, heavy, powerful motion.
A sequence of clear key poses by Vertigo, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: floating upright, veils drifting, a faint corrupted smile;
2. attack wind-up: draws back, the veils spreading like wings;
3. attack strike: glides forward toward the left, the veils lashing out like grasping ribbons;
4. back to the ready stance;
5. defend: wraps itself tightly in its veils;
6. hit reaction: recoils backward, the veils torn, the face twisting in anger;
7. collapse: sinks low, the veils collapsing;
8. down: a heap of fading veils of smoke on the ground.
```

## Asmodeu (`boss_asmodeus`)

**Parado**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame, the whole body including the tail and wings always inside the frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The base of the figure stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur. Slow, heavy, powerful motion.
Subtle idle loop of Asmodeus, a three-headed demon king (bull, crowned human and ram heads) with rooster legs and a serpent tail, holding a lance with a blank banner, riding a winged infernal dragon, body of smoke and ink, non-sexualized: staying in place with only small movements, slow breathing and a slight sway. The dragon's wings move slowly, keeping the same size. The last frame matches the first frame for a seamless loop.
```

**Ações**

```text
2D hand-inked gothic comic art animation, the exact same character as in the reference image, same costume, colors, proportions and line style in every frame. Strict side view, full body always fully inside the frame, character facing left. Locked static camera, same framing and same size in every frame, the whole body including the tail and wings always inside the frame. Plain flat solid light grey background, no frame border, no scenery, no ground line, no shadow, no text, no halo, no glow, no particles, no speed lines, no smears. The base of the figure stays on the same ground line for the whole animation. Clear motion, no morphing, no extra limbs, no motion blur. Slow, heavy, powerful motion.
A sequence of clear key poses by Asmodeus, each one held still for about half a second, returning briefly to the stance between them; it never leaves the center of the frame:
1. ready stance: the dragon standing, wings half spread, the lance held upright;
2. attack wind-up: the dragon rears up, the lance drawn back;
3. attack strike: thrusts the banner lance forward toward the left as the dragon lunges;
4. back to the ready stance;
5. defend: the dragon covers its rider with its wings;
6. hit reaction: the dragon recoils backward, the three heads roaring;
7. collapse: the dragon sinks to the ground, wings drooping;
8. down: the dragon lying on the ground with its rider slumped, motionless.
```
