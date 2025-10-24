SELECT
	medicos.nombre as "Nombre del médico",
    pacientes.nombre as "Nombre del paciente",
    count(consultas.id_consulta) as "Cantidad de consultas"
from pacientes
join consultas on pacientes.id_paciente = consultas.id_paciente
join medicos on consultas.id_medico = medicos.id_medico
group by pacientes.nombre, medicos.nombre
order by medicos.nombre, pacientes.nombre;