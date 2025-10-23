SELECT pacientes.nombre as "Nombre del paciente", consultas.fecha, consultas.diagnostico
FROM consultas
join pacientes on consultas.id_paciente = pacientes.id_paciente
where fecha BETWEEN '2024-08-01' and '2024-08-31'
order by consultas.fecha;