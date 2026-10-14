# Decisões de implementação — 0.2 “First Week”

Referência: Documento Mestre V3.0, seções 45–47, 49.2, 49.5, 50, 61 e 62. Registro: 14 de outubro de 2026. As decisões do 0.1 continuam válidas e estão preservadas abaixo.

## Escopo cumprido (seção 62)

Sete dias jogáveis com grade semanal; Postura de Foco; Diretor de Aula com `question`, `note`, `help_request` e `drowsy`; Janela de Questão `choice` e `truefalse`; Missões de Sala M-01 a M-04; banco mínimo de 62 questões/33 cartões da Unidade 1 em quatro matérias; Domínio por matéria; Cartões; seis colegas sentados com fichas curtas; criador em quatro passos; humor e diário básicos; mesada; grupo da turma com dez mensagens; save v3 com migração de v2. Critérios de aceite verificados por teste automatizado: uma semana sem repetir Janela, três vínculos no nível 1 e migração v2 → v3.

## Decisões técnicas

| Tema | Decisão |
|---|---|
| Sessão de aula | `ClassSession` (RefCounted) é uma máquina de estados sem UI: devolve **telas como dicionários** (`body`, `options`, `grid`, `tools`, `footer`) e recebe comandos (`class_cmd`). `GameUI.render_screen` só desenha. Isso permite testar aulas inteiras headless e trocar a apresentação depois. |
| Determinismo | `SeededRng.from_string(data + ":" + período)` alimenta plano, risco de flagrante, sorteio e embaralhamento de questões. Recarregar um save não muda o que a aula faria. |
| Blocos | Período em blocos de 10 minutos a partir do minuto de chegada; chegar atrasado encurta a aula e, acima de 5 minutos, gera ocorrência leve. |
| Orçamento de momentos | Máximo 2 por período e 3 janelas interativas por dia (`data/class_moments.json`). **Exceções deliberadas:** missões agendadas sempre acontecem; flagrante força a pergunta ao jogador; energia < 30 força o Sono em aula. Perguntas além do limite caem em colegas. |
| Perguntas a colegas | O colega acerta com probabilidade `0,35 + Domínio × 0,006` (limitada a 10–95%), usando o Domínio da ficha. |
| Não repetir Janela | Exclui as últimas 20 vistas **e** as questões fixas de missões ainda não concluídas; se os níveis indicados se esgotarem, amplia para os outros níveis antes de admitir repetição. |
| Nível da questão | Pelo Domínio (0–29 → 1; 30–69 → 1–2; 70–100 → 2–3); flagrante sobe um nível. Recompensa por nível em `QuestionBank.REWARDS`. |
| Ferramentas | *Consultar caderno* exige postura Anotar, Página de Caderno da matéria ou posse do Cartão (e concede o Cartão). *Pedir ajuda* exige vizinho adjacente presente com vínculo nível 2 e Domínio ≥ 40, remove uma alternativa errada e tem 15% de flagrante. *Não sei* rende +1 Domínio e a explicação. |
| Domínio | +6 por matéria por dia no máximo; nunca cai; a cada 10 pontos ganhos, +1 Conhecimento (`counters.mastery_progress`). Domínio inicial = Conhecimento, com bônus de talento e origem. |
| Missões | JSON declarativo (`trigger`, `block`, `steps`, `effects`). Uma missão por período, a primeira que casar na ordem do índice; `chance` é determinística e forçada no último dia da janela. Conclusão em `quests[id].state`. |
| Vínculo | Níveis 50/150/300/500/750 com nomes Estranho → Conhecido → Colega → Amigo → Amigo próximo → Laço profundo. Conversa diária +15 (+3 Sociável; +50 Brincalhão com Tsubasa uma vez). |
| Fichas | Um arquivo por personagem em `data/characters/` + `index.json`. Pontos de rotina aceitam `"seat:B2"`, resolvidos pelo `SeatMap`; `via` são pontos intermediários e `patrol` percorre em laço. `data/npcs.json` foi removido. |
| Pose sentada | Ator que chega à cadeira entra em `seated`: ignora colisão com a carteira, vira para o quadro, pernas dobradas e corpo rebaixado. Sem rig: é a solução de protótipo. |
| Criador | Quatro passos num só modal com rascunho compartilhado; talento define atributos e item; origem define item e ajuste de Domínio (exterior: +15 Inglês, −5 Literatura); até dois traços. |
| Humor | Estado + data de validade; expira na manhã seguinte ao prazo. Cansado (dormir após 23:00) encarece energia em 20%; Animado nas segundas sem humor ativo (+1 Domínio por postura); Inspirado ao olhar pela janela. |
| Diário | `DayCycle.close_day` gera três linhas (aulas/perguntas/ocorrências, social ou missão, humor) e o jogador pode anexar uma frase; limite de 28 entradas. |
| Mesada | ¥3.000 às segundas a partir de 8 de abril, uma vez por data (`counters.allowance_<data>`). |
| Save v3 | Campos aditivos. Migração v2 → v3 cria perfil neutro e Domínio = Conhecimento salvo; a migração v1 → v2 foi mantida. `config/name` permanece “School Life — First Day” para preservar a pasta `user://`; o título da janela é definido em tempo de execução. |
| Testes com binário template | Templates não aceitam `--path` nem geram o cache de `class_name`; `tests/run_template.sh` espelha o projeto ao lado do binário, gera `.godot/global_script_class_cache.cfg` (`tests/tools/gen_class_cache.py`) e define a cena de testes por `override.cfg`. |

