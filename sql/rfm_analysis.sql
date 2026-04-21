-- Comando para excluir as colunas extras da tabela de Dezembro
ALTER TABLE `rfmanalysis-493717.sales.sales202512`
DROP COLUMN IF EXISTS `Unnamed: 5`,
DROP COLUMN IF EXISTS `Unnamed: 6`,
DROP COLUMN IF EXISTS `Unnamed: 7`;


-- Passo 1: Juntar todos as tabelas de vendas por mês, em uma tabela única.

CREATE OR REPLACE TABLE `rfmanalysis-493717.sales.sales_2025` AS   
SELECT * FROM `rfmanalysis-493717.sales.sales202501`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202502`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202503`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202504`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202505`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202506`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202507`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202508`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202509`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202510`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202511`
UNION ALL SELECT * FROM `rfmanalysis-493717.sales.sales202512`;

-- Passo 2: Calcular recency, frequency, monetary, r, f, m ranks
-- Combinar views com CTEs


CREATE OR REPLACE VIEW `rfmanalysis-493717.sales.rfm_metrics`
AS
WITH current_date AS (
  SELECT DATE ('2026-04-19') AS analysis_date -- Dia de hoje
),
rfm AS (
  SELECT

    CustomerID,
    MAX(OrderDate) AS last_order_date,
    DATE_DIFF((SELECT analysis_date FROM current_date), MAX(OrderDate), DAY) AS recency,
    COUNT(*) AS frequency,
    SUM(OrderValue) AS monetary

  FROM `rfmanalysis-493717.sales.sales_2025`
  GROUP BY CustomerID
)

SELECT 
 rfm.*,

  ROW_NUMBER() OVER(ORDER BY recency ASC) AS r_rank,
  ROW_NUMBER() OVER(ORDER BY frequency DESC) AS f_rank,
  ROW_NUMBER() OVER(ORDER BY monetary DESC) AS m_rank

FROM rfm;


-- Classificação por decis (escala de 1 a 10)

CREATE OR REPLACE VIEW `rfmanalysis-493717.sales.rfm_scores`
AS
SELECT *,

 NTILE(10) OVER(ORDER BY r_rank DESC) AS r_score,
 NTILE(10) OVER(ORDER BY f_rank DESC) AS f_score,
 NTILE(10) OVER(ORDER BY m_rank DESC) AS m_score

FROM `rfmanalysis-493717.sales.rfm_metrics`;

-- Passo 4: Calcular o score total 

CREATE OR REPLACE VIEW `rfmanalysis-493717.sales.rfm_total_score`
AS 
SELECT

  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  (r_score + f_score + m_score) AS rfm_total_score

FROM `rfmanalysis-493717.sales.rfm_scores`
ORDER BY rfm_total_score DESC;

-- Passo 5: Tabela de segmentos finalizada para consumo no BI


CREATE OR REPLACE TABLE `rfmanalysis-493717.sales.rfm_segments_final`
AS 
SELECT

  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  rfm_total_score,
  
  CASE 
    WHEN rfm_total_score >= 28 THEN 'Campeões'
    WHEN rfm_total_score >= 24 THEN 'Leais/VIPs'
    WHEN rfm_total_score >= 20 THEN 'Pontêncialmente Leais'
    WHEN rfm_total_score >= 16 THEN 'Promissores'
    WHEN rfm_total_score >= 12 THEN 'Engajados' 
    WHEN rfm_total_score >= 8 THEN 'Requer Atenção'
    WHEN rfm_total_score >= 4 THEN 'Em Risco'
    ELSE 'Perdido/Inativo'
  END AS rfm_segment

FROM `rfmanalysis-493717.sales.rfm_total_score`
ORDER BY rfm_total_score DESC;




