# DOCUMENTO MESTRE DE DESENVOLVIMENTO — SCHOOL LIFE 3D

## PROMPT MESTRE — VERSÃO 3.0

**Simulador de vida escolar • Hoshikawa • Godot 4**

Uma cidade japonesa viva em 3D. Três anos letivos, rotinas, amizades, clubes, escolhas e caminhos pessoais — sem mecânicas de fazenda.

Documento de referência para direção criativa, programação, arte, sistemas e produção.

Outubro de 2026 • Pré-alpha • Protótipo 0.1 "First Day" jogável • Especificação de conceito e expansão

---

### Ficha do projeto

| Campo | Definição |
|---|---|
| Gênero | Simulador de vida escolar, social simulation, slice of life, exploração e RPG social leve |
| Plataforma inicial | PC (Windows / Steam) |
| Engine | Godot 4, mantendo GDScript como linguagem principal |
| Perspectiva | 3D, câmera elevada e inclinada, exploração semelhante à de Coral Island |
| Direção artística | 3D estilizado, colorido, aconchegante e inspirado na vida cotidiana japonesa |
| Ambientação | Hoshikawa, cidade japonesa fictícia contemporânea |
| Nome | School Life (provisório) |
| Modelo de lançamento | Acesso antecipado, começando pelo primeiro ano escolar, com expansões para o segundo e terceiro anos |
| Estado | Pré-alpha. O protótipo 3D 0.1 valida o ciclo mínimo da seção 40. A cidade completa, o elenco e os sistemas da Parte II ainda não existem |

### Como ler este documento

- **Parte I — Fundação (seções 1 a 43)** consolida o Prompt Mestre V2.0. O texto foi preservado como registro das decisões. Notas marcadas com **➜ V3** apontam para as seções da Parte II que aprofundam cada tema.
- **Parte II — Expansão V3.0 (seções 44 a 64)** continua o planejamento: estado real do protótipo, protagonista aprofundado, aulas com Momentos de Aula, Missões de Sala e Janela de Questão, elenco completo, calendário central dia a dia, clubes, missões, economia, celular, cidade, arquitetura e roadmap.
- Nada na Parte II deve ser lido como funcionalidade existente, salvo quando marcado explicitamente como implementado.

Legenda de status usada na Parte II:

| Marca | Significado |
|---|---|
| `[IMPLEMENTADO 0.1]` | Existe e foi validado no protótipo First Day (ver `README.md` e `docs/VALIDATION.md`). |
| `[PARCIAL]` | Existe uma versão reduzida no protótipo; a especificação descreve a forma final. |
| `[PLANEJADO]` | Proposta de design. Nenhum arquivo, cena ou sistema correspondente existe ainda. |

### Registro de revisão V2.0 → V3.0

| Tema | V2.0 | V3.0 |
|---|---|---|
| Estado do projeto | "A migração para 3D ainda precisa ser implementada" | Protótipo 3D 0.1 jogável, com 5 ambientes, 3 NPCs, calendário e save versionado (seção 44) |
| Protagonista | Nome, aparência e atributos iniciais | Origem, motivo da mudança, talento inicial, traços, voz própria, sonhos, humor, hábitos, diário, álbum, crescimento em três anos e especificação visual do modelo (45) |
| Aulas | Situações genéricas com duas escolhas | Aula em cinco fases, Postura de Foco, catálogo de Momentos de Aula, Missões de Sala roteirizadas, Janela de Questão, Diretor de Aula, horário semanal real (46) |
| Conteúdo acadêmico | "Perguntas e pequenos desafios" | Currículo por unidades, Cartões de Conteúdo, Domínio por matéria, banco de questões em dados (47) |
| Notas e provas | Critérios gerais | Dever de casa, cinco períodos de prova, fórmula de nota, boletim, ranking e recuperação (48) |
| Personagens | 3 NPCs de teste | 50 personagens nomeados e 17 alunos de apoio com fichas (49), mapa de assentos (50) e grafo de relações (51) |
| Vínculo | Escala 0–1000 provisória | Níveis, ritmo de confiança, tópicos de conversa, presentes, saídas e romance por etapas (52) |
| Objetivos | Flags de tutorial | Sistema de missões em cinco categorias (53) |
| Clubes | 7 clubes listados | 9 clubes e comitês, loop de treino, patentes e competições (54) |
| Conselho e disciplina | Caminho alternativo | Representantes de turma, eleições, ocorrências e reputação em quatro dimensões (55) |
| Calendário | Tabela por mês | Tabela central dia a dia do Ano 1 (56) |
| Economia | Fontes e despesas | Empregos com turnos e requisitos, mesada e tabela de preços (57) |
| Celular | Lista de funções | Aplicativos, grupo da turma e exemplos de mensagens (58) |
| Cidade | Oito regiões | Novos locais e atividades (59) e um dia típico integrado (60) |
| Técnica | Estrutura conceitual | Módulos, arquivos de dados, save v3, migração e sorteio determinístico (61) |
| Roadmap | 12 fases | Marcos 0.2 a 1.0 com escopos fechados (62) |
| Decisões | Lista V2.0 | Itens consolidados na V3 e novos pontos provisórios (63) |

### Sumário

**Parte I — Fundação (V2.0 consolidada)**

1. Visão geral do jogo
2. Direção artística e gráficos
3. Câmera e exploração 3D
4. Hoshikawa — concepção do mapa
5. Bairro residencial
6. Casa do protagonista
7. Distrito escolar
8. Centro comercial
9. Estação Hoshikawa
10. Parque municipal, rio e distrito antigo
11. Colinas, santuário e mirante
12. Escala e deslocamento no mapa
13. Criação do protagonista
14. Tempo, calendário e passagem dos dias
15. Clima e estações
16. Sistema de rotina escolar
17. Sistema de aulas
18. Notas, provas e progressão acadêmica
19. Sistema de atributos
20. Clubes escolares
21. Conselho estudantil e reputação
22. NPCs, inteligência social e rotinas
23. Sistema de amizades e relacionamentos
24. Diálogos e eventos narrativos
25. Calendário de eventos anuais
26. Trabalhos de meio período e economia
27. Sistema de energia e necessidades
28. Celular do protagonista
29. HUD — interface durante a exploração
30. Menus e interfaces secundárias
31. Animações e expressividade
32. Iluminação, clima visual e ciclo dia/noite
33. Áudio e trilha sonora
34. Sistema de progressão dos três anos
35. Prólogo oficial
36. Tecnologia e arquitetura do projeto
37. Desempenho e otimização
38. Save e persistência
39. Conteúdo do acesso antecipado
40. Primeiro protótipo 3D — versão 0.1
41. Roadmap de produção 3D
42. Regras de desenvolvimento para a IA
43. Decisões consolidadas e pontos provisórios (V2.0)

**Parte II — Expansão V3.0**

44. Estado real do projeto — protótipo 0.1 "First Day"
45. Protagonista V3 — identidade, história e crescimento
46. Sistema de aulas V3 — Momentos de Aula, Missões de Sala e Janela de Questão
47. Currículo, Cartões de Conteúdo, Domínio por matéria e banco de questões
48. Dever de casa, provas, boletim e ranking
49. Elenco de Hoshikawa — fichas de personagens
50. Mapa de assentos da 1-A e dinâmica de vizinhos
51. Relações entre NPCs e arcos independentes
52. Sistema de vínculo V3 — níveis, conversas, presentes, saídas e romance
53. Missões e objetivos
54. Clubes V3 — novos clubes, loop de treino, progressão e competições
55. Representantes, conselho estudantil, disciplina e reputação
56. Tabela central do calendário — Ano 1 completo
57. Trabalhos, mesada e tabela de preços
58. Celular V3 — aplicativos e mensagens
59. Novos locais e atividades de Hoshikawa
60. Um dia típico em Hoshikawa — exemplo integrado
61. Arquitetura técnica V3 — módulos, dados, save v3 e migração
62. Roadmap V3 — marcos 0.2 a 1.0
63. Decisões consolidadas e pontos provisórios — atualização V3
64. Objetivo final

---

# PARTE I — FUNDAÇÃO (V2.0 CONSOLIDADA)

## 1. VISÃO GERAL DO JOGO

School Life será um simulador de vida escolar ambientado no Japão contemporâneo, com um mundo 3D explorável, personagens com rotinas independentes, progressão acadêmica, relacionamentos sociais profundos e liberdade para construir uma experiência individual.

O jogador assume o papel de um estudante que acaba de se mudar para a cidade fictícia de Hoshikawa, onde iniciará o primeiro ano do ensino médio.

Durante a experiência, poderá frequentar aulas, estudar para provas, participar de clubes escolares, desenvolver habilidades, fazer amigos, namorar, trabalhar meio período, explorar a cidade, comprar roupas, personalizar sua casa e participar de festivais.

O objetivo central não é simplesmente terminar a escola, mas viver a experiência de três anos de juventude, construindo histórias e memórias por meio das decisões tomadas.

O mundo deve continuar existindo independentemente do protagonista. Os estudantes terão amizades próprias, compromissos, famílias, interesses, objetivos e relacionamentos. Professores terão horários. Lojas abrirão e fecharão. Festivais acontecerão em datas específicas. Alguns personagens mudarão de comportamento com o passar dos anos.

**Princípio fundamental: o jogador não é o centro do universo. Ele é um dos habitantes de Hoshikawa.**

### 1.1. Pilares de gameplay

O projeto deverá ser construído ao redor de seis pilares:

1. **Vida escolar:** aulas, provas, notas, clubes, professores, reputação e progressão acadêmica.
2. **Vida social:** amizades, romances, rivalidades, acontecimentos pessoais e relações familiares.
3. **Administração de tempo:** escolher atividades dentro de uma rotina diária limitada.
4. **Exploração:** deslocamento físico por uma cidade 3D viva, compacta e interligada.
5. **Progressão pessoal:** desenvolvimento de atributos, habilidades, objetivos e oportunidades.
6. **Narrativa emergente:** histórias que surgem da combinação entre escolhas, calendário, personagens e acontecimentos.

Não existirão mecânicas de agricultura, plantações, criação de animais de fazenda ou gerenciamento agrícola.

O School Life deverá utilizar a filosofia de simulação de vida encontrada em jogos como Coral Island e Stardew Valley, mas com uma identidade própria.

## 2. DIREÇÃO ARTÍSTICA E GRÁFICOS

### 2.1. Referência visual principal

A direção artística deverá utilizar Coral Island como referência de qualidade visual, legibilidade dos ambientes e apresentação de um mundo 3D estilizado.

Entretanto, o jogo não deverá copiar personagens, modelos, texturas, interfaces ou construções específicas de outras propriedades intelectuais.

Buscamos uma identidade artística original que una:

- O charme visual de um simulador de vida 3D.
- A arquitetura de cidades japonesas contemporâneas.
- A expressividade dos personagens de anime.
- A atmosfera acolhedora de histórias slice of life.
- Cenários suficientemente detalhados para transmitir a sensação de um lugar habitado.

### 2.2. Estilo dos personagens

Os personagens serão totalmente tridimensionais. A aparência combinará anatomia humana estilizada com elementos visuais inspirados em animações japonesas.

Direção desejada:

- Proporções humanas levemente estilizadas, sem aparência excessivamente caricata.
- Rostos expressivos, com olhos e cabelos estilizados.
- Cabelos modelados em mechas tridimensionais.
- Uniformes escolares visualmente detalhados.
- Roupas casuais variadas.
- Animações naturais e expressivas.
- Silhuetas facilmente reconhecíveis.
- Diversidade de alturas, estilos e características individuais.

Os personagens não deverão parecer bonecos genéricos reutilizados com pequenas mudanças de cor. Cada personagem importante deverá possuir uma identidade visual reconhecível.

Os estudantes também poderão alterar penteados e roupas conforme suas rotinas e eventos.

> **➜ V3:** a especificação técnica do modelo do protagonista (rig, blendshapes, camadas de roupa, LOD e retratos por camadas) está na seção 45.13. As silhuetas do elenco estão nas fichas da seção 49.

### 2.3. Retratos durante conversas

Proposta visual: combinar os personagens 3D presentes no cenário com retratos ilustrados em 2D durante conversas importantes.

A apresentação deverá funcionar assim:

- Conversas comuns apresentam a caixa de diálogo e o nome do personagem.
- Conversas importantes exibem um retrato ilustrado.
- Retratos possuem diferentes expressões.
- Emoções como alegria, surpresa, vergonha, irritação e tristeza podem alterar a expressão.
- Eventos especiais poderão utilizar enquadramentos cinematográficos dos modelos 3D.

Os retratos deverão manter coerência com a aparência dos modelos tridimensionais.

### 2.4. Ambientes e materiais

A cidade terá construções em 3D com materiais estilizados, detalhes arquitetônicos e objetos que transmitam personalidade.

Elementos importantes:

- Telhados com volumes definidos.
- Janelas com reflexos discretos.
- Portas, toldos e placas comerciais.
- Cercas, postes, árvores e cabos elétricos.
- Calçadas, faixas de pedestres e ruas.
- Máquinas automáticas de bebidas.
- Bicicletas estacionadas.
- Jardins residenciais.
- Bancos, lixeiras, vasos e sinalização.
- Iluminação interna visível durante a noite.

Os cenários deverão apresentar detalhes suficientes para parecerem vivos, mas evitar excesso visual que prejudique a navegação.

### 2.5. Paleta de cores

Cada estação terá uma atmosfera própria.

- **Primavera:** cores suaves, céu claro, vegetação fresca e flores de cerejeira.
- **Verão:** cores vibrantes, vegetação intensa, dias luminosos e noites de festival.
- **Outono:** tons dourados, laranjas, vermelhos e vegetação em transformação.
- **Inverno:** cores mais frias, manhãs suaves, iluminação aconchegante e decorações sazonais.

A identidade visual deve ser agradável e reconhecível durante todas as estações.

## 3. CÂMERA E EXPLORAÇÃO 3D

A câmera será um dos elementos mais importantes da identidade visual.

### 3.1. Câmera padrão

Utilizar uma câmera tridimensional elevada, inclinada em direção ao personagem, semelhante à perspectiva de exploração de Coral Island.

Configuração inicial proposta para testes:

- Tipo: câmera ortográfica 3D, com possibilidade de testar perspectiva de campo de visão reduzido.
- Inclinação vertical: aproximadamente 40° a 50°.
- Rotação horizontal inicial: ângulo fixo definido para favorecer a leitura do cenário.
- Personagem posicionado ligeiramente abaixo do centro da tela.
- Acompanhamento suave do movimento.
- Distância visual suficiente para enxergar ruas, prédios e personagens próximos.
- Movimento de câmera estável, sem oscilações excessivas.

Os valores serão ajustados por meio de testes de jogabilidade.

### 3.2. Zoom

Proposta: permitir dois níveis principais de enquadramento e zoom intermediário.

- **Visão padrão:** mais afastada, adequada para explorar ruas, corredores escolares e ambientes amplos.
- **Visão aproximada:** permite observar melhor o protagonista, os NPCs e os detalhes dos cenários.

A aproximação não deverá transformar o jogo obrigatoriamente em terceira pessoa tradicional. O estilo principal continuará sendo uma câmera elevada. O zoom deverá utilizar transições suaves.

### 3.3. Rotação da câmera

Inicialmente, priorizar a câmera com orientação fixa.

Posteriormente, avaliar rotação em incrementos de 90° para facilitar a visualização de determinados ambientes.

Não implementar rotação livre antes de verificar se os mapas, a interface e a navegação funcionam corretamente com uma câmera fixa.

### 3.4. Objetos que bloqueiam a visão

Casas, árvores, paredes e outros objetos altos não deverão impedir que o jogador enxergue seu personagem.

Quando um objeto bloquear a câmera:

- O objeto poderá ficar parcialmente transparente.
- Paredes internas poderão desaparecer seletivamente.
- Telhados poderão ser ocultados quando o personagem entrar em um edifício.
- A transição deverá ser suave.
- A colisão física dos objetos continuará funcionando.

O jogador nunca deverá precisar adivinhar a posição do protagonista atrás de um prédio.

### 3.5. Movimento do personagem

Movimentação tridimensional livre, com suporte a oito direções ou movimento analógico contínuo.

Controles iniciais para PC:

| Tecla | Ação |
|---|---|
| WASD | Movimentação |
| Shift | Correr |
| E | Interagir |
| Mouse | Navegar pela interface |
| Roda do mouse | Zoom |
| Tab | Celular ou menu rápido, sujeito a testes |
| M | Mapa |
| Esc | Menu e configurações |

Deverá existir suporte planejado para controle.

As animações precisam acompanhar a velocidade e direção do personagem. Movimentar-se deverá ser agradável, com aceleração e desaceleração discretas. O personagem deverá virar naturalmente durante mudanças de direção.

### 3.6. Câmera em interiores

Interiores utilizarão a mesma linguagem visual da câmera externa. Entretanto, os enquadramentos poderão ser ajustados para ambientes menores.

Em uma sala de aula, por exemplo, a câmera deverá mostrar as carteiras, os alunos e o professor sem perder a visibilidade.

Casas e estabelecimentos poderão utilizar cortes de paredes e ocultação de telhados.

> **➜ V3:** enquadramentos específicos da aula (câmera da carteira, ida ao quadro, abertura da Janela de Questão) estão na seção 46.9.

## 4. HOSHIKAWA — CONCEPÇÃO DO MAPA

### 4.1. Filosofia da cidade

Hoshikawa será uma cidade japonesa fictícia de pequeno a médio porte.

O objetivo não é criar um mapa gigantesco. Queremos uma cidade compacta, visualmente marcante, interligada e cheia de atividades.

O jogador deverá conseguir aprender os caminhos naturalmente.

Cada rua deverá possuir alguma função:

- Conectar lugares importantes.
- Servir de atalho.
- Abrigar personagens ou estabelecimentos.
- Criar oportunidades de interação.
- Receber eventos.
- Oferecer uma paisagem memorável.
- Esconder pequenos segredos.

Não criar grandes áreas vazias apenas para aumentar a dimensão do mundo.

### 4.2. Formato do mundo

O mapa será desenvolvido em 3D com regiões conectadas. A exploração externa deverá transmitir a sensação de uma cidade contínua.

Proposta técnica: utilizar setores interligados e carregamento inteligente para preservar desempenho, evitando carregar todos os interiores simultaneamente.

As ruas deverão possuir conexões naturais, em vez de funcionar como salas isoladas. O jogador poderá caminhar do bairro residencial até a escola e, futuramente, até o centro comercial.

Interiores complexos poderão utilizar cenas separadas com transições discretas.

### 4.3. Estrutura geográfica oficial

Hoshikawa será formada por oito regiões principais:

1. Bairro Residencial.
2. Distrito Escolar.
3. Centro Comercial.
4. Parque Municipal.
5. Estação Hoshikawa.
6. Rio e Canal.
7. Distrito Antigo.
8. Colinas, Santuário e Mirante.

A organização geográfica geral seguirá esta lógica:

- **Norte:** colinas, santuário e mirante.
- **Norte/Centro:** distrito escolar, em uma área levemente elevada.
- **Centro:** bairro residencial, conectado à escola, ao comércio e ao parque.
- **Centro/Sul:** região comercial e estação.
- **Sul:** rio, pontes e distrito antigo.

Deverão existir conexões laterais e atalhos entre regiões. O mapa não deverá obrigar o jogador a retornar sempre a uma praça central para acessar outras áreas.

> **➜ V3:** novos locais por região (telhado da escola, loja escolar, sentō, karaokê, arcade, salão, clínica, casas visitáveis) estão na seção 59.

## 5. BAIRRO RESIDENCIAL

O bairro residencial será o primeiro ambiente explorável do jogo. É onde o protagonista viverá ao chegar a Hoshikawa.

### 5.1. Direção visual

O bairro deverá lembrar áreas residenciais japonesas contemporâneas.

Elementos desejados:

- Ruas estreitas e tranquilas.
- Casas japonesas modernas.
- Pequenos edifícios residenciais.
- Muros baixos.
- Jardins particulares.
- Calçadas estreitas.
- Postes e fios elétricos.
- Bicicletas.
- Máquinas de bebidas.
- Árvores e pequenos canteiros.
- Ruas secundárias.
- Escadarias e leves diferenças de elevação.

O ambiente deverá transmitir segurança, familiaridade e tranquilidade.

### 5.2. Estabelecimentos e locais

O bairro deverá conter:

- Casa do protagonista.
- Casas de NPCs importantes.
- Pequeno parque de bairro.
- Konbini.
- Máquina de bebidas.
- Ponto de ônibus.
- Ruas e vielas secundárias.

Nem todas as casas precisarão ter interiores acessíveis. Algumas poderão existir para completar o cenário e representar residências de personagens secundários.

### 5.3. Transformações ao longo do dia

- **Manhã:** estudantes saem de suas casas e seguem para a escola.
- **Tarde:** moradores circulam pelo bairro, crianças utilizam o parque e alguns estudantes retornam.
- **Noite:** as ruas ficam tranquilas, janelas acendem e o movimento diminui.

O mesmo cenário deverá transmitir atmosferas diferentes conforme horário, clima e estação.

## 6. CASA DO PROTAGONISTA

### 6.1. Contexto narrativo

O protagonista acaba de se mudar para Hoshikawa para morar com sua avó. Ela trabalha em outra cidade e passa bastante tempo fora, proporcionando ao jogador certa independência na administração da rotina doméstica.

A casa será um espaço importante de descanso, personalização e progressão.

> **➜ V3:** a avó recebe nome e ficha (Harue Mizushima, seção 49.1); o motivo da mudança passa a ser uma escolha do jogador (seção 45.4).

### 6.2. Estrutura sugerida

Uma residência japonesa de porte moderado, com:

- Entrada genkan.
- Pequena sala de estar.
- Cozinha.
- Área de refeições.
- Banheiro.
- Quarto do protagonista.
- Quarto da avó.
- Espaço para lavanderia.
- Pequeno jardim ou área externa.

A versão inicial poderá utilizar uma estrutura simplificada, desde que preserve a identidade da residência.

### 6.3. Funcionalidades

O jogador poderá:

- Dormir.
- Trocar de roupa.
- Personalizar o quarto.
- Utilizar computador.
- Utilizar celular.
- Estudar.
- Comer.
- Guardar objetos.
- Consultar o calendário.
- Organizar compromissos.
- Interagir com determinados móveis.

### 6.4. Personalização do quarto

Sistema proposto para expansão:

- Alteração de papel de parede.
- Mudança de piso.
- Posicionamento de móveis.
- Decoração de paredes.
- Estantes e objetos colecionáveis.
- Troca de cama, mesa e iluminação.
- Exposição de troféus, fotografias e lembranças.

Os objetos deverão encaixar em posições coerentes, evitando colisões e posicionamentos inválidos.

A personalização será cosmética, sem vantagens obrigatórias para o desempenho acadêmico.

## 7. DISTRITO ESCOLAR

A escola será o principal centro de gameplay. O cenário precisará receber maior atenção visual e funcional do que qualquer outro ambiente.

### 7.1. Exterior da escola

A escola ficará em uma área levemente elevada de Hoshikawa.

A chegada deverá possuir uma composição reconhecível:

- Rua de acesso inclinada.
- Portão principal.
- Placa com o nome da escola.
- Pátio frontal.
- Árvores e jardins.
- Prédio principal.
- Ginásio.
- Quadras.
- Campo esportivo.
- Piscina.
- Áreas de clubes.

O jogador deverá reconhecer imediatamente a escola ao se aproximar.

### 7.2. Prédio principal

O prédio será explorável e possuirá múltiplos pavimentos.

Ambientes planejados:

- Entrada e armários de sapatos.
- Corredores.
- Escadarias.
- Salas de aula.
- Biblioteca.
- Sala dos professores.
- Enfermaria.
- Laboratórios.
- Salas de arte.
- Sala de música.
- Sala de economia doméstica.
- Banheiros.
- Salas de clubes.
- Sala do conselho estudantil.
- Pátio interno.
- Área de almoço.

Proposta técnica: utilizar interiores modulares, de modo que salas e andares possam ser carregados separadamente conforme necessário.

### 7.3. Sala de aula

As salas deverão possuir:

- Carteiras individuais.
- Mesa do professor.
- Quadro.
- Janelas.
- Armários.
- Materiais escolares.
- Objetos de decoração específicos da turma.
- Posições atribuídas aos estudantes.

Cada estudante deverá ter uma carteira definida. Os NPCs deverão ocupar seus lugares durante as aulas, salvo quando houver justificativa narrativa ou mecânica.

> **➜ V3:** o mapa de assentos oficial da 1-A, com 30 carteiras nomeadas e a troca de lugares por sorteio a cada trimestre, está na seção 50.

### 7.4. Ginásio e instalações esportivas

O complexo esportivo poderá incluir:

- Ginásio de basquete e vôlei.
- Campo externo.
- Pista de atletismo simplificada.
- Piscina escolar.
- Vestiários.
- Depósito de equipamentos.
- Salas de clubes.

Os locais serão utilizados por clubes, aulas de educação física e competições.

### 7.5. Ambiente escolar vivo

Durante o intervalo, estudantes devem circular pelos corredores. No almoço, grupos se formarão em locais específicos. Depois das aulas, os clubes começarão suas atividades. Professores poderão circular pelo prédio.

Em datas especiais, a decoração da escola deverá mudar.

A escola não poderá funcionar como um cenário estático com personagens sempre posicionados nos mesmos lugares.

## 8. CENTRO COMERCIAL

O centro comercial será o principal local de atividades depois da escola. A arquitetura deverá lembrar ruas comerciais compactas de cidades japonesas.

### 8.1. Estabelecimentos planejados

- Restaurante de ramen.
- Café.
- Livraria.
- Loja de roupas.
- Arcade.
- Karaokê.
- Doceria.
- Farmácia.
- Pequena clínica.
- Lojas familiares.
- Pequena galeria comercial coberta.

Nem todos os estabelecimentos precisarão estar disponíveis no lançamento inicial.

### 8.2. Interações

O jogador poderá comprar itens, conversar com vendedores, encontrar NPCs, aceitar trabalhos e participar de atividades sociais.

Alguns estabelecimentos terão horários definidos.

O comércio deverá apresentar diferenças entre manhã, tarde e noite.

> **➜ V3:** nomes, donos, horários, empregos e preços de cada estabelecimento estão nas seções 49.6, 57 e 59.

## 9. ESTAÇÃO HOSHIKAWA

A estação será o principal ponto de ligação com áreas externas.

Deverá conter:

- Plataforma ferroviária.
- Entrada com bilheteria.
- Praça frontal.
- Ponto de ônibus.
- Bicicletário.
- Máquinas de bebidas.
- Pequenos estabelecimentos.

A estação também poderá receber cenas narrativas, encontros e eventos.

Viagens deverão levar a mapas específicos, não a um Japão inteiro explorável.

Áreas externas futuras:

- Praia.
- Cidade costeira.
- Locais de excursões escolares.
- Arenas de competições.
- Destinos de viagens de clubes.

> **➜ V3:** a cidade costeira recebe o nome de Shiosaki e aparece na excursão de junho, no acampamento de clubes de agosto e nos passeios de verão (seções 56 e 59).

## 10. PARQUE MUNICIPAL, RIO E DISTRITO ANTIGO

### 10.1. Parque Municipal

O parque será uma importante região de socialização.

Deverá possuir:

- Lago pequeno.
- Ponte.
- Caminhos de passeio.
- Bancos.
- Área gramada.
- Playground.
- Árvores sazonais.
- Máquinas de bebidas.
- Espaços de descanso.

Poderá receber encontros, atividades físicas e eventos menores.

### 10.2. Rio Hoshikawa

O rio será um marco visual da cidade. Possuirá margens acessíveis, pequenas pontes, caminhos para pedestres e áreas gramadas.

Personagens poderão caminhar, correr ou permanecer sentados em determinados pontos.

A região deverá ser especialmente bonita durante a primavera e ao entardecer.

### 10.3. Distrito Antigo

Bairro de arquitetura tradicional japonesa, localizado depois do rio.

Locais planejados:

- Rua tradicional.
- Casa de chá.
- Loja familiar.
- Pequeno templo.
- Loja de doces.
- Casas antigas.

Essa região deverá apresentar uma identidade arquitetônica diferente dos bairros modernos.

## 11. COLINAS, SANTUÁRIO E MIRANTE

A região norte de Hoshikawa apresentará uma transição gradual entre cidade e natureza.

O jogador encontrará:

- Ruas residenciais mais inclinadas.
- Escadarias.
- Trilhas.
- Vegetação.
- Portão torii.
- Santuário.
- Mirante.

O mirante deverá permitir observar uma representação panorâmica de Hoshikawa.

A região poderá receber eventos de Ano Novo, festivais e momentos narrativos especiais.

O percurso até o santuário deverá parecer uma pequena jornada sem se tornar excessivamente demorado.

> **➜ V3:** a lenda local do "rio que caiu do céu" (origem do nome Hoshikawa) é conteúdo da unidade 1 de História e liga o santuário, o mirante, o Clube de Ciências e Astronomia e a chuva de meteoros de agosto (seções 47.3 e 56).

## 12. ESCALA E DESLOCAMENTO NO MAPA

Hoshikawa deverá ser agradável de percorrer a pé.

Tempos de deslocamento originalmente planejados, medidos em tempo real aproximado durante a exploração:

| Trajeto | Tempo real aproximado |
|---|---|
| Casa → Escola | 1 a 2 minutos |
| Casa → Centro | aproximadamente 1 minuto |
| Centro → Estação | 30 a 45 segundos |
| Centro → Parque | 30 a 45 segundos |
| Parque → Escola | aproximadamente 1 minuto |
| Centro → Rio | aproximadamente 30 segundos |
| Rio → Distrito Antigo | 30 a 45 segundos |
| Escola → Santuário | aproximadamente 1 minuto |

Esses tempos deverão ser reavaliados após a implementação do movimento 3D.

