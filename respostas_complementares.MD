### Questões complementares:
  1. Tem conhecimento em processos e ferramentas de ETL? Quantos anos de experiência? Quais cases foram aplicados?
  2. Tem experiência com ferramental Azure Data Factory?
Resposta: Vou responder as perguntas 1 e 2 ao mesmo tempo porque uma das ferramentas que já utilizei para fazer ETL foi justamente o Data Factory. Quando trabalhei na ClearSale como Especialista de People Analytics, tive que criar todos os processos de ETL para criar um lake dos dados de People e disponibilizar os relatórios de indicadores de diversidade, treinamento, absenteísmo, folha de pagamento e outros, via Power BI. Como a arquitetura era toda em Azure, acabei utilizando lá pela primeira vez o Data Factory para consumir os dados de diferentes fontes - a maioria em APIs - como do ApData e da Gupy (dados de recrutamento). O processo todo foi bastante semelhante ao que vou descrever abaixo no case da questão 3, com a única diferença de que os dados eram consumidos de API e eu utilizei o Synapse ao invés do SQL Server. Já na Claro, eu utilizava o Knime, que era o software disponibilizado por eles nas nossas máquinas virtuais. Também tenho conhecimento em DBT, apesar de nunca ter utilizado em trabalhos. Acabei estudando DBT quando fui gestor de uma Consultoria de Dados que utilizava a ferramenta como padrão e, para poder me comunicar melhor com os experts dos projetos, precisei aprender algumas ferramentas e dentre elas o DBT.

  3. Pode responder em um fluxograma (ou escrito em tópicos) um case de ETL onde:
      - Parte dos dados da origem estão em banco de dados Oracle e outra em CSV no Storage Bucket da AWS
      - O dado final deverá estar na base de dados SQL Server.
      - Deverá acontecer validação da entrada dos dados da origem.
      - Validação dos dados finais que foram processados.
      - Cálculos dos dados de origem, para geração de indicadores (que serão os dados finais).

Resposta:
- Usar Linked Service do Data Factory para conectar aos bancos Oracle e AWS
- Extrair os dados utilizando a atividade Copy Data e armazenar em um Data Lake no Azure
- Usar atividade Data Flow no ADF para verificar integridade e formatos de dados
- Usar atividade Data Flow no ADF para tratar dados ausentes, aplicar transformações necessárias e calcular indicadores
- Estruturar dados transformados para carga no SQL Server (ou Synapse)
- Usar Linked Service no ADF para conectar ao SQL Server (ou Synapse)
- Usar atividade Copy Data para carregar os dados transformados e indicadores no SQL Server
- Consumir os dados do SQL Server (ou Synapse) para o Power BI e gerar os relatórios de acompanhamento dos indicadores
