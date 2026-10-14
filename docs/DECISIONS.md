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
- `npc_manager.gd` / `npc_actor.gd`: seleção de rotinas e execução local; conteúdo em `data/npcs.json`.
- `geometry.gd` e scripts de ambientes: construção visual e pontos de interação reutilizáveis.
- `game_ui.gd` / `map_view.gd`: apresentação e emissão de comandos.

## Próximos marcos

1. Executar o roteiro manual em PC com renderização e registrar imagens das duas câmeras.
2. Ajustar visibilidade, escala, composição, alcance de interação e legibilidade do HUD com base nesses testes.
3. Melhorar navegação e continuidade dos NPCs: rotas entre regiões, assentos, contextos sociais e animações.
4. Expandir o primeiro ano aos poucos: frequência/notas, um clube e eventos pessoais de poucos personagens.
5. Só então expandir bairros, clima, áudio, festivais e produção de arte final.

A possibilidade de avançar o calendário não significa que os três anos de conteúdo tenham sido produzidos.
