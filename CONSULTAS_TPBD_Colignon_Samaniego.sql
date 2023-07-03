-- ---------------------------------------- EJERCICIO 6 --------------------------------------------
--Saber todos los datos de la tabla “weight” de los cuales la descripción abreviada del alimento es “Baby” 
--y su respectivo grupo de alimentos, además la medida de peso sea en “cup”, ordenar por esta última:
SELECT * FROM weight AS w
JOIN (SELECT *
	FROM food_des AS fd
	JOIN fd_group AS fg
	ON fd.fdgrp_cd = fg.fdgrp_cd
	WHERE fd.shrt_desc LIKE '%BABY%') AS fd
ON w.ndb_no = fd. ndb_no
WHERE w.msre_desc LIKE '%cup%'
ORDER BY w.msre_desc 

--Hallar los 20 alimentos que menos calorías tienen:
SELECT ndb_no, long_desc, pro_factor, fat_factor, cho_factor, (pro_factor*4+fat_factor*9 + cho_factor*4) AS calorias
FROM food_des
GROUP BY ndb_no
ORDER BY calorias ASC
LIMIT 20

--Nombre de los alimentos que tienen registros asociados en la tabla "nut_data":
SELECT fd.ndb_no, fd.long_desc
FROM food_des AS fd
WHERE EXISTS
	(SELECT 1 
	 FROM nut_data AS nd 
	 WHERE fd.ndb_no = nd.ndb_no)
ORDER BY fd.ndb_no ASC

--Seleccionar los alimentos cuya unidad coincide con microgramo, miligramo y gramo:

SELECT nutr_no, units, nutrdesc
FROM nutr_def
WHERE units IN ('mg','mcg', 'g')

--Encontrar alimentos que contengan carne pero que esta no esté cruda:
SELECT ndb_no, fdgrp_cd, long_desc, shrt_desc
FROM food_des AS fd
WHERE EXISTS 
		(SELECT 1 
		 FROM food_des AS fd2
		 WHERE fd.ndb_no = fd2.ndb_no AND fd2.long_desc like '%meat%')
  	AND NOT EXISTS 
		(SELECT 1 
		 FROM food_des AS fd2
		 WHERE fd.ndb_no = fd2.ndb_no AND fd2.long_desc like '%raw%')

--Obtener el ID del origen de datos, los autores y el conteo de registros correspondientes a cada 
--origen de datos en "nut_data". 
--Filtrar por grupos con un conteo mayor a 150 y ordenar los resultados según el conteo:
SELECT ds.datasrc_id, ds.authors, COUNT(nd.ndb_no) AS conteo
FROM data_src AS ds
JOIN datsrcln AS asl ON ds.datasrc_id = asl.datasrc_id
JOIN nut_data AS nd  ON asl.ndb_no = nd.ndb_no
GROUP BY ds.datasrc_id, ds.authors
HAVING COUNT(nd.ndb_no) > 2000 --no es eficiente porque se ejecuta desp de la optimizacion
ORDER BY conteo 

--Obtener la descripción del alimento, la descripción de la medida de peso y la descripción 
--del grupo de alimentos para aquellos registros que cumplan con solo las filas donde la descripción 
--de la medida de peso contenga la palabra "cup". 
--Ordenar ascendente según la descripción del alimento en la tabla "food_des"
SELECT fd.long_desc AS descripcion_alimento, 
	   w.msre_desc AS unidad_de_medida, 
	   fg.fddrp_desc AS grupo_alimenticio
FROM food_des AS fd
JOIN weight AS w ON fd.ndb_no = w.ndb_no
JOIN fd_group AS fg ON fd.fdgrp_cd = fg.fdgrp_cd
WHERE w.msre_desc LIKE '%cup%'
ORDER BY fd.long_desc ASC;

-- ---------------------------------------- EJERCICIO 7 --------------------------------------------

-- CONSULTA SIN OPTIMIZAR
SELECT fd.long_desc AS descripcion_alimento, 
		w.msre_desc AS unidad_de_medida, 
		fg.fddrp_desc AS grupo_alimenticio,
		fg.fdgrp_cd AS codigo_g_alimento
FROM food_des AS fd
JOIN weight AS w ON fd.ndb_no = w.ndb_no
JOIN fd_group AS fg ON fd.fdgrp_cd = fg.fdgrp_cd
WHERE fd.long_desc like '%Cheese%' 
	AND w.gm_wgt between 10 and 35
	AND fd.fdgrp_cd = '0100'
ORDER BY w.gm_wgt ASC 

-- CONSULTA OPTIMIZADA:
SELECT sub_con_3.long_desc AS descripcion_alimento, 
	   sub_con_3.msre_desc AS unidad_de_medida, 
	   sub_con_4.fddrp_desc AS grupo_alimenticio, 
	   sub_con_4.fdgrp_cd AS codigo_g_alimento
FROM ( SELECT fddrp_desc, fdgrp_cd FROM fd_group) sub_con_4,
     ( SELECT sub_con_1.long_desc, sub_con_2.msre_desc, sub_con_1.fdgrp_cd, sub_con_2.gm_wgt
       FROM ( SELECT long_desc, ndb_no, fdgrp_cd 
			  FROM food_des 
			  WHERE long_desc like '%Cheese%' AND fdgrp_cd = '0100') sub_con_1,
            ( SELECT msre_desc, ndb_no, gm_wgt 
			  FROM weight 
			  WHERE gm_wgt between 10 and 35) sub_con_2
       WHERE sub_con_1.ndb_no = sub_con_2.ndb_no) sub_con_3
WHERE  sub_con_4.fdgrp_cd = sub_con_3.fdgrp_cd
ORDER BY sub_con_3.gm_wgt ASC

-- ---------------------------------------- EJERCICIO 8 --------------------------------------------

--3 grupos de alimentos con mayor cantidad de registros, para comparar sus valores nutricionales 
--(carbohidratos, proteínas, grasas y calorías) y ver si existe alguna diferencia entre ellos:
SELECT  ndb_no, fdgrp_cd, long_desc, pro_factor, fat_factor, cho_factor, 
		(pro_factor*4+cho_factor*4+fat_factor*9) AS calorias
FROM food_des
WHERE fdgrp_cd = '1100'
   OR fdgrp_cd = '1300'
   OR fdgrp_cd = '1800'
   
SELECT *
FROM fd_group
WHERE fdgrp_cd = '1100'
OR fdgrp_cd = '1300'
OR fdgrp_cd = '1800'

--Tabla que utilizaremos para explorar en R como un dataset:
SELECT fg.fdgrp_cd, fg.fddrp_desc, COUNT(fd.fdgrp_cd) AS repeticiones
FROM food_des AS fd 
JOIN fd_group AS fg ON fd.fdgrp_cd = fg.fdgrp_cd
GROUP BY fg.fdgrp_cd
ORDER BY repeticiones DESC
LIMIT 3

