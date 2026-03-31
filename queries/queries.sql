-- 1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1 ASC, apellido2 ASC, nombre ASC;

-- 2. Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades. (nombre, apellido1, apellido2)
SELECT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno' AND telefono IS NULL;

-- 3. Retorna el llistat dels alumnes que van néixer en 1999. (id, nombre, apellido1, apellido2, fecha_nacimiento)
SELECT id, nombre, apellido1, apellido2, fecha_nacimiento
FROM persona
WHERE YEAR(fecha_nacimiento) = 1999;


-- 4. Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K. (nombre, apellido1, apellido2, nif)
SELECT nombre, apellido1, apellido2, nif
FROM persona
WHERE tipo = 'profesor' AND telefono IS NULL AND nif LIKE '%K';

-- 5. Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7. (id, nombre, cuatrimestre, curso, id_grado)
SELECT id, nombre, cuatrimestre, curso, id_grado
FROM asignatura
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

-- 6. Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom. (apellido1, apellido2, nombre, departamento)
SELECT per.apellido1, per.apellido2, per.nombre, dep.nombre AS departamento
FROM persona AS per
JOIN profesor AS pro
ON pro.id_profesor = per.id
JOIN departamento AS dep
ON pro.id_departamento = dep.id
WHERE per.tipo = 'profesor'
ORDER BY per.apellido1 ASC, per.apellido2 ASC, per.nombre ASC;

-- 7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M. (nombre, anyo_inicio, anyo_fin)
SELECT asi.nombre, anyo_inicio, anyo_fin
FROM persona AS per
JOIN alumno_se_matricula_asignatura AS asma
ON asma.id_alumno = per.id
JOIN asignatura AS asi
ON asma.id_asignatura = asi.id
JOIN curso_escolar AS cues
ON asma.id_curso_escolar = cues.id
WHERE per.nif = '26902806M';

-- 8. Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015). (nombre)
SELECT DISTINCT dep.nombre
FROM departamento AS dep
JOIN profesor AS pro
ON dep.id = pro.id_departamento
JOIN asignatura AS asi
ON asi.id_profesor = pro.id_profesor
JOIN grado AS gra
ON gra.id = asi.id_grado
WHERE gra.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019. (nombre, apellido1, apellido2)
SELECT DISTINCT per.nombre, per.apellido1, per.apellido2
FROM persona AS per
JOIN alumno_se_matricula_asignatura AS asma 
ON asma.id_alumno = per.id
JOIN curso_escolar AS cues
ON asma.id_curso_escolar = cues.id
WHERE cues.anyo_inicio = 2018 AND cues.anyo_fin = 2019;

-- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.
-- 10. Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom. (departamento, apellido1, apellido2, nombre)
SELECT dep.nombre AS departamento, per.apellido1, per.apellido2, per.nombre
FROM profesor AS pro
LEFT JOIN departamento AS dep
ON dep.id = pro.id_departamento
JOIN persona AS per
ON pro.id_profesor = per.id
ORDER BY dep.nombre ASC, per.apellido1 ASC, per.apellido2 ASC, per.nombre ASC;

-- 11. Retorna un llistat amb els professors/es que no estan associats a un departament. (apellido1, apellido2, nombre)
SELECT per.apellido1, per.apellido2, per.nombre
FROM profesor AS pro
LEFT JOIN departamento AS dep
ON dep.id = pro.id_departamento
JOIN persona AS per
ON pro.id_profesor = per.id
WHERE dep.nombre IS NULL;

-- 12. Retorna un llistat amb els departaments que no tenen professors/es associats. (nombre)
SELECT dep.nombre
FROM departamento AS dep
LEFT JOIN profesor AS pro
ON pro.id_departamento = dep.id
WHERE pro.id_profesor IS NULL;

-- 13. Retorna un llistat amb els professors/es que no imparteixen cap assignatura. (apellido1, apellido2, nombre)
SELECT per.apellido1, per.apellido2, per.nombre
FROM profesor AS pro
LEFT JOIN asignatura AS asi
ON asi.id_profesor = pro.id_profesor
JOIN persona AS per 
ON pro.id_profesor = per.id
WHERE asi.nombre IS NULL;

