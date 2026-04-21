# 📊 Customer Segmentation with RFM Analysis (SQL & BigQuery)

## 📋 Sobre o Projeto
Este projeto consiste no desenvolvimento de uma análise de **RFM (Recency, Frequency, Monetary)** para segmentar uma base de clientes de um e-commerce. A análise permite identificar padrões de comportamento e classificar os clientes em grupos estratégicos, facilitando ações de marketing personalizadas e estratégias de retenção.

## 🛠️ Tecnologias Utilizadas
* **Google BigQuery:** Processamento de grandes volumes de dados (ETL e Análise).
* **SQL:** Utilização de CTEs, Window Functions (`ROW_NUMBER`, `NTILE`) e Views para estruturação dos dados.
* **Python (Pandas):** Automação do upload dos dados via Google Colab.

## 🧠 Metodologia de Dados
A base foi processada através de 5 etapas principais:
1. **Unificação (Union ALL):** Consolidação de 12 meses de vendas em uma única tabela produtiva.
2. **Cálculo de Métricas:** Definição de Recência, Frequência e Valor Monetário por cliente.
3. **Distribuição por Decis:** Aplicação da técnica de **Deciles (Notas de 1 a 10)** para garantir uma segmentação de alta precisão.
4. **Scoring:** Criação de um Score Total para ranqueamento de performance.
5. **Segmentação (BI Ready):** Classificação final em clusters como *Campeões*, *Leais*, *Em Risco* e *Hibernando*.

## 📈 Resultados
O output final é uma tabela **BI-ready**, pronta para ser consumida em ferramentas de visualização como **Power BI** ou **Tableau**, permitindo o monitoramento em tempo real do faturamento por segmento.
<img width="1149" height="650" alt="Captura de tela 2026-04-21 000630" src="https://github.com/user-attachments/assets/9445511c-f6d5-4081-b761-fba214a82764" />

---
*Projeto desenvolvido como parte do meu portfólio em Sistemas de Informação.*
