WITH NomeProcessado AS (
    SELECT 
        F00091 AS original_nome,
        UPPER(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(
                                                REPLACE(
                                                    F00091, '-', ''), '@', ''), '#', ''), '$', ''), '%', ''), '^', ''), '&', ''), '*', ''), '(', ''), ')', '')
        ) AS nome
    FROM ramaprod.dbo.T00030
    WHERE PATINDEX('%[^A-Za-z0-9 ]%', F00091) <> 0
)
SELECT 
    REPLACE(nome, ' ', '') AS nome_pessoa, 
    COUNT(original_nome) AS qtde_nome_pessoa
FROM NomeProcessado
GROUP BY REPLACE(nome, ' ', '')
HAVING COUNT(original_nome) > 1
ORDER BY qtde_nome_pessoa DESC;

SELECT
    UPPER(REPLACE(F00091, ' ', '')) AS nome,
    COUNT(F00091) AS qtde_nome
FROM ramaprod.dbo.T00030
GROUP BY UPPER(REPLACE(F00091, ' ', ''))
HAVING 
    COUNT(F00091) > 1
ORDER BY qtde_nome DESC;

SELECT
    F27086 AS doc,
    COUNT(F27086) AS qtde_doc
FROM ramaprod.dbo.T00030
GROUP BY F27086
HAVING 
    COUNT(F27086) > 1
ORDER BY qtde_doc DESC;