A velocidade do relógio do jogo e a escala física do cenário deverão ser equilibradas para que o jogador consiga cumprir compromissos sem deslocamentos frustrantes.

**Regra: deslocamentos devem representar escolhas de tempo, não punições pela distância.**

> **➜ V3:** a bicicleta (seção 59.4) é a única aceleração de deslocamento planejada; não haverá viagem rápida gratuita.

## 13. CRIAÇÃO DO PROTAGONISTA

O jogador criará seu próprio personagem antes de começar a história.

### 13.1. Personalização visual

Sistema proposto:

- Nome.
- Sobrenome.
- Identidade e tratamento do personagem.
- Aparência facial.
- Tonalidade de pele.
- Estilo e cor dos cabelos.
- Olhos.
- Sobrancelhas.
- Acessórios.
- Estilo de roupa.

O sistema não precisará oferecer um editor facial extremamente complexo na primeira versão. A prioridade será permitir que o protagonista tenha identidade própria e combine com a direção artística dos NPCs.

### 13.2. Uniformes

O protagonista terá um uniforme escolar adequado ao calendário.

Será possível utilizar variações permitidas pela escola, como versões de verão e inverno.

Roupas casuais serão utilizadas fora do ambiente escolar.

### 13.3. Atributos iniciais

O protagonista começará como um estudante relativamente dedicado, com bom potencial acadêmico e menor experiência esportiva.

Entretanto, o jogador não deverá ser obrigado a manter esse perfil.

Os atributos poderão evoluir de maneira diferente conforme as atividades escolhidas.

> **➜ V3:** a criação passa a ter quatro passos (identidade, aparência, história e personalidade), com origem, motivo da mudança, talento inicial, traços, sonhos, humor, hábitos, diário e crescimento ao longo dos três anos. Ver seção 45. O perfil "dedicado" continua sendo o padrão.

## 14. TEMPO, CALENDÁRIO E PASSAGEM DOS DIAS

O tempo será uma das mecânicas centrais do jogo.

### 14.1. Calendário oficial

O jogo terá 12 meses: janeiro, fevereiro, março, abril, maio, junho, julho, agosto, setembro, outubro, novembro e dezembro.

Cada mês terá 14 dias. Consequentemente:

- 14 dias por mês.
- 12 meses por ano.
- 168 dias jogáveis por ano.
- 3 anos escolares completos.
- 504 dias jogáveis ao longo dos três anos.

Cada mês terá duas semanas completas. O calendário utilizará os sete dias tradicionais, de segunda-feira a domingo.

Todos os meses começam em uma segunda-feira por simplificação do sistema.

### 14.2. Ano letivo

O ano escolar começa em abril e termina em março.

O protagonista inicia no primeiro ano. Depois poderá avançar ao segundo e terceiro anos, até a formatura.

O mundo deverá refletir essa progressão. Estudantes mais velhos se formarão, novos alunos entrarão e os clubes poderão mudar de liderança.

### 14.3. Início oficial

**Segunda-feira, 1º de abril, 06:30.**

Velocidade original do protótipo: 1 segundo real = 1 minuto dentro do jogo.

Essa será a velocidade inicial de referência. Ajustes poderão ser feitos após testes para garantir conforto durante deslocamentos e atividades.

### 14.4. Regras de passagem do tempo

- O tempo avança naturalmente durante a exploração.
- Atividades programadas consomem períodos do dia.
- Conversas importantes poderão pausar o relógio.
- Menus não deverão consumir tempo injustamente.
- Dormir avança para a manhã seguinte.
- Todos os dias devem existir e ser potencialmente jogáveis.
- Não implementar saltos obrigatórios de vários dias.

Proposta adicional: criar velocidades alternativas de simulação e períodos de avanço contextual para atividades longas, sem permitir que isso quebre eventos ou horários de NPCs.

> **➜ V3:** a tabela central com todos os eventos do Ano 1, dia a dia, está na seção 56. Os três trimestres letivos (abril–julho, setembro–dezembro, janeiro–março) organizam provas, boletins e trocas de lugar.

## 15. CLIMA E ESTAÇÕES

O mundo deverá apresentar um sistema climático.

Estados climáticos planejados:

- Ensolarado.
- Parcialmente nublado.
- Nublado.
- Chuva leve.
- Chuva forte.
- Neblina ocasional.
- Neve em períodos apropriados.

O clima deverá afetar:

- Iluminação.
- Sons ambientes.
- Vestimentas.
- Rotinas de NPCs.
- Atividades externas.
- Disponibilidade de determinados eventos.

A chuva poderá alterar o comportamento dos estudantes, que passarão a utilizar guarda-chuvas e procurar áreas cobertas.

Durante o inverno, personagens poderão utilizar roupas mais quentes.

As quatro estações também modificarão a vegetação e determinados detalhes da cidade.

> **➜ V3:** a estação chuvosa (junho), o guarda-chuva como item e o evento de dividir o guarda-chuva estão nas seções 56 e 59.

## 16. SISTEMA DE ROTINA ESCOLAR

A escola será uma experiência jogável, não apenas uma coleção de cenas automáticas.

### 16.1. Dias letivos

Segunda a sexta-feira serão normalmente dias de aula. Sábados e domingos serão normalmente livres.

Entretanto, poderão ocorrer atividades extraordinárias durante os fins de semana, incluindo:

- Competições.
- Festivais.
- Reuniões.
- Atividades de clubes.
- Excursões.
- Preparação de eventos.

### 16.2. Horário escolar de referência

| Horário | Atividade |
|---|---|
| 06:30 | Acordar |
| 07:00–08:15 | Janela de chegada |
| 08:25–08:35 | Homeroom |
| 08:40–09:30 | Aula 1 |
| 09:40–10:30 | Aula 2 |
| 10:40–11:30 | Aula 3 |
| 11:40–12:30 | Aula 4 |
| 12:30–13:15 | Almoço |
| 13:15–14:05 | Aula 5 |
| 14:15–15:05 | Aula 6 |
| 15:05–15:20 | Limpeza escolar |
| 15:20–15:30 | Homeroom final |
| 15:30+ | Clubes e atividades livres |

### 16.3. Frequência e atrasos

O jogador poderá chegar atrasado ou faltar às aulas.

Porém, suas decisões poderão gerar consequências proporcionais:

- Redução de frequência.
- Perda de conteúdo.
- Advertências.
- Conversas com professores.
- Dificuldade em determinadas avaliações.
- Restrições acadêmicas.

Evitar punições exageradas que tornem uma única falta capaz de prejudicar permanentemente o jogo.

> **➜ V3:** o horário semanal por matéria (seção 46.2) e o sistema de ocorrências (seção 55.4) detalham frequência, atrasos e consequências.

## 17. SISTEMA DE AULAS

As aulas deverão ser interativas, mas não repetitivas.

Não será necessário completar seis minijogos por dia.

### 17.1. Matérias planejadas

- Japonês e Literatura.
- Matemática.
- Inglês.
- História e Estudos Sociais.
- Ciências.
- Educação Física.
- Artes.
- Economia Doméstica.

### 17.2. Funcionamento básico

Durante as aulas, o jogador poderá receber situações específicas.

Exemplos:

- Professor faz uma pergunta.
- Estudante pede ajuda.
- O jogador escolhe prestar atenção.
- O jogador revisa outra matéria.
- Um evento especial acontece.
- O professor anuncia uma prova.
- Um colega tenta conversar.

As respostas e escolhas poderão modificar conhecimento, relações e disciplina.

### 17.3. Apresentação das aulas

Proposta: utilizar uma combinação de participação presencial e avanço contextual.

O jogador entra na sala e ocupa sua carteira. A aula começa.

O sistema apresenta situações interativas relevantes e permite avançar períodos menos importantes.

A passagem do tempo será integrada naturalmente à rotina escolar.

O objetivo é fazer o jogador sentir que participa da vida escolar sem transformar cada aula em uma espera obrigatória.

> **➜ V3:** esta seção é expandida integralmente na seção 46 (aula em cinco fases, Postura de Foco, Momentos de Aula, Missões de Sala, Janela de Questão e Diretor de Aula) e na seção 47 (currículo e banco de questões).

## 18. NOTAS, PROVAS E PROGRESSÃO ACADÊMICA

As notas não serão determinadas apenas pelo atributo Inteligência.

O desempenho deverá considerar:

- Conhecimento da matéria.
- Frequência.
- Pontualidade.
- Participação.
- Tarefas.
- Estudo.
- Resultados das provas.
- Decisões durante as aulas.

### 18.1. Avaliações

O calendário terá períodos de avaliação.

Proposta: utilizar provas com perguntas, pequenos desafios e verificações de conhecimento.

As avaliações deverão apresentar dificuldade compatível com o jogo, sem exigir conhecimento acadêmico avançado do jogador.

O desempenho acadêmico influenciará oportunidades escolares.

### 18.2. Consequências das notas

Notas altas poderão oferecer:

- Reconhecimento acadêmico.
- Acesso a atividades especiais.
- Oportunidades relacionadas ao conselho.
- Eventos com professores e colegas.

Notas baixas poderão gerar:

- Recuperação.
- Estudos extras.
- Orientação de professores.
- Restrições temporárias.
- Risco de reprovação em situações persistentes.

A reprovação deverá ser possível, mas sua implementação definitiva dependerá de um sistema de progressão que não destrua injustamente o tempo investido pelo jogador.

> **➜ V3:** dever de casa, cinco períodos de prova, fórmula de nota, boletim, ranking e recuperação estão na seção 48.

## 19. SISTEMA DE ATRIBUTOS

Atributos representarão o desenvolvimento pessoal do protagonista.

### 19.1. Atributos principais

- **Conhecimento / Inteligência:** capacidade acadêmica, aprendizagem e compreensão de matérias.
- **Carisma:** comunicação, expressão e habilidade de interação social.
- **Condicionamento / Esporte:** preparo físico, desempenho esportivo e capacidade atlética.
- **Criatividade:** desenvolvimento artístico, produção criativa e resolução de determinadas atividades.
- **Disciplina:** organização, responsabilidade e consistência nas tarefas.
- **Empatia:** compreensão social, sensibilidade e capacidade de lidar com situações interpessoais.

### 19.2. Progressão

Os atributos deverão melhorar através de atividades coerentes.

Exemplos:

- Estudar desenvolve conhecimento.
- Participar de atividades sociais pode desenvolver carisma.
- Treinar melhora condicionamento.
- Criar obras e praticar artes desenvolve criatividade.
- Cumprir responsabilidades pode desenvolver disciplina.
- Ajudar e compreender outros personagens pode desenvolver empatia.

### 19.3. Tempo como custo principal

O sistema não deverá funcionar como uma troca artificial de atributos.

Estudar não deverá diminuir automaticamente o condicionamento físico.

O verdadeiro custo é o tempo.

Se o jogador utilizar duas horas estudando, não poderá utilizar essas mesmas duas horas treinando ou participando de outro compromisso.

### 19.4. Especializações

Os atributos poderão abrir oportunidades.

Exemplos:

- Carisma e conhecimento favorecem participação no conselho estudantil.
- Condicionamento e experiência favorecem liderança esportiva.
- Criatividade favorece clubes artísticos.
- Disciplina influencia determinadas responsabilidades escolares.

Os valores máximos, fórmulas de progressão e níveis ainda precisarão ser definidos durante o desenvolvimento.

> **➜ V3:** o protótipo usa escala 0–100 para os seis atributos. A V3 acrescenta o **Domínio por matéria** (seção 47.1), separado do atributo Conhecimento, e define limites diários de ganho para evitar repetição mecânica.

## 20. CLUBES ESCOLARES

Os clubes serão um dos sistemas de progressão mais importantes do jogo.

### 20.1. Clubes planejados

- Natação.
- Vôlei.
- Basquete.
- Atletismo.
- Música.
- Artes.
- Literatura.

Outros clubes poderão ser adicionados posteriormente.

### 20.2. Estrutura dos clubes

Cada clube deverá possuir:

- Professor responsável.
- Capitão ou presidente.
- Integrantes.
- Veteranos (senpais).
- Novatos (kouhais).
- Horários de atividade.
- Requisitos de participação.
- Relações internas.
- Eventos próprios.
- Objetivos e competições.

### 20.3. Progressão esportiva

Nos clubes esportivos, o jogador poderá:

- Participar de treinos.
- Desenvolver habilidades.
- Ganhar experiência.
- Melhorar desempenho.
- Participar de seletivas.
- Competir.
- Disputar posições na equipe.
- Eventualmente se tornar capitão.

A progressão deverá considerar habilidade, presença, compromisso e relações com o grupo.

O jogador não receberá automaticamente uma posição de liderança apenas por ser o protagonista.

### 20.4. Progressão artística e cultural

Clubes artísticos terão atividades diferentes.

O clube de música poderá trabalhar com ensaios e apresentações. O clube de artes poderá envolver criação de trabalhos e exposições. O clube de literatura poderá organizar atividades e publicações escolares.

Cada clube deverá oferecer uma trajetória própria.

> **➜ V3:** a seção 54 acrescenta o Clube de Ciências e Astronomia e o Jornal Escolar, define professores responsáveis, capitães, integrantes do elenco, loop de treino, patentes e competições.

## 21. CONSELHO ESTUDANTIL E REPUTAÇÃO

O conselho estudantil será um caminho alternativo de progressão.

Poderá envolver:

- Campanhas.
- Eleições.
- Organização de eventos.
- Relações com professores.
- Responsabilidades escolares.
- Interações com representantes de turma.

O acesso a determinados cargos dependerá de requisitos e eventos. NPCs também poderão disputar posições.

### 21.1. Reputação

Sistema proposto: a reputação será dividida em dimensões, evitando uma única barra universal de popularidade.

Exemplos:

- Reputação acadêmica.
- Reputação esportiva.
- Reputação social.
- Reputação institucional.

Um estudante pode ser conhecido por suas boas notas e, ao mesmo tempo, pouco envolvido nas atividades sociais.

O sistema deverá produzir diferenças narrativas, não simplesmente transformar todos os NPCs em admiradores do jogador.

> **➜ V3:** representantes de turma, cargos por ano escolar, campanha, debate, ocorrências disciplinares e efeitos de cada dimensão de reputação estão na seção 55.

## 22. NPCs, INTELIGÊNCIA SOCIAL E ROTINAS

Os NPCs serão um dos principais diferenciais do School Life.

### 22.1. Fichas individuais

Cada NPC importante deverá possuir:

- Identificador permanente.
- Nome.
- Idade.
- Ano escolar.
- Turma.
- Aniversário.
- Personalidade.
- Aparência.
- Clube, se aplicável.
- Família e relações relevantes.
- Amigos.
- Preferências.
- Locais favoritos.
- Rotina semanal.
- Objetivos pessoais.
- Eventos narrativos.
- Estado de relacionamento com o protagonista.

### 22.2. Rotinas dinâmicas

Um NPC deverá seguir compromissos coerentes.

Exemplo:

- 07:20 — sai de casa.
- 08:10 — chega à escola.
- 08:30 — participa das atividades escolares.
- 12:30 — encontra amigos durante o almoço.
- 15:40 — participa do clube.
- 18:00 — sai da escola.
- 18:20 — visita um estabelecimento ou retorna para casa.

Os horários são exemplos e deverão variar conforme cada personagem.

### 22.3. Comportamento independente

Os personagens deverão:

- Conversar entre si.
- Participar de atividades sem o jogador.
- Manter amizades próprias.
- Ausentar-se em determinados dias.
- Reagir a eventos.
- Alterar rotinas conforme o calendário.
- Desenvolver objetivos e conflitos pessoais.

### 22.4. Organização técnica

Proposta: usar um sistema de rotinas baseado em dados, estados e horários.

Não será necessário simular fisicamente todos os NPCs distantes da câmera.

Personagens fora da região ativa poderão ter suas posições e atividades calculadas logicamente. Ao carregar uma região, deverão aparecer em posições coerentes com o horário atual.

Isso ajudará a manter o desempenho do mundo 3D.

> **➜ V3:** o elenco completo com fichas está na seção 49; o grafo de relações entre NPCs e os arcos que acontecem sem o jogador estão na seção 51. O formato de rotinas do protótipo (`data/npcs.json`) é a base do formato V3 descrito na seção 61.

## 23. SISTEMA DE AMIZADES E RELACIONAMENTOS

O sistema social deverá possuir profundidade comparável à dos principais simuladores de vida.

Entretanto, não poderá depender exclusivamente de repetir conversas e entregar presentes diariamente.

### 23.1. Amizades

O jogador poderá desenvolver vínculos através de:

- Conversas.
- Participação em atividades.
- Ajuda em situações pessoais.
- Convites.
- Eventos escolares.
- Presentes apropriados.
- Escolhas durante diálogos.
- Experiências compartilhadas.

O vínculo deverá ser influenciado pela personalidade do NPC.

Um personagem reservado poderá levar mais tempo para confiar no protagonista. Outro poderá ser sociável desde o primeiro encontro.

### 23.2. Níveis de relacionamento

Proposta inicial: utilizar uma escala interna de vínculo de 0 a 1000 pontos, apresentada visualmente em níveis de afinidade.

Essa escala é provisória e deverá ser ajustada durante testes.

A progressão poderá desbloquear eventos e diálogos.

Entretanto, valores altos não deverão garantir automaticamente amizade profunda ou romance. Alguns eventos poderão exigir decisões específicas.

### 23.3. Romance

O romance deverá ser uma opção, não uma obrigação.

O jogador poderá conhecer personagens compatíveis, desenvolver amizades e, quando as condições forem adequadas, iniciar um namoro.

O sistema deverá respeitar a ambientação adolescente e apresentar relacionamentos apropriados à idade dos personagens.

Elementos planejados:

- Desenvolvimento gradual de sentimentos.
- Conversas pessoais.
- Convites para passeios.
- Eventos de afinidade.
- Confissões.
- Namoro.
- Datas especiais.
- Desentendimentos cotidianos.
- Reconciliações.
- Mudanças conforme a progressão dos anos escolares.

O namoro não deverá encerrar a progressão social do personagem. Após começar um relacionamento, novos diálogos, eventos e atividades poderão surgir.

### 23.4. Amizades igualmente importantes

Personagens que não sejam interesses românticos deverão possuir histórias próprias.

Amizades profundas poderão desbloquear acontecimentos tão significativos quanto os romances.

O jogador também deverá conseguir permanecer solteiro durante toda a experiência.

### 23.5. Relações entre NPCs

Os NPCs poderão manter vínculos independentes.

Determinados personagens poderão começar o jogo com amizades, rivalidades ou relacionamentos existentes.

O mundo social deverá continuar mudando ao longo dos três anos.

> **➜ V3:** níveis de vínculo, ritmo de confiança por personagem, tópicos de conversa, presentes, saídas, saídas em grupo e as etapas do romance estão na seção 52.

## 24. DIÁLOGOS E EVENTOS NARRATIVOS

### 24.1. Sistema de diálogo

A interface de diálogo deverá apresentar:

- Nome do personagem.
- Texto.
- Retrato expressivo, quando apropriado.
- Opções de resposta.
- Indicação de continuidade.
- Histórico recente de conversa.

### 24.2. Escolhas

As respostas poderão influenciar:

- Relações.
- Reputação.
- Atributos.
- Eventos futuros.
- Oportunidades.
- Desenvolvimento de personagens.

Nem toda escolha precisará alterar um atributo. Algumas deverão existir simplesmente para construir personalidade e proporcionar uma experiência narrativa.

### 24.3. Tipos de eventos

- **Eventos fixos:** acontecem em datas planejadas.
- **Eventos condicionais:** dependem de atributos, relações, escolhas ou atividades.
- **Eventos dinâmicos:** dependem do estado atual dos personagens e do mundo.

### 24.4. Apresentação

Eventos importantes poderão utilizar:

- Animações especiais.
- Mudanças de câmera.
- Retratos.
- Música própria.
- Objetos interativos.
- Pequenas sequências cinematográficas.

A prioridade será narrativa expressiva com recursos compatíveis com uma produção independente.

> **➜ V3:** a voz do protagonista nos diálogos (registros Gentil, Direto, Reservado e opção de traço) está na seção 45.7.

## 25. CALENDÁRIO DE EVENTOS ANUAIS

O jogo deverá incluir uma adaptação de festivais japoneses e acontecimentos escolares ao calendário de 14 dias por mês.

| Mês | Eventos principais |
|---|---|
| Abril | Início do ano, cerimônia de entrada, orientação e recrutamento de clubes |
| Maio | Golden Week adaptada e atividades sociais |
| Junho | Avaliações, possível excursão e estação chuvosa |
| Julho | Tanabata, provas e início das férias de verão |
| Agosto | Férias, festivais, fogos de artifício, viagens e eventos de verão |
| Setembro | Retorno às aulas |
| Outubro | Festival esportivo |
| Novembro | Festival cultural, eleições e atividades de clubes |
| Dezembro | Provas e férias de inverno |
| Janeiro | Ano Novo, Hatsumode e retorno escolar |
| Fevereiro | Setsubun, Valentine's Day e preparação acadêmica |
| Março | Provas finais, resultados, White Day e formatura |

As datas específicas deverão ser definidas em uma tabela central de eventos.

O calendário poderá oferecer diferentes experiências dependendo dos clubes e relacionamentos do jogador.

> **➜ V3:** a tabela central de eventos do Ano 1, com datas exatas no calendário de 14 dias, está na seção 56.

## 26. TRABALHOS DE MEIO PERÍODO E ECONOMIA

O dinheiro será um recurso importante, mas não deverá se tornar o foco central do jogo.

### 26.1. Fontes de renda

- Mesada.
- Trabalhos de meio período.
- Recompensas por determinadas atividades.
- Pequenos serviços e oportunidades especiais.

### 26.2. Possíveis empregos

- Atendente de café.
- Auxiliar de konbini.
- Funcionário de livraria.
- Atendente de restaurante.
- Auxiliar em loja comercial.

Cada trabalho deverá possuir horários, remuneração e requisitos.

### 26.3. Despesas

O jogador poderá gastar dinheiro com:

- Alimentação.
- Roupas.
- Presentes.
- Transporte.
- Atividades recreativas.
- Objetos de decoração.
- Materiais para hobbies.

O dinheiro será apresentado em ienes japoneses (¥).

### 26.4. Equilíbrio

Trabalhar oferece renda, mas consome tempo.

Quem utiliza tardes trabalhando terá menos disponibilidade para clubes, estudos e encontros.

Nenhum caminho deverá ser automaticamente superior aos outros.

> **➜ V3:** turnos, remuneração, requisitos, atividade de cada emprego, mesada e tabela de preços estão na seção 57.

## 27. SISTEMA DE ENERGIA E NECESSIDADES

O jogo deverá possuir uma mecânica leve de energia. Não queremos um simulador de sobrevivência.

### 27.1. Energia

Atividades poderão consumir energia dependendo de sua intensidade.

Exemplos:

- Correr.
- Treinar.
- Trabalhar.
- Estudar durante longos períodos.

Dormir e descansar recuperam energia.

### 27.2. Alimentação

Refeições poderão ajudar na recuperação de energia.

Entretanto, o jogador não deverá ser obrigado a alimentar o personagem a cada poucos minutos.

### 27.3. Sono

Dormir tarde poderá provocar cansaço no dia seguinte.

Evitar penalidades exageradas e sistemas que obriguem uma rotina perfeita.

A energia deverá oferecer decisões interessantes, não restringir excessivamente a liberdade.

> **➜ V3:** o humor do protagonista (seção 45.9) complementa a energia sem bloquear ações; o sono em aula (seção 46.5) é a principal consequência de energia baixa durante o período escolar.

## 28. CELULAR DO PROTAGONISTA

Novo sistema proposto: o celular será a principal interface de organização e comunicação.

Deverá permitir:

- Visualizar agenda.
- Consultar calendário.
- Ver contatos.
- Receber mensagens.
- Consultar amizades.
- Receber convites.
- Acompanhar tarefas.
- Visualizar compromissos de clubes.
- Verificar notificações escolares.

### 28.1. Mensagens

Os NPCs poderão enviar mensagens em horários apropriados.

Exemplos:

- Convite para passear.
- Aviso de reunião.
- Mensagem de aniversário.
- Pedido de ajuda.
- Informação sobre eventos.
- Conversas pessoais.

Mensagens não deverão interromper permanentemente a exploração.

### 28.2. Sistema de convites

O jogador poderá convidar personagens quando houver disponibilidade.

A aceitação dependerá de:

- Horário.
- Agenda.
- Relação.
- Evento.
- Preferências.

Um NPC poderá recusar por estar ocupado, sem que isso signifique necessariamente perda de amizade.

> **➜ V3:** aplicativos do celular, grupo da turma, app Escola (horário, notas, ranking, ocorrências), diário e álbum estão na seção 58.

## 29. HUD — INTERFACE DURANTE A EXPLORAÇÃO

A interface será moderna, limpa e discreta.

O jogador deverá enxergar o ambiente tridimensional sem excesso de elementos na tela.

### 29.1. Identidade visual do HUD

Proposta estética:

- Painéis pequenos e arredondados.
- Transparência moderada.
- Tons neutros e suaves.
- Ícones simples.
- Tipografia clara.
- Animações discretas.
- Pequenos detalhes visuais relacionados à estação atual.

A interface deverá combinar com o estilo aconchegante do mundo.

### 29.2. Canto superior direito

Exibir um painel compacto contendo:

```
SEG • 01 ABR
06:30
Primavera — Ensolarado
```

O relógio deverá ser o elemento de maior destaque dentro do painel. Abaixo poderão aparecer dia, mês, estação e clima.

### 29.3. Canto superior esquerdo

Exibir informações contextuais.

Exemplo:

```
Escola Hoshikawa
Próxima atividade: Homeroom — 08:25
```

Quando não houver compromissos importantes, essa área poderá ser recolhida.

### 29.4. Canto inferior esquerdo

Exibir, quando necessário:

- Indicador de energia.
- Pequeno ícone de estado.
- Avisos de efeitos temporários.

Evitar barras enormes ocupando a tela.

### 29.5. Canto inferior direito

Exibir pequenos atalhos para:

- Celular.
- Mochila.
- Mapa.
- Menu.

Os ícones poderão desaparecer parcialmente durante a exploração normal.

### 29.6. Informações de dinheiro

O dinheiro deverá ficar disponível no inventário e no celular.

Durante compras, o saldo em ienes ficará visível no painel comercial.

Não será necessário exibir dinheiro permanentemente durante toda a exploração.

### 29.7. Interações contextuais

Quando o protagonista se aproximar de um objeto interativo, aparecerá uma indicação.

Exemplos:

```
E — Conversar
E — Abrir porta
E — Sentar
E — Examinar
```

A indicação deverá desaparecer ao sair do alcance.

> **➜ V3:** o "pequeno ícone de estado" do canto inferior esquerdo passa a representar o humor do protagonista (seção 45.9).

## 30. MENUS E INTERFACES SECUNDÁRIAS

### 30.1. Menu principal

Opções:

- Continuar.
- Novo jogo.
- Carregar jogo.
- Configurações.
- Créditos.
- Sair.

### 30.2. Inventário

Interface organizada em categorias.

Exemplos:

- Itens pessoais.
- Presentes.
- Roupas.
- Objetos de atividades.
- Itens importantes.

O inventário não precisará funcionar como um sistema de armazenamento agrícola.

### 30.3. Tela de personagem

Apresentar:

- Nome.
- Ano escolar.
- Turma.
- Atributos.
- Clube.
- Histórico acadêmico.
- Reputação.
- Condição atual.

### 30.4. Tela social

Exibir personagens conhecidos.

Cada ficha poderá apresentar:

- Nome.
- Retrato.
- Relação atual.
- Aniversário conhecido.
- Informações descobertas.
- Eventos importantes já vividos.

Informações pessoais dos NPCs deverão ser reveladas progressivamente.

### 30.5. Mapa

O mapa deverá mostrar Hoshikawa em uma representação estilizada.

Funcionalidades propostas:

- Regiões.
- Localização do jogador.
- Edifícios importantes.
- Estabelecimentos conhecidos.
- Pontos de interesse.
- Objetivos ativos.

Evitar revelar automaticamente a localização precisa de todos os NPCs. O jogador deverá aprender suas rotinas e locais favoritos.

## 31. ANIMAÇÕES E EXPRESSIVIDADE

Os personagens deverão possuir animações compatíveis com o mundo 3D.

### 31.1. Protagonista

Animações iniciais:

- Parado.
- Caminhada.
- Corrida.
- Interação.
- Sentar.
- Levantar.
- Dormir.
- Utilizar celular.
- Reação durante diálogos.

### 31.2. NPCs

Além das animações básicas, NPCs importantes poderão possuir:

- Conversar.
- Acenar.
- Ler.
- Comer.
- Utilizar celular.
- Carregar mochila.
- Estudar.
- Alongar.
- Treinar.
- Demonstrar emoções.

### 31.3. Animações contextuais

O sistema deverá permitir associar animações às atividades.

Exemplo:

- Um estudante no clube de literatura poderá aparecer lendo.
- Um atleta no ginásio poderá realizar movimentos de aquecimento.
- Um NPC no café poderá estar sentado com uma bebida.

**Regra: a movimentação e a animação devem reforçar a sensação de uma cidade habitada.**

> **➜ V3:** a lista de animações do protagonista é ampliada na seção 45.13 (variações de parado por humor, escrever na carteira, levantar a mão, ir ao quadro, guarda-chuva, bicicleta, comer bento, alongar).

## 32. ILUMINAÇÃO, CLIMA VISUAL E CICLO DIA/NOITE

O sistema de iluminação deverá ser dinâmico.

### 32.1. Manhã

- Luz suave.
- Sombras alongadas.
- Cores claras.
- Atmosfera tranquila.

### 32.2. Meio-dia

- Iluminação mais intensa.
- Sombras definidas.
- Cores vibrantes.
- Maior atividade nas ruas.

