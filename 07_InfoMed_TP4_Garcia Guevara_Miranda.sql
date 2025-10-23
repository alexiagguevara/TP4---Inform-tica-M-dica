select ciudad, count(id_paciente) as "Cantidad de pacientes" 
from pacientes
GROUP by ciudad;