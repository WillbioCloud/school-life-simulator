# Validação — First Day 0.1

## Resultado local (14/10/2026)

**Godot 4.7.2.stable.custom_build — 62 verificações aprovadas, 0 falhas.** A execução final não emitiu erros de script ou runtime.

O ambiente não tinha Godot instalada. O download do binário foi bloqueado pela rede; por isso foi compilado o código-fonte oficial da tag `4.7.2-stable`, em modo `template_debug`, com servidor headless e sem backends gráficos. O módulo de lightmapping foi desativado para essa compilação de validação. A engine e os arquivos temporários **não fazem parte do repositório**.

Como templates não aceitam por padrão sobrescrever o caminho do projeto, a validação usou uma cópia temporária de `project.godot`, com `tests/test_runner.tscn` como cena principal, e diretório de saves isolado. Scripts, cenas e dados eram os mesmos deste checkout. O registro de classes foi preparado localmente, sem alterações versionadas em `.godot/`.

O comando de execução nessa cópia foi:

```bash
SCHOOL_LIFE_TEST=1 XDG_DATA_HOME=<diretorio-isolado> \
  ./godot --headless --fixed-fps 60 --quit-after 1800
```

Para uma instalação normal da Godot, use `tests/run.sh`, que faz a importação pelo editor antes dos testes. O workflow GitHub Actions segue esse caminho; seu resultado deve ser consultado no PR, não inferido a partir do teste local.

## Cobertura automatizada

- Início oficial às 06:30 de segunda-feira, 1º de abril.
- Dias úteis/finais de semana, virada de mês, virada de ano escolar.
- Contagem de 168 dias/ano e 504 dias em três anos.
- Consumo contextual de tempo, atributos, registro escolar e proteção contra repetição.
- Save/load, inventário, dinheiro, vínculo e marcos narrativos.
- Rejeição de datas, cenas e posições inválidas.
- Save corrompido sem modificar a partida atual; migração e recuperação de backup.
- Instanciação do menu, cinco ambientes, protagonista, NPCs e painéis.
- Menus pausam e retomam o relógio.
- Presença dos NPCs em aula e depois da escola.
- Limite diário de recompensa em conversas.
- Ciclo escola → atividade → casa → sono → próximo dia → autosave.
- Energia após sono tardio e tratamento de meia-noite.
- Alternância das projeções da câmera.
- Colisão real do personagem com o chão.

## Limitações da validação

Os testes de integração acionam comandos e transições diretamente; não simulam todas as teclas nem caminham cada percurso completo. Renderização, transparência, disposição final dos painéis, sombras, legibilidade, qualidade artística, desempenho em hardware real, exportação Windows e joystick **não foram validados visualmente** neste ambiente. Não há um executável Windows já exportado nem uma versão web nesta entrega.

## Roteiro manual pendente

- [ ] Importar o checkout limpo na Godot 4.7.2 Standard e executar com F5.
- [ ] Conferir o menu em 1280×800 e 1920×1080; criar um personagem.
- [ ] Caminhar e correr nas oito direções; confirmar giro, colisões e energia.
- [ ] Percorrer quarto → casa → bairro → corredor → sala usando somente WASD e E.
- [ ] Comparar ortográfica/perspectiva, zoom e obstáculos entre câmera e personagem.
- [ ] Conferir todos os rótulos de interação e impedir acesso através de paredes.
- [ ] Conversar com os três NPCs e observar mudanças de rotina sem intervenção do jogador.
- [ ] Esperar na carteira, participar e confirmar mudanças de agenda/atributos.
- [ ] Comprar e consumir um onigiri, estudar e descansar.
- [ ] Conferir mapa, celular, calendário, inventário e fechamento com Esc.
- [ ] Voltar à casa, dormir, encerrar o aplicativo e continuar o save.
- [ ] Confirmar iluminação de manhã, tarde e noite e transparência das construções.
- [ ] Exportar e testar em Windows após instalar os templates oficiais correspondentes.

O próximo marco de produção depende dessa validação manual, não apenas dos testes automatizados.