### 32.3. Entardecer

- Iluminação dourada.
- Céu alaranjado.
- Sombras longas.
- Atmosfera visual mais acolhedora.

### 32.4. Noite

- Iluminação natural reduzida.
- Postes acesos.
- Janelas iluminadas.
- Lojas com iluminação artificial.
- Reflexos discretos no chão durante chuva.

A iluminação deverá priorizar legibilidade e desempenho.

Não será necessário utilizar tecnologias gráficas extremamente caras para produzir resultados agradáveis.

## 33. ÁUDIO E TRILHA SONORA

A direção sonora deverá reforçar a atmosfera cotidiana japonesa.

### 33.1. Música

Criar faixas originais para:

- Menu principal.
- Manhã na cidade.
- Caminho para a escola.
- Ambientes escolares.
- Centro comercial.
- Parque.
- Noite.
- Dias chuvosos.
- Festivais.
- Eventos narrativos.

A trilha deverá ser agradável durante sessões longas.

### 33.2. Sons ambientais

- Pássaros.
- Cigarras no verão.
- Chuva.
- Passos.
- Portas.
- Sinos escolares.
- Conversas ambientes.
- Trânsito distante.
- Água corrente.
- Sons de estabelecimentos.

### 33.3. Áudio contextual

A música e os sons deverão mudar de forma suave conforme o jogador atravessa regiões.

Os ambientes internos terão paisagens sonoras próprias.

## 34. SISTEMA DE PROGRESSÃO DOS TRÊS ANOS

O projeto completo acompanhará o protagonista do primeiro ano até a formatura.

### 34.1. Primeiro ano

Foco em:

- Adaptação a Hoshikawa.
- Conhecimento da escola.
- Formação das primeiras amizades.
- Entrada em clubes.
- Desenvolvimento inicial dos atributos.
- Descoberta da cidade.

### 34.2. Segundo ano

Foco em:

- Consolidação das relações.
- Novas responsabilidades.
- Progressão nos clubes.
- Mudanças na composição das turmas.
- Novas oportunidades acadêmicas.
- Desenvolvimento de conflitos e histórias pessoais.

### 34.3. Terceiro ano

Foco em:

- Preparação para a formatura.
- Decisões sobre o futuro.
- Responsabilidades escolares.
- Últimas competições e festivais.
- Conclusão de arcos narrativos.
- Consequências acumuladas das decisões anteriores.

### 34.4. Evolução dos NPCs

O mundo deverá evoluir com o tempo.

Personagens veteranos poderão se formar. Novos estudantes poderão entrar. Capitães e presidentes de clubes poderão mudar.

Algumas relações e oportunidades serão diferentes conforme o ano escolar.

### 34.5. Finais

Proposta: criar encerramentos variados baseados na trajetória do jogador.

Os finais poderão considerar:

- Desempenho acadêmico.
- Atividades.
- Clubes.
- Relações.
- Objetivos pessoais.
- Principais escolhas.

O jogo não deverá possuir apenas um final considerado correto.

> **➜ V3:** os Sonhos do protagonista (seção 45.8) e os arcos de três anos de cada personagem (seção 49) alimentam os finais. O crescimento visível do protagonista entre anos está na seção 45.12.

## 35. PRÓLOGO OFICIAL

A experiência deverá começar com a chegada do protagonista a Hoshikawa.

### 35.1. Cena de abertura

O jogador chega à Estação Hoshikawa com uma mala e uma mochila. O cenário apresenta parte da cidade.

A estação estará em funcionamento e os moradores seguirão suas rotinas.

Após a chegada, o protagonista utilizará o transporte local para alcançar o bairro residencial.

### 35.2. Chegada à casa

O protagonista chegará à residência da avó.

O primeiro diálogo apresentará a situação familiar e os motivos da mudança.

A avó poderá explicar informações básicas sobre a cidade, a casa e o início das aulas.

### 35.3. Primeiros controles

O prólogo funcionará como um tutorial integrado à história.

O jogador aprenderá:

- Movimento.
- Câmera.
- Interação.
- Uso do celular.
- Consulta ao calendário.
- Acesso ao inventário.
- Exploração básica.

Não concentrar todas as explicações em uma sequência extensa de tutoriais.

### 35.4. Início da vida escolar

Após a introdução, a história avançará para a manhã do primeiro dia letivo:

**SEG • 01 ABR • 06:30**

O protagonista acordará e iniciará sua rotina. Esse momento marcará o início oficial do ciclo diário.

> **➜ V3:** o prólogo passa a refletir origem e motivo da mudança (seção 45.4) e termina com o primeiro Cartão de Conteúdo (um provérbio dito pela avó) que será perguntado na primeira Janela de Questão (Missão de Sala M-02, seção 46.7).

## 36. TECNOLOGIA E ARQUITETURA DO PROJETO

### 36.1. Engine

Manter Godot 4 e GDScript.

A versão original do projeto foi iniciada na Godot 4.7.2 Stable.

A versão de desenvolvimento utilizada na migração deverá ser validada antes de alterar o projeto.

### 36.2. Migração do 2D para o 3D

O projeto anterior utilizava sistemas como:

- CharacterBody2D.
- Sprite2D.
- CollisionShape2D.
- TileMapLayer.
- CanvasLayer.
- GameTime.

Na nova estrutura, deverão ser utilizados recursos próprios para 3D.

Exemplos:

- CharacterBody3D.
- CollisionShape3D.
- Camera3D.
- MeshInstance3D.
- AnimationTree.
- NavigationAgent3D.
- NavigationRegion3D.

A interface continuará utilizando sistemas de UI da Godot.

> **➜ V3:** o checkout atual nasceu diretamente em 3D (ver `docs/DECISIONS.md`); não houve código 2D a migrar. O item permanece como registro histórico.

### 36.3. Separação de responsabilidades

Evitar um único script gigantesco. Criar sistemas independentes.

Estrutura conceitual proposta:

- **Core:** gerenciamento de cenas, eventos globais, salvamento, configurações.
- **Time:** GameTime, SchoolCalendar, SchoolSchedule, WeatherSystem.
- **Player:** movimento, câmera, atributos, inventário, interações.
- **NPC:** dados individuais, rotinas, navegação, comportamentos, relacionamentos.
- **School:** aulas, matérias, notas, clubes, conselho estudantil.
- **World:** regiões, estabelecimentos, eventos, transições, objetos interativos.
- **UI:** HUD, menus, celular, diálogos, mapa.

### 36.4. Dados externos

Sempre que possível, armazenar informações de NPCs, eventos, horários, objetos e atividades em recursos de dados.

Evitar informações importantes inseridas diretamente em scripts específicos.

Isso facilitará adicionar novos personagens e conteúdos sem reescrever sistemas existentes.

### 36.5. Modelagem 3D

Utilizar um fluxo de trabalho com modelos originais.

O Blender poderá ser utilizado para:

- Modelagem de personagens.
- Objetos.
- Edifícios.
- Animações.
- Preparação de recursos.

A exportação poderá utilizar glTF/GLB quando apropriado.

O projeto deverá organizar materiais, texturas e modelos de forma consistente.

> **➜ V3:** módulos novos, arquivos de dados, esquema do save v3 e migração estão na seção 61.

## 37. DESEMPENHO E OTIMIZAÇÃO

O jogo será desenvolvido inicialmente para PC.

Deverá funcionar de maneira satisfatória em máquinas intermediárias, com opções gráficas configuráveis.

### 37.1. Estratégias

- Limitar objetos ativos fora da câmera.
- Utilizar níveis de detalhe quando necessário.
- Reduzir materiais e chamadas de renderização excessivas.
- Reutilizar modelos de objetos comuns.
- Evitar simular personagens distantes desnecessariamente.
- Carregar interiores sob demanda.
- Utilizar navegação eficiente.
- Controlar quantidade de sombras dinâmicas.
- Utilizar instâncias para vegetação e objetos repetidos.

### 37.2. Opções gráficas

Criar opções para:

- Resolução.
- Qualidade das sombras.
- Distância de renderização.
- Qualidade dos efeitos.
- Escala de renderização.
- Limite de FPS.
- V-Sync.
- Tela cheia e modo janela.

O desempenho deverá ser testado desde os primeiros protótipos.

## 38. SAVE E PERSISTÊNCIA

O sistema de salvamento deverá preservar a continuidade do mundo.

Informações necessárias:

- Ano escolar.
- Mês.
- Dia.
- Hora.
- Localização.
- Dinheiro.
- Inventário.
- Roupas.
- Atributos.
- Notas.
- Clube.
- Relacionamentos.
- Escolhas narrativas.
- Eventos concluídos.
- Estados de NPCs.
- Progresso acadêmico.
- Estado da casa.

### 38.1. Compatibilidade

O sistema deverá ser projetado para permitir a expansão do jogo em atualizações.

Novos conteúdos e anos escolares não deverão exigir o reinício obrigatório do progresso.

Utilizar versionamento dos arquivos de salvamento e rotinas de migração quando necessário.

> **➜ V3:** o protótipo grava um slot JSON v2 com validação, temporário e backup. O esquema v3 e a migração v2 → v3 estão na seção 61.4.

## 39. CONTEÚDO DO ACESSO ANTECIPADO

O jogo será lançado progressivamente.

A primeira versão comercial deverá priorizar conteúdo completo e funcional do primeiro ano escolar.

Não tentar produzir os três anos imediatamente.

### 39.1. Escopo do primeiro ano

Priorizar:

- Vida escolar.
- Rotina diária.
- Progressão acadêmica.
- Clubes selecionados.
- Personagens importantes.
- Relações e eventos.
- Exploração de Hoshikawa.
- Personalização.
- Economia básica.
- Festivais essenciais.

### 39.2. Expansões

Atualizações futuras poderão incluir:

- Novos bairros.
- Novos estabelecimentos.
- Mais clubes.
- Personagens adicionais.
- Novos romances.
- Áreas externas.
- Eventos sazonais.
- Mais atividades.
- Segundo ano escolar.
- Terceiro ano e formatura.

A progressão dos três anos deverá ser planejada desde o início, mesmo que seu conteúdo completo seja produzido posteriormente.

## 40. PRIMEIRO PROTÓTIPO 3D — VERSÃO 0.1

Antes de construir a cidade inteira, criar um protótipo pequeno e jogável.

Nome interno: **School Life 3D — First Day**.

### 40.1. Ambientes

A primeira versão técnica deverá conter:

- Quarto do protagonista.
- Área básica da casa.
- Pequena rua residencial.
- Caminho até a escola.
- Entrada da escola.
- Corredor escolar.
- Sala de aula.

### 40.2. Personagens

Adicionar inicialmente:

- Protagonista controlável.
- Um NPC estudante.
- Um NPC professor.
- Um NPC de teste para rotinas.

Esses personagens não precisam ter histórias completas nessa etapa.

### 40.3. Mecânicas mínimas

Implementar:

1. Movimento 3D.
2. Câmera elevada funcional.
3. Colisões.
4. Transição entre ambientes.
5. HUD de data e hora.
6. Calendário.
7. Interação com objetos.
8. Diálogo simples.
9. Horário escolar básico.
10. Rotina mínima de NPC.
11. Dormir.
12. Avançar para o dia seguinte.
13. Salvar e carregar.

### 40.4. Objetivo de validação

O jogador deverá conseguir:

Acordar → sair do quarto → explorar a casa → caminhar pelo bairro → chegar à escola → interagir com um NPC → participar de uma atividade escolar → voltar para casa → dormir → iniciar o próximo dia.

Somente após esse ciclo funcionar adequadamente devemos expandir a produção.

> **➜ V3:** este ciclo está implementado e coberto por testes automatizados (seção 44). A validação manual em PC com renderização continua pendente (`docs/VALIDATION.md`).

## 41. ROADMAP DE PRODUÇÃO 3D

- **Fase 1 — Fundação 3D:** configurar o projeto, importar modelos, criar personagem, colisões, movimento e câmera.
- **Fase 2 — Protótipo de ambiente:** criar uma rua residencial tridimensional e testar escala, perspectiva e legibilidade.
- **Fase 3 — Interações:** implementar objetos interativos, diálogos, portas e transições.
- **Fase 4 — Tempo e HUD:** integrar o GameTime existente à nova interface e aos ambientes 3D.
- **Fase 5 — Calendário escolar:** implementar SchoolCalendar e SchoolSchedule.
- **Fase 6 — NPCs:** criar personagens com rotinas, horários e navegação.
- **Fase 7 — Escola:** implementar salas de aula, presença, atividades e eventos simples.
- **Fase 8 — Progressão:** criar atributos, desempenho acadêmico e clubes.
- **Fase 9 — Relacionamentos:** implementar amizade, eventos sociais e sistemas de diálogo avançados.
- **Fase 10 — Mundo e conteúdo:** expandir regiões, estabelecimentos, personalização e eventos.
- **Fase 11 — Polimento:** melhorar animações, interfaces, áudio, iluminação, desempenho e estabilidade.
- **Fase 12 — Acesso antecipado:** preparar lançamento inicial e estrutura de atualizações.

> **➜ V3:** as fases 1 a 5 estão concluídas em forma de protótipo; as fases 6 e 7 estão parcialmente iniciadas. O roadmap por marcos jogáveis (0.2 "First Week" até 1.0) está na seção 62.

## 42. REGRAS DE DESENVOLVIMENTO PARA A IA

A IA responsável por auxiliar no desenvolvimento deverá seguir estas regras:

1. Não alterar decisões consolidadas sem consultar o responsável pelo projeto.
2. Diferenciar funcionalidades planejadas de funcionalidades implementadas.
3. Não inventar arquivos, cenas ou sistemas como se já existissem.
4. Antes de modificar o projeto, verificar a estrutura real dos arquivos disponíveis.
5. Manter o desenvolvimento em Godot e GDScript, salvo decisão explícita em contrário.
6. Priorizar sistemas reutilizáveis e modulares.
7. Construir uma funcionalidade por vez.
8. Explicar os arquivos e cenas criados.
9. Fornecer códigos completos quando solicitado, evitando trechos incompletos.
10. Validar dependências entre cenas, scripts e recursos.
11. Preservar o sistema de calendário de 14 dias.
12. Manter a cidade compacta e explorável.
13. Respeitar a direção visual 3D estilizada.
14. Não transformar o jogo em simulador de fazenda.
15. Não simplificar os sistemas sociais ao ponto de torná-los superficiais.
16. Considerar desempenho e escalabilidade desde o protótipo.
17. Não implementar a cidade inteira antes de validar o ciclo principal.
18. Planejar a progressão até a formatura, mas produzir inicialmente o primeiro ano.
19. Utilizar recursos artísticos originais ou devidamente licenciados.
20. Registrar as decisões e mudanças importantes em documentação atualizada.

> **➜ V3:** regras adicionais (21 a 26) sobre conteúdo em dados, banco de questões, sorteio determinístico, elenco e testes estão na seção 63.3.

## 43. DECISÕES CONSOLIDADAS E PONTOS PROVISÓRIOS (V2.0)

### Decisões consolidadas

- Simulação de vida escolar no Japão.
- Cidade fictícia Hoshikawa.
- Protagonista criado pelo jogador.
- Três anos escolares até a formatura.
- Calendário de 14 dias por mês.
- Todos os dias jogáveis.
- Escola como núcleo de gameplay.
- Atributos desenvolvidos por atividades.
- Clubes escolares.
- NPCs com rotinas próprias.
- Amizade e romance com progressão.
- Tempo como recurso principal.
- Mundo construído progressivamente.
- Godot e GDScript.
- Foco inicial em PC.
- Primeiro ano como conteúdo do acesso antecipado.
- Migração da direção visual para 3D estilizado, inspirada em Coral Island.

### Especificações novas que ainda exigem validação (na V2.0)

- Configuração exata da câmera.
- Níveis e limites de zoom.
- Possibilidade de rotação.
- Proporções finais dos modelos.
- Identidade definitiva dos retratos de diálogo.
- Layout exato do HUD.
- Sistema detalhado do celular.
- Fórmulas de atributos.
- Quantidade e escala dos vínculos.
- Quantidade de NPCs e clubes iniciais.
- Modelo de eventos românticos.
- Métodos de apresentação das aulas.
- Dificuldade das provas.
- Sistema de personalização da casa.
- Equilíbrio de energia.
- Formato definitivo dos finais.
- Configurações mínimas de hardware.
- Escala final dos setores 3D.

Esses pontos serão tratados como propostas de design, não como funcionalidades prontas.

> **➜ V3:** a seção 63 atualiza esta lista: vários itens receberam propostas concretas (celular, vínculos, quantidade de NPCs e clubes, apresentação das aulas, dificuldade das provas, eventos românticos) e continuam marcados como provisórios até os testes.

---

# PARTE II — EXPANSÃO V3.0

## 44. ESTADO REAL DO PROJETO — PROTÓTIPO 0.1 "FIRST DAY"

Esta seção existe para cumprir a regra 42.2: diferenciar o que existe do que está planejado. Fonte: checkout atual do repositório (`README.md`, `docs/DECISIONS.md`, `docs/VALIDATION.md`, scripts e dados).

### 44.1. Itens da seção 40 e seu estado

| Item | Estado | Observação |
|---|---|---|
| Quarto, casa, rua residencial + caminho + entrada da escola, corredor, sala 1-A | `[IMPLEMENTADO 0.1]` | Cinco cenas em `scenes/world/` (`bedroom`, `home`, `neighborhood`, `school_hall`, `classroom`), geometria procedural em GDScript |
| Protagonista controlável | `[IMPLEMENTADO 0.1]` | `CharacterBody3D`, nome, tom de pele e cor de cabelo; sem rosto, penteados ou roupas variadas |
| NPC estudante, NPC professor, NPC de rotina | `[IMPLEMENTADO 0.1]` | Yui Tanaka (1-A), Professor Sato (orientador da 1-A), Ren Mori (vizinho da 1-B) em `data/npcs.json` |
| Movimento 3D, câmera elevada, colisões, transições | `[IMPLEMENTADO 0.1]` | Câmera ortográfica fixa com comparação em perspectiva, zoom, transparência de obstáculos |
| HUD de data e hora, calendário | `[IMPLEMENTADO 0.1]` | 14 dias por mês, 12 meses, início SEG · 01 ABR · 06:30, 1 segundo = 1 minuto |
| Interação com objetos, diálogo simples | `[IMPLEMENTADO 0.1]` | Pontos de interação, diálogos com duas respostas, vínculo 0–1000 com limite diário |
| Horário escolar básico | `[IMPLEMENTADO 0.1]` | `data/schedule.json` com um único dia fixo de nove períodos; participação com duas escolhas (seção 17 original) |
| Rotina mínima de NPC | `[IMPLEMENTADO 0.1]` | Entradas por minuto do dia, cena, ponto, trajeto `via` e `patrol`; só a região atual é simulada |
| Dormir, próximo dia, salvar e carregar | `[IMPLEMENTADO 0.1]` | Save JSON v2, temporário, backup, validação e migração v1 → v2 |
| Energia, estudo, descanso, alimentação, compra | `[IMPLEMENTADO 0.1]` | Economia mínima (onigiri a ¥200, ¥1.500 iniciais) |
| Testes automatizados | `[IMPLEMENTADO 0.1]` | 62 verificações headless e workflow no GitHub Actions |

### 44.2. O que o protótipo **não** tem

Prólogo da estação, restante de Hoshikawa, modelos e retratos finais, áudio, clima, festivais, férias, provas e notas, faltas com consequências, clubes, empregos, decoração, convites, romance, conteúdo dos três anos. As conversas atuais são validação técnica, não o sistema social final.

### 44.3. Pontos de encaixe para a Parte II

Os sistemas da V3 devem **estender** o que existe, não substituir:

| Existente | Como a V3 se apoia nele |
|---|---|
| `GameState.attributes` (seis atributos 0–100) | Permanece. A V3 acrescenta `mastery` (Domínio por matéria), `mood`, `traits`, `dream`, `reputation` |
| `GameState.relationships` (0–1000 por NPC) | Permanece como pontuação bruta; a V3 define níveis, ritmo e eventos (seção 52) |
| `GameState.attendance` (chave `data:período`) | Permanece; recebe campos de postura, momentos e ocorrências (seção 46) |
| `GameState.flags` | Permanece para marcos; missões passam a ter estrutura própria (seção 53) |
| `GameTime` (minuto do dia, 14 dias) | Permanece intacto; `SchoolCalendar` e `EventScheduler` consultam `stamp()` |
| `SchoolSchedule` + `data/schedule.json` | O arquivo de períodos continua; a V3 acrescenta `data/timetable.json` com a matéria de cada período por dia da semana |
| `NPCManager` + `data/npcs.json` | O formato de rotina é mantido e ganha campos de ficha (seção 61.2); o arquivo pode ser dividido por personagem |
| `SaveSystem` v2 | Sobe para v3 com migração aditiva (seção 61.4) |

## 45. PROTAGONISTA V3 — IDENTIDADE, HISTÓRIA E CRESCIMENTO

`[PARCIAL]` — o protótipo tem nome, pele e cabelo. Tudo o mais nesta seção é `[PLANEJADO]`.

### 45.1. Princípio

O protagonista não é um avatar vazio nem um personagem fechado. É uma **moldura com voz**: o jogador define origem, traços e sonhos; o jogo devolve alguém com voz interior, humor, memórias e crescimento visível ao longo dos três anos.

Três compromissos de design:

1. Toda escolha de criação precisa aparecer no jogo em falas, reações de NPCs ou pequenas opções — nunca ser só um número escondido.
2. Nenhuma escolha de criação fecha caminhos. Ela muda o começo, não o destino.
3. O perfil padrão continua sendo o estudante dedicado da V2.0 (bom potencial acadêmico, menor experiência esportiva).

### 45.2. Criação em quatro passos

| Passo | Conteúdo | Pré-visualização |
|---|---|---|
| 1. Identidade | Nome, sobrenome, tratamento (ele / ela / neutro, independente do corpo), aniversário no calendário de 14 dias (padrão sugerido: 10 de outubro) | Nome na placa da carteira e no armário de sapatos |
| 2. Aparência | Rosto, pele, olhos, sobrancelhas, cabelo, altura, compleição, acessórios (seção 45.13) | Modelo 3D girando com uniforme de inverno; botões para uniforme de verão e roupa casual |
| 3. História | Origem (45.3), motivo da mudança (45.4), talento inicial (45.5) | Texto curto do prólogo muda ao vivo |
| 4. Personalidade | Dois traços entre dez (45.6) | Exemplo de fala desbloqueada por traço |

O aniversário do protagonista gera um evento próprio: mensagens de NPCs conforme o nível de vínculo, bolo da avó se ela estiver em casa e, a partir do nível 4, um pequeno presente ou convite.

### 45.3. Origem

| Origem | O que muda | Marcas no mundo |
|---|---|---|
| **Capital** (Tóquio ou outra metrópole) | Item inicial: cartão de trem antigo. Falas sobre trens lotados e silêncio das ruas de Hoshikawa | Aiko quer saber tudo sobre lojas da capital; o Professor Kurata desconfia de "gente da cidade grande" até a unidade de história local |
| **Interior** (vila de montanha) | Item inicial: amuleto do vilarejo. Reconhece plantas e festivais | A Professora Fujii e o Mestre Arai se aproximam mais rápido (+50 de vínculo inicial); Mei acha "rústico", depois muda de ideia |
| **Retorno do exterior** (kikokushijo) | Domínio inicial de Inglês +15 e de Japonês e Literatura −5. Item: caderno bilíngue | O Professor Hill fala em inglês com o protagonista; questões de Literatura nível 1 aparecem com uma dica extra no primeiro trimestre |

### 45.4. Motivo da mudança

Afeta o prólogo, as mensagens da família no celular e um arco familiar de baixa intensidade. Nenhuma opção domina o tom slice of life.

| Motivo | Prólogo | Arco familiar |
|---|---|---|
| **Transferência dos pais para o exterior** | A avó busca o protagonista na estação; os pais mandam fotos de outro fuso horário | "Saudade": mensagens fora de hora, chamada de vídeo no Obon (agosto), visita curta no Ano Novo |
| **Recomeço após a separação dos pais** | A avó explica que a casa "sempre foi um lugar seguro"; o protagonista recebe mensagens separadas da mãe e do pai | "Duas casas": escolher com quem passar o Ano Novo; conversa com a avó em fevereiro sobre não precisar escolher lados |
| **Escolha própria** (cuidar da avó, escola menor) | O protagonista chega sozinho; a avó deixa a chave com a vizinha Sra. Ueno | "Raízes": a avó aparece mais nas conversas; no Ano 2, uma preocupação com a saúde dela movimenta a rotina da casa |

### 45.5. Talento inicial

Mantém a soma de 43 pontos do protótipo (`DEFAULT_STATS`). O talento define a distribuição, um item e um Domínio inicial.

| Talento | Conhecimento | Carisma | Condicionamento | Criatividade | Disciplina | Empatia | Item | Domínio inicial |
|---|---|---|---|---|---|---|---|---|
| **Dedicado** (padrão) | 15 | 5 | 3 | 5 | 10 | 5 | Caderno de capa dura | +10 em Matemática |
| **Atleta** | 8 | 6 | 12 | 3 | 8 | 6 | Tênis de corrida | +10 em Educação Física |
| **Artista** | 9 | 5 | 4 | 14 | 5 | 6 | Estojo de lápis de desenho | +10 em Artes |
| **Sociável** | 8 | 13 | 5 | 5 | 4 | 8 | Capinha de celular chamativa | +10 em Inglês |

### 45.6. Traços de personalidade (dois entre dez)

Traços são leves: desbloqueiam uma quarta opção de fala em diálogos marcados, dão um modificador pequeno e têm afinidade com um tipo de Momento de Aula (seção 46.5).

| Traço | Efeito mecânico | Falas desbloqueadas | Afinidade em aula |
|---|---|---|---|
| **Curioso** | 20% de chance de receber um Cartão de Conteúdo extra ao prestar atenção | Perguntas diretas sobre a vida do NPC | Desafio do professor |
| **Tímido** | +15% de vínculo em conversas a sós, −15% em grupo | Respostas hesitantes que alguns NPCs acham encantadoras | Bilhete passado (pode ignorar sem custo social) |
| **Sociável** | +15% de vínculo em grupo, −15% a sós | Apresentações espontâneas, convites em cadeia | Trabalho em dupla |
| **Competitivo** | +10% de Domínio ganho em provas; humor Ansioso mais fácil após derrotas | Provocações amistosas com Daichi e Riku | Exercício no quadro |
| **Sonhador** | Olhar pela janela três vezes na semana dá +1 Criatividade extra | Comentários sobre o céu, cores e sons | Evento da janela |
| **Prático** | Deveres de casa levam 20% menos tempo | Soluções diretas em conflitos | Verificação do dever |
| **Teimoso** | Segunda tentativa em questões de nível 1 e 2 (custa reputação social se errar de novo) | Insistência que irrita Rina e diverte Tsubasa | Debate / apresentação |
| **Observador** | Vê o humor do NPC desde o nível 1 de vínculo (os demais só a partir do nível 2) | Comentários sobre detalhes que o NPC não contou | Colega em apuros |
| **Brincalhão** | +50 de vínculo inicial com Tsubasa; chance maior de ocorrência leve | Piadas que mudam o clima de uma cena | Interrupção |
| **Cuidadoso** | Metade da chance de ser flagrado em ações de risco em aula | Avisos e cuidados que Hina valoriza | Experimento |

Traços podem **evoluir** por eventos (seção 45.12): Tímido → Reservado, Brincalhão → Bem-humorado, Competitivo → Determinado. A evolução é narrada, não imposta.

### 45.7. Voz do protagonista

Sempre que fizer sentido, as opções de diálogo seguem três registros, mais a opção de traço:

- **Gentil** — tende a Empatia; aproxima personagens sensíveis.
- **Direto** — tende a Carisma; aproxima personagens práticos.
- **Reservado / Silêncio** — não altera atributos; alguns NPCs preenchem o silêncio e revelam algo (recompensa o traço Observador).
- **Opção de traço** — aparece só quando o protagonista tem o traço exigido.

Entre cenas, o protagonista tem **pensamentos** curtos em itálico (uma linha), usados com moderação: ao acordar, ao ver uma nota no mural, ao receber uma mensagem inesperada. Os pensamentos alimentam o Diário (45.11).

### 45.8. Sonhos (aspirações de longo prazo)

Os Sonhos não são escolhidos na criação. Aparecem na **Pesquisa de Futuro**, entregue pelo Professor Sato na Hora da Turma de quinta-feira, 11 de abril ("O que você quer ser?"). "Indeciso" é uma resposta válida e abre arcos de descoberta. O Sonho pode ser trocado na escrivaninha do quarto uma vez por trimestre.

| Sonho | Marcos do Ano 1 (exemplos) | Fontes principais | Influência no final |
|---|---|---|---|
| Universidade | Ranking de turma ≤ 10; grupo de estudo avançado; conversa com Kōhei sobre vestibular | Domínio, Conhecimento, Disciplina | Final acadêmico |
| Atleta | Titular em clube esportivo; pódio em uma competição; capitã/capitão no Ano 3 | Condicionamento, clube, Festival Esportivo | Final esportivo |
| Artista | Obra na exposição do Festival Cultural; retrato encomendado por um NPC | Criatividade, Clube de Artes | Final artístico |
| Músico | Apresentação com a banda de Taiga; composição própria | Criatividade, Carisma, Clube de Música | Final artístico |
| Escritor / Jornalista | Texto no jornal escolar; redação premiada em maio | Domínio de Literatura, Jornal Escolar | Final cultural |
| Empreendedor | Trabalhar em dois estabelecimentos; organizar a barraca da 1-A no festival | Carisma, dinheiro, reputação social | Final comunitário |
| Professor | Monitoria de Kenta; ajudar o Professor Hill no clube de conversação | Empatia, Domínio, reputação acadêmica | Final acadêmico-comunitário |
| Indeciso | Experimentar três clubes; três conversas "sobre o futuro" com NPCs diferentes | Exploração | Desbloqueia o final "Ainda descobrindo", tratado como válido e bonito |

