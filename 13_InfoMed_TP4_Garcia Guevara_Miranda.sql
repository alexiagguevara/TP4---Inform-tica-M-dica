SELECT 
	pacientes.nombre as "Nombre del paciente",
    count(recetas.id_paciente) as "Cantidad de recetas"
from pacientes
join recetas on pacientes.id_paciente = recetas.id_paciente
GROUP by pacientes.id_paciente, pacientes.nombre
order by "Cantidad de recetas" desc; 
--ponemos el id por si hay mas de un paciente con el mismo nombre