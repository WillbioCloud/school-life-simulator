# Validação — First Week 0.2

## Resultado local (14/10/2026)

**Godot 4.7.2.stable.custom_build — 188 verificações aprovadas, 0 falhas.** A execução final não emitiu erros de script ou runtime. (0.1: 62 verificações.)

O ambiente não tinha Godot instalada e o download do binário foi bloqueado pela rede; por isso o código-fonte oficial da tag `4.7.2-stable` foi compilado em modo `template_debug`, com servidor headless e sem backends gráficos. A engine e os arquivos temporários **não fazem parte do repositório**.

Templates não aceitam `--path` nem geram o cache de `class_name`. O procedimento usado está versionado em `tests/run_template.sh`: espelha o projeto numa pasta temporária ao lado do binário, gera `.godot/global_script_class_cache.cfg` com `tests/tools/gen_class_cache.py`, define `tests/test_runner.tscn` como cena principal por `override.cfg` e isola o diretório de saves:

```bash
GODOT_TEMPLATE=/caminho/godot.linuxbsd.template_debug.x86_64 ./tests/run_template.sh
```

Para uma instalação normal da Godot, use `tests/run.sh`, que faz a importação pelo editor antes dos testes. O workflow GitHub Actions segue esse caminho; seu resultado deve ser consultado no PR, não inferido a partir do teste local.

## Cobertura automatizada

Calendário e base 0.1:

- Início oficial às 06:30 de segunda-feira, 1º de abril; dias úteis/finais de semana; viradas de mês e de ano; 168 dias/ano e 504 em três anos.
- Save/load, inventário, dinheiro, vínculo e marcos; rejeição de datas, cenas e posições inválidas; save corrompido sem modificar a partida; backup.
- Instanciação do menu, cinco ambientes, protagonista, NPCs e painéis; menus pausam e retomam o relógio; projeções da câmera; colisão com o chão; ciclo escola → casa → sono → autosave; meia-noite.

Novo no 0.2:

- Integridade de dados: regras de autoria do banco (ids únicos, níveis, cartões existentes, explicações), 60+ questões, 30 slots na grade, carga semanal 5/5/4, Literatura com Sato na segunda, estudo dirigido na sexta, mapa de assentos (Yui/Kenta/Daichi/Tsubasa ao redor de C2), oito fichas, missões e questões reservadas.
- `SeededRng` reprodutível por data e período.
- Perfil: talento, origem (exterior: +15 Inglês/−5 Literatura), limite de dois traços, itens iniciais; Domínio com teto diário de +6 e +1 Conhecimento a cada 10; níveis e nomes de vínculo; vínculo nunca negativo; validade e expiração do humor; últimas 20 questões; custo de energia do humor Cansado.
- Diretor: cinco blocos, uma pergunta garantida no primeiro período teórico, no máximo dois momentos, limite diário de janelas, Sono em aula com energia baixa, atraso com ocorrência e período encurtado.
- Aula completa headless: tela de postura, avanço até o fim do período, Domínio e energia, Cartões, pergunta respondida e lembrada, flag `class`.
- Ferramentas da Janela: *Pedir ajuda* (Daichi nível 2) remove uma alternativa errada e preserva a certa; *Consultar caderno* liberado por Páginas e concede o Cartão; *Não sei* mostra a explicação e dá +1 Domínio; deitar no Sono em aula restaura energia e gera ocorrência.
- Missões: M-01 no Homeroom do dia 1 (flag `intro_done`), M-02 com a questão fixa `jl_u1_001` na primeira Literatura após o dia 1, M-04 com as duas questões cooperativas e vínculo com Kenta.
- Save v3: ida e volta de Domínio, Cartões e diário; Domínio fora de 0–100 rejeitado; v1 → v2 → v3; v2 real migra com Domínio = Conhecimento salvo e restaura sem perder progresso.
- Composição: criador com perfil, seis abas do celular, quatro passos do criador, cinco presentes às 08:25 e seis às 08:40 (Tsubasa entra com o sinal), colegas sentados nas cadeiras mapeadas, contexto com vizinhos, Homeroom dirigido pela UI (`class_cmd`) concluindo M-01 e fechando o modal, conversa diária (+15, +3 Sociável), diário de três linhas e anotação, humor Cansado após dormir tarde, mesada na segunda 8 de abril e não no dia seguinte.
- **Aceite da semana:** 45 períodos em 7 dias com posturas alternadas, nenhuma Janela de Questão repetida, três vínculos no nível 1, M-01 e M-02 concluídas, sete entradas de diário, save/load v3 do estado final.

## Limitações da validação

Os testes de integração acionam comandos e transições diretamente; não simulam todas as teclas nem caminham cada percurso completo. A semana simulada usa uma política fixa (sempre acerta, escolhe a primeira opção), então a variedade de Momentos observada depende da semente de cada data — um roteiro aleatório foi executado à parte sem erros, mas não faz parte da suíte. Renderização, legibilidade do modal de aula (grade de alternativas, ferramentas, placas de nome nas carteiras), pose sentada, desempenho, exportação Windows e joystick **não foram validados visualmente** neste ambiente.

## Roteiro manual pendente

- [ ] Importar o checkout limpo na Godot 4.7.2 Standard e executar com F5.
- [ ] Conferir o menu em 1280×800 e 1920×1080; criar um personagem pelos quatro passos (voltar e avançar, trocar talento e traços).
- [ ] Caminhar e correr nas oito direções; confirmar giro, colisões e energia.
- [ ] Percorrer quarto → casa → bairro → corredor → sala usando somente WASD e E; ler o bilhete da avó e conferir o Cartão de Literatura.
- [ ] Na sala às 08:25: placas de nome, seis colegas sentados sem atravessar carteiras, Tsubasa entrando com o sinal.
- [ ] Homeroom: Primeira chamada com duas escolhas; conferir vínculos na aba Contatos.
- [ ] Em cada postura, uma aula inteira: legibilidade da grade de alternativas, ferramentas, rolagem do modal, botão “Ficar até o fim”.
- [ ] Provocar flagrante (descansar/conversar) e confirmar a pergunta dirigida; chegar atrasado e conferir a ocorrência.
- [ ] Energia abaixo de 30 numa aula teórica: Sono em aula.
- [ ] Terça: A pergunta do Sato; quarta/quinta: O bilhete de Tsubasa (50% ao dia, garantido no último dia da janela).
- [ ] Celular: Caderno (Domínio, Cartões, páginas), Turma (mensagens liberadas pela data), Diário (entradas e “hoje, até agora”).
- [ ] Dormir: diário com anotação, humor do dia seguinte, mesada na segunda 8 de abril.
- [ ] Carregar um save do 0.1 e confirmar a migração sem perda de dinheiro, vínculos e flags.
- [ ] Exportar e testar em Windows após instalar os templates oficiais correspondentes.

O próximo marco de produção depende dessa validação manual, não apenas dos testes automatizados.