### 45.9. Humor

O humor é um estado leve, exibido como o pequeno ícone do canto inferior esquerdo do HUD. **Nunca bloqueia ações.**

| Estado | Como surge | Efeito | Como passa |
|---|---|---|---|
| **Tranquilo** | Padrão | Nenhum | — |
| **Animado** | Dormir antes das 23:00 por três noites; boa conversa; vitória | +10% de vínculo em conversas; ganhos de aula +1 | Dura até o fim do dia |
| **Inspirado** | Olhar pela janela; visitar o mirante; ver uma obra na exposição; ouvir música ao vivo | +1 Criatividade em atividades artísticas; opção extra em Proposta criativa | Dura 2 dias |
| **Cansado** | Energia abaixo de 30 ao acordar; dormir depois das 23:00 | Custos de energia +20%; chance de Sono em aula | Dormir bem; descansar na enfermaria |
| **Ansioso** | Semana de provas com Domínio médio < 40; conflito não resolvido; ocorrência | Questões aparecem com +1 de risco; dica do vizinho indisponível | Estudar com alguém; conversa de nível 3+; treino |
| **Triste** | Discussão; promessa quebrada; resultado abaixo do esperado; despedida | −10% de vínculo em grupo; falas mais curtas | Conversa com a avó; mensagem de amigo; dia seguinte |

O humor dos NPCs usa os mesmos seis estados e aparece no painel de conversa (seção 52.3).

### 45.10. Hábitos

Sequências repetidas viram hábitos com bônus passivo. Quebrar a sequência apenas remove o bônus.

| Hábito | Condição | Bônus enquanto ativo |
|---|---|---|
| Ritmo de estudo | Estudar em casa 5 dias seguidos | Estudar custa 20% menos energia |
| Corrida matinal | Correr com Ren ou sozinho 3 manhãs na semana | +1 Condicionamento extra por semana |
| Boa noite | Dormir antes das 23:00 por 5 noites | Acordar Animado |
| Dever em dia | 10 deveres entregues com qualidade A ou B | +1 Disciplina por semana |
| Presença | Nenhum atraso em um mês | Sato libera a "Justificativa de confiança" (uma saída antecipada por mês sem ocorrência) |

### 45.11. Diário e Álbum

- **Diário:** ao dormir, o jogo escreve uma entrada automática a partir do registro do dia (aulas, momentos, conversas, missões) usando modelos de frase com a voz do protagonista. O jogador pode acrescentar uma nota curta (até 140 caracteres). Entradas ficam no app Diário do celular e na escrivaninha. Limite: 504 entradas, uma por dia.
- **Álbum de memórias:** eventos marcantes geram um **Cartão de Memória** (título, data, participantes, ícone, uma frase). Exemplos: primeira conversa com cada personagem importante, primeiro dia de clube, Tanabata, fogos, resultado de prova, purikura com amigos. Cartões aparecem no quadro de cortiça do quarto e no app Álbum. Servem de base para a Retrospectiva de fim de ano.

### 45.12. Crescimento em três anos

| Mudança | Ano 1 → Ano 2 | Ano 2 → Ano 3 |
|---|---|---|
| Corpo | +1% na escala do modelo | +1% |
| Insígnia da turma | Verde → azul | Azul → vermelha |
| Penteados | +4 opções no salão | +4 opções |
| Voz interior | Pensamentos mais longos; menos perguntas, mais conclusões | Pensamentos sobre o futuro e despedidas |
| Traços | Primeira evolução possível por evento | Segunda evolução possível |
| Retrospectiva | Tela de fim de ano com estatísticas, memórias e relações | Idem, com comparação ao ano anterior |

### 45.13. Especificação visual do protagonista

Objetivo: o protagonista precisa ter a mesma qualidade visual dos NPCs principais e, ao mesmo tempo, suportar personalização.

**Modelo e rig**

- Um corpo base por compleição (esguio, médio, forte) com três alturas por blendshape (155, 165 e 175 cm). O tratamento escolhido não restringe corpo nem roupas.
- Orçamento: 12 a 18 mil triângulos no corpo e roupas, até 4 mil no cabelo, LOD1 com 50% e LOD2 com 20%. Sombras dinâmicas somente no LOD0.
- Esqueleto humanoide compatível com retargeting da Godot (`Skeleton3D` + `AnimationTree`), compartilhado com todos os NPCs.
- 24 blendshapes faciais: seis visemas básicos, piscar, e as emoções alegria, surpresa, vergonha, irritação, tristeza, foco e sono, com variantes de intensidade.
- Olhos com shader de brilho estilizado e pupilas que acompanham o interlocutor em diálogos.

**Personalização**

- 6 tons de pele, 5 formatos de olho, 12 cores de íris, 4 sobrancelhas, 3 formatos de rosto.
- 12 penteados base × 10 cores, com franja opcional; 4 penteados adicionais por ano no salão Cut & Star (seção 59).
- Acessórios: óculos (3), presilhas, fones de ouvido, pulseira, relógio.
- Roupas em camadas: uniforme de inverno (blazer, camisa, gravata ou laço, calça ou saia, meia-calça opcional), meia-estação (colete ou cardigã), verão (camisa de manga curta), traje de Educação Física (camiseta e calção, cor da insígnia do ano), traje de natação, yukata para festivais, casaco e cachecol no inverno. Casual: 12 conjuntos iniciais mais os comprados na Shirakawa Boutique.
- Regra escolar: no período letivo, dentro da escola, uniforme obrigatório; acessórios permitidos; penteado livre.

**Animações do protagonista (lista ampliada da seção 31.1)**

Parado (variações por humor: Cansado com ombros caídos, Animado balançando, Ansioso mexendo nas mãos), caminhar, correr, correr com mochila, virar, sentar e levantar (carteira, banco, chão), escrever na carteira, levantar a mão, caminhar até o quadro e escrever, passar bilhete, receber bilhete, cochilar na carteira, acordar assustado, comer bento, beber da máquina, usar celular em pé e sentado, guarda-chuva (abrir, andar, fechar), pedalar, alongar, aquecer, nadar (clube), arremessar (clube), tocar instrumento (clube), desenhar, ler, dormir, reações de diálogo (concordar, rir, surpresa, vergonha).

**Retratos 2D**

Como o protagonista é personalizável, os retratos usam um **sistema por camadas**: base do rosto por formato, camadas de olhos, sobrancelhas, cabelo e roupa atual, com oito expressões. Os NPCs usam retratos desenhados à mão com as mesmas oito expressões, para manter coerência de estilo.

## 46. SISTEMA DE AULAS V3 — MOMENTOS DE AULA, MISSÕES DE SALA E JANELA DE QUESTÃO

`[PARCIAL]` — o protótipo tem períodos fixos, espera contextual e uma participação com duas escolhas. Tudo o mais é `[PLANEJADO]`.

### 46.1. Objetivos de design

1. Participar de uma aula deve ser **curto, variado e consequente**: no máximo três janelas interativas por dia por padrão, cada uma com menos de 60 segundos.
2. Habilidade do jogador e atributos do personagem contam **juntos**: o jogador responde de verdade às questões, mas Domínio, postura e amizades mudam a dificuldade, as dicas e os resultados.
3. A aula é um **lugar social**: vizinhos de carteira, bilhetes, pedidos de ajuda e duplas ligam o sistema de aulas ao sistema de vínculo.
4. A aula é um **lugar físico em 3D**: ir ao quadro, trocar de sala para laboratório ou ginásio, olhar pela janela e evacuar no simulado usam o espaço, não apenas menus.
5. Tudo é **conteúdo em dados**: matérias, momentos, missões e questões vivem em JSON (seção 61), para que novos conteúdos não exijam novo código.

### 46.2. Horário semanal da 1-A

Os horários dos períodos continuam os da seção 16.2. O que muda é a matéria de cada período por dia da semana (`data/timetable.json`).

| Período | Segunda | Terça | Quarta | Quinta | Sexta |
|---|---|---|---|---|---|
| 1 (08:40) | Japonês e Literatura | Matemática | Inglês | Ciências | Matemática |
| 2 (09:40) | Matemática | Japonês e Literatura | Matemática | Japonês e Literatura | Ciências |
| 3 (10:40) | Inglês | Ciências | Japonês e Literatura | Matemática | Japonês e Literatura |
| 4 (11:40) | Ciências | Inglês | História e Est. Sociais | Inglês | Economia Doméstica |
| 5 (13:15) | História e Est. Sociais | Artes | Educação Física | História e Est. Sociais | Educação Física |
| 6 (14:15) | Educação Física | Artes | Economia Doméstica | Hora da Turma | Estudo dirigido |

Totais semanais: Literatura 5, Matemática 5, Inglês 4, Ciências 4, História 3, Educação Física 3, Artes 2 (aula dupla), Economia Doméstica 2, Hora da Turma 1, Estudo dirigido 1.

- **Hora da Turma (quinta, período 6):** decisões coletivas, Pesquisa de Futuro, preparação de festivais, eleição de representantes.
- **Estudo dirigido (sexta, período 6):** o jogador escolhe a matéria; funciona como estudo em casa com colegas por perto (Daichi ajuda em Matemática, Nozomi em Literatura).
- Educação Física, Ciências (laboratório), Artes e Economia Doméstica acontecem em **outras salas**: o jogador precisa se deslocar no intervalo de 10 minutos. Chegar depois do sinal gera atraso leve.

### 46.3. Anatomia de um período de aula

| Fase | Duração no relógio | O que acontece | Interação |
|---|---|---|---|
| 1. Chegada | Até o sinal | Sala em tempo real: sentar, conversar com vizinhos, conferir o dever, ler o mural | Livre |
| 2. Chamada e abertura | 2 min | Professor entra pela rotina; chamada; aviso do dia | Automática; atraso vira ocorrência leve se > 5 min |
| 3. Exposição | 30–40 min | O jogador escolhe uma **Postura de Foco** (46.4); o tempo avança em blocos de 10 minutos (cerca de 2 segundos reais cada); o Diretor de Aula (46.8) dispara de 0 a 2 **Momentos de Aula** (46.5) | Escolha de postura + momentos |
| 4. Encerramento | 5 min | Dever de casa, aviso de prova, pedido de material; os Cartões de Conteúdo revelados vão para o Caderno | Resumo em uma tela |
| 5. Intervalo | 10 min | Sala livre, NPCs conversam entre si, loja escolar aberta no almoço, deslocamento para a próxima sala | Livre |

O jogador pode, a qualquer momento da fase 3, escolher **"Ficar até o fim"** para avançar o restante do período sem novos momentos (equivalente ao `attend` atual do protótipo). Momentos de missão roteirizada não podem ser pulados dessa forma.

### 46.4. Postura de Foco

A postura é escolhida no início da exposição e pode ser trocada entre blocos de 10 minutos. O **risco** é a chance de o próximo "Pergunta do professor" cair sobre o protagonista com um nível a mais de dificuldade.

| Postura | Efeito principal | Energia | Risco | Observações |
|---|---|---|---|---|
| **Prestar atenção** | +2 Domínio da matéria; revela 2 Cartões de Conteúdo | −5 | 0% | Postura padrão |
| **Anotar com cuidado** | +1 Domínio; +1 Página de Caderno (bônus em provas e dever) | −7 | 0% | Permite "Consultar caderno" na Janela de Questão desta aula |
| **Revisar outra matéria** | +1 Domínio em matéria escolhida; 0 na atual | −5 | 25% | Se flagrado, −1 de relação com o professor; Kurata e Kawaguchi flagram mais |
| **Descansar discretamente** | +8 energia | 0 | 35% | Se flagrado: ocorrência leve e questão difícil |
| **Conversar baixinho** | +8 de vínculo com o vizinho escolhido | −3 | 30% | Depende do vizinho aceitar (Hina recusa; Tsubasa sempre aceita); se flagrados, ambos levam advertência |
| **Olhar pela janela** | +1 Criatividade (máximo 1 por dia); habilita Eventos da janela | −2 | 20% | Única postura que dispara o momento `window_event` |

### 46.5. Catálogo de Momentos de Aula

Cada momento tem identificador (para dados e testes), gatilho, janela de interação e resultados. Pesos e condições ficam em `data/class_moments.json`.

| Id | Momento | Quando tende a acontecer | Interação | Resultados típicos |
|---|---|---|---|---|
| `question` | **Pergunta do professor** | Qualquer aula teórica; mais provável com postura de risco | Janela de Questão (46.6) com 1 questão | Certo: +Domínio, +reputação acadêmica, +relação com o professor. Errado: +1 Domínio (aprendeu), explicação mostrada |
| `board` | **Exercício no quadro** | Matemática, Inglês, Ciências | O personagem caminha até o quadro em 3D; Janela com 2–3 passos encadeados | Como `question`, com o dobro de reputação acadêmica; plateia reage |
| `pair_work` | **Trabalho em dupla** | Inglês, Ciências, Artes, Economia Doméstica | Escolha de parceiro entre vizinhos adjacentes; janela cooperativa em que cada passo é "respondido" por um dos dois (o do NPC usa o Domínio dele) | +vínculo com o parceiro; +Domínio; cria pretexto para convite depois da aula |
| `note` | **Bilhete passado** | Qualquer aula; depende de vizinhos com vínculo ≥ 1 | Ler / Passar adiante / Devolver / Ignorar; conteúdo escrito pelo NPC remetente | Pequenos ganhos de vínculo; convites; risco de flagrante conforme o professor |
| `help_request` | **Colega em apuros** | Vizinho com Domínio baixo na matéria (Kenta em Inglês, Tsubasa em Matemática) | Explicar (−1 bloco de atenção, +vínculo, +Empatia) / Passar a resposta (+vínculo, risco, −Disciplina) / Recusar | Abre a missão de monitoria quando repetido |
| `pop_quiz` | **Prova surpresa** | 1 por matéria por trimestre, sem aviso | Janela com 3 questões | Conta 5% da nota do trimestre; +Domínio |
| `challenge` | **Desafio do professor** | Kawaguchi (Matemática) toda segunda; outros ocasionalmente | "Quem quiser tentar…": levantar a mão é opcional; questão de nível 3 | Acerto: +2× Domínio e +reputação acadêmica; erro sem punição, mas Daichi sorri (rivalidade +) |
| `window_event` | **Evento da janela** | Só com postura Olhar pela janela | Algo acontece lá fora: o gato Mochi no telhado do ginásio, o time de atletismo passando, as primeiras gotas de chuva, pétalas caindo | Flags para missões (telhado, guarda-chuva), +Inspirado; chance de ser chamado desatento |
| `drowsy` | **Sono em aula** | Energia < 30 ou dormiu depois das 23:00 | Barra de tempo "ficar acordado" (três toques no ritmo) | Falha: cabeça na carteira, ocorrência leve, perde os Cartões do bloco. Kenta cutuca o protagonista se vínculo ≥ 2 |
| `interruption` | **Interrupção** | Aleatório raro; roteirizado em datas | Aviso do conselho (Kaede ou Rina), chamada da enfermaria, visita do diretor, simulado de evacuação | Flags, pequenas escolhas, movimentação em 3D |
| `homework_check` | **Verificação do dever** | Primeira aula da matéria após um dever atribuído | Entregou (qualidade A/B/C) / Esqueceu: honestidade, desculpa (teste de Carisma) ou copiar de Daichi na hora (risco) | Disciplina, relação com o professor, 15% da nota (48.3) |
| `presentation` | **Apresentação** | Agendada com 1 semana de aviso (Inglês, História) | Requer item "Material de apresentação"; 3 escolhas de conteúdo + teste de Carisma | Reputação social e acadêmica; reações de toda a turma |
| `lab` | **Experimento** | Ciências, no laboratório | Grupos de 4; sequência de 3 passos em janela; um passo com barra de tempo | Sucesso: +Domínio para o grupo. Falha: fumaça, limpeza, humor da Fujii |
| `reading` | **Leitura em voz alta** | Literatura, Inglês | Escolher a leitura ou pronúncia correta entre 3 | Tímido: opção de "ler baixinho" com metade do ganho |
| `art_prompt` | **Proposta criativa** | Artes, Economia Doméstica | Escolha de tema e técnica (sem resposta errada); qualidade do resultado por Criatividade | Cria um item (desenho, bento, costura) que pode virar presente |
| `sports_drill` | **Exercício de Educação Física** | Educação Física, no campo ou ginásio | Barra de ritmo ou escolha de equipe; Iwasaki comanda | +Condicionamento; prepara o Festival Esportivo |
| `festival_prep` | **Preparação de evento** | Hora da Turma e aulas da semana anterior a festivais | Votações, divisão de tarefas, persuasão | Define o projeto da turma e papéis |
| `seat_change` | **Troca de lugares** | Primeiro dia de cada trimestre | Sorteio animado; o jogador pode pedir troca a um colega (vínculo ≥ 3) | Novo mapa de assentos (seção 50) |

### 46.6. Janela de Questão

A Janela de Questão é a interface central de participação. É reutilizada em aulas, provas surpresa, provas, deveres de casa, desafio da semana, debates do conselho e quizzes de clube.

**Quando abre:** `question`, `board`, `pair_work`, `pop_quiz`, `challenge`, `homework_check` (modo dever), provas (seção 48.2), monitoria, e o Desafio da semana na escrivaninha.

**Layout proposto**

```
┌─────────────────────────────────────────────────────────────┐
│ MATEMÁTICA · Unidade 2 — Equações      Prof.ª Kawaguchi     │
│ "Vamos ver… hoje quero ouvir você."                         │
├─────────────────────────────────────────────────────────────┤
│  Resolva: 3x + 7 = 22. Qual é o valor de x?                 │
│                                                             │
│   [ A ]  3          [ B ]  5                                │
│   [ C ]  7          [ D ]  15                               │
│                                                             │
│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ (barra de tempo, opcional)  │
├─────────────────────────────────────────────────────────────┤
│ [ Consultar caderno ]  [ Pedir ajuda · Yui ]  [ Não sei ]   │
└─────────────────────────────────────────────────────────────┘
```

**Elementos**

| Elemento | Regra |
|---|---|
| Cabeçalho | Matéria, unidade, professor e uma fala curta que muda com a relação (neutra, encorajadora ou severa) |
| Enunciado | Texto; opcionalmente um diagrama simples (figura geométrica, linha do tempo, mapa) |
| Alternativas | 2 a 4 botões; ordem embaralhada por sorteio determinístico |
| **Consultar caderno** | Disponível se a postura da aula foi Anotar com cuidado ou se há Página de Caderno da unidade; revela o Cartão de Conteúdo relacionado. Em provas: indisponível, salvo omamori de estudo (um uso por trimestre) |
| **Pedir ajuda ao vizinho** | Disponível se um vizinho adjacente tem vínculo ≥ 2 e Domínio ≥ 40 na matéria; elimina uma alternativa errada; 15% de chance de ocorrência leve para os dois |
| **Não sei** | Sem ocorrência; o professor explica; +1 Domínio; pequena perda de reputação acadêmica apenas no Desafio |
| Barra de tempo | Desligada por padrão em aula; ligada em provas (60 s por questão) e no modo "Pressão" das configurações |
| Feedback | Acerto: fala do professor + "+X Domínio". Erro: alternativa correta destacada + uma linha de explicação (`explain`) + "+1 Domínio" |

**Tipos de questão** (`type` no banco de questões): `choice` (múltipla escolha), `truefalse`, `order` (ordenar 3–4 itens), `fill` (completar com uma palavra entre 4), `match` (associar 3×3), `numeric` (digitar número no teclado da janela), `approach` (escolha de abordagem, sem resposta errada; usada em Artes, Economia Doméstica e dilemas de História).

**Seleção de dificuldade**

| Domínio na matéria | Níveis sorteados | Ajustes |
|---|---|---|
| 0–29 | nível 1 | Postura de risco flagrada: +1 nível |
| 30–69 | níveis 1–2 | Desafio: sempre nível 3 |
| 70–100 | níveis 2–3 | Humor Ansioso: +1 de risco, não de nível |

**Recompensas por acerto**

| Nível | Domínio | Reputação acadêmica | Relação com o professor |
|---|---|---|---|
| 1 | +1 | +1 | +1 |
| 2 | +2 | +2 | +1 |
| 3 | +3 | +4 | +2 |

**Acessibilidade e justiça**

- Sem limite de tempo por padrão; tamanho de fonte ajustável; feedback por cor e por ícone.
- Navegação completa por controle (alternativas no D-pad, ferramentas nos botões superiores).
- **Sorteio determinístico:** a questão e a ordem das alternativas são escolhidas com semente `hash(data + período + índice do momento)`. Salvar e recarregar não troca a questão. Como a resposta correta é mostrada após o erro, recarregar seria trapaça consciente — e o Diário registra a entrada do dia mesmo assim.

### 46.7. Missões de Sala

Missões de Sala são cenários roteirizados de vários passos que acontecem **dentro de um ou mais períodos**, combinando Momentos de Aula, Janelas de Questão, movimentação em 3D e consequências sociais. Elas substituem a sensação de "aula genérica" nos dias importantes e ensinam as mecânicas em contexto.

**Modelo de ficha de missão**

```
Id · Nome
Gatilho: data ou condição
Pré-requisitos: flags, vínculos, Domínio
Etapas: sequência numerada com tipo de interação
Janelas: quais Janelas de Questão aparecem e de que unidade
Saídas: ramificações e seus efeitos
Flags gravadas · Recompensas · Cartão de Memória (se houver)
```

**M-01 · Primeira chamada** — Segunda, 1 de abril, Homeroom (08:25)

- Etapas: (1) Sato pede que cada aluno se apresente; os NPCs falam antes, revelando um gosto cada. (2) Janela de **apresentação pessoal**: escolher 2 entre 4 fatos sobre si (origem, hobby ligado ao talento, um sonho vago, "nada especial"). (3) Reações: NPCs com interesse em comum ganham +10 de vínculo inicial; "nada especial" rende uma risada de Tsubasa e uma anotação de Hina.
- Saídas: define as primeiras impressões; nenhuma saída negativa permanente.
- Flags: `intro_done`, `intro_facts`. Memória: "O primeiro dia na 1-A".

**M-02 · A pergunta do Sato** — Terça, 2 de abril, Literatura (período 2)

- Pré-requisito: o prólogo entregou o Cartão de Conteúdo "Provérbio: Nana korobi ya oki (cair sete vezes, levantar oito)".
- Etapas: (1) Sato explica provérbios (exposição com tutorial de Postura). (2) Momento `question` dirigido ao protagonista, nível 1, sobre o provérbio da avó. (3) Tutorial das ferramentas da janela (Consultar caderno aparece porque o cartão veio do prólogo).
- Saídas: acerto — Sato comenta "sua avó ensina bem"; erro — Sato explica e Yui sussurra "eu também não sabia". Ambas as saídas gravam `first_question`.
- Recompensa: +Domínio de Literatura; abertura do Caderno no celular.

**M-03 · O bilhete de Tsubasa** — Primeira semana, qualquer aula teórica

- Pré-requisito: Tsubasa sentado atrás do protagonista (mapa inicial, seção 50).
- Etapas: (1) Momento `note` com um desenho do professor atual. (2) Opções: rir baixinho (risco 20%), devolver com um desenho seu (Criatividade ≥ 8 abre opção), passar para Yui, ignorar. (3) No intervalo, Tsubasa convida para o arcade sábado.
- Saídas: aceitar o convite abre a missão de cidade "Galaxy Game Center"; ser flagrado gera a primeira ocorrência leve e uma fala de Sato sobre "começar bem".
- Flags: `tsubasa_note`, `arcade_invite`.

**M-04 · Kenta e o verbo irregular** — Terça, 9 de abril, Inglês (período 4)

- Etapas: (1) Hill pede que a turma conjugue verbos. (2) Momento `help_request`: Kenta não sabe "went". (3) Explicar (Janela cooperativa de 2 passos em que o protagonista responde o primeiro e orienta o segundo) / Passar a resposta / Recusar. (4) Se explicou: Hill nota e pergunta ao protagonista a próxima questão (nível 2).
- Saídas: explicar duas vezes em semanas diferentes abre a missão **Monitoria** (almoço, 2× por semana, +Domínio de Inglês para os dois, ramen de graça no Oyama); passar a resposta rende +vínculo rápido, mas Kenta continua sem aprender e falha na prova de maio.
- Flags: `kenta_help_1`, `tutoring_unlocked`.

**M-05 · O experimento de Fujii** — Quinta, 11 de abril, Ciências (período 1, laboratório)

- Etapas: (1) Deslocamento até o laboratório no intervalo (atraso conta). (2) Fujii divide grupos de 4 por bancada (o do protagonista: Yui, Kenta e Sora, ou vizinhos atuais). (3) Momento `lab`: passo 1 — ordenar o procedimento (`order`); passo 2 — escolher a medida correta (`choice`); passo 3 — barra de tempo para apagar a chama. (4) Resultado por bancada.
- Saídas: sucesso completo — +Domínio para o grupo, Fujii convida para "ver o telescópio um dia" (gancho do Clube de Ciências e Astronomia). Falha no passo 3 — fumaça, janelas abertas, limpeza extra com o grupo (+vínculo com os três, humor Inspirado de Sora ao ver a fumaça "parecer uma nebulosa").
- Flags: `lab_first`, `astronomy_hook`.

**M-06 · Desafio da semana de Kawaguchi** — Toda segunda, Matemática (período 2); repetível

- Etapas: (1) Kawaguchi cola um problema de nível 3 no quadro lateral. (2) Qualquer dia até sexta, na escrivaninha ou na biblioteca, a Janela de Questão do desafio pode ser aberta (uma tentativa; Teimoso ganha segunda tentativa). (3) Sexta, no Estudo dirigido, Kawaguchi lê os nomes de quem acertou; NPCs resolvem conforme o Domínio deles.
- Saídas: acertar três desafios no trimestre dá o título "Resolvedor" no app Escola, +reputação acadêmica e uma conversa de Daichi que muda de provocação para respeito.
- Flags: `weekly_challenge_<data>`, contador `challenges_solved`.

**M-07 · A redação sobre Hoshikawa** — Quinta, 4 de maio, Literatura (período 2); entrega segunda, 8 de maio; leitura terça, 9 de maio

- Etapas: (1) Sato pede uma redação sobre um lugar da cidade. (2) Escolha do tema: o rio, o santuário, a rua comercial ou a casa da avó. **Visitar o lugar antes de escrever** desbloqueia uma quarta opção de estilo com detalhes reais do cenário. (3) Na escrivaninha, três Janelas `approach` definem tom, abertura e fechamento. (4) Terça, 9 de maio: Sato lê a melhor redação da turma em voz alta; se for a do protagonista, teste de Carisma para ler com calma.
- Saídas: redação premiada — Nozomi, que escreve poemas, procura o protagonista depois da aula (abre o arco dela); Kōhei convida para o Clube de Literatura. Redação comum — Sato devolve com comentário gentil e +1 Domínio.
- Flags: `essay_topic`, `essay_best`. Memória: "A redação lida em voz alta" (se premiada).

**M-08 · A janela e o gato** — Primavera, aleatório, com postura Olhar pela janela

- Etapas: (1) `window_event`: o gato Mochi caminha no telhado do ginásio. (2) Tsubasa percebe e cochicha; Sora acorda e sorri. (3) Depois da aula, o telhado está trancado: o zelador Ishida tem a chave. (4) Ajudar Ishida a carregar caixas (15 min) rende a permissão de almoçar no telhado às terças e quintas.
- Saídas: o telhado vira ponto de almoço (seção 59.1); Mochi passa a aparecer lá.
- Flags: `rooftop_access`.

**M-09 · Simulado de evacuação** — Terça, 2 de setembro, Ciências (período 3)

- Etapas: (1) `interruption`: sirene; a turma se levanta e desce para o pátio em 3D seguindo Hina. (2) Haruto continua dormindo na última carteira: acordá-lo (Empatia) ou seguir a fila (Disciplina). (3) No pátio, Iwasaki conta as turmas; Kaede fala pelo conselho.
- Saídas: acordar Haruto abre o arco dele; seguir a fila rende elogio de Iwasaki e +Disciplina.
- Flags: `evac_done`, `haruto_woken`.

**M-10 · O dia do voto** — Quinta, 4 de outubro, Hora da Turma (votação) e Segunda, 1 de novembro, Literatura cedida à turma (divisão de tarefas)

- Etapas: (1) Hina abre a votação do projeto do Festival Cultural: café temático, casa assombrada, peça curta ou exposição de fotos. (2) Antes do voto, três NPCs pedem a opinião do protagonista; persuadir com Carisma ou argumentos vistos em outras conversas. (3) Voto nominal; NPCs votam por preferência própria mais influência recebida. (4) 1 de novembro: divisão de tarefas por Janela `approach`.
- Saídas: o projeto vencedor define os Momentos `festival_prep` da semana, o que a 1-A apresenta nos dias 6 e 7 e quais Cartões de Memória existem.
- Flags: `festival_project`, `festival_role`.

### 46.8. Diretor de Aula (ClassDirector)

Componente responsável por escolher o que acontece em cada período. `[PLANEJADO]`

1. **Entrada:** data, período, matéria, professor, postura, energia, humor, vizinhos e seus vínculos, Domínio, flags, missões agendadas.
2. **Prioridade 1 — Missões de Sala** agendadas para a data/período são obrigatórias e ocupam o orçamento de momentos do período.
3. **Prioridade 2 — Momentos sorteados:** candidatos filtrados por matéria, sala e condições; pesos ajustados por postura (risco aumenta `question`), vínculo com vizinhos (aumenta `note` e `help_request`), energia (aumenta `drowsy`), dias desde o último momento do mesmo tipo (reduz repetição), e pela configuração **Intensidade das aulas**: Leve (até 2 janelas por dia), Normal (3), Intensa (5), Só missões (nenhum sorteio).
4. **Garantias mínimas:** pelo menos um momento interativo por dia letivo e pelo menos uma Janela de Questão por matéria por semana, para que o Domínio sempre tenha entrada.
5. **Sorteio determinístico** por data e período (seção 46.6).
6. **Participação dos NPCs:** quando a pergunta não cai sobre o protagonista, ela cai sobre um NPC visível (ele se levanta, um balão mostra se acertou). O acerto segue o Domínio do NPC. Isso constrói o ranking da turma de forma orgânica e deixa a aula viva mesmo sem interação do jogador.

