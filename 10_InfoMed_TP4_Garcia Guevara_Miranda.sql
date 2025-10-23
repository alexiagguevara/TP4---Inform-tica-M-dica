SELECT
	id_consulta,
    id_paciente,
    fecha,
    diagnostico,
    tratamiento,
    snomed_codigo
from consultas
where id_medico=3 and fecha BETWEEN '2024-08-01' and '2024-08-31'
order by fecha;
