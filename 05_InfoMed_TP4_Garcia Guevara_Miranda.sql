update pacientes set ciudad = case
WHEN lower (SUBSTRING(trim(ciudad),1,1)) = 'b' then 'Buenos Aires' --trim le saca los espacios, primer letra, cantidad de caracteres que me quedo
WHEN lower (SUBSTRING(trim(ciudad),1,1)) = 'c' THEN 'Córdoba'
WHEN lower (SUBSTRING(trim(ciudad),1,1)) = 'm' then 'Mendoza'
when lower (SUBSTRING(trim(ciudad),1,1)) = 's' THEN 'Santa Fe'
else 'Rosario'
END;