# School Life 3D — First Week

**Protótipo 0.2 · Godot 4.7.2 · GDScript · PC**

Uma primeira semana em Hoshikawa: acordar na casa da avó, percorrer a rua das cerejeiras, sentar na carteira C2 da turma 1-A e viver cada aula com uma **Postura de Foco**, **Momentos de Aula**, a **Janela de Questão** e as primeiras **Missões de Sala** — com seis vizinhos de carteira que têm fichas, rotinas e opiniões.

O marco 0.1 (*First Day*, seção 40 do Documento Mestre) continua inteiro; o 0.2 implementa a **seção 62 (“First Week”)** do Documento Mestre V3.0. Não representa o jogo completo, nem um primeiro ano de conteúdo comercial.

> **Documento Mestre V3.0:** [`docs/DOCUMENTO_MESTRE_V3.md`](docs/DOCUMENTO_MESTRE_V3.md) consolida a V2.0 (Parte I) e continua o planejamento (Parte II). As seções 45–47, 49.2, 49.5, 50 e 61 agora têm um primeiro recorte implementado; o restante da Parte II segue como especificação. A lista “Implementado / Ainda não implementado” abaixo é a referência do que existe de fato.

## Abrir e jogar

1. Instale a **Godot 4.7.2 Standard**, sem necessidade de .NET.
2. Importe o arquivo [`project.godot`](project.godot) pelo gerenciador de projetos.
3. Aguarde a importação inicial e pressione **F6** em `scenes/main.tscn` ou **F5** para executar o projeto.
4. Selecione **Novo jogo** e percorra os quatro passos do criador: identidade, origem e motivo da mudança, talento e até dois traços.

O projeto usa o renderizador **Compatibility**. Toda a geometria é criada em GDScript; não há dependências de modelos, plugins ou serviços externos para jogar. Os ambientes são cenas separadas carregadas sob demanda.

### Controles

| Tecla | Ação |
|---|---|
| WASD / setas | Movimento relativo à câmera |
| Shift | Correr, com consumo leve de energia |
| E | Interagir com o objeto/personagem próximo |
| Roda do mouse | Zoom suave |
| Tab | Celular: agenda, caderno (Domínio e Cartões), personagem, contatos, grupo da turma e diário |
| I | Mochila e alimentação |
| M | Mapa do protótipo, sem teletransporte |
| Esc | Pausa / fechar painel |

Menus e conversas pausam o relógio. Em **Configurações**, compare a câmera ortográfica com perspectiva suave, alterne sombras e tela cheia. As preferências são mantidas somente durante a sessão.

## Experimente o ciclo principal

1. No quarto, aproxime-se da porta **SALA** e pressione E.
2. Leia o bilhete da avó sobre a mesa da sala.
3. Saia pela porta **RUA**. Siga a rua principal para o norte até a escola.
4. Entre, converse com o Professor Sato ou com Yui conforme a rotina e acesse a **SALA 1-A**.
5. Interaja com **SUA CARTEIRA**. Se estiver cedo, espere até a próxima atividade. No Homeroom do primeiro dia acontece a Missão de Sala **Primeira chamada**.
6. Em cada aula, escolha a **Postura de Foco** (prestar atenção, anotar, revisar outra matéria, descansar, conversar com um vizinho, olhar pela janela). A aula corre em blocos de 10 minutos; o Diretor de Aula pode abrir uma **Janela de Questão**, passar um bilhete, trazer um colega em apuros ou um ataque de sono.
7. Na Janela de Questão, responda, **consulte o caderno** (mostra o Cartão), **peça ajuda** a um vizinho de nível Colega ou diga **Não sei** para ouvir a explicação.
8. Volte pelo corredor, saia para o bairro e retorne à casa e ao quarto.
9. Durma na cama: o diário resume o dia em três linhas (você pode acrescentar uma frase), o dia avança para 06:30 e o progresso é salvo automaticamente. Às segundas, a partir de 8 de abril, chega a mesada de ¥3.000.

