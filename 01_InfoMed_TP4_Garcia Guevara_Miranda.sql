CREATE INDEX index_pacientes_ciudad
ON pacientes(ciudad);

SELECT ciudad, COUNT(*) AS "Cantidad de pacientes"
FROM pacientes
GROUP BY ciudad;