WITH DossieEventos AS (
    SELECT 
        b.F14474 AS dossie,
        MAX(b.F01187) AS produto,
        MAX(b.F35249) AS data_benner,
        MAX (
            CASE
                WHEN b.F25017 = 1 THEN 'Ativo'
                WHEN b.F25017 = 2 THEN 'Encerrado'
                WHEN b.F25017 = 3 THEN 'Acordo'
                WHEN b.F25017 = 4 THEN 'Em encerramento'
                ELSE 'Em precatório (Ativo)'
            END 
            ) AS situacao,
        MAX(d.F00162) AS fase,
        MAX(c.F00091) AS adverso_nome,
        MAX(c.F27086) AS cpf,
        STUFF((
            SELECT ', ' + c.F01132
            FROM [ramaprod].[dbo].T00069 AS a1
            LEFT JOIN [ramaprod].[dbo].T00064 AS c ON a1.F01133 = c.ID
            WHERE a1.F02003 = b.ID
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS eventos
    FROM [ramaprod].[dbo].T00041 AS b
    LEFT JOIN [ramaprod].[dbo].T00069 AS a ON a.F02003 = b.ID
    LEFT JOIN [ramaprod].[dbo].T00030 AS c ON b.F05220 = c.ID
    LEFT JOIN [ramaprod].[dbo].T00037 AS d ON b.F00177 = d.ID
    GROUP BY b.F14474, b.ID
),

-----------------------------------------------------------------------------------------------------------------------------------------

DossieComGarantia AS (
	SELECT DISTINCT 
		b.F14474 AS dossie_com_garantia
	FROM [ramaprod].[dbo].T00069 AS a
	LEFT JOIN [ramaprod].[dbo].T00041 AS b ON a.F02003 = b.ID
	LEFT JOIN [ramaprod].[dbo].T00064 AS c ON a.F01133 = c.ID
	WHERE (CASE WHEN c.F01132 = 'Operação com Garantia' THEN 'Sim' ELSE 'Não' END) = 'Sim'
),

-----------------------------------------------------------------------------------------------------------------------------------------

EventosHistorico AS (
    SELECT 
		p.F14474 AS dossie,
		e.F01132 AS evento,

        CASE
            WHEN p.F14474 IN (SELECT dossie_com_garantia FROM DossieComGarantia) 
                AND e.F01132 = 'Operação com Garantia'
                AND x.F00395 IS NULL
                THEN 'Aval'
            WHEN p.F14474 IN (SELECT dossie_com_garantia FROM DossieComGarantia) 
                AND e.F01132 = 'Operação com Garantia'
                AND (x.F00395 LIKE '%Creditórios%' OR x.F00395 LIKE '%creditórios%' OR x.F00395 LIKE '%Creditorios%' OR x.F00395 LIKE '%creditorios%') 
                THEN 'Direitos Creditórios'
            WHEN p.F14474 IN (SELECT dossie_com_garantia FROM DossieComGarantia) 
                AND e.F01132 = 'Operação com Garantia'
                AND (x.F00395 LIKE '%Veículo%' OR x.F00395 LIKE '%veiculo%' OR x.F00395 LIKE '%Caminhão%' OR x.F00395 LIKE '%caminhão%' OR x.F00395 LIKE '%camionete%' OR 
                    x.F00395 LIKE '%camioneta%' OR x.F00395 LIKE '%reboque%' OR x.F00395 LIKE '%carro%') 
                THEN 'Veículo'
            WHEN p.F14474 IN (SELECT dossie_com_garantia FROM DossieComGarantia) 
                AND e.F01132 = 'Operação com Garantia'
                AND (x.F00395 LIKE '%máquina%' OR x.F00395 LIKE '%Máquina%' OR x.F00395 LIKE '%maquinário%' OR x.F00395 LIKE '%Maquin%')
                THEN 'Maquinário'
            WHEN p.F14474 IN (SELECT dossie_com_garantia FROM DossieComGarantia) 
                AND e.F01132 = 'Operação com Garantia'
                AND (x.F00395 LIKE '%imóvel%' OR x.F00395 LIKE '%Imóvel%' OR x.F00395 LIKE '%casa%' OR x.F00395 LIKE '%apar%' OR x.F00395 LIKE 'Terren' OR x.F00395 LIKE 'terren')
                THEN 'Imóvel'
            ELSE 'Não'
        END AS garantia,

        CASE
            WHEN p.F14474 IN (SELECT dossie_com_garantia FROM DossieComGarantia) THEN x.F00395
            ELSE NULL
        END descricao_garantia,

        CASE 
            WHEN e.F01132 = 'Execução 2.10 Pesquisa patrimonial negativa' OR e.F01132 = 'Execução 13.1 - Pesquisa patrimonial negativa' OR e.F01132 = 'Execução 2.9 - Pesquisa Patrimonial Positiva'
                THEN x.F00395
            ELSE NULL
        END AS pesquisa_patrimonial



	FROM [ramaprod].[dbo].T00069 AS x 
	LEFT JOIN [ramaprod].[dbo].T00041 AS p ON x.F02003 = p.ID
	LEFT JOIN [ramaprod].[dbo].T00064 AS e ON x.F01133 = e.ID
)
SELECT
    de.dossie,
    de.produto,
    de.data_benner,
    de.situacao,
    de.fase,
    de.adverso_nome,
    de.cpf,
    CASE
        WHEN 
            (CHARINDEX('Execução 7.1.2 - Penhora de valores insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.1.1 - Penhora de valores suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.4.1 - Penhora de bens móveis suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.4.2 - Penhora de bens móveis insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.3.1 - Penhora de imóveis suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.3.2 - Penhora de imóveis insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.2.1 - Penhora de veículos suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.2.2 - Penhora de veículos insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', eventos) > 0)
            AND CHARINDEX('Execução 7.1.1 - Penhora de valores suficiente', eventos) > 0
            THEN 'Não'
        WHEN 
            (CHARINDEX('Execução 7.1.2 - Penhora de valores insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.1.1 - Penhora de valores suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.4.1 - Penhora de bens móveis suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.4.2 - Penhora de bens móveis insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.3.1 - Penhora de imóveis suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.3.2 - Penhora de imóveis insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.2.1 - Penhora de veículos suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.2.2 - Penhora de veículos insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', eventos) > 0)
            AND CHARINDEX('Execução 7.1.1 - Penhora de valores suficiente', eventos) = 0
            THEN 'Sim'
        ELSE 'Não'
    END AS penhora_de_bens,

    CASE
        WHEN 
            (CHARINDEX('Execução 7.1.2 - Penhora de valores insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.1.1 - Penhora de valores suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.4.1 - Penhora de bens móveis suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.4.2 - Penhora de bens móveis insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.3.1 - Penhora de imóveis suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.3.2 - Penhora de imóveis insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.2.1 - Penhora de veículos suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.2.2 - Penhora de veículos insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', eventos) > 0)
            AND CHARINDEX('Execução 7.1.1 - Penhora de valores suficiente', eventos) > 0
            THEN NULL
        WHEN 
            (CHARINDEX('Execução 7.1.2 - Penhora de valores insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.1.1 - Penhora de valores suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.4.1 - Penhora de bens móveis suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.4.2 - Penhora de bens móveis insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.3.1 - Penhora de imóveis suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.3.2 - Penhora de imóveis insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.2.1 - Penhora de veículos suficiente', eventos) > 0
            OR CHARINDEX('Execução 7.2.2 - Penhora de veículos insuficiente', eventos) > 0
            OR CHARINDEX('Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', eventos) > 0)
            AND CHARINDEX('Execução 7.1.1 - Penhora de valores suficiente', eventos) = 0
            THEN x.F00395
        ELSE NULL
    END AS descricao_bem_penhorado



FROM DossieEventos AS de
JOIN EventosHistorico AS eh ON de.dossie = eh.dossie
WHERE 
    de.situacao <> 'Encerrado' AND
    de.produto NOT IN (32, 34, 14, 36, 35)




-- TIPO GARANTIA 
-- DESCRIÇÃO GARANTIA
-- PESQUISA PATRIMONIAL
RESUMO JURÍDICO
-- PENHORAS DE BENS (SIM/NÃO)
-- DESCRIÇAÕ DO BEM PENHORADO 
BLOQUEIO DE VALORES (SIM/NÃO)
VALOR BLOQUEADO
-- FASE
EXPECTATIVA DE RECUPERAÇÃO
