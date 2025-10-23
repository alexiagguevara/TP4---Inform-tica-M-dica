SELECT medicamentos.nombre as "Nombre del medicamento"
from medicamentos
join recetas on medicamentos.id_medicamento = recetas.id_medicamento
where recetas.id_medico=2
GROUP by medicamentos.nombre
HAVING count(recetas.id_medicamento)>1;