### 46.9. Apresentação 3D da aula

- **Câmera da carteira:** ao sentar, a câmera aproxima levemente (zoom 25 do protótipo) e enquadra professor, quadro e os vizinhos.
- **Abertura da janela:** a câmera se aproxima por cima do ombro do protagonista e o fundo recebe desfoque suave; o professor olha para a carteira.
- **Ida ao quadro:** o protagonista caminha de verdade até o quadro; a turma vira a cabeça; a janela abre com o quadro ao fundo.
- **Bilhete:** animação de mão sob a carteira; o professor tem um "cone de atenção" visível apenas por reações (vira-se, para de escrever).
- **Mãos levantadas, cochilos e cochichos** dos NPCs refletem Domínio, energia e relações deles.
- **Janelas da sala:** chuva, pétalas, luz de fim de tarde e o telhado do ginásio visíveis, para que Olhar pela janela mostre algo de verdade.

### 46.10. Avanço contextual e relógio

A exposição avança em blocos de 10 minutos de jogo (cerca de 2 segundos reais). Um momento interrompe o avanço e pausa o relógio enquanto a janela estiver aberta (regra 14.4: menus não consomem tempo injustamente). Ao terminar o período, o relógio está exatamente no fim dele, como no protótipo.

### 46.11. Faltas, atrasos e justificativas

- Atraso leve (até 5 min após a chamada): registrado, sem ocorrência.
- Atraso (mais de 5 min): ocorrência leve.
- Falta a um período: perda dos Cartões daquele período; três faltas no mês geram conversa com Sato.
- Enfermaria: com energia < 20, descansar na enfermaria durante um período conta como **falta justificada** (uma vez por semana) e restaura 30 de energia; a Enfermeira Mochizuki conversa sobre rotina.
- Nada disso destrói um trimestre sozinho (regra 16.3).

## 47. CURRÍCULO, CARTÕES DE CONTEÚDO, DOMÍNIO POR MATÉRIA E BANCO DE QUESTÕES

`[PLANEJADO]`

### 47.1. Domínio por matéria

Cada uma das oito matérias tem um **Domínio** de 0 a 100, separado do atributo Conhecimento.

| Fonte | Ganho | Limite |
|---|---|---|
| Prestar atenção em aula | +2 | — |
| Anotar com cuidado | +1 (+1 Página de Caderno) | — |
| Questão certa em aula | +1 / +2 / +3 por nível | — |
| Questão errada (com explicação) | +1 | — |
| Dever de casa entregue (qualidade A / B / C) | +2 / +1 / 0 | — |
| Estudo em casa (60 min, matéria escolhida) | +3 | — |
| Leitura na biblioteca (30 min) | +1 a +2 conforme o livro | — |
| Monitoria (dar ou receber) | +2 para ambos | — |
| Estudo dirigido de sexta | +2 | — |
| **Teto diário por matéria** | — | **+6** (evita repetição mecânica) |

Não há perda de Domínio com o tempo. O custo de não estudar é não crescer, nunca regredir.

### 47.2. Relação com o atributo Conhecimento

O atributo Conhecimento continua existindo como "capacidade geral" (o protótipo já o alimenta com estudo e aulas). Ele:

- Define a disponibilidade de dicas extras na Janela de Questão (Conhecimento ≥ 40: o enunciado destaca a palavra-chave).
- Soma `Conhecimento ÷ 10` ao Domínio efetivo usado na parte simulada da nota (seção 48.3).
- Ganha +1 a cada 10 pontos de Domínio acumulados em qualquer matéria, mantendo a progressão atual.

### 47.3. Currículo do Ano 1

Cada matéria tem cinco unidades alinhadas aos cinco períodos de prova (maio, julho, outubro, dezembro, março). O conteúdo precisa ser respondível por um público geral, sem conhecimento acadêmico avançado (regra 18.1).

| Matéria | U1 (abr–mai) | U2 (mai–jul) | U3 (set–out) | U4 (out–dez) | U5 (jan–mar) |
|---|---|---|---|---|---|
| Japonês e Literatura | Provérbios e expressões (kotowaza) | Haiku e palavras de estação (kigo) | Contos clássicos e estrutura narrativa | Redação e argumentação | Poesia moderna e leitura crítica |
| Matemática | Aritmética e porcentagens | Equações de 1º grau | Geometria plana (ângulos e áreas) | Funções e gráficos simples | Probabilidade e estatística básica |
| Inglês | Apresentações e cotidiano | Verbos irregulares e passado | Direções e cidade | Compras e números | Leitura de pequenos textos |
| História e Estudos Sociais | História local de Hoshikawa (lenda do rio de estrelas, santuário) | Período Edo e vida cotidiana | Era Meiji e modernização | Geografia do Japão e clima | Cidadania e governo local |
| Ciências | Método científico e medidas | Água, estados e misturas | Corpo humano e saúde | Astronomia básica (estrelas, estações, Perseidas) | Energia e eletricidade no cotidiano |
| Educação Física | Atletismo (corrida) | Natação | Esportes coletivos (festival) | Basquete e vôlei | Alongamento, dança e saúde |
| Artes | Observação e esboço | Cor e luz | Cartazes (festival cultural) | Cerâmica e escultura simples | Retrato |
| Economia Doméstica | Nutrição e bento | Costura básica | Orçamento doméstico | Culinária sazonal | Convivência e planejamento de festas |

A unidade de História local dobra como guia de exploração: cada Cartão aponta para um lugar real da cidade (o torii, a pedra do mirante, a ponte velha), e visitar o lugar desbloqueia o cartão sem precisar da aula.

### 47.4. Cartões de Conteúdo

- Cada unidade tem de 8 a 12 cartões: título e uma ou duas frases.
- Fontes: postura Prestar atenção e Anotar com cuidado, leitura na biblioteca, monitoria, visitas (História), experimentos (Ciências), eventos (o provérbio da avó no prólogo).
- Os cartões ficam no **Caderno**, dentro do app Escola, organizados por matéria e unidade, com indicação de quais faltam.
- Toda questão referencia um cartão. Ter o cartão habilita "Consultar caderno" no dever de casa (livre), em aula (conforme postura) e nunca em prova (salvo omamori).

Exemplos de cartões:

| Id | Matéria / unidade | Texto |
|---|---|---|
| `jl_u1_c01` | Literatura U1 | **Nana korobi ya oki.** "Cair sete vezes, levantar oito": persistir depois das falhas. |
| `ma_u2_c03` | Matemática U2 | Para isolar x, faça a mesma operação dos dois lados da igualdade. |
| `hs_u1_c02` | História U1 | A lenda diz que uma estrela caiu no rio e por isso a cidade se chama Hoshikawa, "rio de estrelas". O santuário foi erguido onde a água brilhou. |
| `ci_u4_c05` | Ciências U4 | As Perseidas atingem o pico em meados de agosto; parecem vir da constelação de Perseu. |
| `en_u2_c01` | Inglês U2 | *Go → went → gone.* Verbos irregulares não seguem a regra do -ed. |

### 47.5. Banco de questões

Arquivos por matéria em `data/questions/<matéria>.json`. Exemplo:

```json
{
  "id": "ma_u2_014",
  "subject": "math",
  "unit": 2,
  "level": 2,
  "type": "choice",
  "card": "ma_u2_c03",
  "prompt": "Resolva: 3x + 7 = 22. Qual é o valor de x?",
  "options": ["3", "5", "7", "15"],
  "answer": 1,
  "explain": "Subtraia 7 dos dois lados (3x = 15) e divida por 3.",
  "tags": ["equacao", "basico"]
}
```

Outros tipos:

```json
{"id": "hs_u3_006", "subject": "history", "unit": 3, "level": 2, "type": "order",
 "card": "hs_u3_c02", "prompt": "Coloque em ordem cronológica:",
 "items": ["Chegada dos navios negros", "Restauração Meiji", "Primeira ferrovia Tóquio–Yokohama"],
 "answer": [0, 1, 2], "explain": "1853, 1868 e 1872."}

{"id": "ma_u1_031", "subject": "math", "unit": 1, "level": 1, "type": "numeric",
 "card": "ma_u1_c04", "prompt": "Um onigiri custa ¥200. Com 15% de desconto, quanto custa?",
 "answer": 170, "tolerance": 0, "explain": "15% de 200 é 30; 200 − 30 = 170."}

{"id": "ar_u2_004", "subject": "art", "unit": 2, "level": 1, "type": "approach",
 "card": "ar_u2_c01", "prompt": "O entardecer no rio. Que paleta você escolhe?",
 "options": ["Laranjas e roxos quentes", "Azuis frios com um ponto dourado", "Preto e branco com textura"],
 "effects": [{"creativity": 1}, {"creativity": 1, "mood": "inspired"}, {"creativity": 1}],
 "explain": "Não há resposta errada: a escolha define o estilo da sua obra."}
```

**Volume alvo do Ano 1:** 8 matérias × 5 unidades × 3 níveis × 8 questões ≈ **960 questões**. Mínimo viável para o marco 0.4: 4 por nível por unidade (480).

**Diretrizes de autoria**

1. Sem pegadinhas; a dificuldade vem do conteúdo, não da redação.
2. Toda questão tem `explain` de uma linha: errar ensina.
3. Nada que exija ler japonês de verdade; termos em romaji com explicação.
4. pt-BR como idioma primário; chaves preparadas para en e ja.
5. Alternativas embaralhadas por semente; `answer` aponta para a posição original.
6. Cada questão referencia um `card` existente — validado por teste automatizado (seção 61.6).

### 47.6. Estudo em casa V3

Na escrivaninha, na biblioteca ou no café:

| Opção | Tempo | Efeito |
|---|---|---|
| Estudar uma matéria | 60 min | +3 Domínio na matéria, +1 Conhecimento, −10 energia (como hoje) |
| Revisar cartões | 30 min | Quiz de 3 cartões já obtidos; +1 Domínio por acerto |
| Fazer o dever | 25–45 min | Ver seção 48.1 |
| Estudar com alguém | 60 min | +2 Domínio na matéria forte do parceiro, +15 de vínculo; requer convite aceito (Daichi: Matemática; Nozomi: Literatura; Hill: Inglês às quartas na sala dos professores; Chiaki: Ciências) |
| Desafio da semana | 10 min | Janela de nível 3 (M-06) |

## 48. DEVER DE CASA, PROVAS, BOLETIM E RANKING

`[PLANEJADO]`

### 48.1. Dever de casa

- Atribuído em média três vezes por semana (Literatura, Matemática e Inglês com mais frequência; demais ocasionalmente). Aparece no app Escola com prazo (próxima aula da matéria).
- Feito em qualquer escrivaninha, biblioteca ou mesa de café.

| Modo | Tempo | Domínio | Qualidade | Risco |
|---|---|---|---|---|
| Fazer com cuidado | 45 min | +2 | A | — |
| Fazer rápido | 25 min | +1 | B | 20% de sair incompleto (C) |
| Copiar do Daichi | 10 min | 0 | C | Requer vínculo ≥ 2; na terceira vez Daichi recusa e perde 10 de vínculo; −1 Disciplina |

- A entrega acontece no momento `homework_check`. Esquecer abre as opções da seção 46.5.
- **Dever de verão:** pacote de 8 tarefas entregue em 10 de julho com prazo em 1 de setembro. Cada tarefa é uma Janela de 3 questões ou um `approach` (diário de observação, desenho, leitura). Entregar tudo rende +Disciplina e um comentário no boletim; não entregar gera recuperação na primeira semana de setembro.

### 48.2. Provas

| Período | Dias (Ano 1) | Unidades cobradas |
|---|---|---|
| Intermediária do 1º trimestre | Qua 10 e Qui 11 de maio | U1 |
| Final do 1º trimestre | Qua 3 e Qui 4 de julho | U1 e U2 |
| Intermediária do 2º trimestre | Qua 10 e Qui 11 de outubro | U3 |
| Final do 2º trimestre | Qua 3 e Qui 4 de dezembro | U3 e U4 |
| Final do ano | Qua 3 e Qui 4 de março | U4 e U5 (com revisão leve de U1–U3) |

- Dia 1: Literatura, Matemática, História, Artes (teórica curta). Dia 2: Inglês, Ciências, Economia Doméstica. Educação Física tem prova prática na semana anterior (`sports_drill` avaliado).
- Cada prova: **5 questões interativas** (níveis 1, 2, 2, 2, 3 — valendo 1, 2, 2, 2, 3 pontos) com barra de 60 s, mais a parte simulada (48.3).
- **Semana de provas:** clubes suspensos da segunda-feira da semana de provas até o fim delas; biblioteca aberta até 19:00; eventos de estudo em grupo (Aiko organiza no Café Hoshizora; Daichi na biblioteca); humor Ansioso possível.
- **Véspera:** dormir cedo (acorda Animado) ou virar a noite (+4 Domínio na matéria escolhida, acorda Cansado: −10% na parte interativa por tempo menor, 45 s por questão).
- **Omamori de estudo** (seção 59.3, santuário): um uso de "Consultar caderno" por trimestre em prova.

### 48.3. Fórmula de nota (provisória)

```
Nota = 0,40 × (pontos interativos ÷ 10) × 100
     + 0,45 × Domínio efetivo
     + 0,15 × (deveres entregues ÷ deveres atribuídos) × 100

Domínio efetivo = Domínio × (0,85 + 0,15 × frequência) + Conhecimento ÷ 10   (teto 100)
```

Exemplo: Domínio 55, Conhecimento 30, frequência 95%, deveres 80%, 6 de 10 pontos interativos → 24 + 0,45 × 57,6 ≈ 25,9 + 12 = **≈ 62**.

A fórmula é um ponto de partida para testes; o peso da parte interativa não deve passar de 40% para que o jogador menos hábil em quizzes ainda chegue a boas notas com rotina.

### 48.4. Conceitos e ranking

| Nota | Conceito |
|---|---|
| 85–100 | 5 |
| 70–84 | 4 |
| 50–69 | 3 |
| 35–49 | 2 |
| 0–34 | 1 |

- **Ranking:** posição na turma (1 a 30) e no ano (1 a 120; turmas 1-A a 1-D). As notas dos NPCs saem do Domínio de cada um, com variação pequena por semente.
- Os resultados são afixados no mural do corredor no dia seguinte ao fim das provas (objeto 3D) e aparecem no app Escola. Os dez primeiros do ano são nomeados; os demais veem só a própria posição.
- Reações: Daichi comenta a posição relativa; Kenta comemora qualquer melhora; a avó manda mensagem; Kawaguchi convida os cinco primeiros em Matemática para o grupo avançado.

### 48.5. Boletim

Entregue no Homeroom final do último dia letivo de cada trimestre (10 de julho, 10 de dezembro, 12 de março). Contém conceitos, frequência, ocorrências e um comentário do Professor Sato montado por modelos conforme flags (participação, ajuda a colegas, atrasos, clube). A avó lê em casa à noite: orgulho, preocupação ou conversa calma, e ocasionalmente ¥2.000 "para um lanche com os amigos" — valor pequeno de propósito.

### 48.6. Recuperação

- Qualquer matéria com nota < 35 gera **três tardes de recuperação** (15:30–17:00) na semana seguinte, bloqueando o clube. Cada tarde é uma Janela de 3 questões de nível 1; concluir as três eleva a nota ao piso 35.
- Dois trimestres seguidos com a mesma matéria < 35 **e** frequência < 70% disparam a conversa "Risco de reprovação" com Sato em fevereiro, com plano de estudo guiado.
- No acesso antecipado, a reprovação do Ano 1 fica desativada (apenas a flag é gravada), em respeito à seção 18.2; a decisão definitiva é reavaliada com o conteúdo do Ano 2.

### 48.7. Oportunidades ligadas às notas

| Condição | Oportunidade |
|---|---|
| Ranking do ano ≤ 10 | Convite para o grupo de estudo avançado (biblioteca, terças) e conversa com Kōhei sobre o vestibular |
| Conceito 5 em Matemática | Kawaguchi indica para a Olimpíada regional (viagem de um dia, Ano 2) |
| Conceito 5 em Literatura | Sato pede ajuda para o jornal escolar e para o concurso de redação de fevereiro |
| Conceito 5 em Inglês | Hill convida para o clube de conversação do almoço (quartas) |
| Média ≥ 4 no trimestre | Reputação acadêmica +10 e permissão de trabalho renovada automaticamente |

## 49. ELENCO DE HOSHIKAWA — FICHAS DE PERSONAGENS

`[PARCIAL]` — existem Yui Tanaka, Professor Sato e Ren Mori como NPCs de teste. Todos os demais são `[PLANEJADO]`. Nomes, aparências e histórias são originais; nenhuma ficha deve ser substituída por personagens de outras obras.

Convenções: idades no início do Ano 1; aniversários no calendário de 14 dias; "ritmo de confiança" multiplica os ganhos de vínculo nos primeiros níveis (rápido ×1,2 · normal ×1,0 · lento ×0,8). "Relação possível" indica o teto narrativo com o protagonista; romance nunca é obrigatório e vale para qualquer tratamento escolhido pelo jogador.

Resumo do elenco: **50 personagens nomeados** (14 na família e cidade, 12 na 1-A, 3 em outras turmas do 1º ano, 9 veteranos, 12 professores e funcionários) e **17 alunos de apoio** que completam as 30 carteiras da 1-A.

### 49.1. Família

**Harue Mizushima** (水島 春江) · 68 anos · avó do protagonista · aniversário 14 de setembro

| Campo | Conteúdo |
|---|---|
| Ocupação | Coordenadora de uma cooperativa têxtil em Minamizawa, cidade vizinha (40 min de trem). Em casa às sextas, sábados e domingos; durante a semana, alterna semanas fora e semanas em casa |
| Personalidade | Prática, afetuosa, brincalhona; não se mete sem ser chamada. Ritmo rápido |
| Aparência | Baixa, cabelo grisalho preso, avental com estampa de flores, óculos pendurados no pescoço |
| Gosta / não gosta | Rádio antigo, pickles caseiros, novelas da tarde / desperdício de comida, gente que não dorme |
| Função no sistema | Mesada de ¥3.000 às segundas; bento de domingo (item de energia para três dias); bilhetes na mesa (já no protótipo); reação ao boletim; conversas de humor Triste |
| Arcos | Ano 1 — "O quarto do avô": uma caixa de fotos no armário e a visita ao túmulo no Obon. Ano 2 — uma preocupação de saúde que muda a rotina da casa. Ano 3 — a formatura, vista da arquibancada |

Os pais do protagonista não aparecem em 3D no Ano 1: existem em mensagens, fotos e uma chamada de vídeo, conforme o motivo da mudança (seção 45.4).

### 49.2. Turma 1-A

| Nome | Aniv. | Personalidade (ritmo) | Clube / ocupação | Família e ligações | Relação possível | Gancho do Ano 1 |
|---|---|---|---|---|---|---|
| **Yui Tanaka** (田中 結衣) | 7 mai | Observadora, reservada, teimosa com o próprio trabalho (lento) | Artes | Pais donos de uma gráfica; irmão Sōta, 9; melhor amiga de Aiko | Amizade · romance | Não consegue terminar retratos; a exposição de novembro |
| **Aiko Fujimoto** (藤本 愛子) | 3 ago | Expansiva, organizadora, impaciente (rápido) | Natação | Mãe enfermeira na clínica, pai maquinista; apartamento perto do rio | Amizade · romance | Puxa o grupo inteiro e não sabe pedir ajuda; competição de junho |
| **Daichi Kurosawa** (黒沢 大地) | 9 jan | Metódico, orgulhoso, justo (normal) | Comitê da biblioteca | Pai médico da Clínica Kurosawa, mãe farmacêutica | Rival → amizade · romance | A primeira vez que fica em segundo lugar |
| **Kenta Oyama** (大山 健太) | 13 out | Leal, alegre, distraído (rápido) | Basquete | Pais donos do Oyama Ramen; irmã Yuka, 20 | Amizade · romance | Inglês, monitoria e a seletiva de setembro |
| **Hina Mochizuki** (望月 陽菜) | 6 nov | Responsável, direta, perfeccionista (normal; promessas quebradas custam o dobro) | Representante de turma; conselho (novembro) | Mãe é a enfermeira da escola | Amizade · romance | A representante que não dorme; colapso em novembro |
| **Nozomi Arai** (新井 希) | 4 fev | Delicada, irônica em voz baixa, leal (lento até o nível 3) | Literatura | Avô dono da casa de chá; mãe ceramista | Amizade · romance (a mais lenta) | O poema sem nome no jornal escolar |
| **Sora Hayashi** (林 空) | 12 jul | Sonhador, calmo, distraído (normal) | Ciências e Astronomia (reativando) | Mora com a irmã Hikari, 24, funcionária da estação | Amizade · romance | Cinco assinaturas para reabrir o clube; as Perseidas |
| **Mei Shirakawa** (白川 芽衣) | 2 abr | Direta, vaidosa, generosa quando ninguém vê (normal; começa fria com quem a trata como fútil) | Trabalha na Shirakawa Boutique | Mãe Reiko, dona da boutique; irmã Rin, 6 | Amizade · romance | Pede ajuda escondida em Matemática; desfile no festival |
| **Tsubasa Ikeda** (池田 翼) | 1 jun | Palhaço da turma, sensível, criativo (rápido) | Arcade; Música a partir de outubro | Pais separados; mora com a mãe acima da farmácia | Amizade | Os bilhetes, o violão escondido e a banda de Taiga |
| **Riku Takahashi** (高橋 陸) | 8 set | Confiante, provocador, generoso em quadra (normal) | Atletismo (velocidade) | Pai treinador de futebol amador; três irmãos | Amizade | Rivalidade com Ren; namoro com Aiko em outubro (se nada mudar) |
| **Chiaki Nakamura** (中村 千秋) | 10 dez | Lógica, humor seco, curiosa (lento) | Ciências e Astronomia; sala de informática | Pais donos de uma loja de conserto de eletrônicos | Amizade · romance | Quer fazer um jogo; vira presidente do clube reativado |
| **Haruto Shiina** (椎名 陽翔) | 5 mar | Calado, orgulhoso, cansado (lento) | Nenhum; trabalha à noite no konbini sem permissão | Loja da família no distrito antigo em dificuldade; amigo de infância de Ren | Amizade | Dorme na última carteira; aceitar ajuda sem pena |

### 49.3. Outros alunos do primeiro ano

| Nome | Turma | Aniv. | Personalidade (ritmo) | Clube | Ligações | Relação possível | Gancho |
|---|---|---|---|---|---|---|---|
| **Ren Mori** (森 蓮) | 1-B | 11 abr | Otimista, disciplinado, competitivo consigo mesmo (rápido) | Atletismo (fundo) | Vizinho do protagonista; amigo de infância de Haruto; corre com o Prof. Hill | Amizade · romance | Baixar 10 segundos nos 1500 m; trazer Haruto de volta |
| **Saki Watanabe** (渡辺 咲) | 1-B | 7 jun | Barulhenta, franca, protetora (rápido) | Vôlei | Rival amistosa de Aiko; prima de Mana | Amizade | Levar o vôlei feminino ao regional |
| **Yuto Kobayashi** (小林 悠人) | 1-C | 12 nov | Tímido, erudito, engraçado por escrito (lento) | Literatura; Jornal Escolar | Trabalha na Livraria Kinoshita; amigo de Nozomi e Daichi | Amizade | Escrever a coluna de mistérios da escola |

### 49.4. Veteranos

| Nome | Turma | Aniv. | Cargo | Personalidade | Gancho do Ano 1 |
|---|---|---|---|---|---|
| **Kaede Hoshino** (星野 楓) | 3-A | 9 out | Presidente do Conselho Estudantil | Carismática, calma, estrategista | Sucessão do conselho; formatura em 8 de março; o segundo botão |
| **Shingo Takeda** (武田 真吾) | 3-B | 3 mai | Capitão de Basquete | Duro, justo, cansado de perder | Último torneio em julho; aposentadoria do clube; passa a faixa |
| **Kōhei Matsuda** (松田 浩平) | 3-A | 6 dez | Presidente de Literatura | Sonhador prático, estressado com o vestibular | Entrega o clube em setembro; mostra o que é ser 3º ano |
| **Ayumi Sekiguchi** (関口 歩) | 3-C | 1 mai | Capitã de Vôlei | Serena, exigente | Treina Saki para a sucessão |
| **Miyu Okamoto** (岡本 美優) | 2-A | 1 ago | Capitã de Natação | Competitiva, protetora, teimosa | Lesão no ombro em junho; volta em agosto |
| **Taiga Nishimura** (西村 大河) | 2-B | 13 jul | Líder do Clube de Música, banda "Hoshikawa Lights" | Carismático, desorganizado | Perde o guitarrista em outubro; recruta Tsubasa |
| **Akari Yoshida** (吉田 あかり) | 2-A | 2 out | Presidente de Artes | Gentil, firme sobre técnica | Mentora de Yui; organiza a exposição |
| **Rina Ishikawa** (石川 里奈) | 2-B | 11 jan | Vice-presidente do conselho; editora do Jornal Escolar | Rígida, íntegra, difícil de agradar | Candidata à presidência em novembro; controla o que o jornal publica |
| **Jin Kawamura** (川村 仁) | 2-C | 4 set | Capitão de Atletismo | Quieto, metódico | Senpai de Ren e Riku; planeja o treino de verão |

No Japão, veteranos do 3º ano se afastam dos clubes após as competições de verão para estudar. O jogo reproduz isso: Shingo e Ayumi se aposentam em julho, Kōhei em setembro, e Kaede fica ausente de fevereiro em diante. Isso muda rotinas, lideranças e disponibilidade de conversa.

### 49.5. Professores e funcionários

| Nome | Idade | Matéria / função | Clube responsável | Personalidade | Marcas no jogo |
|---|---|---|---|---|---|
| **Kenji Sato** (佐藤 健二) | 44 | Japonês e Literatura; orientador da 1-A | Literatura | Calmo, usa provérbios, atento | Já no protótipo. Lê a melhor redação; escreve o comentário do boletim; mora sozinho com um gato |
| **Emi Kawaguchi** (川口 恵美) | 31 | Matemática | Vôlei | Rápida, adora enigmas | Desafio da semana; grupo avançado; flagra quem revisa outra matéria |
| **Marcus Hill** | 34 | Inglês (professor assistente estrangeiro) | Atletismo | Simpático, curioso sobre Hoshikawa | Fala em inglês com quem veio do exterior; corre no rio com Ren; clube de conversação às quartas |
| **Hideo Kurata** (倉田 英雄) | 58 | História e Estudos Sociais | Basquete | Rígido, apaixonado pela história local | Cartões de História ligados a lugares; desconfia da "cidade grande"; treinador surpreendentemente sensível |
| **Naoko Fujii** (藤井 直子) | 38 | Ciências | Ciências e Astronomia | Caótica no laboratório, precisa no céu | Experimentos que dão errado; telescópio; madrinha da reativação do clube |
| **Goro Iwasaki** (岩崎 吾郎) | 35 | Educação Física | Natação | Barulhento, justo, ex-atleta | Festival Esportivo; seletivas; conta as turmas no simulado |
| **Yuki Aizawa** (相沢 由紀) | 29 | Artes | Artes | Voz baixa, olhar certeiro | Propostas criativas; exposição de novembro |
| **Tomoya Hasegawa** (長谷川 智也) | 40 | Música (optativa do 2º ano) e sala de música | Música | Perfeccionista afetuoso | Ensaios; apresentação do Festival Cultural |
| **Setsuko Baba** (馬場 節子) | 60 | Economia Doméstica | Jornal Escolar | Avó de todos, memória da escola | Amiga de Harue; bento, chocolate de fevereiro; arquivo do jornal com segredos da escola |
| **Kaori Mochizuki** (望月 香織) | 42 | Enfermeira | — | Serena, observadora | Faltas justificadas; conversa sobre sono; mãe de Hina |
| **Diretor Ōtsuka** (大塚) | 61 | Diretor | — | Cerimonioso, gentil | Cerimônias; visita surpresa à 1-A |
| **Sr. Ishida** (石田) | 66 | Zelador | — | Resmungão, generoso | Chave do telhado; depósito antigo; sabe onde Mochi dorme |

### 49.6. Moradores de Hoshikawa