## O que ficou de fora de propósito

- Matérias práticas (EF, Artes, Economia Doméstica) e História só têm postura; seus momentos próprios vêm com o banco da Unidade 2.
- Reputação é acumulada, mas não tem consequências; ocorrências são contadas sem reunião com o professor.
- O grupo da turma é somente leitura; responder pertence ao sistema de mensagens do 0.3.
- Convite para o arcade (M-03) fica registrado em `flags.arcade_invite`; o local ainda não existe.

## Responsabilidades (0.2)

- `class_session.gd`: fases da aula, telas e comandos; `class_director.gd`: plano de momentos; `class_missions.gd`: carga, agendamento e efeitos de missões; `question_bank.gd`: banco, níveis, apresentação e validação; `timetable.gd`: matérias e grade; `seat_map.gd`: assentos e vizinhos; `seeded_rng.gd`: aleatoriedade reprodutível; `day_cycle.gd`: fechamento e abertura do dia.
- `game_actions.gd`: inicia a sessão com `class_context()` (presentes, vizinhos, fichas) e encaminha `class_cmd`.
- `game_ui.gd`: `render_screen`, criador em quatro passos e abas do celular.

---

# Decisões de implementação — 0.1

Referência: Documento Mestre School Life 3D V2.0 fornecido pelo responsável pelo projeto. Registro: 14 de outubro de 2026.

> **Atualização (14/10/2026):** o Documento Mestre foi consolidado e expandido na **V3.0** em [`DOCUMENTO_MESTRE_V3.md`](DOCUMENTO_MESTRE_V3.md). A Parte I preserva a V2.0; a Parte II (seções 44–64) acrescenta protagonista aprofundado, aulas em cinco fases com Postura de Foco, Momentos de Aula, Missões de Sala e Janela de Questão, currículo e banco de questões, provas e boletim, elenco de 50 personagens, mapa de assentos, vínculo em níveis, missões, clubes, conselho, calendário central do Ano 1, economia, celular, novos locais, arquitetura (save v3) e roadmap 0.2–1.0. **Nenhum código foi alterado nesta revisão**; as soluções provisórias abaixo continuam descrevendo o protótipo 0.1. O próximo marco proposto é o 0.2 "First Week" (seção 62 da V3).

