WITH subquery AS (
	SELECT
		a.F04461 AS pasta,
		MAX(d.F14474) AS dossie,
		MAX(e.F01062) AS criado_em,
		MAX(e.F15680) AS data_citacao_capa,
		MAX(
		CASE
			WHEN f.F25017 = 1 THEN 'Ativo'
			WHEN f.F25017 = 2 THEN 'Encerrado'
			WHEN f.F25017 = 3 THEN 'Acordo'
			WHEN f.F25017 = 4 THEN 'Em encerramento'
			ELSE 'Em precatório (Ativo)'
		END)  AS situacao,
		MAX(s.F00227) AS desdobramento_nome,
		MAX(m.F01130) AS carteira,
		MAX(
			CASE 
			WHEN m.F01130 IN ('E1', 'Massificado PJ', 'PF', 'Massificado PJ - E2', 'E2', 'Autos Santander', 'Alto Ticket', 'Massificado PJ','Diligência Varejo Massificado') THEN 'Varejo'
			WHEN m.F01130 = 'Créditos Especiais - Special Credits' AND x.F47448 IN ('E2 POLO', 'BAIXO TICKET') THEN 'Varejo'
			WHEN m.F01130 IN ('Empresas 3 - Judicial Especializado', 'Empresas 3 - Núcleo Massificado', 'Créditos Especiais - Special Credit') AND x.F47448 = 'E3' THEN 'E3'
			WHEN m.F01130 IN ('Falência', 'Falência - Créditos Especiai', 'Falência - Empresas 1 e 2', 'Falência - Empresas 3', 'Recuperação Judicial', 'Recuperação Judicial - Créditos Especiais',
	            'Recuperação Judicial - Empresas 1 e 2', 'Recuperação Judicial - Empresas 3', 'Recuperação Judicial - Empresas 1 e 2 Baixo Ticket', 'Recuperação Judicial - Produtor Rural') THEN 'Falência e RJ'
			WHEN m.F01130 = 'Credito Rural' THEN 'Agro'
			ELSE 'Outro'
	    END )AS setor,
		MAX(h.F00162) AS fase,
		MAX(g.F43686) AS subfase,
		MAX(f.F00179) AS valor_causa,
		MAX(i.F00091) AS advogado_interno,
		MAX(k.F02568) AS comarca,
		MAX(n.F00091) AS adverso,
		MAX(
			CASE
				WHEN n.F00148 = 1 THEN 'PF'
				WHEN n.F00148 = 2 THEN 'PJ'
				WHEN n.F00148 = 3 THEN 'Espólio'
			END) AS tipo_pessoa,
		MAX(n.F27086) AS cpf_cnpj,
		MAX(
			CASE
				WHEN j.F01132 IN ('Cobrança 2.1 -  Citação devedor principal', 'Cobrança 2.11 -  Citação por carta precatória positiva', 'Cobrança 2.12 - Citação por acordo', 'Monitória 2.1 - Citação devedor principal',
					'Monitória 2.11- Citação por carta precatória positiva', 'Monitória 2.12 - Citação por acordo', 'Execução 3.1 - Citação devedor principal', 'Execução 3.11 - Citação por Carta Precatória positiva',
					'Execução 3.14 – Citação por acordo', 'BA 3.6 - Citação efetivada (com retomada)', 'BA 3.8 - Citação por carta precatória positiva','Cobrança 2.2 -  Citação coobrigado',
					'Monitória 2.2 - Citação coobrigado', 'Execução 3.2 - Citação coobrigado', 'Citação Positiva') THEN j.F01132
				ELSE NULL
			END) AS evento_citacao,
		MAX(
			CASE
				WHEN j.F01132 IN ('Cobrança 2.1 -  Citação devedor principal', 'Cobrança 2.11 -  Citação por carta precatória positiva', 'Cobrança 2.12 - Citação por acordo', 'Monitória 2.1 - Citação devedor principal',
					'Monitória 2.11- Citação por carta precatória positiva', 'Monitória 2.12 - Citação por acordo', 'Execução 3.1 - Citação devedor principal', 'Execução 3.11 - Citação por Carta Precatória positiva',
					'Execução 3.14 – Citação por acordo', 'BA 3.6 - Citação efetivada (com retomada)', 'BA 3.8 - Citação por carta precatória positiva', 'Cobrança 2.2 -  Citação coobrigado',
					'Monitória 2.2 - Citação coobrigado', 'Execução 3.2 - Citação coobrigado', 'Citação Positiva') THEN a.F00385
				ELSE NULL
			END) AS data_citacao,
		MAX(
			CASE
				WHEN j.F01132 IN ('BA 6.1 - Conversão para execução deferida', 'BA 3.1 - Retomada efetivada', 
					'Execução 8.3.4 - Remoção de berm penhorado', 'BA 4.14 - Retomada efetivada', 'BA 8.6 - Entrega amigável realizada', 
					'Venda de Bem em Leilão') THEN j.F01132
				ELSE NULL
			END) AS evento_retomada,
		MAX(
			CASE
				WHEN j.F01132 IN ('BA 6.1 - Conversão para execução deferida', 'BA 3.1 - Retomada efetivada', 
					'Execução 8.3.4 - Remoção de berm penhorado', 'BA 4.14 - Retomada efetivada', 'BA 8.6 - Entrega amigável realizada', 
					'Venda de Bem em Leilão') THEN a.F00385
				ELSE NULL
			END) AS data_retomada,
		MAX(
			CASE
				WHEN j.F01132 IN ('Execução 7.3.2 - Penhora de imóveis insuficiente', 'Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', 
					'Execução 7.1.2 - Penhora de valores insuficiente', 'Execução 6.2.1 - Deferido bloqueio Renajud', 'Execução 7.14.2 - Penhora de direitos creditórios insuficiente', 
					'Execução 7.8.2 - Penhora de ações e quotas insuficiente', 'Execução 7.11.2 - Penhora de direitos aquisitivos insuficiente') THEN j.F01132
				ELSE NULL
			END) AS evento_penhora,
		MAX(
			CASE
				WHEN j.F01132 IN ('Execução 7.3.2 - Penhora de imóveis insuficiente', 'Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', 
					'Execução 7.1.2 - Penhora de valores insuficiente', 'Execução 6.2.1 - Deferido bloqueio Renajud', 'Execução 7.14.2 - Penhora de direitos creditórios insuficiente', 
					'Execução 7.8.2 - Penhora de ações e quotas insuficiente', 'Execução 7.11.2 - Penhora de direitos aquisitivos insuficiente') THEN a.F00385
				ELSE NULL
			END) AS data_penhora,
		MAX(
		CASE
			WHEN j.F01132 IN ('Execução 12.2 - Amortização de valores', 'BA 4.19 - Venda do bem') THEN j.F01132
			ELSE NULL
		END) AS evento_financeiro,
		MAX(
			CASE
				WHEN j.F01132 IN ('Execução 12.2 - Amortização de valores') AND YEAR(GETDATE()) = 2024 THEN CONVERT(VARCHAR, a.F00395)
				ELSE NULL 
			END) AS valor_financeiro,  
		MAX(
		CASE
			WHEN j.F01132 IN ('Execução 12.2 - Amortização de valores', 'BA 4.19 - Venda do bem') THEN a.F00385
			ELSE NULL
		END) AS data_financeiro,
		MAX(aa.F00156) AS tipo_acao	
	FROM [ramaprod].[dbo].T00069 AS a
	LEFT JOIN [ramaprod].[dbo].T00003 AS b ON a.F08501 = b.ID
	LEFT JOIN [ramaprod].[dbo].T00064 AS c ON a.F01133 = c.ID
	LEFT JOIN [ramaprod].[dbo].T00041 AS d ON a.F02003 = d.ID
	LEFT JOIN [ramaprod].[dbo].T00041 AS e ON a.F02003 = e.ID
	LEFT JOIN [ramaprod].[dbo].T00041 AS f ON a.F02003 = f.ID
	LEFT JOIN [ramaprod].[dbo].T02682 AS g ON f.F43687 = g.ID
	LEFT JOIN [ramaprod].[dbo].T00037 AS h ON f.F00177 = h.ID
	LEFT JOIN [ramaprod].[dbo].T00030 AS i ON f.F11578 = i.ID
	LEFT JOIN [ramaprod].[dbo].T00064 AS j ON a.F01133 = j.ID
	LEFT JOIN [ramaprod].[dbo].T00041 AS k ON a.F02003 = k.ID
	LEFT JOIN [ramaprod].[dbo].T00041 AS l ON a.F02003 = l.ID
	LEFT JOIN [ramaprod].[dbo].T00035 AS m ON f.F01187 = m.ID
	LEFT JOIN [ramaprod].[dbo].T00030 AS n ON f.F05220 = n.ID
	LEFT JOIN [ramaprod].[dbo].T00045 AS o ON f.F00217 = o.ID
	LEFT JOIN [ramaprod].[dbo].T01777 AS p ON f.F34969 = p.ID
	LEFT JOIN [ramaprod].[dbo].T00035 AS q ON p.F24930 = q.ID
	LEFT JOIN [ramaprod].[dbo].T00083 AS r ON f.F14465 = r.ID
	LEFT JOIN [ramaprod].[dbo].T00046 AS s ON r.F00488 = s.ID
	LEFT JOIN [ramaprod].[dbo].T02913 AS t ON d.F47450 = t.ID
	LEFT JOIN [ramaprod].[dbo].T00030 AS v ON f.F05220 = v.ID
	LEFT JOIN [ramaprod].[dbo].T02913 AS x ON v.F47449 = x.ID
	LEFT JOIN [ramaprod].[dbo].T02676 AS z ON d.F43645 = z.ID
	LEFT JOIN [ramaprod].[dbo].T02678 AS w ON d.F43647 = w.ID
	LEFT JOIN [ramaprod].[dbo].T02677 AS y ON d.F43646 = y.ID
	LEFT JOIN [ramaprod].[dbo].T00034 AS aa ON d.F01122 = aa.ID
	GROUP BY a.F04461
)
SELECT
	dossie,
	criado_em,
	data_citacao_capa,
	situacao,
	tipo_acao,
	carteira,
	setor,
	fase,
	subfase,
	adverso,
	cpf_cnpj,
	tipo_pessoa,
	evento_citacao,
	data_citacao,
	evento_penhora,
	data_penhora,
	evento_retomada,
	data_retomada,
	evento_financeiro,
	data_financeiro
FROM subquery
WHERE 
	evento_citacao IS NULL
	AND data_citacao_capa IS NULL
	AND fase = 'Acordo'
	AND setor = 'Varejo'
	AND tipo_acao NOT IN ('Ação de Consignação em Pagamento (SFH)', 'Ação de Rescisão Contratual', 'Diligência Processual', 'Execução Hipotecária', 'Habilitação de Crédito', 'Homologação de Acordo Extrajudicial',
		'Notificação Extraj. Alienação Fiduciária', 'Pré-ajuizamento')
ORDER BY criado_em DESC;