| Nome | Idade | Lugar | Ligação | Função no jogo |
|---|---|---|---|---|
| **Takeshi e Fumiko Oyama** | 50 / 47 | Oyama Ramen (centro) | Pais de Kenta | Emprego de sexta e sábado; ramen de graça para quem ajuda Kenta em Inglês |
| **Gen'ichi Arai** (新井 源一) | 72 | Casa de chá Arai (distrito antigo) | Avô de Nozomi | Lendas de Hoshikawa (cartões de História U1); chá que muda com a estação |
| **Reiko Shirakawa** (白川 玲子) | 41 | Shirakawa Boutique (centro) | Mãe de Mei | Emprego de fim de semana; roupas casuais; desconto |
| **Jun Hasebe** (長谷部 潤) | 27 | Café Hoshizora (centro) | Ex-aluno, ex-conselho | Emprego de terça, quinta e sábado; mentor informal; Kaede estuda lá |
| **Sr. Tanabe** (田辺) | 55 | Konbini Hoshimart (bairro) | — | Emprego noturno; percebe Haruto trabalhando sem permissão |
| **Sra. Kinoshita** (木下) | 63 | Livraria Kinoshita (centro) | Empregadora de Yuto | Emprego de quarta e sábado; deixa ler de graça quem recomenda bem |
| **Masao Hoshino** (星野 正雄) | 74 | Santuário (colinas) | Avô de Kaede | Omikuji, omamori, Hatsumode; telescópio velho doado ao clube |
| **Dr. Kurosawa** (黒沢) | 48 | Clínica Kurosawa (centro) | Pai de Daichi | Pressão sobre o filho; atende Harue no Ano 2 |
| **Sra. Ueno** (上野) | 66 | Casa ao lado (bairro) | Vizinha | "A rádio do bairro": sabe de tudo, conta à avó; guarda a chave no prólogo |
| **Hikari Hayashi** (林 光) | 24 | Estação | Irmã de Sora | Vende bilhetes para Shiosaki; conta o que Sora não conta |
| **Momo** (もも) | 7 | Parque do bairro | — | Missões pequenas (gato perdido, pipa presa); chama o protagonista de "senpai" |
| **Mochi** (もち) | ? | Telhados da cidade | Gato de ninguém | Avistamentos registrados no Álbum; aparece em Eventos da janela; dorme no depósito do Sr. Ishida |

### 49.7. Alunos de apoio da 1-A

Completam as 30 carteiras. Têm nome, uma característica, rotina simples e falas curtas; podem ganhar fichas completas em atualizações.

| Carteira | Nome | Uma linha |
|---|---|---|
| B1 | Akane Morita | Lê romances policiais durante o intervalo; amiga de Nozomi |
| C1 | Shun Endo | Dupla cômica com Ryota; quer fazer manzai no festival |
| D1 | Kana Ueda | Braço direito de Hina; organiza o mural |
| A2 | Takumi Ono | Apaixonado por trens e mapas; quinto membro possível do clube de astronomia |
| B2 | Misaki Goto | Sabe de tudo antes de todo mundo; fonte do jornal |
| E2 | Kaito Sasaki | Skatista; chega sempre em cima da hora |
| A3 | Yuna Hirano | Pianista do Clube de Música; sorri pouco, toca muito |
| E3 | Ryo Fukuda | Basquete; come tanto quanto Kenta |
| A4 | Rei Nagai | Fotógrafa amadora; propõe a exposição de fotos no festival |
| D4 | Sho Kudo | Dorme quase tanto quanto Haruto, mas por jogar à noite |
| E4 | Mana Yamamoto | Vôlei; prima de Saki |
| C5 | Keita Honda | Joga shogi com Daichi; fala pouco e ganha muito |
| D5 | Ayaka Nishi | Dança; descobre o segredo de Hina |
| B6 | Hiroki Abe | O mais alto depois de Kenta; Natação |
| C6 | Nana Kimura | Confeitaria caseira; rival de Kenta pelo melon-pan |
| D6 | Ryota Maeda | A outra metade da dupla cômica |
| E6 | Sakura Ito | Anima qualquer evento da turma; amiga de Mei |

### 49.8. Fichas estendidas

**Yui Tanaka**

| Campo | Conteúdo |
|---|---|
| Aparência | Cabelo castanho-escuro na altura dos ombros com presilha azul, franja reta, olhos cinza-esverdeados, manga do uniforme manchada de grafite, estojo sempre à mostra |
| Gosta / não gosta | Lápis de desenho, cadernos de papel grosso, doces de matcha / ser fotografada, barulho do arcade |
| Lugares | Praça do bairro, sala de artes, margem do rio ao entardecer |
| Rotina | 07:10 sai de casa e espera Aiko na praça; aula; almoço na sala com Aiko; seg/qua/sex clube de Artes; ter/qui desenha na praça; 18:00 casa; sábado rio; domingo casa |
| Objetivo | Expor uma obra no Festival Cultural; no fundo, desenhar pessoas sem travar |
| Arcos | Ano 1 — "Rosto sem contorno". Ano 2 — concurso regional e divergência de estilo com Akari. Ano 3 — escola de arte ou a gráfica da família |
| Segredo (nível 4) | Um caderno só com desenhos de pessoas da turma, inclusive do protagonista |

**Aiko Fujimoto**

| Campo | Conteúdo |
|---|---|
| Aparência | Rabo de cavalo alto castanho-claro, pele bronzeada, sorriso largo, pulseira de miçangas, meias coloridas fora da escola |
| Gosta / não gosta | Pudim da doceria, músicas animadas, verão / silêncio longo, frio |
| Lugares | Piscina, Café Hoshizora, ponte do rio |
| Rotina | 07:15 busca Yui na praça; aula; almoço com grupo grande; natação de segunda a sexta; sábado treino de manhã e centro à tarde; domingo rio |
| Objetivo | Classificar para a competição regional de agosto; organizar "a melhor saída de verão da turma" |
| Arcos | Ano 1 — "Quem puxa o grupo". Ano 2 — disputa pela capitania com uma caloura. Ano 3 — esporte universitário ou enfermagem como a mãe |
| Segredo (nível 4) | Tem medo de água funda desde criança e nunca contou ao clube |

**Daichi Kurosawa**

| Campo | Conteúdo |
|---|---|
| Aparência | Óculos de armação fina, cabelo preto curto repartido, uniforme impecável, relógio de pulso do pai |
| Gosta / não gosta | Shogi, canetas de tinta, café sem açúcar / atrasos, música alta, "sorte" |
| Lugares | Biblioteca, sala de estudos, consultório do pai |
| Rotina | 07:30 chega cedo; aula; almoço na biblioteca; biblioteca até 18:00; sábado curso preparatório; domingo shogi com o pai |
| Objetivo | Primeiro do ano em todas as provas; no fundo, provar que não é só "o filho do médico" |
| Arcos | Ano 1 — "Segundo lugar". Ano 2 — pressão do pai pela medicina. Ano 3 — o vestibular que ele escolher |
| Segredo (nível 4) | Desenha mapas de cidades imaginárias nas últimas páginas do caderno |

**Kenta Oyama**

| Campo | Conteúdo |
|---|---|
| Aparência | O mais alto da turma, laterais raspadas, bochechas coradas, blazer apertado nos ombros, mochila cheia de lanches |
| Gosta / não gosta | Ramen, melon-pan, tênis novos, mangá de esportes / Inglês, provas, ver alguém comer sozinho |
| Lugares | Ginásio, loja escolar, Oyama Ramen, telhado |
| Rotina | 07:00 ajuda no restaurante; aula; almoço na loja escolar e telhado; basquete; 19:00 restaurante; sábado jogo; domingo parque |
| Objetivo | Ser titular; passar em Inglês |
| Arcos | Ano 1 — monitoria e seletiva de setembro. Ano 2 — lesão no joelho e a descoberta de que gosta de cozinhar. Ano 3 — assumir o restaurante ou tentar bolsa esportiva |
| Segredo (nível 4) | Anota as receitas do pai num caderno escondido porque o pai nunca escreve nada |

**Hina Mochizuki**

| Campo | Conteúdo |
|---|---|
| Aparência | Cabelo preto comprido em trança lateral, faixa de representante, postura reta, caderno de capa vermelha |
| Gosta / não gosta | Papelaria organizada, chá de jasmim, listas / improviso, atrasos, bagunça no mural |
| Lugares | Sala do conselho, enfermaria, biblioteca |
| Rotina | 07:35 prepara a sala; aula; almoço com Kana; reunião de representantes ou biblioteca; 18:30 casa; sábado voluntariado quando houver |
| Objetivo | Ser presidente do conselho no Ano 3 |
| Arcos | Ano 1 — "A representante que não dorme". Ano 2 — vice-presidência contra Rina. Ano 3 — presidência e a conversa com a mãe sobre o vestibular |
| Segredo (nível 4) | Ensaia coreografias no quarto; Ayaka descobre |

**Nozomi Arai**

| Campo | Conteúdo |
|---|---|
| Aparência | Cabelo preto curto com franja desigual, cachecol mesmo na primavera, olhos grandes, caderninho de poemas, uniforme um pouco grande |
| Gosta / não gosta | Poesia, chá de cevada, papel de carta, gatos / falar em público, multidões, perfume forte |
| Lugares | Casa de chá, ponte velha, biblioteca, banco atrás do santuário |
| Rotina | 07:00 ajuda a abrir a casa de chá; 07:50 atravessa a ponte; aula; almoço na biblioteca ou na escadaria; ter/qui Literatura; demais dias casa de chá; sábado cerâmica com a mãe; domingo templo |
| Objetivo | Publicar um poema sem assinatura; no fundo, ler um poema em voz alta |
| Arcos | Ano 1 — "O poema sem nome". Ano 2 — concurso de poesia: anonimato ou reconhecimento. Ano 3 — a casa de chá pode fechar |
| Segredo (nível 4) | Os poemas são sobre pessoas reais da turma, inclusive um sobre "quem senta perto da janela" |

**Sora Hayashi**

| Campo | Conteúdo |
|---|---|
| Aparência | Cabelo castanho desgrenhado, olheiras leves, blazer aberto, binóculo pequeno na mochila, sempre olhando para cima |
| Gosta / não gosta | Mapas celestes, café em lata, silêncio, noites limpas / luz forte, acordar cedo, planos rígidos |
| Lugares | Mirante, telhado, laboratório, estação à noite |
| Rotina | Chega às 08:24; dorme nas duas primeiras aulas; almoço no telhado; ter/qui laboratório com Fujii; 21:00 mirante se o céu estiver limpo; sábado dorme; domingo estação com a irmã |
| Objetivo | Registrar as Perseidas de 12 de agosto do mirante com cinco pessoas; fazer o clube existir |
| Arcos | Ano 1 — "Cinco assinaturas" e a noite das Perseidas. Ano 2 — a irmã se muda. Ano 3 — bolsa em astronomia ou cuidar do telescópio do santuário |
| Segredo (nível 4) | Não dorme em aula por preguiça: passa as noites catalogando estrelas num caderno de 300 páginas |

**Mei Shirakawa**

| Campo | Conteúdo |
|---|---|
| Aparência | Cabelo castanho-mel ondulado, brincos pequenos que tira na entrada, saia no limite do permitido, bolsa customizada por ela |
| Gosta / não gosta | Moda, revistas, purikura, doces bonitos / ser chamada de burra, uniformes feios, chuva no cabelo |
| Lugares | Boutique, arcade (purikura), karaokê, salão Cut & Star |
| Rotina | 07:45 chega de bicicleta; aula; almoço com Ayaka e Sakura; tarde no centro; sábado e domingo boutique 13:00–17:00 |
| Objetivo | Desfile improvisado no Festival Cultural; tirar conceito 3 em Matemática para a mãe parar de se preocupar |
| Arcos | Ano 1 — "Notas e costuras". Ano 2 — concurso jovem de moda na capital. Ano 3 — ficar com a loja ou ir embora |
| Segredo (nível 4) | Costura à noite as peças que a boutique vende como importadas |

**Ren Mori**

| Campo | Conteúdo |
|---|---|
| Aparência | Cabelo preto curto, pele morena, faixa na testa fora da escola, relógio de corrida |
| Gosta / não gosta | Tênis, bananas, correr na chuva, música eletrônica / ficar parado, chá amargo, perder sem saber por quê |
| Lugares | Rua das cerejeiras, margem do rio, pista |
| Rotina | 06:30 corrida pelo bairro (já no protótipo); 08:10 escola; aula na 1-B; atletismo; 18:00 corrida leve no rio; sábado competição ou treino longo; domingo parque |
| Objetivo | Baixar 10 segundos nos 1500 m até outubro |
| Arcos | Ano 1 — "O amigo que parou de correr" e a corrida de outubro. Ano 2 — lesão por excesso. Ano 3 — bolsa esportiva ou família |
| Segredo (nível 4) | Passa todas as manhãs pela casa de Haruto esperando que ele saia |

**Kaede Hoshino**

| Campo | Conteúdo |
|---|---|
| Aparência | Cabelo castanho-avermelhado longo e liso, broche do conselho, caderno de capa de couro, sapatos sempre limpos |
| Gosta / não gosta | Chá verde, planejamento, histórias do santuário, fogos / injustiça, bajulação, atrasos em reuniões |
| Lugares | Sala do conselho, santuário, Café Hoshizora |
| Rotina | 07:30 abre a sala do conselho; aula na 3-A; almoço em reuniões; seg/qua/sex conselho; ter/qui café; fins de semana no santuário; ausente de fevereiro em diante |
| Objetivo | Deixar o conselho organizado para a sucessão; decidir se sai de Hoshikawa |
| Arcos | Ano 1 — "Sucessão" e a formatura de 8 de março (segundo botão só com vínculo 5). Ano 2 — visitas. Ano 3 — uma carta |
| Relação | Mentoria e amizade; sem romance no Ano 1 |
| Segredo (nível 4) | Queria ser miko em tempo integral e não contou ao avô que vai prestar vestibular em outra cidade |

## 50. MAPA DE ASSENTOS DA 1-A E DINÂMICA DE VIZINHOS

`[PARCIAL]` — a sala do protótipo tem 12 carteiras e Yui ocupa a "carteira 02". A sala final tem 30 carteiras em cinco colunas (A a E) e seis fileiras (1 a 6). A coluna A fica junto às janelas; a coluna E, junto à porta do corredor. A fileira 1 é a da frente.

### 50.1. Mapa do primeiro trimestre (abril a julho)

```
                 QUADRO  ·  MESA DO PROFESSOR SATO
        A (janela)     B            C            D            E (porta)
  1     Nozomi         Akane        Shun         Kana         Hina
  2     Takumi         Misaki       Daichi       Mei          Kaito
  3     Yuna           Yui          VOCÊ         Kenta        Ryo
  4     Rei            Aiko         Tsubasa      Sho          Mana
  5     Sora           Chiaki       Keita        Ayaka        Riku
  6     Haruto         Hiroki       Nana         Ryota        Sakura
```

Leitura do mapa inicial:

- **Vizinhos adjacentes do protagonista:** Yui (esquerda), Kenta (direita), Daichi (frente), Tsubasa (atrás). São os quatro candidatos a Trabalho em dupla, Pedir ajuda, Bilhete e Conversar baixinho no primeiro trimestre.
- **Diagonais:** Misaki, Mei, Aiko e Sho recebem bilhetes repassados.
- **Janela e última fila:** Sora e Haruto dormem; Nozomi senta na frente para ninguém olhar o caderno dela.
- **Porta:** Hina senta ao lado da porta para abrir e fechar a sala; Kaito chega atrasado por ali.

### 50.2. Troca de lugares

- Acontece no primeiro dia letivo de cada trimestre (1 de abril é o mapa fixo acima; 1 de setembro e 8 de janeiro usam sorteio).
- O sorteio é determinístico por semente e **respeita restrições**: Nozomi e quem usa óculos ficam nas três primeiras fileiras; Kenta e Hiroki ficam nas duas últimas.
- O jogador pode pedir troca a um colega com vínculo ≥ 3 antes de Sato fechar o mapa (uma troca por trimestre). Hina anota, mas permite.
- A mudança de vizinhos muda os Momentos de Aula mais prováveis: sentar perto de Hina reduz bilhetes e aumenta ajuda em Matemática; perto de Tsubasa, o oposto.

### 50.3. Dados

O mapa fica em `data/classrooms/1a.json` com `seat`, `npc_id`, restrições e o trimestre. A cena 3D posiciona os NPCs a partir desse arquivo; a rotina dos NPCs referencia a carteira por id (por exemplo `"point": "seat:B3"`) em vez de coordenadas.

## 51. RELAÇÕES ENTRE NPCs E ARCOS INDEPENDENTES

`[PLANEJADO]` — o mundo precisa mudar mesmo que o jogador não participe (seção 1 e 22.3).

### 51.1. Grafo inicial (vínculo 0–1000 e tipo)

| A | B | Tipo | Valor inicial | Observação |
|---|---|---|---|---|
| Yui | Aiko | Melhores amigas | 850 | Desde o primário; Aiko fala, Yui desenha |
| Daichi | Hina | Rivais de representante | 300 | Respeito mútuo escondido |
| Ren | Haruto | Amigos de infância distantes | 400 (caindo) | Haruto parou de responder mensagens |
| Kaede | Rina | Presidente e vice | 500 | Discordam de método, não de valores |
| Kaede | Kōhei | Amigos de infância | 700 | Ambos filhos de famílias do distrito antigo |
| Aiko | Riku | Interesse mútuo | 350 | Namoro em outubro se nada mudar |
| Aiko | Saki | Rivais amistosas | 450 | Natação contra vôlei no Festival Esportivo |
| Kenta | Tsubasa | Amigos | 600 | Arcade e melon-pan |
| Kenta | Shingo | Novato e capitão | 200 | Shingo é duro com ele |
| Sora | Chiaki | Parceiros de planilha | 500 | A única que lê os registros dele |
| Nozomi | Yuto | Amigos de biblioteca | 550 | Trocam livros com bilhetes dentro |
| Nozomi | Kōhei | Caloura e presidente | 300 | Ele acha que ela deveria assinar os poemas |
| Mei | Hina | Antipatia | 100 | "Fútil" contra "mandona" |
| Tsubasa | Taiga | Admiração à distância | 150 | Tsubasa vai a todos os ensaios abertos |
| Yui | Akari | Caloura e mentora | 400 | Akari quer que Yui termine um retrato |
| Hill | Ren | Treinador informal | 300 | Correm no rio às 06:30 |
| Sato | Baba | Colegas antigos | 600 | Baba conhece a avó do protagonista |

### 51.2. Arcos que acontecem sem o jogador

| Quando | Acontecimento | O que o jogador pode mudar |
|---|---|---|
| Junho (dia 9) | Miyu machuca o ombro no treino; Aiko assume a liderança dos treinos sem estar pronta | Acompanhar Aiko reduz o estresse dela; não muda a lesão |
| Julho (dia 6) | Shingo perde o último torneio e se aposenta; Kenta chora no telhado | Estar no telhado abre uma cena; a aposentadoria acontece de qualquer forma |
| Setembro (dia 1) | Kōhei entrega a Literatura; Nozomi recusa a vice-presidência | Com vínculo ≥ 3 e a redação de maio, Nozomi aceita no Ano 2 |
| Outubro (dia 6) | Aiko e Riku começam a namorar depois do Festival Esportivo | Se o jogador tem romance em andamento com um deles (nível 4 e sinais), o outro não se declara; ninguém "rouba" ninguém |
| Outubro (dia 12) | O guitarrista da banda de Taiga sai; Tsubasa é chamado | Sem intervenção, Tsubasa entra. O jogador pode entrar no lugar se estiver no Clube de Música com Criatividade ≥ 30 — e Tsubasa fica magoado por um mês |
| Novembro (dia 12) | Eleição: Rina vence a presidência para o Ano 2 | Com Kaede a favor e reputação institucional ≥ 50, Hina (ou o jogador no Ano 2) disputa de verdade |
| Novembro (dia 8) | A loja da família de Haruto fecha por um mês | Com a missão "Luzes do distrito antigo" concluída, a loja reabre em janeiro com ajuda do bairro |
| Dezembro (dia 13) | Daichi e Hina são vistos estudando juntos pela primeira vez | Nenhuma; é o fruto da rivalidade |
| Fevereiro (dia 8) | Kōhei e Kaede fazem o vestibular; ficam ausentes uma semana | Mensagens de apoio contam para o segundo botão |
| Março (dia 8) | Formatura dos veteranos | Presença, mensagens e vínculo definem as cenas de despedida |

### 51.3. Regras do grafo

- NPCs com vínculo mútuo ≥ 600 aparecem juntos em rotinas (almoço, caminho de casa) e se defendem em conversas.
- Vínculos entre NPCs mudam por eventos do calendário, não por acaso.
- O jogador vê um vínculo entre dois NPCs no app Contatos só depois de testemunhar uma cena entre eles.

## 52. SISTEMA DE VÍNCULO V3 — NÍVEIS, CONVERSAS, PRESENTES, SAÍDAS E ROMANCE

`[PARCIAL]` — o protótipo tem vínculo 0–1000, +15 por primeira conversa do dia e escolha entre Empatia e Carisma. O restante é `[PLANEJADO]`.

### 52.1. Níveis

| Nível | Faixa | Nome | O que abre |
|---|---|---|---|
| 0 | 0–49 | Estranho | Cumprimento; nome aparece após a primeira conversa |
| 1 | 50–149 | Conhecido | Tópicos básicos; aniversário aparece no app |
| 2 | 150–299 | Colega | Pedir ajuda em aula; convites curtos (almoço, caminho de casa); presentes aceitos |
| 3 | 300–499 | Amigo | Saídas de tarde; missão de personagem 1; mensagens espontâneas; pedir troca de lugar |
| 4 | 500–749 | Amigo próximo | Segredo da ficha; visita à casa; missão de personagem 2; sinais de romance (se aplicável) |
| 5 | 750–1000 | Laço profundo | Missão de personagem 3; eventos de fim de ano; confissão possível; segundo botão de veterano |

O ritmo de confiança multiplica os ganhos até o nível 2 (lento) ou nível 3 (Nozomi). Vínculo nunca decai; após 28 dias sem contato surge o estado **Distante**: a próxima conversa tem uma fala sobre a ausência e nenhum ganho extra até uma saída ser feita.

### 52.2. Fontes de vínculo

| Ação | Ganho | Limite |
|---|---|---|
| Primeira conversa do dia | +10 (+15 na primeira da vida, como hoje) | 1/dia |
| Tópico favorito | +10 extra | 1/dia |
| Tópico sensível | −10 | — |
| Presente adorado / gostado / indiferente / detestado | +40 / +20 / +5 / −20 | 1/semana por NPC |
| Saída aceita e concluída | +30 | — |
| Saída em grupo | +15 para cada presente | — |
| Trabalho em dupla, ajuda em aula, monitoria | +8 a +15 | por evento |
| Missão de personagem concluída | +60 a +120 | — |
| Aniversário lembrado (mensagem ou presente no dia) | +40 | — |
| Promessa quebrada (convite aceito e não comparecido) | −40 (−80 com Hina) | — |
| Mensagem ignorada por 2 dias | −5 | — |

### 52.3. Conversas por tópicos

A conversa comum deixa de ser uma fala fixa. O painel oferece de três a cinco **tópicos** descobertos: Aulas, Clube, Hobbies, Cidade, Família, Sonhos, Fofocas, Comida, além de tópicos de evento (a prova de ontem, o festival que vem). Cada NPC tem dois tópicos favoritos e um sensível, revelados por tentativa ou por outros NPCs.

- **Escuta ativa:** a opção "Só ouvir" em um tópico favorito rende a mesma recompensa e, às vezes, uma informação nova.
- **Humor do NPC** aparece no painel a partir do nível 2 (ou nível 1 com o traço Observador). Um NPC Triste prefere escuta; um NPC Animado aceita convites com mais facilidade.
- **Memória de conversa:** o NPC lembra o último tópico e retoma ("Você ainda está pensando na prova?").

### 52.4. Presentes

Categorias: doces, livros, material de arte, esportes, música, moda, tecnologia, tradicional, comida caseira (feita em Economia Doméstica), bugigangas do arcade. Cada ficha define dois adorados, dois gostados e um detestado. Exemplos: Yui adora papel grosso e matcha, detesta fotos impressas dela; Kenta adora melon-pan e tênis, detesta dicionários; Sora adora café em lata e mapas celestes, detesta despertadores; Mei adora revistas de moda e presilhas, detesta "qualquer coisa marrom".

### 52.5. Saídas

| Destino | Custo | Duração | Quem adora | Observações |
|---|---|---|---|---|
| Café Hoshizora | ¥450 cada | 60 min | Kaede, Daichi, Yui | Estudar junto conta como saída |
| Galaxy Game Center | ¥300–¥600 | 60 min | Tsubasa, Kenta, Chiaki, Mei (purikura) | Purikura gera Cartão de Memória com 2+ amigos |
| Karaokê Star Box | ¥1.200/hora dividido | 90 min | Aiko, Saki, Sakura, Taiga | Miniatividade de ritmo; +Carisma |
| Margem do rio | grátis | 45 min | Ren, Nozomi, Sora (à noite) | Melhor ao entardecer |
| Oyama Ramen | ¥800 | 45 min | Kenta, Ryo, Riku | Kenta paga se for aniversário dele |
| Casa de chá Arai | ¥600 | 60 min | Nozomi, Kaede, Yuto | Gen'ichi conta lendas |
| Mirante | grátis | 60 min | Sora, Yui, Chiaki | Só à noite com céu limpo rende Inspirado |
| Shiosaki (praia) | ¥640 ida e volta | meio dia | Aiko, Riku, Mei | Só em férias e fins de semana de verão |
| Shirakawa Boutique | variável | 45 min | Mei, Sakura, Ayaka | Escolher roupa para alguém testa o gosto |

Convites são feitos pelo celular ou pessoalmente; a aceitação depende de agenda, humor, vínculo e evento (seção 28.2). Uma recusa diz o motivo ("tenho treino") e sugere outro dia.

### 52.6. Saídas em grupo

A partir de três amigos com nível ≥ 3 e vínculo mútuo entre eles ≥ 300, o protagonista pode organizar saídas em grupo (até cinco pessoas). Grupos criam cenas próprias (a dupla cômica no karaokê, Daichi perdendo no arcade) e Cartões de Memória exclusivos. Aiko organiza saídas de grupo por conta própria e convida o protagonista a partir do nível 2.

### 52.7. Romance

Opções de romance no Ano 1: Yui, Aiko, Daichi, Kenta, Hina, Nozomi, Sora, Mei, Ren e Chiaki. Veteranos, adultos e Tsubasa, Riku e Haruto têm arcos de amizade. Nenhum romance depende do tratamento escolhido pelo jogador.

| Etapa | Condição | O que acontece |
|---|---|---|
| Afinidade | Nível 3 | Falas ganham calor; o NPC lembra de detalhes |
| Sinais | Nível 4 + duas saídas a sós + um evento sazonal juntos | Cena de "sinal" (o NPC hesita, a câmera demora); o jogador pode responder ou deixar passar sem perda |
| Confissão | Nível 5 + missão de personagem 2 concluída + sem namoro ativo | Feita pelo jogador em local significativo da ficha, ou pelo NPC em data sazonal (Tanabata, fogos, Noite das Luzes, Valentine, White Day). Recusar mantém a amizade com um período Distante de uma semana |
| Namoro | Confissão aceita | Novos tópicos, mensagens diárias curtas, caminho de casa juntos, datas especiais, apelido opcional |
| Desentendimentos | Promessa quebrada, ciúme leve em evento, descuido em data especial | Cena de conversa com três registros; nunca termina o namoro sozinho |
| Reconciliação | Saída no lugar do primeiro encontro ou presente adorado + conversa | Restaura o estado |
| Término | Escolha do jogador, ou do NPC após três desentendimentos sem reconciliação | Com dignidade; amizade preservada no nível 3 após um mês |

Regras: relacionamentos apropriados à idade, sem conteúdo explícito; um namoro por vez; ficar solteiro é uma trajetória completa, com cenas próprias de amizade nas datas sazonais.

## 53. MISSÕES E OBJETIVOS

`[PARCIAL]` — o protótipo usa flags para o objetivo de tutorial. A estrutura abaixo é `[PLANEJADO]`.

### 53.1. Categorias

| Categoria | Origem | Exemplos |
|---|---|---|
| **Principais** | Arco do ano | "Primeiro dia", "Semana dos clubes", "Primeira prova", "Verão em Hoshikawa", "Festival Cultural", "Despedidas" |
| **De personagem** | Três por personagem principal, por nível de vínculo | Yui: "Um rosto para o retrato" (3), "O caderno escondido" (4), "A exposição" (5) |
| **Escolares** | Aulas, deveres, provas | Missões de Sala (46.7), Desafio da semana, Monitoria, Dever de verão |
| **De clube** | Clube atual | Reativação do clube de astronomia; seletiva; acampamento de verão |
| **De cidade** | Moradores e lugares | "O gato de Momo", "Caixas do Sr. Ishida", "Luzes do distrito antigo", "Entregas da casa de chá" |

### 53.2. Regras

1. **Sem marcadores sobre as cabeças.** Pistas chegam por mensagens, falas e conhecimento de rotinas; o mapa mostra apenas o lugar quando a missão diz explicitamente o lugar.
2. Missões com prazo avisam pelo celular um dia antes. Perder o prazo é um resultado, não um erro: a missão termina com uma versão "atrasada" ou some com uma fala.
3. Recompensas: vínculo, atributos, Domínio, itens, dinheiro (pequeno), Cartões de Memória e desbloqueios (lugares, horários, opções de diálogo).
4. Cada missão registra `started`, `step`, `completed`, `failed` e `expired` no save.
5. No máximo cinco missões ativas aparecem destacadas; as demais ficam na lista completa.

### 53.3. Estrutura em dados

```json
{
  "id": "yui_03",
  "category": "character",
  "title": "Um rosto para o retrato",
  "npc": "yui",
  "requires": {"bond_level": 3, "flags": ["intro_done"]},
  "steps": [
    {"id": "ask", "type": "talk", "npc": "yui", "topic": "hobbies", "hint": "Yui desenha na praça às terças e quintas."},
    {"id": "pose", "type": "activity", "place": "neighborhood_square", "time": "15:40-17:30", "duration": 45},
    {"id": "result", "type": "scene", "scene": "yui_portrait_fail"}
  ],
  "deadline": null,
  "rewards": {"bond": {"yui": 80}, "attributes": {"Empatia": 2}, "memory": "yui_sketch"},
  "on_complete_flags": ["yui_portrait_attempt"]
}
```

### 53.4. Exemplos por categoria

