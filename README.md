# School Life 3D — First Day

**Protótipo 0.1 · Godot 4.7.2 · GDScript · PC**

Um primeiro dia em Hoshikawa: acordar, conhecer a casa da avó, percorrer a rua das cerejeiras, encontrar colegas, participar de uma atividade escolar e voltar para dormir.

Esta implementação segue o **escopo de validação da seção 40 do Documento Mestre**. Não representa o jogo completo, nem um primeiro ano de conteúdo comercial. O repositório original continha somente um README; não havia um projeto 2D para migrar.

> **Documento Mestre V3.0:** [`docs/DOCUMENTO_MESTRE_V3.md`](docs/DOCUMENTO_MESTRE_V3.md) consolida a V2.0 (Parte I) e continua o planejamento (Parte II): protagonista aprofundado, aulas com Momentos de Aula, Missões de Sala e Janela de Questão, elenco completo, calendário dia a dia do Ano 1, clubes, missões, economia e roadmap 0.2–1.0. A Parte II é especificação, não funcionalidade implementada.

## Abrir e jogar

1. Instale a **Godot 4.7.2 Standard**, sem necessidade de .NET.
2. Importe o arquivo [`project.godot`](project.godot) pelo gerenciador de projetos.
3. Aguarde a importação inicial e pressione **F6** em `scenes/main.tscn` ou **F5** para executar o projeto.
4. Selecione **Novo jogo**, informe o nome e escolha as cores simplificadas do protagonista.

O projeto usa o renderizador **Compatibility**. Toda a geometria é criada em GDScript; não há dependências de modelos, plugins ou serviços externos para jogar. Os ambientes são cenas separadas carregadas sob demanda.

### Controles

| Tecla | Ação |
|---|---|
| WASD / setas | Movimento relativo à câmera |
| Shift | Correr, com consumo leve de energia |
| E | Interagir com o objeto/personagem próximo |
| Roda do mouse | Zoom suave |
| Tab | Celular: agenda, personagem, contatos |
| I | Mochila e alimentação |
| M | Mapa do protótipo, sem teletransporte |
| Esc | Pausa / fechar painel |

Menus e conversas pausam o relógio. Em **Configurações**, compare a câmera ortográfica com perspectiva suave, alterne sombras e tela cheia. As preferências são mantidas somente durante a sessão.

## Experimente o ciclo principal

1. No quarto, aproxime-se da porta **SALA** e pressione E.
2. Leia o bilhete da avó sobre a mesa da sala.
3. Saia pela porta **RUA**. Siga a rua principal para o norte até a escola.
4. Entre, converse com o Professor Sato ou com Yui conforme a rotina e acesse a **SALA 1-A**.
5. Interaja com **SUA CARTEIRA**. Se estiver cedo, espere até a próxima atividade.
6. Escolha como participar. O relógio avança ao fim do período e registra a participação.
7. Volte pelo corredor, saia para o bairro e retorne à casa e ao quarto.
8. Durma na cama: o dia avança para 06:30 e o progresso é salvo automaticamente.

Você também pode estudar, descansar nos bancos, comprar um lanche e continuar explorando os dias seguintes. O caminho foi encurtado para testes; a escala definitiva da cidade ainda não está validada.

## Implementado

- Cinco ambientes conectados: quarto, casa, bairro/caminho/entrada escolar, corredor e sala 1-A.
- Movimento `CharacterBody3D`, colisões, aceleração e animação procedural simples de caminhada/corrida.
- Câmera elevada com acompanhamento suave, zoom, comparação ortográfica/perspectiva e transparência de obstáculos.
- Geometria estilizada original: casas, escola, praça, árvores, mobiliário, máquina de lanches e iluminação por horário.
- Nome, tonalidade de pele e cor do cabelo na criação inicial simplificada.
- Calendário de **14 dias por mês**, 12 meses, ano letivo abril–março, início **SEG · 01 ABR · 06:30**; referência de um minuto por segundo real.
- HUD, celular, calendário, mapa, mochila, pausa e diálogos com escolhas.
- Três NPCs de teste com rotinas externas em JSON, presença por região/horário e percursos por pontos de passagem.
- Horário escolar, espera contextual, participação, registro de atraso e ganho de atributos sem recompensa duplicada.
- Primeiro contato social, escolha entre empatia/carisma e limite de recompensa de conversa por dia.
- Energia leve, estudo, descanso, alimentação e compra em ienes.
- Sono, passagem de um único dia e retorno ao quarto à meia-noite.
- Save versionado, validação antes de carregar, gravação temporária, backup e migração inicial v1 → v2.
- Testes automatizados e workflow de validação no GitHub Actions.

## Ainda não implementado

Prólogo da estação, restante de Hoshikawa, modelos/rigs/retratos finais, áudio, clima variável, festivais, férias, provas/notas completas, faltas e consequências acadêmicas completas, clubes, empregos, decoração, convites, narrativas sociais profundas, romance, progressão de conteúdo dos três anos e formatura.

A base do calendário suporta os três anos, **mas os arcos narrativos e conteúdos correspondentes não existem ainda**. As conversas desta versão são apenas uma validação técnica, não o sistema social final. As rotinas usam percursos autorados; navegação por navmesh, interação autônoma profunda entre NPCs e animações contextuais ficam para a próxima etapa.

## Salvamentos

- **Esc → Salvar jogo** ou durma na cama.
- **Continuar** no início ou **Esc → Carregar último salvamento**.
- Arquivos: `user://first_day.json` e `user://first_day.json.bak`.
- Em Windows, normalmente ficam em `%APPDATA%\Godot\app_userdata\School Life — First Day\`.
- Se o arquivo principal não puder ser carregado e houver backup, a interface oferece recuperá-lo.
- Um novo jogo substitui o slot anterior somente ao salvar ou dormir. Há apenas um slot nesta versão.

## Organização

```text
scenes/main.tscn           Composição da experiência
scenes/world/             Cinco ambientes carregados separadamente
scripts/core/             Estado, salvamento, comandos e coordenação
scripts/time/             Relógio e calendário
scripts/player/           Movimento, visual e câmera
scripts/npc/              Rotinas e atores ativos
scripts/school/           Horário e participação escolar
scripts/world/            Kit procedural, ambientes, interações e luz
scripts/ui/               HUD, telas e mapa
data/                    NPCs e horários em JSON
tests/                   Testes de lógica e integração
docs/                    Decisões, validação e próximos passos
```

## Testes

Com a Godot no PATH, em Linux/macOS ou ambiente Bash:

```bash
./tests/run.sh
# ou
GODOT=/caminho/para/godot ./tests/run.sh
```

O script importa o projeto, executa os testes headless e isola o diretório de saves. **Não execute a cena de testes diretamente sobre um save real.**

**Validação local:** 62 verificações aprovadas, zero falhas e nenhum erro de script/runtime na execução final com Godot 4.7.2 compilada em modo headless. Isso valida lógica e integração, **não qualidade visual, desempenho gráfico ou usabilidade por controle real**. Veja [`docs/VALIDATION.md`](docs/VALIDATION.md) para a metodologia e o roteiro de teste manual pendente.

Mais detalhes: [`docs/DECISIONS.md`](docs/DECISIONS.md). Planejamento completo: [`docs/DOCUMENTO_MESTRE_V3.md`](docs/DOCUMENTO_MESTRE_V3.md).
