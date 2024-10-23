SELECT DISTINCT
	b.F00446 AS providencia
FROM [ramaprod].[dbo].T00076 AS a
LEFT JOIN [ramaprod].[dbo].T00077 AS b ON a.F00447 = b.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS c ON a.F06982 = c.ID
LEFT JOIN [ramaprod].[dbo].T00003 AS d ON a.F05341 = d.ID
LEFT JOIN [ramaprod].[dbo].T00557 AS e ON a.F05633 = e.ID
LEFT JOIN [ramaprod].[dbo].T00030 AS f ON e.F05200 = f.ID
