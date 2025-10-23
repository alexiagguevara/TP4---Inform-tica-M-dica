CREATE or REPLACE VIEW view_pacientes_overview AS
SELECT
  pacientes.id_paciente as "ID Paciente",
  pacientes.nombre as "Nombre",
  pacientes.fecha_nacimiento as "Fecha de Nacimiento",
  extract(year from AGE(CURRENT_DATE, pacientes.fecha_nacimiento)) AS "Edad",
  sexobiologico.descripcion AS "Sexo Biológico",
  pacientes.calle || ' ' || pacientes.numero || ', ' || pacientes.ciudad AS "Dirección"
FROM Pacientes
LEFT JOIN sexobiologico ON sexobiologico.id_sexo = pacientes.id_sexo;