- **Principal · "Semana dos clubes" (3 a 8 de abril):** visitar três clubes em dias de teste, conversar com um capitão, escolher até segunda-feira, 8 de abril. Falhar em escolher leva Sato a sugerir o comitê da biblioteca, sem punição.
- **De personagem · Sora, "Cinco assinaturas" (nível 3):** convencer dois alunos a assinar a reativação do clube (Takumi, Yuto, Rei ou Chiaki já convencida), entregar o formulário a Fujii e passar uma noite no mirante. Recompensa: clube oficial, telescópio de Masao e acesso ao mirante à noite.
- **Escolar · "Monitoria" (após M-04 duas vezes):** dois almoços por semana com Kenta por quatro semanas; cada sessão é uma Janela cooperativa de Inglês. Recompensa: Kenta passa em julho, ramen vitalício às sextas, +Domínio de Inglês.
- **De clube · "Seletiva de setembro" (Basquete):** três treinos com desempenho mínimo, um jogo-treino e a decisão de Shingo (ou de Kurata após a aposentadoria dele).
- **De cidade · "Luzes do distrito antigo" (novembro):** ajudar Gen'ichi, Haruto e os comerciantes a montar a iluminação da rua tradicional em quatro tardes; traz clientes à loja da família de Haruto. Recompensa: Haruto fala pela primeira vez sobre o pai; Memória "A rua acesa".

## 54. CLUBES V3 — NOVOS CLUBES, LOOP DE TREINO, PROGRESSÃO E COMPETIÇÕES

`[PLANEJADO]`

### 54.1. Clubes e comitês do Ano 1

| Clube | Professor | Liderança no Ano 1 | Integrantes do elenco | Dias | Requisito de entrada | Local |
|---|---|---|---|---|---|---|
| Natação | Iwasaki | Miyu (2-A) | Aiko, Hiroki | seg–sex | Condicionamento ≥ 8 ou teste de 50 m | Piscina |
| Vôlei | Kawaguchi | Ayumi (3-C) → Saki em setembro | Saki, Mana | seg, qua, sex, sáb | Nenhum | Ginásio |
| Basquete | Kurata | Shingo (3-B) → escolhido em julho | Kenta, Ryo | seg–sex | Condicionamento ≥ 10 | Ginásio |
| Atletismo | Hill | Jin (2-C) | Ren, Riku | ter, qui, sáb + corrida livre | Nenhum | Pista e rio |
| Música | Hasegawa | Taiga (2-B) | Yuna, Tsubasa (outubro) | ter, qui, sex | Teste de ritmo ou Criatividade ≥ 12 | Sala de música |
| Artes | Aizawa | Akari (2-A) | Yui, Rei | seg, qua, sex | Nenhum | Sala de artes |
| Literatura | Sato | Kōhei (3-A) → interina em setembro | Nozomi, Yuto, Akane | ter, qui | Nenhum | Biblioteca anexa |
| **Ciências e Astronomia** (novo) | Fujii | Chiaki, após a reativação | Sora, Chiaki, Takumi | ter, qui + noites de céu limpo | Missão "Cinco assinaturas" | Laboratório e mirante |
| **Jornal Escolar** (novo, comitê) | Baba | Rina (2-B), editora | Yuto, Misaki | qua + fechamento mensal | Conceito ≥ 3 em Literatura ou convite | Sala do jornal |
| Comitê da biblioteca | Sato | Daichi | — | 1 tarde por semana | Nenhum | Biblioteca |
| Comitê de saúde | Enf. Mochizuki | Kana | — | 1 almoço por semana | Nenhum | Enfermaria |
| Comitê de festival | Kaede | rotativo | — | temporário | Nenhum | Sala do conselho |

Regras de participação: um clube por vez; comitês são compatíveis com clubes; troca livre até 14 de maio; depois, só no início de trimestre. Clubes suspensos nas semanas de provas. Veteranos do 3º ano se aposentam após as competições de verão.

### 54.2. Loop de uma tarde de clube

| Fase | Duração | Conteúdo |
|---|---|---|
| Chegada e aquecimento | 15:40–16:00 | Conversa com integrantes; humor do grupo visível |
| **Janela de treino** | 16:00–17:20 | Escolha de foco + uma miniatividade curta (abaixo). Avanço contextual como nas aulas |
| Fechamento | 17:20–17:40 | Fala do capitão ou professor; pontos de prática; às vezes um evento de clube |
| Social | 17:40–18:30 | Caminho de casa com um colega de clube (saída curta) |

Miniatividades por clube (todas opcionais na primeira implementação — a escolha de foco sozinha já funciona):

| Clube | Focos | Miniatividade |
|---|---|---|
| Natação | Resistência, técnica, velocidade | Barra de ritmo de braçadas |
| Vôlei | Recepção, saque, bloqueio | Reação ao sinal |
| Basquete | Arremesso, passe, defesa | Barra de tempo do lance livre |
| Atletismo | Fundo, velocidade, salto | Ritmo de passadas |
| Música | Técnica, repertório, composição | Sequência de ritmo |
| Artes | Observação, cor, composição | Janela `approach` com resultado por Criatividade |
| Literatura | Leitura, escrita, crítica | Escolha de palavras em um poema coletivo |
| Ciências e Astronomia | Observação, registro, divulgação | Quiz de 3 cartões de Ciências; à noite, identificar constelações |
| Jornal | Pauta, entrevista, edição | Escolher perguntas para um NPC; a matéria publicada muda a reputação de alguém |

### 54.3. Progressão

- **Pontos de prática** por clube: presença +5, foco correto para a semana +3, miniatividade bem-feita +2, evento +10. Condicionamento ou Criatividade sobem conforme o clube (seção 19.2).
- **Patentes:** Novato (0) → Reserva (60) → Titular (160) → Veterano (320) → Capitão/Presidente (eleição ou indicação no Ano 2 ou 3, com Veterano, presença ≥ 80% e vínculo médio com o clube ≥ 300).
- O protagonista nunca vira capitão no Ano 1 (regra 20.3).
- Faltar a três treinos seguidos sem avisar gera conversa com o capitão; faltar a uma competição anunciada rebaixa uma patente.

### 54.4. Competições e eventos de clube (Ano 1)

| Data | Clube | Evento |
|---|---|---|
| 13 jun (sáb) | Natação | Competição interescolar em Shiosaki |
| 6 jul (sáb) | Basquete, Vôlei | Último torneio dos veteranos |
| 13 jul (sáb) | Música | Show aberto no parque |
| 2–4 ago | Todos | Acampamento de treino (esportivos em Shiosaki; culturais na escola; astronomia no mirante) |
| 12 ago (sex) | Ciências e Astronomia | Noite das Perseidas |
| 5 set (sex) | Basquete | Seletiva de titulares |
| 6 out (sáb) | Todos | Festival Esportivo (torneio entre turmas, não entre clubes) |
| 6–7 nov | Artes, Música, Literatura, Jornal | Exposição, show, antologia e edição especial no Festival Cultural |
| 13 jan (sáb) | Atletismo | Corrida de estrada por equipes |
| 13 fev (sáb) | Literatura | Concurso regional de redação |

## 55. REPRESENTANTES, CONSELHO ESTUDANTIL, DISCIPLINA E REPUTAÇÃO

`[PLANEJADO]`

### 55.1. Representantes de turma

- Eleitos na Hora da Turma de 4 de abril (1º trimestre), 4 de setembro (2º) e 11 de janeiro (3º). Candidatos do elenco: Hina e Daichi. O jogador pode se candidatar com Carisma ≥ 15 ou reputação institucional ≥ 20; os NPCs votam por vínculo e por reputação.
- Funções: abrir e fechar a sala, levar recados do conselho, conduzir votações (M-10), organizar a limpeza. Cada função é um pequeno compromisso de tempo com +reputação institucional.

### 55.2. Conselho estudantil por ano

| Ano do protagonista | Cargos disponíveis | Caminho |
|---|---|---|
| Ano 1 | Secretaria ou tesouraria do 1º ano (eleição de 12 de novembro) | Reputação institucional ≥ 30, representante ou comitê, apoio de Kaede ou de Hina |
| Ano 2 | Vice-presidência | Cargo no Ano 1, reputação ≥ 50, campanha contra Rina ou ao lado dela |
| Ano 3 | Presidência | Vice no Ano 2 e eleição |

**Campanha (9 a 12 de novembro):** cartazes (Criatividade; Yui ou Rei ajudam), discursos no almoço (Carisma), **debate** em Janela de Questão no modo debate (perguntas da plateia com três respostas: prática, idealista, evasiva — cada uma agrada a um grupo), apoios públicos (amigos nível 3+ anunciam voto e influenciam os próprios amigos pelo grafo).

### 55.3. Reputação em quatro dimensões (0–100)

| Dimensão | Sobe com | Efeitos |
|---|---|---|
| Acadêmica | Questões certas, ranking, Desafio da semana | ≥ 40: pedidos de ajuda de colegas (missões de monitoria); ≥ 70: professores confiam tarefas |
| Esportiva | Clube, Festival Esportivo, competições | ≥ 40: convites para treinos de outros clubes; ≥ 70: torcida pelo nome |
| Social | Saídas em grupo, festival, karaokê, ajudar | ≥ 40: Aiko convida para tudo; ≥ 70: NPCs cumprimentam na rua |
| Institucional | Representante, comitês, limpeza, voluntariado | ≥ 30: cargo no conselho; ≥ 60: chave da sala do conselho |

As dimensões são independentes de propósito (regra 21.1): é possível ser o melhor aluno e um desconhecido no corredor.

### 55.4. Ocorrências disciplinares

| Ocorrência | Pontos |
|---|---|
| Atraso acima de 5 minutos | 1 |
| Flagrante em aula (bilhete, cochilo, celular, conversa) | 1 |
| Falta não justificada a um período | 2 |
| Trabalho sem permissão escolar | 3 (se descoberto) |
| Brincadeira no laboratório ou piscina | 3 |

| Acumulado no trimestre | Consequência |
|---|---|
| 3 | Conversa com Sato depois da aula (cena curta, gentil) |
| 6 | Aviso à avó (mensagem; humor Triste do protagonista no dia) |
| 9 | Uma semana sem clube e limpeza extra |
| 12 | Conversa com o Diretor Ōtsuka; reputação institucional −20 |

Pontos zeram a cada trimestre. A **Justificativa de confiança** (hábito Presença) perdoa uma ocorrência por mês.

### 55.5. Permissão de trabalho

Trabalhar exige a autorização escolar (**Permissão de trabalho**), obtida com Sato a partir de 14 de abril com Disciplina ≥ 10 ou consentimento da avó por conversa. Máximo de três turnos por semana. Trabalhar sem permissão é possível (como Haruto), com o risco da ocorrência de 3 pontos ao ser visto por um professor ou pela Sra. Ueno.

## 56. TABELA CENTRAL DO CALENDÁRIO — ANO 1 COMPLETO

`[PLANEJADO]` — fonte única para `data/calendar_events.json`. Dias sem linha são dias comuns (aulas de segunda a sexta; fins de semana livres). Legenda: ESC escola · PRO provas · FES festival e tradição · CLU clube · SOC social · ANI aniversário · CLI clima · FAM família. Dias 1–5 e 8–12 são dias úteis; 6–7 e 13–14 são fins de semana.

### Abril — Primavera, cerejeiras

| Dia | Evento |
|---|---|
| 1 seg | ESC Cerimônia de entrada; Homeroom com M-01; mapa de assentos; início do ciclo diário |
| 2 ter | ESC Primeiro dia de aulas regulares; M-02 · ANI Mei |
| 3 qua | CLU Feira de clubes no pátio; dias de teste até sexta |
| 4 qui | ESC Hora da Turma: eleição de representante (Hina × Daichi) |
| 6 sáb | SOC Hanami no parque (saída de grupo de Aiko) |
| 7 dom | FAM Avó em casa; bento de domingo |
| 8 seg | CLU Prazo de escolha de clube · primeira mesada |
| 9 ter | ESC M-04 Kenta e o verbo irregular (dia típico da seção 60) |
| 10 qua | ESC Teste diagnóstico (não vale nota) |
| 11 qui | ESC M-05 Experimento de Fujii; Hora da Turma: Pesquisa de Futuro · ANI Ren |
| 12 sex | ESC Primeiro Estudo dirigido; resultado do Desafio da semana |
| 13 sáb | CLU Treino aberto dos clubes esportivos · SOC Café Hoshizora anuncia vaga |
| 14 dom | SOC Chá na casa da Sra. Ueno · ESC Permissão de trabalho disponível |

### Maio — Golden Week e primeira prova

| Dia | Evento |
|---|---|
| 1 seg | FES Golden Week adaptada (sem aulas até quarta) · ANI Ayumi |
| 2 ter | FES Festival de primavera do santuário (Kaede como miko; barracas) |
| 3 qua | SOC Passeio a Shiosaki disponível · ANI Shingo |
| 4 qui | ESC Retorno; M-07 redação atribuída |
| 6 sáb | ESC Estudo em grupo no Café Hoshizora (Aiko) |
| 7 dom | ESC Estudo em grupo na biblioteca (Daichi) · ANI Yui |
| 8 seg | PRO Semana de provas (clubes suspensos); entrega da redação |
| 9 ter | ESC Leitura da melhor redação |
| 10–11 qua–qui | PRO Provas intermediárias do 1º trimestre (U1) |
| 12 sex | PRO Resultados e ranking no mural; clubes voltam |
| 14 dom | FAM Dia das Mães → "Dia da avó" (presente ou bento para Harue) |

### Junho — Estação chuvosa

| Dia | Evento |
|---|---|
| 1 seg | CLI Início da estação chuvosa (até dia 14) · ESC troca para uniforme de verão · ANI Tsubasa |
| 2 ter | SOC Evento "Guarda-chuva dividido" possível em dias de chuva |
| 4–5 qui–sex | ESC Excursão do 1º ano a Shiosaki (aquário, praia, pousada; noite de conversas) |
| 7 dom | ANI Saki |
| 9 ter | CLU Lesão de Miyu (arco independente) |
| 10 qua | SOC Limpeza do rio (voluntariado após a aula; Hina) |
| 12 sex | CLU Ensaio da competição de natação |
| 13 sáb | CLU Competição interescolar de natação em Shiosaki |
| 14 dom | CLI Fim da estação chuvosa |

### Julho — Tanabata e verão

| Dia | Evento |
|---|---|
| 1–2 seg–ter | PRO Revisão; clubes suspensos |
| 3–4 qua–qui | PRO Provas finais do 1º trimestre (U1 e U2) |
| 5 sex | PRO Resultados |
| 6 sáb | CLU Último torneio dos veteranos (basquete e vôlei); Shingo e Ayumi se aposentam |
| 7 dom | FES Tanabata no santuário: tanzaku, barracas, evento de romance ou amizade |
| 8–9 seg–ter | ESC Devolução de provas; aulas de encerramento |
| 10 qua | ESC Cerimônia de encerramento do 1º trimestre; boletim; Dever de verão entregue |
| 11 qui | ESC Início das férias de verão (até 14 de agosto); treino de verão dos clubes |
| 12 sex | ANI Sora |
| 13 sáb | CLU Show aberto da banda no parque · ANI Taiga |
| 14 dom | FAM Avó em casa |

### Agosto — Férias

| Dia | Evento |
|---|---|
| 1 seg | ANI Miyu |
| 2–4 ter–qui | CLU Acampamento de treino (Shiosaki, escola ou mirante) |
| 3 qua | ANI Aiko (durante o acampamento) |
| 6 sáb | FES Festival de verão de Hoshikawa: yukata, barracas, trabalho temporário |
| 7 dom | FES Fogos de artifício no rio (ponte velha ou mirante) |
| 9–11 ter–qui | FAM Obon: avó em casa; visita ao túmulo do avô; chamada de vídeo dos pais |
| 12 sex | CLU Noite das Perseidas no mirante |
| 13 sáb | SOC Praia em Shiosaki com a turma |
| 14 dom | ESC Último dia de férias; lembrete do Dever de verão |

### Setembro — Segundo trimestre

| Dia | Evento |
|---|---|
| 1 seg | ESC Cerimônia de abertura; entrega do Dever de verão; troca de lugares; Kōhei passa a Literatura |
| 2 ter | ESC M-09 Simulado de evacuação |
| 4 qui | ESC Hora da Turma: eleição de representante do 2º trimestre e divisão de provas do Festival Esportivo · ANI Jin |
| 5 sex | CLU Seletiva de basquete |
| 8 seg | ESC Treinos de turma após a aula até sexta (revezamento, cabo de guerra, dança) · ANI Riku |
| 13 sáb | FES Tsukimi: noite no mirante com dango |
| 14 dom | FAM Aniversário de Harue; jantar |

### Outubro — Festival Esportivo

| Dia | Evento |
|---|---|
| 1 seg | ESC Troca para uniforme de inverno |
| 2 ter | ANI Akari |
| 4 qui | ESC Hora da Turma: M-10 votação do projeto do Festival Cultural |
| 5 sex | ESC Ensaio geral do Festival Esportivo |
| 6 sáb | FES Festival Esportivo: provas por turma e cor; Aiko × Saki; Ren × Riku; dança da turma |
| 8 seg | ESC Feriado compensatório (Dia do Esporte) |
| 9 ter | PRO Revisão · ANI Kaede |
| 10–11 qua–qui | PRO Provas intermediárias do 2º trimestre (U3) |
| 12 sex | PRO Resultados · CLU o guitarrista deixa a banda de Taiga |
| 13 sáb | ANI Kenta (ramen para amigos nível 3+) |
| 14 dom | SOC Shiosaki fecha a temporada de praia |

### Novembro — Festival Cultural e eleições

| Dia | Evento |
|---|---|
| 1–5 seg–sex | ESC Preparativos do Festival Cultural; 1 seg divisão de tarefas (M-10, parte 2) |
| 6–7 sáb–dom | FES Festival Cultural: projeto da 1-A, exposição de Artes, show da banda, desfile de Mei; fogueira de encerramento no domingo · ANI Hina (dia 6) |
| 8 seg | ESC Folga compensatória · SOC a loja da família de Haruto fecha |
| 9 ter | ESC Início da campanha do conselho |
| 10–11 qua–qui | ESC Cartazes, discursos no almoço e debate |
| 12 sex | ESC Eleição do conselho · ANI Yuto |
| 13 sáb | SOC Missão "Luzes do distrito antigo" começa (quatro tardes nas duas semanas seguintes) |

### Dezembro — Fim do segundo trimestre

| Dia | Evento |
|---|---|
| 1–2 seg–ter | PRO Revisão; clubes suspensos |
| 3–4 qua–qui | PRO Provas finais do 2º trimestre (U3 e U4) |
| 5 sex | PRO Resultados |
| 6 sáb | ANI Kōhei (estudando; mensagem conta) |
| 9 ter | ESC Limpeza geral da escola |
| 10 qua | ESC Cerimônia de encerramento do 2º trimestre; boletim · ANI Chiaki |
| 11 qui | ESC Início das férias de inverno (até 7 de janeiro) |
| 13 sáb | FES Noite das Luzes de Hoshikawa (iluminação do centro; evento de romance ou amizade) · SOC Daichi e Hina estudando juntos |
| 14 dom | FES Banho de yuzu no sentō Yu no Hoshi · FAM avó em casa |

### Janeiro — Ano Novo

| Dia | Evento |
|---|---|
| 1 seg | FES Ano Novo: Hatsumode no santuário, omikuji do ano, otoshidama ¥10.000; mensagens de todos os contatos nível 2+; trabalho temporário no santuário (1 a 3) |
| 2–3 ter–qua | FAM Primeiros dias: família conforme o motivo da mudança |
| 4 qui | CLI Neve possível a partir deste dia |
| 6 sáb | SOC Guerra de bolas de neve no parque (se nevar) |
| 8 seg | ESC Cerimônia de abertura do 3º trimestre; troca de lugares |
| 9 ter | ANI Daichi |
| 11 qui | ESC Hora da Turma: eleição de representante do 3º trimestre · ANI Rina |
| 13 sáb | CLU Corrida de estrada por equipes (Ren, Riku, Jin); a turma torce |

### Fevereiro — Inverno e chocolates

| Dia | Evento |
|---|---|
| 3 qua | FES Setsubun na aula de Economia Doméstica: arremesso de feijões; Iwasaki de oni |
| 4 qui | ANI Nozomi |
| 8–9 seg–ter | ESC Vestibular dos veteranos (Kaede e Kōhei ausentes a semana toda) |
| 10 qua | ESC Economia Doméstica: preparar chocolate (item para o dia 12 ou 14) |
| 12 sex | FES Troca de chocolates na escola (honmei e giri) |
| 13 sáb | CLU Concurso regional de redação |
| 14 dom | FES Dia dos Namorados: encontro ou saída de amigos |

### Março — Formatura e encerramento

| Dia | Evento |
|---|---|
| 1–2 seg–ter | PRO Revisão; clubes suspensos |
| 3–4 qua–qui | PRO Provas finais do ano (U4 e U5) |
| 5 sex | PRO Resultados · ANI Haruto (festa pequena na loja reaberta, se a missão foi concluída) |
| 6 sáb | ESC Preparação da formatura (comitê) |
| 8 seg | FES Cerimônia de formatura dos veteranos; segundo botão; despedidas |
| 9–11 ter–qui | ESC Última semana: devolução, limpeza, montagem da Retrospectiva |
| 12 sex | ESC Cerimônia de encerramento do ano; boletim anual; Hora final da turma e foto da 1-A |
| 13 sáb | ESC Férias de primavera (13 e 14) |
| 14 dom | FES White Day: retribuição dos chocolates · Retrospectiva do Ano 1 · transição para o Ano 2 |

Aniversários de professores e moradores (Sato 8 fev, Hill 12 jun, Fujii 10 set, Jun 13 out, Momo 5 jul) aparecem no app Contatos quando descobertos e geram falas, não eventos.

## 57. TRABALHOS, MESADA E TABELA DE PREÇOS

`[PARCIAL]` — o protótipo tem ¥1.500 iniciais, onigiri a ¥200 e compra na máquina. O restante é `[PLANEJADO]`.

### 57.1. Renda

| Fonte | Valor | Quando |
|---|---|---|
| Saldo inicial | ¥1.500 | Criação |
| Mesada da avó | ¥3.000 | Toda segunda-feira (transferência; mensagem curta) |
| Otoshidama | ¥10.000 | 1 de janeiro |
| Boletim com média ≥ 4 | ¥2.000 | Fim de trimestre |
| Empregos | Tabela abaixo | Turnos |
| Trabalhos temporários | ¥1.200/h | Festival de verão (6 ago), santuário (1–3 jan) |
| Prêmios | ¥1.000–¥3.000 | Concurso de redação, Festival Esportivo (vale-lanche) |

### 57.2. Empregos

| Lugar | Dias e horário | Pagamento por turno | Requisito | Atividade do turno | Vantagem |
|---|---|---|---|---|---|
| Café Hoshizora (Jun Hasebe) | ter, qui, sáb · 16:30–19:30 | ¥2.850 | Carisma ≥ 8; permissão de trabalho | Memorizar 3 a 5 pedidos e montar a bandeja certa; gorjeta por acerto | Café grátis; Kaede e Daichi frequentam; Jun dá conselhos sobre o conselho |
| Konbini Hoshimart (Sr. Tanabe) | qualquer dia · 17:00–20:00 | ¥2.700 | Disciplina ≥ 8; permissão | Repor prateleiras (ordenar) e caixa (calcular troco: prática de Matemática) | 10% de desconto; subtrama de Haruto à noite |
| Livraria Kinoshita | qua, sáb · 15:30–18:30 | ¥2.640 | Conhecimento ≥ 12; permissão | Encontrar livros por categoria; recomendar por gênero (questão curta) | Ler de graça (+Domínio); amizade com Yuto |
| Oyama Ramen | sex, sáb · 18:00–21:00 | ¥3.000 | Condicionamento ≥ 8; permissão | Barra de tempo do macarrão; servir mesas | Ramen grátis (+30 de energia); família de Kenta |
| Shirakawa Boutique | sáb, dom · 13:00–17:00 | ¥3.600 | Carisma ≥ 10 ou Criatividade ≥ 10; permissão | Montar conjuntos para clientes (combinação de estilo) | 15% de desconto; amizade com Mei |
| Entregas da casa de chá Arai | sáb · 10:00–12:00 | ¥1.800 | Bicicleta | Entregar 4 encomendas no distrito antigo dentro do tempo | Chá grátis; lendas de Gen'ichi |

Máximo de três turnos por semana (regra escolar). Cada turno consome 15 de energia. Faltar a um turno combinado reduz a confiança do empregador; três faltas encerram o emprego com uma conversa.

### 57.3. Preços de referência

| Item | Preço |
|---|---|
| Onigiri (máquina ou konbini) | ¥200 |
| Melon-pan / yakisoba-pan / leite de café (loja escolar) | ¥150 / ¥180 / ¥120 |
| Café no Hoshizora | ¥450 |
| Ramen | ¥800 |
| Matcha com doce na casa de chá | ¥600 |
| Bilhete de trem para Shiosaki (ida) | ¥320 |
| Arcade (crédito) / purikura | ¥100 / ¥400 |
| Karaokê (hora, sala) | ¥1.200 |
| Sentō Yu no Hoshi | ¥450 |
| Omikuji / omamori de estudo | ¥100 / ¥500 |
| Guarda-chuva | ¥500 |
| Corte e penteado no Cut & Star | ¥2.500 |
| Conjunto casual na boutique | ¥2.000–¥6.000 |
| Yukata | ¥4.500 |
| Presentes | ¥300–¥3.000 |
| Decoração do quarto | ¥800–¥12.000 |
| **Bicicleta** | **¥18.000** (meta de poupança do primeiro trimestre) |

A economia deve permitir que quem não trabalha viva bem com a mesada, e que quem trabalha compre a bicicleta, roupas e presentes mais cedo — sem que o dinheiro desbloqueie progressão acadêmica ou social diretamente (regra 26.4).

## 58. CELULAR V3 — APLICATIVOS E MENSAGENS

`[PARCIAL]` — o protótipo abre o celular com agenda, personagem e contatos. O conjunto abaixo é `[PLANEJADO]`.

### 58.1. Aplicativos

| App | Conteúdo |
|---|---|
| **Talk** | Mensagens individuais e o grupo "1-A" (criado por Aiko no dia 3 de abril); respostas com três registros; convites |
| **Agenda** | Compromissos do dia e da semana (aulas, clube, turnos, prazos, saídas combinadas) |
| **Contatos** | Fichas sociais com nível, humor (nível 2+), aniversário, tópicos descobertos, presentes conhecidos, vínculos entre NPCs testemunhados |
| **Objetivos** | Missões ativas (cinco destacadas), concluídas e expiradas |
| **Escola** | Horário semanal, Caderno (Cartões por matéria), deveres e prazos, notas, ranking, ocorrências, Desafio da semana |
| **Diário** | Entradas automáticas e notas do jogador |
| **Álbum** | Cartões de Memória; avistamentos de Mochi |
| **Carteira** | Saldo, extrato simples, turnos pagos |
| **Mapa** | Igual ao mapa da tecla M |
| **Config** | Intensidade das aulas, barra de tempo, acessibilidade |

### 58.2. Grupo da turma

O grupo "1-A" recebe de duas a quatro mensagens por dia letivo (lembretes de Hina, piadas de Tsubasa, fotos de Rei, convites de Aiko, correções de Daichi). O jogador pode responder ou só ler. Responder no mesmo dia a uma mensagem direcionada rende +5 de vínculo com o autor. O grupo é o principal canal de anúncios de saídas em grupo.

### 58.3. Exemplos de mensagens

| Remetente | Gatilho | Mensagem |
|---|---|---|
| Harue | Toda segunda, 07:00 | "Mesada enviada. Compre algo quente se chover. Vovó." |
| Aiko | 3 de abril | "Criei o grupo da turma!! Quem não entrar é monstro 👻 (brincadeira) (não é)" |
| Kenta | Após M-04 | "ei… aquele negócio do went. tem como explicar de novo amanhã? pago o melon-pan" |
| Hina | Véspera de prova | "Lembrete: provas amanhã às 08:40. Tragam lápis 2B. Não se atrasem." |
| Sora | Noite de céu limpo, nível 3+ | "céu limpo. mirante. agora. (se quiser)" |
| Nozomi | Nível 4, dia seguinte a uma saída | "obrigada por ontem. escrevi uma coisa. não vou mostrar." |
| Daichi | Resultado de prova | "Parabéns pela posição. Da próxima vez será diferente." |
| Ren | 06:20 em dias de hábito Corrida matinal | "acordou? 5 min na esquina" |
| Mei | Sábado, nível 3+ | "tem uma jaqueta aqui que é a sua cara. vem ver. (não precisa comprar) (precisa)" |
| Prof. Sato | 3 ocorrências | "Passe na sala dos professores depois da aula. Não é bronca. É conversa." |

Mensagens chegam com um som discreto e um ponto no ícone; nunca abrem janela sozinhas (regra 28.1). Mensagens com convite expiram no horário combinado.

## 59. NOVOS LOCAIS E ATIVIDADES DE HOSHIKAWA

`[PLANEJADO]` — complementa as seções 5 a 11 sem aumentar o tamanho do mapa: cada local novo ocupa um prédio ou um canto já previsto.

### 59.1. Escola

| Local | O que oferece |
|---|---|
| **Telhado** | Trancado até a missão M-08; ponto de almoço às terças e quintas; cenas de Kenta, Sora e Haruto; vista da cidade |
| **Loja escolar** | Abre no almoço; melon-pan limitado a 5 unidades por dia — quem chega primeiro leva (Kenta e Nana competem); yakisoba-pan e leite de café sem limite |
| **Biblioteca** | Leitura de 30 min (+Domínio por área do livro), estudo com alguém, grupo avançado às terças, aberta até 19:00 em semanas de provas |
| **Sala dos professores** | Permissão de trabalho, dúvidas (Janela de 1 questão com dica garantida, uma vez por dia), clube de conversação de Hill às quartas no almoço |
| **Enfermaria** | Falta justificada; conversa com a Enfermeira Mochizuki; comitê de saúde |
| **Sala do conselho** | Acesso com reputação institucional ≥ 60 ou cargo; mural de eventos; Kaede |
| **Depósito antigo** | Sr. Ishida; Mochi dorme lá; objetos para a decoração do festival |
| **Sala de informática** | Chiaki; pesquisar cartões (versão lenta do estudo); protótipo do jogo dela |
| **Mural do corredor** | Ranking, cartazes de campanha, anúncios de clubes (objeto 3D que muda com o calendário) |

