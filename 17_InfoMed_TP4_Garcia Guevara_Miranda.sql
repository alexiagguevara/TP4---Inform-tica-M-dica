SELECT
	medicamentos.nombre as "Nombre del medicamento",
    count(recetas.id_medicamento) as "Cantidad de recetas prescritas",
    medicos.nombre as "Nombre del médico",
    pacientes.nombre as "Nombre del paciente"
from medicamentos
join recetas on medicamentos.id_medicamento = recetas.id_medicamento
join medicos on recetas.id_medico = medicos.id_medico
join pacientes on recetas.id_paciente = pacientes.id_paciente
GROUP by 
	medicamentos.id_medicamento, medicamentos.nombre, 
    medicos.id_medico, medicos.nombre, 
    pacientes.id_paciente, pacientes.nombre
order by "Cantidad de recetas prescritas" desc;