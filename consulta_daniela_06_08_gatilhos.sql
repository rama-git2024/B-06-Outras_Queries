
WITH sub AS (
SELECT
    d.F14474 AS dossie,
    MAX(e.F01062) AS criado_em,
    MAX(
        CASE
            WHEN f.F25017 = 1 THEN 'EM ANDAMENTO'
            WHEN f.F25017 = 2 THEN 'EXTINTO'
            WHEN f.F25017 = 3 THEN 'SUSPENSO'
            WHEN f.F25017 = 4 THEN 'SUSPENSO'
            ELSE NULL
        END
    ) AS situacao,
    MAX(
        CASE
            WHEN aa.F00156 = 'Execução de Título Extrajudicial' THEN 'EXECUÇÃO'
            WHEN aa.F00156 = 'Ação Monitória' THEN 'MONITÓRIA'
            WHEN aa.F00156 IN ('Ação de Busca e Apreensão', 'Ação de Busca e Apreensão - Cumprimento de Sentença') THEN 'BUSCA E APREENSÃO'
            ELSE 'OUTROS'
        END
    ) AS tipo_acao,
    MAX(h.F00162) AS fase,
    MAX(
        CASE
            WHEN j.F01132 IN (
                'Execução 3.1 - Citação devedor principal',
                'Execução 3.2 - Citação coobrigado',
                'Monitória 2.1 - Citação devedor principal',
                'Monitória 2.2 - Citação coobrigado',
                'Cobrança 2.1 - Citação devedor principal',
                'Cobrança 2.2 - Citação coobrigado',
                'Monitória 2.3 - 1ª Citação negativa',
                'Monitória 2.4 - 2ª Citação negativa',
                'Monitória 2.5 - 3ª Citação negativa',
                'Monitória 2.6 - Certidão negativa',
                'Cobrança 2.3 - 1ª Citação negativa',
                'Cobrança 2.4 - 2ª Citação negativa',
                'Cobrança 2.5 - 3ª Citação negativa',
                'Cobrança 2.6 - Certidão negativa',
                'Execução 3.3 - 1ª Citação negativa',
                'Execução 3.4 - 2ª Citação negativa',
                'Execução 3.5 - 3ª Citação negativa',
                'Execução 3.6 - Certidão negativa',
                'Execução 8.3.4 - Remoção de bem penhorado',
                'BA 3.1 - Retomada efetivada',
                'BA 3.2 - Retomada parcial',
                'BA 4.14 - Retomada efetivada',
                'BA 4.15 - Retomada parcial',
                'BA 3.4 - Mandado negativo',
                'BA 4.17 - Mandado negativo',
                'Execução 6.1.1 - Deferido bloqueio Bacenjud',
                'Execução 6.18.1 - Resultado pesquisa Infojud',
                'Execução 6.2.1 - Deferido bloqueio Renajud',
                'Execução 4.1.1 - Defesa sem efeito suspensivo',
                'Execução 4.1.6 - Exceção de pré-executividade',
                'Execução 4.1.7 - Embargos à execução',
                'Monitória 3.1 - Embargos monitórios',
                'Cobrança 3.1 - Contestação',
                'Monitória 4.1 - Procedente',
                'Cobrança 4.1 - Procedente',
                'BA 5.1 - Sentença procedente',
                'Homologação 4.1 - Procedente',
                'Monitória 4.2 - Improcedente',
                'Cobrança 4.2 - Improcedente',
                'Homologação 4.2 - Improcedente',
                'BA 5.3 - Sentença improcedente',
                'Execução 11.3 - Alvará expedido',
                'Aguardando cumprimento de mandado',
                'Aguardando cumprimento de mandado de citação'
            ) THEN j.F01132
            ELSE NULL
        END
    ) AS ultimo_evento,
    MAX(CASE WHEN j.F01132 IN (
    'Execução 3.1 - Citação devedor principal',
    'Execução 3.2 - Citação coobrigado',
    'Monitória 2.1 - Citação devedor principal',
    'Monitória 2.2 - Citação coobrigado',
    'Cobrança 2.1 - Citação devedor principal',
    'Cobrança 2.2 - Citação coobrigado',
    'Monitória 2.3 - 1ª Citação negativa',
    'Monitória 2.4 - 2ª Citação negativa',
    'Monitória 2.5 - 3ª Citação negativa',
    'Monitória 2.6 - Certidão negativa',
    'Cobrança 2.3 - 1ª Citação negativa',
    'Cobrança 2.4 - 2ª Citação negativa',
    'Cobrança 2.5 - 3ª Citação negativa',
    'Cobrança 2.6 - Certidão negativa',
    'Execução 3.3 - 1ª Citação negativa',
    'Execução 3.4 - 2ª Citação negativa',
    'Execução 3.5 - 3ª Citação negativa',
    'Execução 3.6 - Certidão negativa',
    'Execução 8.3.4 - Remoção de bem penhorado',
    'BA 3.1 - Retomada efetivada',
    'BA 3.2 - Retomada parcial',
    'BA 4.14 - Retomada efetivada',
    'BA 4.15 - Retomada parcial',
    'BA 3.4 - Mandado negativo',
    'BA 4.17 - Mandado negativo',
    'Execução 6.1.1 - Deferido bloqueio Bacenjud',
    'Execução 6.18.1 - Resultado pesquisa Infojud',
    'Execução 6.2.1 - Deferido bloqueio Renajud',
    'Execução 4.1.1 - Defesa sem efeito suspensivo',
    'Execução 4.1.6 - Exceção de pré-executividade',
    'Execução 4.1.7 - Embargos à execução',
    'Monitória 3.1 - Embargos monitórios',
    'Cobrança 3.1 - Contestação',
    'Monitória 4.1 - Procedente',
    'Cobrança 4.1 - Procedente',
    'BA 5.1 - Sentença procedente',
    'Homologação 4.1 - Procedente',
    'Monitória 4.2 - Improcedente',
    'Cobrança 4.2 - Improcedente',
    'Homologação 4.2 - Improcedente',
    'BA 5.3 - Sentença improcedente',
    'Execução 11.3 - Alvará expedido',
    'Aguardando cumprimento de mandado',
    'Aguardando cumprimento de mandado de citação'
) THEN a.F00385 ELSE NULL END) AS data_ultimo_evento
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
WHERE
    j.F01132 IN (
        'Execução 3.1 - Citação devedor principal',
        'Execução 3.2 - Citação coobrigado',
        'Monitória 2.1 - Citação devedor principal',
        'Monitória 2.2 - Citação coobrigado',
        'Cobrança 2.1 - Citação devedor principal',
        'Cobrança 2.2 - Citação coobrigado',
        'Monitória 2.3 - 1ª Citação negativa',
        'Monitória 2.4 - 2ª Citação negativa',
        'Monitória 2.5 - 3ª Citação negativa',
        'Monitória 2.6 - Certidão negativa',
        'Cobrança 2.3 - 1ª Citação negativa',
        'Cobrança 2.4 - 2ª Citação negativa',
        'Cobrança 2.5 - 3ª Citação negativa',
        'Cobrança 2.6 - Certidão negativa',
        'Execução 3.3 - 1ª Citação negativa',
        'Execução 3.4 - 2ª Citação negativa',
        'Execução 3.5 - 3ª Citação negativa',
        'Execução 3.6 - Certidão negativa',
        'Execução 8.3.4 - Remoção de bem penhorado',
        'BA 3.1 - Retomada efetivada',
        'BA 3.2 - Retomada parcial',
        'BA 4.14 - Retomada efetivada',
        'BA 4.15 - Retomada parcial',
        'BA 3.4 - Mandado negativo',
        'BA 4.17 - Mandado negativo',
        'Execução 6.1.1 - Deferido bloqueio Bacenjud',
        'Execução 6.18.1 - Resultado pesquisa Infojud',
        'Execução 6.2.1 - Deferido bloqueio Renajud',
        'Execução 4.1.1 - Defesa sem efeito suspensivo',
        'Execução 4.1.6 - Exceção de pré-executividade',
        'Execução 4.1.7 - Embargos à execução',
        'Monitória 3.1 - Embargos monitórios',
        'Cobrança 3.1 - Contestação',
        'Monitória 4.1 - Procedente',
        'Cobrança 4.1 - Procedente',
        'BA 5.1 - Sentença procedente',
        'Homologação 4.1 - Procedente',
        'Monitória 4.2 - Improcedente',
        'Cobrança 4.2 - Improcedente',
        'Homologação 4.2 - Improcedente',
        'BA 5.3 - Sentença improcedente',
        'Execução 11.3 - Alvará expedido',
        'Aguardando cumprimento de mandado',
        'Aguardando cumprimento de mandado de citação'
    )
GROUP BY d.F14474
)
SELECT
    dossie,
    fase,
    situacao,
    tipo_acao,
    (CASE
        WHEN ultimo_evento IN ('BA 2.1 - Deferida liminar de BA/RP') THEN 'LIMINAR DEFERIDA'
        WHEN ultimo_evento IN ('Aguardando cumprimento de mandado', 'Aguardando cumprimento de mandado de citação') THEN 'MANDADO EXPEDIDO'
        WHEN ultimo_evento IN ('Execução 3.1 -  Citação devedor principal', 'Execução 3.2 -  Citação coobrigado', 'Monitória 2.1 -  Citação devedor principal', 'Monitória 2.2 -  Citação coobrigado', 'Cobrança 2.1 -  Citação devedor principal', 'Cobrança 2.2 -  Citação coobrigado') THEN 'CITAÇÃO POSITIVA'
        WHEN ultimo_evento IN ('Monitória 2.1 - Citação devedor principal','Monitória 2.2 - Citação coobrigado','Cobrança 2.1 - Citação devedor principal','Cobrança 2.2 - Citação coobrigado','Monitória 2.3 - 1ª Citação negativa',
        'Monitória 2.4 - 2ª Citação negativa','Monitória 2.5 - 3ª Citação negativa','Monitória 2.6 - Certidão negativa','Cobrança 2.3 - 1ª Citação negativa','Cobrança 2.4 - 2ª Citação negativa',
        'Cobrança 2.5 - 3ª Citação negativa','Cobrança 2.6 - Certidão negativa','Execução 3.3 - 1ª Citação negativa','Execução 3.4 - 2ª Citação negativa','Execução 3.5 - 3ª Citação negativa',
        'Execução 3.6 - Certidão negativa') THEN 'CITAÇÃO NEGATIVA'
        WHEN ultimo_evento IN ('Execução 8.3.4 - Remoção de bem penhorado','BA 3.1 - Retomada efetivada','BA 3.2 - Retomada parcial','BA 4.14 - Retomada efetivada','BA 4.15 - Retomada parcial') THEN 'MANDADO POSITIVO / RETOMADA EFETIVADA'
        WHEN ultimo_evento IN ('BA 3.4 - Mandado negativo','BA 4.17 - Mandado negativo') THEN 'MANDADO NEGATIVO'
        WHEN ultimo_evento IN ('Execução 6.1.1 - Deferido bloqueio Bacenjud','Execução 6.18.1 - Resultado pesquisa Infojud','Execução 6.2.1 - Deferido bloqueio Renajud') THEN 'CONSTRIÇÃO DEFERIDA (RENAJUD/ INFOJUD/ BACEN)'
        WHEN ultimo_evento IN ( 'Execução 4.1.1 - Defesa sem efeito suspensivo','Execução 4.1.6 - Exceção de pré-executividade','Execução 4.1.7 - Embargos à execução','Monitória 3.1 - Embargos monitórios',
        'Cobrança 3.1 - Contestação') THEN 'DEFESA ADVERSO'
        WHEN ultimo_evento IN ('Monitória 4.1 - Procedente','Cobrança 4.1 - Procedente','BA 5.1 - Sentença procedente','Homologação 4.1 - Procedente') THEN 'SENTENÇA PROCEDENTE'
        WHEN ultimo_evento IN ('Monitória 4.2 - Improcedente','Cobrança 4.2 - Improcedente','Homologação 4.2 - Improcedente','BA 5.3 - Sentença improcedente') THEN 'SENTENÇA IMPROCEDENTE'
        WHEN ultimo_evento = 'Execução 11.3 - Alvará expedido' THEN 'ALVARÁ EXPEDIDO'
        WHEN fase = 'Inicial' THEN 'DISTRIBUIDO'
        WHEN fase = 'Acordo' THEN 'EM ACORDO'
        WHEN fase = 'Suspenso' THEN 'PROCESSO SUSPENSO'
        ELSE NULL
    END) AS status,
    data_ultimo_evento
FROM sub;




