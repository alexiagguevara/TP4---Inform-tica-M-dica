SELECT 
	pacientes.ciudad, 
    sexobiologico.descripcion as "Sexo Biológico", 
	COUNT(pacientes.id_paciente) as "Cantidad de pacientes"
from pacientes
join sexobiologico on sexobiologico.id_sexo = pacientes.id_sexo
GROUP by pacientes.ciudad, sexobiologico.id_sexo
order by pacientes.ciudad, sexobiologico.id_sexo;
