SELECT
	a.F31768 AS operacao,
	CASE
		WHEN a.F16778 = 1 THEN 'Liquidado'
		WHEN a.F16778 = 2 THEN 'Em aberto'
		WHEN a.F16778 = 3 THEN 'Com pendência'
		WHEN a.F16778 = 4 THEN 'Em negociação'
		WHEN a.F16778 = 5 THEN 'Negociado'
		WHEN a.F16778 = 6 THEN 'Liquidado via negociação'
		WHEN a.F16778 = 7 THEN 'Devolvido para o cliente'
		ELSE 'Sem status'
	END AS situacao,
	c.F13661 processo,
	a.F35050 AS pasta,
	b.F14474 AS dossie
FROM ramaprod.dbo.T01167 AS a,
LEFT JOIN ramaprod.dbo.T00041 AS b ON a.F35050 = b.ID
LEFT JOIN ramaprod.dbo.T01166 AS c ON a.F13700 = c.ID
WHERE a.F13700 IS NOT NULL AND a.F13700 = 35525



WITH subquery AS (
	SELECT
		F31768 AS operacao,
		CASE
			WHEN F16778 = 1 THEN 'Liquidado'
			WHEN F16778 = 2 THEN 'Em aberto'
			WHEN F16778 = 3 THEN 'Com pendência'
			WHEN F16778 = 4 THEN 'Em negociação'
			WHEN F16778 = 5 THEN 'Negociado'
			WHEN F16778 = 6 THEN 'Liquidado via negociação'
			WHEN F16778 = 7 THEN 'Devolvido para o cliente'
			ELSE 'Sem status'
		END AS situacao
	FROM ramaprod.dbo.T01167
)
SELECT
	situacao,
	COUNT(operacao) AS qtde_operacao
FROM subquery
GROUP BY situacao
ORDER BY qtde_operacao DESC;