### 59.2. Centro comercial

| Local | O que oferece |
|---|---|
| **Café Hoshizora** | Emprego; saídas; estudo em grupo; Jun |
| **Galaxy Game Center** | Máquina de garra (¥100; pelúcias viram presentes), jogo de ritmo, **purikura** (¥400, Memória com 2+ amigos), ranking de iniciais onde Chiaki e Tsubasa disputam |
| **Karaokê Star Box** | Miniatividade de ritmo em grupo; +Carisma; Aiko e Saki |
| **Shirakawa Boutique** | Roupas casuais, yukata, presentes de moda; emprego |
| **Livraria Kinoshita** | Livros (itens que dão +Domínio ao ler em casa), revistas de presente; emprego |
| **Oyama Ramen** | Refeição (+30 energia), emprego, aniversário de Kenta |
| **Doceria Amane** | Pudim de Aiko, doces de matcha de Yui, doces sazonais (kakigōri no verão, oden no konbini no inverno) |
| **Salão Cut & Star** | Trocar penteado (¥2.500); novas opções por ano |
| **Clínica Kurosawa** | Cenas de Daichi; consulta quando a energia chega a zero três dias seguidos (conselho, não punição) |
| **Farmácia** | Mãe de Tsubasa; itens de energia leves |

### 59.3. Bairro, parque, rio, distrito antigo e colinas

| Local | O que oferece |
|---|---|
| **Konbini Hoshimart** | Compras noturnas, emprego, Haruto depois das 20:00 |
| **Casa da Sra. Ueno** | Chá de domingo; fofocas que viram pistas de rotinas |
| **Parque do bairro** | Momo e as missões dela; Yui desenhando; banco de descanso (já no protótipo) |
| **Parque municipal** | Hanami, show da banda, guerra de neve, saídas de grupo |
| **Margem do rio** | Corrida com Ren (+Condicionamento), limpeza do rio, fogos, bancos de conversa ao entardecer |
| **Ponte velha** | Nozomi; melhor ponto dos fogos |
| **Casa de chá Arai** | Lendas (cartões de História), saídas, entregas |
| **Sentō Yu no Hoshi** | Banho (¥450, +40 de energia à noite), conversas com moradores, banho de yuzu em 14 de dezembro |
| **Loja da família de Haruto** | Fecha em novembro; reabre em janeiro com a missão "Luzes do distrito antigo" |
| **Santuário** | Omikuji diário (sorte do dia: pequeno modificador de ±5% nos ganhos de vínculo), omamori de estudo (um por trimestre), ema (desejo ligado ao Sonho), festivais, Hatsumode, trabalho temporário |
| **Mirante** | Observação do céu à noite (clima limpo), Perseidas, Tsukimi, telescópio do clube; humor Inspirado |
| **Estação** | Hikari; trem para Shiosaki; ponto de encontro de saídas |

### 59.4. Bicicleta

- Comprada por ¥18.000 na loja ao lado da estação (ou herdada: a avó conserta a bicicleta velha do avô se o arco "O quarto do avô" for concluído no Obon — a escolha entre comprar cedo e esperar é proposital).
- Velocidade de deslocamento ×1,6 nas ruas; estacionamento obrigatório no bicicletário da escola e da estação; não pode ser usada com guarda-chuva aberto (chuva força caminhar ou se molhar: humor Cansado).
- Abre as entregas da casa de chá e encurta o caminho para o mirante.

### 59.5. Guarda-chuva e dividir o guarda-chuva

Item de ¥500 que fica na mochila. Sair da escola na chuva sem guarda-chuva dispara uma oferta de um NPC presente com vínculo ≥ 2 (Yui, Ren, Nozomi, Kenta…) para ir até o cruzamento junto — cena curta com +20 de vínculo e um Cartão de Memória na primeira vez. Com guarda-chuva, o jogador pode ser quem oferece.

### 59.6. Shiosaki

Cidade costeira a 20 minutos de trem. Mapa compacto: estação, calçadão, praia, aquário, pousada da excursão, barraca de kakigōri. Aberta nas férias, fins de semana de verão, na excursão de junho e no acampamento de agosto. Fecha a temporada em 14 de outubro.

## 60. UM DIA TÍPICO EM HOSHIKAWA — EXEMPLO INTEGRADO

Terça-feira, 9 de abril do Ano 1, segunda semana de aula. Protagonista com talento Dedicado, traços Curioso e Observador, origem Interior. Este roteiro mostra como os sistemas se encaixam; não é uma sequência obrigatória.

| Hora | O que acontece | Sistemas |
|---|---|---|
| 06:30 | Acorda Tranquilo. Pensamento: *"Segunda semana. Já sei onde fica o armário de sapatos."* Mensagem de Ren: "5 min na esquina". | Humor, Diário, Talk |
| 06:40–07:10 | Corre com Ren pela rua das cerejeiras até o rio. Ren conta que Haruto não respondeu de novo. | Hábito Corrida matinal, +Condicionamento, tópico Família de Ren |
| 07:20 | Em casa: bento de domingo da avó na mochila. Bilhete: "Hoje tem reunião; volto quinta." | Energia, FAM |
| 07:45–08:10 | Caminho para a escola. Yui e Aiko na praça; Aiko pergunta sobre o vilarejo (origem Interior). Mochi no muro da Sra. Ueno (avistamento). | Vínculo, Álbum |
| 08:25 | Homeroom. Sato lembra da Pesquisa de Futuro de quinta. Hina distribui o formulário. | ESC |
| 08:40 | **Matemática (período 1).** Postura: Anotar com cuidado. No segundo bloco, o Diretor sorteia `question` para Keita, que erra; Kawaguchi ri e explica. Cartões `ma_u1_c03` e `ma_u1_c04` no Caderno. | Postura, Diretor, Cartões |
| 09:40 | **Literatura (período 2).** Postura: Prestar atenção. Momento `note`: Tsubasa manda um desenho de Sato como gato. Opção Observador: "Devolver com um bigode a mais". Risco não acionado. +8 com Tsubasa. | Momentos, Traços |
| 10:40 | **Ciências (período 3).** Postura: Prestar atenção. `challenge`: Fujii pergunta quem sabe por que a água do rio parece brilhar à noite. Curioso levanta a mão: **Janela de Questão nível 3** sobre reflexão e plâncton (cartão de Ciências U1 obtido no sábado, na biblioteca). Acerto: +3 Domínio, +4 reputação acadêmica; Sora acorda e olha. | Janela de Questão, Desafio |
| 11:40 | **Inglês (período 4).** **M-04:** Kenta sussurra "went?". Escolha: Explicar. Janela cooperativa de 2 passos; Kenta acerta o segundo. Hill nota e pergunta ao protagonista a próxima (nível 2): acerto. Dever atribuído: 10 frases no passado. | Missão de Sala, help_request |
| 12:30 | Almoço. Corrida à loja escolar: melon-pan nº 4 de 5 (Kenta leva o 5º, Nana fica sem e reclama). Almoço na sala com Yui, Aiko e Kenta; Kenta: "amanhã de novo? pago o melon-pan". Mensagem no grupo: Aiko marca hanami atrasado para sábado. | Loja escolar, saídas em grupo |
| 13:15 | **Artes (períodos 5 e 6, aula dupla).** `art_prompt`: esboço de observação; escolha de tema "a janela da sala". Criatividade baixa: resultado "tímido, mas honesto". Yui olha o esboço e diz uma frase (tópico Hobbies descoberto). Humor → Inspirado. | Proposta criativa, Humor |
| 15:05 | Limpeza: dupla com Daichi. Ele comenta o acerto em Ciências: "Sorte." Opção Direto: "Estudo." +Carisma. | Vínculo, rivalidade |
| 15:30 | Sato: "Hora da Turma na quinta. Pense no formulário." | Sonhos |
| 15:40–17:40 | Clube de Literatura (dia de teste da semana dos clubes já passou; o jogador escolheu Literatura na segunda). Janela de treino: foco Escrita; poema coletivo com Nozomi e Yuto. Kōhei fala do jornal. | Clube |
| 17:50 | Caminho de casa com Nozomi até a ponte (saída curta, nível 2). Ela fala do avô. | Vínculo |
| 18:20 | Café Hoshizora: Jun pergunta se o protagonista quer a vaga de quinta. Precisa da permissão de Sato (disponível a partir de domingo). | Empregos |
| 19:00 | Casa. Dever de Inglês: Fazer com cuidado (45 min). Revisar cartões de Matemática (30 min). | Dever, Estudo |
| 20:30 | Jantar (bento). Mensagem de Kenta. Resposta Gentil. | Energia, Talk |
| 21:00 | Mirante? Céu nublado; Sora não manda mensagem. Fica em casa: computador, 30 min no Desafio da semana (nível 3, erra; Teimoso não está entre os traços — sem segunda tentativa). +1 Domínio pela explicação. | Desafio da semana |
| 22:30 | Diário: entrada automática ("Hoje levantei a mão em Ciências e não me arrependi…") + nota do jogador. Dorme antes das 23:00 (hábito Boa noite: 2/5). | Diário, Hábitos |
| 06:30 (10 abr) | Acorda Animado (Inspirado expirou, três noites cedo). Teste diagnóstico hoje. | Humor |

Balanço do dia: três Janelas de Questão (Ciências, Inglês ×2), um bilhete, uma proposta criativa, uma missão de sala avançada, dois hábitos mantidos, cinco vínculos movidos, um Cartão de Memória (primeiro melon-pan), nenhum menu obrigatório fora das aulas.

## 61. ARQUITETURA TÉCNICA V3 — MÓDULOS, DADOS, SAVE V3 E MIGRAÇÃO

`[PLANEJADO]` — tudo aqui descreve a forma pretendida. Nenhum dos arquivos novos existe; os existentes estão marcados.

### 61.1. Módulos

| Pasta | Existente (0.1) | Novo na V3 | Responsabilidade |
|---|---|---|---|
| `scripts/core/` | `game.gd`, `game_actions.gd`, `game_state.gd`, `save_system.gd`, `controls.gd` | `event_bus.gd`, `seeded_rng.gd` | Composição, estado, persistência, sorteio determinístico |
| `scripts/time/` | `game_time.gd` | `school_calendar.gd`, `event_scheduler.gd`, `weather_system.gd` | Relógio, trimestres, eventos do calendário, clima |
| `scripts/player/` | `player.gd`, `character_visual.gd`, `follow_camera.gd` | `mood_system.gd`, `habit_tracker.gd`, `diary.gd` | Movimento, câmera, humor, hábitos, diário |
| `scripts/npc/` | `npc_manager.gd`, `npc_actor.gd` | `npc_registry.gd`, `relationship_graph.gd`, `seat_map.gd` | Fichas, rotinas, grafo, assentos |
| `scripts/school/` | `school_schedule.gd` | `timetable.gd`, `class_director.gd`, `class_moment.gd`, `question_bank.gd`, `question_window.gd` (UI em `ui/`), `mastery.gd`, `homework.gd`, `exams.gd`, `grades.gd`, `clubs.gd`, `discipline.gd`, `reputation.gd` | Horário, aulas, questões, notas, clubes, ocorrências |
| `scripts/social/` | — | `bond.gd`, `topics.gd`, `gifts.gd`, `outings.gd`, `romance.gd`, `quests.gd` | Vínculo, conversas, presentes, saídas, romance, missões |
| `scripts/world/` | `geometry.gd`, ambientes, `interaction_point.gd`, `daylight.gd` | `region_loader.gd`, `shop.gd`, `job_shift.gd` | Regiões, lojas, turnos |
| `scripts/ui/` | `game_ui.gd`, `map_view.gd` | `phone/*.gd` (um por app), `question_window.gd`, `class_hud.gd`, `memory_card.gd` | Interface |

Princípio: `game_actions.gd` continua sendo a única porta entre a interface e os sistemas; os sistemas novos expõem funções puras e sinais, nunca constroem cenários.

### 61.2. Arquivos de dados

| Arquivo | Conteúdo | Observação |
|---|---|---|
| `data/schedule.json` (existe) | Períodos com início e fim em minutos | Mantido |
| `data/timetable.json` | Matéria por período e dia da semana (seção 46.2) | Substitui o campo `subject` fixo por consulta ao dia |
| `data/subjects.json` | Oito matérias: id, nome, professor, sala, atributo associado, unidades | — |
| `data/questions/<matéria>.json` | Banco de questões (seção 47.5) | Um arquivo por matéria |
| `data/cards/<matéria>.json` | Cartões de Conteúdo | Referenciados por `card` nas questões |
| `data/class_moments.json` | Catálogo de momentos com pesos e condições | — |
| `data/missions/class/*.json` | Missões de Sala M-01 a M-10 | — |
| `data/missions/<categoria>/*.json` | Demais missões (seção 53.3) | — |
| `data/npcs.json` (existe) → `data/characters/*.json` | Ficha completa por personagem + rotina no formato atual | Migração por script, mantendo os ids `yui`, `sato`, `ren` |
| `data/classrooms/1a.json` | Mapa de assentos por trimestre e restrições | — |
| `data/relationships.json` | Grafo inicial NPC–NPC (seção 51.1) | — |
| `data/calendar_events.json` | Tabela central (seção 56) | Datas no formato `{"month": 4, "day": 2}` |
| `data/clubs.json`, `data/jobs.json`, `data/items.json`, `data/shops.json`, `data/outings.json`, `data/topics.json`, `data/messages.json` | Conteúdo dos sistemas respectivos | — |

Ficha de personagem (extensão do formato de rotina atual):

```json
{
  "id": "kenta",
  "name": "Kenta Oyama",
  "kanji": "大山 健太",
  "age": 15, "grade": 1, "class": "1-A", "seat": "D3",
  "birthday": {"month": 10, "day": 13},
  "traits": ["leal", "alegre", "distraído"],
  "trust_pace": 1.2,
  "club": "basketball",
  "family": ["oyama_takeshi", "oyama_fumiko"],
  "friends": ["tsubasa", "ryo", "ren"],
  "topics": {"favorite": ["comida", "clube"], "sensitive": ["aulas"]},
  "gifts": {"loved": ["melon_pan", "sneakers"], "liked": ["sports_manga", "ramen_ticket"], "disliked": ["dictionary"]},
  "places": ["gym", "school_store", "oyama_ramen", "rooftop"],
  "mastery": {"english": 18, "math": 35, "pe": 70},
  "romance": true,
  "routine": [{"start": 420, "scene": "offscreen", "activity": "Ajudando no restaurante"}, {"start": 505, "scene": "classroom", "point": "seat:D3", "activity": "Em aula"}],
  "weekend": {"scene": "park", "point": [4, 0, 6], "activity": "Treinando arremessos"}
}
```

### 61.3. Diretor de Aula e Janela de Questão — fluxo técnico

1. `timetable.gd` resolve a matéria do período atual a partir de `GameTime` (dia da semana = `(day - 1) % 7`).
2. `class_director.gd` monta o plano do período: missões agendadas (`event_scheduler`) + momentos sorteados com `seeded_rng` (semente `hash(stamp + period_id)`).
3. Cada momento é um recurso `ClassMoment` com `kind`, `participants`, `window` (opcional) e `outcomes`.
4. `question_bank.gd` seleciona a questão por matéria, unidade atual (`school_calendar`), nível (regra 46.6) e exclusão das últimas 20 questões vistas (registradas no save).
5. `question_window.gd` (UI) emite `answered(question_id, correct, used_tools)`; `mastery.gd`, `reputation.gd` e `bond.gd` reagem por sinal.
6. O resultado do período é gravado em `attendance[stamp:period]` com `posture`, `moments`, `late` e `ocurrences`, estendendo a chave atual.

### 61.4. Save v3

Campos adicionados ao `player` (todos opcionais na leitura, com padrões):

```json
{
  "version": 3,
  "time": {"year": 1, "month": 4, "day": 9, "minute": 1350},
  "player": {
    "name": "Haru", "skin": "efbd98", "hair": "393940",
    "identity": {"surname": "Mizushima", "pronoun": "neutral", "birthday": {"month": 10, "day": 10}},
    "appearance": {"face": 1, "eyes": 2, "brows": 1, "hairstyle": 4, "height": 1, "build": 1, "accessories": ["glasses_1"]},
    "background": {"origin": "countryside", "reason": "own_choice", "talent": "dedicated", "traits": ["curious", "observant"]},
    "dream": "undecided",
    "mood": {"state": "inspired", "until": "1-04-11"},
    "habits": {"study": 3, "run": 2, "sleep": 2, "homework": 1, "presence": 9},
    "attributes": {"Conhecimento": 17, "Carisma": 6, "Condicionamento": 5, "Criatividade": 6, "Disciplina": 11, "Empatia": 6},
    "mastery": {"literature": 14, "math": 19, "english": 12, "history": 8, "science": 16, "pe": 9, "art": 7, "home_ec": 6},
    "cards": ["jl_u1_c01", "ma_u1_c03", "ma_u1_c04", "ci_u1_c02"],
    "notebook_pages": {"math": 1},
    "homework": [{"id": "en_0409", "subject": "english", "due": "1-04-11", "quality": "A", "delivered": false}],
    "grades": {}, "exams_seen": ["ci_u1_041", "en_u1_012", "en_u1_020"],
    "attendance": {"1-04-09:math": {"late": false, "posture": "notes", "moments": ["question:keita"], "occurrences": 0}},
    "club": {"id": "literature", "practice": 15, "rank": "novato"},
    "job": {"id": null, "permission": false, "shifts": []},
    "reputation": {"academic": 9, "sports": 2, "social": 6, "institutional": 3},
    "discipline": {"term_points": 0, "history": []},
    "relationships": {"yui": 95, "aiko": 70, "kenta": 160, "ren": 140, "tsubasa": 58, "nozomi": 60, "daichi": 40, "sato": 30},
    "bond_meta": {"kenta": {"last_talk": "1-04-09", "topics_known": ["comida"], "gifts_this_week": 0}},
    "npc_graph": {"aiko|riku": 350},
    "quests": {"m04_kenta": {"step": 2, "state": "active"}, "club_week": {"state": "completed"}},
    "diary": [{"date": "1-04-09", "auto": "Hoje levantei a mão em Ciências…", "note": "Melon-pan nº 4!"}],
    "memories": ["first_melon_pan"],
    "inventory": {"Onigiri": 1, "umbrella": 1, "bento_grandma": 2},
    "money": 2850,
    "flags": {"home": true, "school_hall": true, "talk": true, "class": true, "slept": true, "intro_done": true, "first_question": true}
  }
}
```

**Migração v2 → v3** (aditiva, no `SaveSystem.migrate`): copiar os campos existentes; preencher `identity`, `appearance`, `background` com o perfil Dedicado padrão; `mastery` igual a `Conhecimento` em todas as matérias; `mood` Tranquilo; listas vazias para o resto; `version = 3`. A validação ganha regras para cada campo novo e continua rejeitando o arquivo sem alterar a partida atual.

### 61.5. Desempenho com 30 alunos em sala

- Alunos de apoio usam o mesmo `CharacterVisual` com variações de cor e cabelo e **pose estática sentada** fora de interações; apenas os 13 personagens principais e os vizinhos animam continuamente.
- Materiais compartilhados por uniforme; cabelos como malhas separadas instanciadas.
- Fora da sala, NPCs distantes continuam calculados logicamente (regra 22.4); o corredor no intervalo limita a 12 atores físicos simultâneos.

### 61.6. Testes automatizados a acrescentar

- Banco de questões: ids únicos, `answer` dentro do intervalo, `card` existente, `explain` não vazio, pelo menos 4 questões por nível por unidade.
- Horário: toda matéria aparece o número de vezes da seção 46.2; nenhum período sem matéria.
- Calendário: nenhuma prova em fim de semana; nenhum evento fora de 1–14; aniversários únicos por personagem.
- Assentos: 30 carteiras, sem repetição, restrições respeitadas no sorteio com 100 sementes.
- Sorteio determinístico: o mesmo `stamp + period` produz o mesmo plano de aula.
- Save v3: migração de um save v2 real do protótipo abre sem erro e mantém atributos, vínculos e flags.

## 62. ROADMAP V3 — MARCOS 0.2 A 1.0

Cada marco é jogável do início ao fim e fecha um escopo. O marco seguinte só começa com o anterior validado em PC com renderização (não apenas headless).

| Marco | Nome | Escopo | Critério de aceite |
|---|---|---|---|
| **0.1** | First Day | Ciclo da seção 40 | Concluído em testes headless; validação manual pendente |
| **0.2** | **First Week** | Sete dias (1 a 7 de abril). Horário semanal; Postura de Foco; Diretor de Aula com `question`, `note`, `help_request`, `drowsy`; **Janela de Questão** com `choice` e `truefalse`; Missões de Sala M-01 a M-04; banco mínimo de 60 questões de U1 (Literatura, Matemática, Inglês, Ciências); Domínio por matéria; Cartões; seis colegas sentados com fichas curtas (Yui, Aiko, Daichi, Kenta, Hina, Tsubasa) e vizinhos funcionais; criação em quatro passos com traços e talento; humor e diário básicos; mesada; grupo da turma com 10 mensagens | Jogar os sete dias sem repetir uma Janela; três vínculos chegarem ao nível 1; save v3 migrando o v2 |
| **0.3** | **First Month** | Abril completo. Semana dos clubes com três clubes (Literatura, Basquete, Artes) e loop de treino simples; eleição de representante; Pesquisa de Futuro; dever de casa; Desafio da semana; 1-A com as 30 carteiras; outros 1º anos e três professores novos (Kawaguchi, Hill, Fujii); Café Hoshizora e permissão de trabalho; centro comercial em versão reduzida; Momo e Mochi | Chegar a 14 de abril com clube escolhido, um emprego e o primeiro dever entregue |
| **0.4** | **First Term** | Maio a julho. Provas intermediárias e finais com ranking e boletim; Golden Week; redação (M-07); excursão a Shiosaki; estação chuvosa e guarda-chuva; competição de natação; Tanabata; aposentadoria dos veteranos; todos os clubes; romance até a etapa Sinais; 480 questões | Dois boletins entregues; um romance em Sinais; relatório de desempenho em PC intermediário |
| **0.5** | **Summer** | Férias de verão. Acampamento; festival e fogos; Obon; Perseidas; Dever de verão; bicicleta; santuário completo; Shiosaki completa | Jogar as férias sem dias vazios |
| **0.6** | **Second Term** | Setembro a dezembro. Troca de lugares; simulado; Festival Esportivo; Festival Cultural com os quatro projetos; eleição do conselho com debate; missão "Luzes do distrito antigo"; Noite das Luzes; confissão e namoro | Festival Cultural com projeto escolhido por voto e consequências visíveis |
| **0.7** | **Third Term** | Janeiro a março. Ano Novo; neve; Setsubun; Valentine e White Day; vestibular dos veteranos; formatura e segundo botão; Retrospectiva; transição para o Ano 2 (estrutura, sem conteúdo) | Concluir o Ano 1 com Retrospectiva e save pronto para o Ano 2 |
| **0.8** | Polish | Arte final do protagonista e dos 13 principais; retratos; áudio; clima completo; acessibilidade; controle; opções gráficas | Sessão de 2 horas sem erro em três configurações de PC |
| **0.9** | Beta fechado | Balanceamento de notas, vínculo, energia e economia com dados de jogadores | Métricas dentro das metas da seção 63.2 |
| **1.0** | **Acesso antecipado — Ano 1** | Conteúdo completo do primeiro ano | Lançamento |
| 1.x | Ano 2, Ano 3 e formatura | Conforme seções 34 e 39.2 | — |

Dependências duras: 0.2 exige a Janela de Questão e o save v3; 0.4 exige o banco de questões em volume; 0.6 exige o grafo de NPCs; 0.8 exige os modelos finais.

## 63. DECISÕES CONSOLIDADAS E PONTOS PROVISÓRIOS — ATUALIZAÇÃO V3

### 63.1. Decisões consolidadas na V3 (somam-se às da seção 43)

- O protótipo 0.1 é a base de código; a V3 estende seus sistemas e formatos em vez de substituí-los.
- Aulas em cinco fases com Postura de Foco, Momentos de Aula sorteados por Diretor e Missões de Sala roteirizadas.
- A **Janela de Questão** é a interface única de participação acadêmica (aulas, deveres, provas, debates, clubes).
- Habilidade do jogador e atributos contam juntos; a parte interativa da nota não passa de 40%.
- Domínio por matéria separado do atributo Conhecimento; sem decaimento; teto diário de ganho.
- Horário semanal fixo da 1-A (seção 46.2) e três trimestres com cinco períodos de prova.
- Elenco oficial do Ano 1: 50 personagens nomeados e 17 alunos de apoio; mapa de assentos de 30 carteiras com troca por trimestre.
- Vínculo em seis níveis sobre a escala 0–1000 existente, sem decaimento, com estado Distante.
- Dez opções de romance no Ano 1, independentes do tratamento do jogador; veteranos e adultos fora do romance.
- Tabela central do calendário do Ano 1 (seção 56) como fonte única de datas.
- Sorteio determinístico por data em tudo que envolve aleatoriedade com consequência.
- Conteúdo em JSON validado por testes; nenhuma questão, missão ou personagem em código.
- Reprovação desativada no acesso antecipado do Ano 1 (flag gravada para decisão futura).
- Bicicleta como única aceleração de deslocamento; sem viagem rápida.

### 63.2. Pontos provisórios (a validar com testes de jogo)

| Ponto | Proposta atual | Como validar |
|---|---|---|
| Fórmula de nota | 40/45/15 (seção 48.3) | Distribuição de conceitos entre 2 e 5 para jogadores de rotina média |
| Pesos do Diretor de Aula | Normal: 3 janelas por dia | Nenhum tipo de momento repetido mais de duas vezes por semana |
| Níveis de vínculo | 50/150/300/500/750 | Nível 3 com um personagem até o fim de maio para quem conversa diariamente |
| Ritmo de confiança | ×1,2 / ×1,0 / ×0,8 | Nozomi chega ao nível 3 até julho com dedicação |
| Energia e humor | Custos da seção 46.4; humor sem bloqueio | Menos de 1 Sono em aula por semana para quem dorme antes das 23:00 |
| Economia | Mesada ¥3.000; bicicleta ¥18.000 | Bicicleta alcançável em julho sem trabalhar, em maio trabalhando |
| Volume de questões | 960 (meta) / 480 (mínimo) | Zero repetição em um trimestre com Intensidade Normal |
| Tamanho da parte interativa da prova | 5 questões, 60 s | Tempo médio de prova por matéria abaixo de 4 minutos reais |
| Troca de lugares | Sorteio com restrições | Vizinhos mudam pelo menos 3 de 4 a cada troca |
| Apresentação 3D da aula | Câmera da carteira e ida ao quadro | Legibilidade em 1280×800 |
| Retratos por camadas | Protagonista por camadas, NPCs à mão | Coerência visual lado a lado |

### 63.3. Regras adicionais para a IA (continuam a seção 42)

21. Todo conteúdo novo (questões, cartões, missões, personagens, eventos, itens) nasce em `data/`, nunca em scripts.
22. Toda questão tem explicação, referencia um cartão existente e é respondível sem conhecimento acadêmico avançado.
23. Tudo que envolve sorte com consequência usa semente derivada da data; salvar e recarregar não muda resultados.
24. Personagens novos recebem ficha completa (seção 22.1 mais os campos da seção 61.2) antes de aparecer em cena.
25. Cada sistema novo chega com testes de dados e de integração; o banco de questões é validado por teste automatizado.
26. Marcar `[IMPLEMENTADO]`, `[PARCIAL]` ou `[PLANEJADO]` ao atualizar este documento, e registrar a mudança em `docs/DECISIONS.md`.

## 64. OBJETIVO FINAL

School Life deverá ser uma experiência em que o jogador realmente sinta que está vivendo em Hoshikawa.

A cidade deve parecer familiar. A escola deve ser um lugar de oportunidades e acontecimentos. Os personagens devem parecer pessoas com suas próprias vidas. A passagem do tempo deve importar. As escolhas devem gerar consequências e abrir trajetórias diferentes.

Dois jogadores não precisam terminar o ensino médio com as mesmas experiências.

Um poderá se tornar um excelente estudante e membro do conselho estudantil. Outro poderá se dedicar aos esportes e alcançar a liderança de seu clube. Outro poderá trabalhar, desenvolver amizades e dedicar seu tempo à vida cultural da cidade. Outro poderá tentar equilibrar todas essas atividades.

Não existe uma única maneira correta de viver os três anos.

A experiência deverá preservar a sensação de liberdade, descoberta, crescimento pessoal e convivência encontrada nos melhores simuladores de vida.

O mundo deve ser belo e agradável de explorar, mas sua verdadeira profundidade estará nos personagens, no calendário, nas decisões e na evolução da vida cotidiana.

School Life não deverá apenas contar uma história sobre o ensino médio japonês. Deverá permitir que o jogador construa e viva a sua própria história.

**FIM DO PROMPT MESTRE — SCHOOL LIFE 3D V3.0**

Nota de projeto: a Parte II é uma proposta de expansão, não a descrição de funcionalidades implementadas. O próximo passo técnico recomendado é o marco **0.2 "First Week"** (seção 62): horário semanal, Postura de Foco, Diretor de Aula, Janela de Questão com 60 questões, Missões de Sala M-01 a M-04, seis colegas com carteira e o save v3 — validado em PC com renderização antes de qualquer expansão de mapa.
