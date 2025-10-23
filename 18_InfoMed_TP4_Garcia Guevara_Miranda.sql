select 
	medicos.nombre as "Nombre del médico",
    count(consultas.id_paciente) as "Pacientes atendidos"
from consultas
join medicos on consultas.id_medico = medicos.id_medico
group by medicos.id_medico, medicos.nombre
order by "Pacientes atendidos" DESC;