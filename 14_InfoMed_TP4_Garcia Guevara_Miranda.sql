select 
	medicamentos.nombre as "Nombre del medicamento",
    count(recetas.id_medicamento) as "Cantidad de recetas"
from medicamentos
join recetas on medicamentos.id_medicamento = recetas.id_medicamento
group by medicamentos.nombre
HAVING COUNT(recetas.id_medicamento) = (
  SELECT MAX(sub.cant)
  FROM (
    SELECT COUNT(r2.id_medicamento) AS cant
    FROM recetas r2
    GROUP BY r2.id_medicamento
  ) sub
);