## Escopo preservado

- Godot **4.7.2**, GDScript e mundo 3D. Nenhuma migração de engine: não havia projeto anterior no checkout.
- Primeiro entregar o ciclo reduzido da seção 40. Não construir a cidade inteira antes de validá-lo.
- Preservar o calendário de 14 dias; não pular dias letivos obrigatoriamente.
- Sem agricultura. A escola, as relações e o tempo continuam os pilares.
- Arte original de protótipo, sem alegação de qualidade final equivalente às referências.

## Soluções provisórias, não decisões definitivas de design

| Tema | Solução técnica nesta versão |
|---|---|
| Câmera | Ortográfica padrão, orientação fixa; perspectiva FOV 34° disponível para comparação. |
| Arte | Primitivas 3D, materiais compartilhados, cores sazonais das árvores e animação procedural de membros. |
| Escala | Rua curta para validar o ciclo rapidamente; não corresponde aos tempos finais casa–escola. |
| Interiores | Cenas independentes com corte frontal/lateral e sem telhado visível; bordas têm colisão. |
| Visibilidade | Raios câmera–personagem na camada 4 tornam construções e copas parcialmente transparentes. |
| NPCs | Horários em JSON determinam a região e atividade. Somente atores da região atual têm simulação física. Rotas autoradas, sem navmesh. |
| Aula | Espera opcional até o período, duas escolhas, consumo contextual de tempo, atributos e registro de participação/atraso. |
| Social | Diálogo inicial com resposta e recompensa diária limitada. Não substitui a futura progressão narrativa de amizade/romance. |
| Atributos | Escala provisória 0–100; estudar não remove condicionamento. |
| Energia | Correr consome pouco; atividades têm custos fixos; sono tardio restaura 80 em vez de 100. |
| Meia-noite | Retorno automático ao quarto e avanço de exatamente um dia, evitando estado de relógio inválido. |
| Persistência | Um slot JSON v2; temporário e backup; validação antes de modificar o estado; exemplo de migração v1. |
| Clima | Céu limpo fixo. Estações e iluminação não constituem um sistema climático completo. |
| Criação | Nome e cores de pele/cabelo; roupas, identidade, rostos e penteados variados ainda pendentes. |
| Preferências | Câmera e sombras duram apenas a sessão. Não há sistema completo de configurações persistentes. |

## Responsabilidades

- `game.gd`: composição, carregamento de regiões, entrada/saída de partida e ciclo de sono.
- `game_actions.gd`: encaminhamento de interações e transações de atividades, sem construir cenários.
- `game_state.gd`: personagem e estado persistente, sem conhecer UI ou cenas.
- `game_time.gd`: relógio e calendário independente da geometria.
- `save_system.gd`: leitura, validação e gravação, sem lógica de apresentação.
- `school_schedule.gd`: períodos e participação escolar; conteúdo em `data/schedule.json`.
- `npc_manager.gd` / `npc_actor.gd`: seleção de rotinas e execução local; conteúdo em `data/npcs.json` (0.1; substituído por `data/characters/` no 0.2).
- `geometry.gd` e scripts de ambientes: construção visual e pontos de interação reutilizáveis.
- `game_ui.gd` / `map_view.gd`: apresentação e emissão de comandos.

## Próximos marcos

1. Executar o roteiro manual em PC com renderização e registrar imagens das duas câmeras.
2. Ajustar visibilidade, escala, composição, alcance de interação e legibilidade do HUD com base nesses testes.
3. Melhorar navegação e continuidade dos NPCs: rotas entre regiões, assentos, contextos sociais e animações.
4. Expandir o primeiro ano aos poucos: frequência/notas, um clube e eventos pessoais de poucos personagens.
5. Só então expandir bairros, clima, áudio, festivais e produção de arte final.

A possibilidade de avançar o calendário não significa que os três anos de conteúdo tenham sido produzidos.
