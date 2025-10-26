SELECT 
	pacientes.nombre as "Nombre del paciente",
    consultas.fecha as "Fecha consulta",
    consultas.diagnostico as "Diagnóstico"
from pacientes
join consultas on pacientes.id_paciente = consultas.id_paciente
where consultas.fecha = (SELECT max(c2.fecha) from consultas c2 where id_paciente = pacientes.id_paciente);