Você também pode estudar uma matéria em casa, descansar nos bancos, comprar um lanche e seguir pelos dias seguintes: cada dia da semana tem um horário diferente (`data/timetable.json`). O caminho foi encurtado para testes; a escala definitiva da cidade ainda não está validada.

## Implementado

### Novo no 0.2 — First Week

- **Horário semanal** da 1-A (`data/timetable.json`): dez matérias, seis períodos por dia, professores e falas de abertura por matéria (`data/subjects.json`).
- **Postura de Foco** por aula, com ganhos, custos e risco de flagrante (`data/class_moments.json`); traço Cuidadoso reduz o risco pela metade.
- **Diretor de Aula** determinístico por data e período (`SeededRng`): no máximo dois momentos por período, três janelas interativas por dia, pelo menos uma janela por dia letivo; flagrante dirige a próxima pergunta a você; energia abaixo de 30 traz o **Sono em aula**.
- **Momentos de Aula**: pergunta do professor (a você ou a um colega, decidida pelo Domínio dele), bilhete passado, colega em apuros e sono.
- **Janela de Questão** com alternativas embaralhadas, verdadeiro/falso, níveis 1–3 escolhidos pelo Domínio, ferramentas *Consultar caderno*, *Pedir ajuda* e *Não sei*; nenhuma pergunta se repete nas últimas vinte.
- **Banco mínimo da Unidade 1**: 62 questões e 33 Cartões em Literatura, Matemática, Inglês e Ciências (`data/questions/`, `data/cards/`), com validação automática das regras de autoria.
- **Domínio por matéria** (0–100, teto de +6 por dia; cada 10 pontos rendem +1 Conhecimento), Cartões e Páginas de Caderno visíveis na aba **Caderno** do celular.
- **Missões de Sala M-01 a M-04** em JSON (`data/missions/class/`): Primeira chamada, A pergunta do Sato, O bilhete de Tsubasa e O verbo do Kenta — passos de texto, escolha, múltipla escolha e questão, com efeitos declarativos.
- **Seis colegas da 1-A** (Yui, Aiko, Daichi, Kenta, Hina, Tsubasa) com fichas curtas, Domínio próprio, bilhetes, falas de conversa, pedidos de ajuda e rotinas; sentam nas carteiras do **mapa de assentos** (`data/classrooms/1a.json`) com placas de nome. Sato e Ren continuam no elenco.
- **Criador em quatro passos**: nome e cores, origem (capital, interior, retorno do exterior) e motivo, talento (Dedicado, Atleta, Artista, Sociável) e até dois traços — com efeitos nos atributos, no Domínio inicial e em pequenas regras de aula.
- **Humor** (Tranquilo, Animado, Inspirado, Cansado…) com validade em dias, **diário** com três linhas por noite e anotação opcional, **mesada** semanal, reputação acadêmica e ocorrências leves.
- **Grupo da turma** no celular: dez mensagens somente leitura liberadas pela data.
- **Save v3** com migração automática de v1 e v2: o Domínio de saves antigos começa no Conhecimento salvo e nada é perdido.

### Base do 0.1 — First Day

- Cinco ambientes conectados: quarto, casa, bairro/caminho/entrada escolar, corredor e sala 1-A.
- Movimento `CharacterBody3D`, colisões, aceleração e animação procedural simples de caminhada/corrida.
- Câmera elevada com acompanhamento suave, zoom, comparação ortográfica/perspectiva e transparência de obstáculos.
- Geometria estilizada original: casas, escola, praça, árvores, mobiliário, máquina de lanches e iluminação por horário.
- Nome, tonalidade de pele e cor do cabelo na criação inicial simplificada.
- Calendário de **14 dias por mês**, 12 meses, ano letivo abril–março, início **SEG · 01 ABR · 06:30**; referência de um minuto por segundo real.
- HUD, celular, calendário, mapa, mochila, pausa e diálogos com escolhas.
- NPCs com rotinas externas em JSON, presença por região/horário, percursos por pontos de passagem e pose sentada em sala.
- Horário escolar, espera contextual, registro de atraso (ocorrência acima de 5 minutos) e participação sem recompensa duplicada.
- Primeiro contato social, escolha entre empatia/carisma e limite de recompensa de conversa por dia.
- Energia leve, estudo, descanso, alimentação e compra em ienes.
- Sono, passagem de um único dia e retorno ao quarto à meia-noite.
- Save versionado, validação antes de carregar, gravação temporária, backup e migração inicial v1 → v2.
- Testes automatizados e workflow de validação no GitHub Actions.

