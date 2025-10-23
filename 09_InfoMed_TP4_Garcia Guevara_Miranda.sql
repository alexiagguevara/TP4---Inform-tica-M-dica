select medicos.nombre as "Nombre del médico", count(recetas.id_receta) as "Cantidad de recetas" 
from medicos
left join recetas on medicos.id_medico = recetas.id_medico
Group By medicos.nombre
ORDER BY "Cantidad de recetas" DESC;