-- 14. Retorna un llistat amb les assignatures que no tenen un professor/a assignat. (id, nombre)
SELECT asi.id, asi.nombre  
FROM asignatura AS asi
LEFT JOIN profesor AS pro
ON asi.id_profesor = pro.id_profesor
WHERE pro.id_profesor IS NULL;

-- 15. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar. (nombre)
SELECT dep.nombre
FROM departamento AS dep
LEFT JOIN profesor AS pro
    ON pro.id_departamento = dep.id
LEFT JOIN asignatura AS asi
    ON asi.id_profesor = pro.id_profesor
GROUP BY dep.id, dep.nombre
HAVING COUNT(asi.id) = 0;

-- 16. Retorna el nombre total d'alumnes que hi ha. (total)
SELECT COUNT(*) AS total
FROM persona
WHERE tipo = 'alumno';

-- 17. Calcula quants alumnes van néixer en 1999. (total)
SELECT COUNT(*) AS total
FROM persona
WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- 18. Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es. (departamento, total)
SELECT dep.nombre AS departamento, COUNT(pro.id_profesor) AS total
FROM departamento AS dep
JOIN profesor AS pro
    ON pro.id_departamento = dep.id
GROUP BY dep.id, dep.nombre
ORDER BY total DESC;

-- 19. Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat. (departamento, total)
SELECT dep.nombre AS departamento, COUNT(pro.id_profesor) AS total
FROM departamento AS dep
LEFT JOIN profesor AS pro
    ON pro.id_departamento = dep.id
GROUP BY dep.id, dep.nombre
ORDER BY total DESC;

-- 20. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures. (grau, total)
SELECT gra.nombre AS grau, COUNT(asi.id) AS total 
FROM grado AS gra
LEFT JOIN asignatura AS asi
ON asi.id_grado = gra.id
GROUP BY gra.nombre
ORDER BY COUNT(asi.id) DESC;

-- 21. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades. (grau, total)
SELECT gra.nombre AS grau, COUNT(asi.id) AS total 
FROM grado AS gra
JOIN asignatura AS asi
ON asi.id_grado = gra.id
GROUP BY gra.nombre
HAVING COUNT(asi.id) > 40;

-- 22. Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus. (grau, tipus, total_creditos)
SELECT gra.nombre AS grau, asi.tipo AS tipus, SUM(asi.creditos) AS total_creditos
FROM grado AS gra
JOIN asignatura AS asi
ON asi.id_grado = gra.id
GROUP BY gra.id, gra.nombre, asi.tipo
ORDER BY gra.nombre, asi.tipo;

-- 23. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats. (anyo_inicio, total)
SELECT cues.anyo_inicio, COUNT(DISTINCT asma.id_alumno) AS total 
FROM curso_escolar AS cues
JOIN alumno_se_matricula_asignatura AS asma
ON asma.id_curso_escolar = cues.id
GROUP BY cues.anyo_inicio;

-- 24. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures. (id, nombre, apellido1, apellido2, total)
SELECT per.id, per.nombre, per.apellido1, per.apellido2, COUNT(asi.id) AS total
FROM profesor AS pro
LEFT JOIN persona AS per
ON pro.id_profesor = per.id
LEFT JOIN asignatura AS asi
ON asi.id_profesor = pro.id_profesor
GROUP BY per.id, per.nombre, per.apellido1, per.apellido2
ORDER BY COUNT(asi.id) DESC;

-- 25. Retorna totes les dades de l'alumne/a més jove. (*)
SELECT *
FROM persona
WHERE tipo = 'alumno' AND fecha_nacimiento = (SELECT MAX(fecha_nacimiento) FROM persona WHERE tipo = 'alumno');

-- 26. Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura. (apellido1, apellido2, nombre)
SELECT per.apellido1, per.apellido2, per.nombre
FROM profesor AS pro
JOIN persona AS per
ON pro.id_profesor = per.id
JOIN departamento AS dep
ON pro.id_departamento = dep.id
LEFT JOIN asignatura AS asi
ON asi.id_profesor = pro.id_profesor
WHERE asi.nombre IS NULL
GROUP BY per.apellido1, per.apellido2, per.nombre;