## Ainda não implementado

Prólogo da estação, restante de Hoshikawa, modelos/rigs/retratos finais, áudio, clima variável, festivais, férias, **provas e boletim**, faltas e consequências acadêmicas completas (as ocorrências são apenas contadas), clubes, empregos, decoração, convites fora da sala (o arcade de Tsubasa fica registrado como flag), responder no grupo da turma, monitoria no almoço, narrativas sociais profundas, romance, progressão de conteúdo dos três anos e formatura.

Dentro das aulas ainda faltam: unidades 2+ do banco, matérias práticas com momentos próprios (Educação Física, Artes, Economia Doméstica e História usam só a postura), intensidade de aula configurável, trocas de lugar e a pontuação de reputação ligada ao traço Competitivo. O mapa de assentos do 1º trimestre é o único autorado.

A base do calendário suporta os três anos, **mas os arcos narrativos e conteúdos correspondentes não existem ainda**. As conversas fora da sala continuam a validação técnica do 0.1. As rotinas usam percursos autorados; navegação por navmesh, interação autônoma profunda entre NPCs e animações contextuais ficam para a próxima etapa.

## Salvamentos

- **Esc → Salvar jogo** ou durma na cama.
- **Continuar** no início ou **Esc → Carregar último salvamento**.
- Arquivos: `user://first_day.json` e `user://first_day.json.bak`. O nome interno do projeto (`config/name`) continua “School Life — First Day” de propósito: ele define a pasta `user://`, e assim os saves do 0.1 são encontrados e migrados para a versão 3.
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
scripts/school/           Horário, grade semanal, sessão de aula, diretor, banco de questões e missões
scripts/world/            Kit procedural, ambientes, interações e luz
scripts/ui/               HUD, telas e mapa
data/characters/          Fichas e rotinas (index.json + um arquivo por personagem)
data/classrooms/          Mapa de assentos da 1-A
data/questions/, cards/   Banco da Unidade 1 por matéria
data/missions/class/      Missões de Sala M-01 a M-04
data/*.json               Períodos, grade semanal, matérias, momentos/posturas, grupo da turma
tests/                    Testes de lógica e integração (+ run_template.sh para binários template)
docs/                    Decisões, validação e Documento Mestre
```

## Testes

Com a Godot no PATH, em Linux/macOS ou ambiente Bash:

```bash
./tests/run.sh
# ou
GODOT=/caminho/para/godot ./tests/run.sh
```

O script importa o projeto, executa os testes headless e isola o diretório de saves. **Não execute a cena de testes diretamente sobre um save real.** Se você só tem um binário *template* (compilado com `scons target=template_debug`, sem editor), use `GODOT_TEMPLATE=/caminho/binario ./tests/run_template.sh`, que espelha o projeto ao lado do binário e gera o cache de classes.

**Validação local:** 188 verificações aprovadas, zero falhas e nenhum erro de script/runtime com Godot 4.7.2 compilada em modo headless — incluindo uma semana inteira simulada (45 períodos) sem repetir Janela de Questão e com três vínculos no nível 1. Isso valida lógica e integração, **não qualidade visual, desempenho gráfico ou usabilidade por controle real**. Veja [`docs/VALIDATION.md`](docs/VALIDATION.md) para a metodologia e o roteiro de teste manual pendente.

Mais detalhes: [`docs/DECISIONS.md`](docs/DECISIONS.md). Planejamento completo: [`docs/DOCUMENTO_MESTRE_V3.md`](docs/DOCUMENTO_MESTRE_V3.md).
