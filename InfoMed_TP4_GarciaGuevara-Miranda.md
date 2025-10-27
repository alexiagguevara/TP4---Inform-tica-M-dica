# **16.22 Informática Médica** - **Trabajo Práctico 4** - **2Q 2025**
**BBDD, SQL y manejo de versiones**

**Grupo 2**

**Integrantes:**

| García Guevara Alexia  | 62721 | 
| :---- | :---: |
| Miranda Mora | 62702 |

**Fecha de entrega:** 27 de octubre de 2025

# **Parte 1: Base de datos**

## **Base de datos centro médico**

Se desea diseñar una base de datos relacional que almacene la información sobre los pacientes, médicos, recetas y consultas en un centro de salud. En la actualidad, la gestión de esta información se lleva a cabo del siguiente modo:   

*Cuando una persona acude al centro de salud, se le toma nota en una ficha con sus datos personales: nombre, fecha de nacimiento, sexo biológico y dirección (calle, número y ciudad). Esta ficha queda registrada en el archivo de pacientes del centro. Los médicos del centro también tienen su ficha, donde se registran su nombre completo, especialidad y dirección profesional.*  
*Cada vez que un médico realiza una consulta o tratamiento a un paciente, puede emitir una receta. Esta receta incluye la fecha, el nombre del paciente atendido, el médico que la emite, el medicamento o tratamiento indicado, y la enfermedad o condición que motivó la prescripción. Esta información queda registrada y organizada para facilitar tanto el seguimiento del paciente como las auditorías clínicas.*  
*Los tratamientos pueden incluir medicamentos, indicaciones como reposo o fisioterapia, y suelen tener especificaciones temporales (por ejemplo, “tomar por 5 días” o “uso indefinido”). También se registran enfermedades o diagnósticos asociados, permitiendo análisis estadísticos o seguimiento epidemiológico.*  
*El sistema busca reemplazar los registros en papel por una solución digital que permita realizar búsquedas rápidas, obtener estadísticas de distribución demográfica, sexo y especialidad, y mantener la información organizada para su integración con otros módulos médicos como historiales clínicos, turnos o recetas médicas.*

## **1\. ¿Qué tipo de base de datos es? Clasificarla según estructura y función.**

Según su estructura, es una base de datos relacional (SQL). Esto se debe a que se organiza la información en tablas relacionadas mediante claves primarias y foráneas, tiene una estructura predefinida. Las entidades fuertes principales del sistema son:

| Entidad | PK | Relaciones |
| :---: | :---: | :---: |
| Paciente | id\_paciente | FK a sexo |
| Médico | id\_medico | FK a especialidades |
| Consulta | id\_consulta | FK a pacientes y médicos, incluye código SNOMED |
| Receta | id\_receta | FK a pacientes, médicos y medicamentos |

Según su función, es una base de datos transaccional. Esto se debe a que su propósito es registrar, gestionar y consultar operaciones del día a día (altas de pacientes y médicos, registrar consultas, emisión de recetas, etc.). 

## **2\. Planteando el Modelo conceptual, armar el diagrama entidad-relación de la base de datos dada. (Usar notación de Chen, marcando tipo de participación, cardinalidad, claves primarias y parciales).**

A continuación se visualiza el diagrama entidad-relación ([DER](https://drive.google.com/file/d/1AV-gJd0ypfJl9p5ZYlN4fTufpkl_8laC/view?usp=sharing)) de la base de datos dada, empleando notación de Chen:  
<img width="567" height="592" alt="Screenshot 2025-10-27 at 1 28 07 PM" src="https://github.com/user-attachments/assets/81327a96-e201-4ca3-b5d4-22e685da32e3" />

Nota a tener en cuenta sobre el DER desarrollado: 1\) el atributo *edad* es derivado, ya que puede calcularse a partir de la *fecha de nacimiento* del paciente. Esta decisión evita almacenar un dato que varía con el tiempo y garantiza consistencia en los registros.

## **3\. Mapear del Modelo conceptual planteado en el punto 2 al Modelo Relacional de la base de datos dada. (Usar notación Crow’s foot en el diagrama).**

A continuación se visualiza el modelo relacional de la base de datos ([Link](https://drive.google.com/file/d/1G1U6qpkAqyk8v4Jr6sHvSHC43PqlL-9a/view?usp=sharing)):  
<img width="605" height="669" alt="Screenshot 2025-10-27 at 1 29 18 PM" src="https://github.com/user-attachments/assets/ab22ad11-3971-489a-8d86-9311c6b5ecdc" />


## **4\. ¿Considera que la base de datos está normalizada? En caso que no lo esté, ¿cómo podría hacerlo?  Nota: no debe normalizar la base de datos, solo explicar como lo haría.**

La base de datos no está completamente normalizada. Cumple con la Primera Forma Normal (1NF), es decir, que todos sus valores son atómicos, aunque *nombre* es debatible. Además, cumple también con la Segunda Forma Normal (2NF), es decir, que todas las tablas usan claves primarias simples, no hay dependencias parciales. Sin embargo, no cumple la Tercera Forma Normal (3NF), ya que tiene dependencias transitivas, es decir, que un atributo no clave depende de otro atributo que tampoco lo es. Se identificaron dos faltas principales:

1. La tabla Pacientes almacena *ciudad* como texto simple (VARCHAR). Esto genera redundancia ya que se repite “Rosario”, “Córdoba”, etc. Además, genera problemas de integridad en, por ejemplo, “Bs Aires”, “buenos aires”, “Buenos Aiers” y “Buenos Aires”. Se puede observar que existe una dependencia transitiva. El *id\_paciente* determina la *calle* y el *número*, y esta dirección determina la *ciudad*.

Solución

1. Crear una tabla catálogo:

CREATE TABLE Ciudades (id\_ciudad SERIAL PRIMARY KEY, nombre VARCHAR (100) UNIQUE)

2. Ingresar a la tabla Ciudades valores únicos como “Buenos Aires”, “Rosario”, “Córdoba”.  
3. En la tabla Pacientes, eliminar *ciudad*.  
4. Añadir nueva columna id\_ciudad INT que sería una FK referenciando a Ciudades (id\_ciudad).

2\. La tabla Consultas almacena tanto el *snomed\_código* como el *diagnóstico*. El código determina el texto, lo que genera una dependencia transitiva. Al conocer el código SNOMED, ya se conoce el diagnóstico estándar, por lo que almacenar ambos genera redundancia.  
Solución

1. Crear una nueva tabla catálogo:

CREATE TABLE DiagnosticosSCT (snomed\_codigo BIGINT PRIMARY KEY, descripcion\_estandar VARCHAR (255))

2. Poblar la tabla con los códigos y sus descripciones oficiales.  
3. En la tabla Consultas, eliminar *diagnóstico*.  
4. Enviar *snomed\_código* como FK referenciando a DiagnósticosSCT(snomed\_código).  
5. Si el médico necesita añadir un detalle como, por ejemplo, “Asma severa” o “Fractura ed brazo”, añadir una nueva columna en Consultas llamada *notas\_diagnostico* TEXT para guardar ese texto libre específico de la consulta.

# **Parte 2: SQL**

Aclaración: Las query SQL utilizadas para esta parte se pueden encontrar en el siguiente enlace: [PostgreSQL.sql](https://drive.google.com/file/d/14av63Ij6e1qaOPvtSvuqJ2rq7whJZNzB/view?usp=sharing)

## **1\. Cuando se realizan consultas sobre la tabla paciente agrupando por ciudad los tiempos de respuesta son demasiado largos. Proponer mediante una query SQL una solución a este problema.**

Query para solucionar el problema:  
```sql
CREATE INDEX index_pacientes_ciudad
ON pacientes(ciudad);

SELECT ciudad, COUNT(*) AS "Cantidad de pacientes"
FROM pacientes
GROUP BY ciudad;
```
Podemos observar la cantidad de pacientes por ciudad, y notar las inconsistencias de las maneras en que se escribieron las ciudades, las cuales generan problemas de integridad como se mencionó anteriormente.  
<img width="420" height="419" alt="Screenshot 2025-10-27 at 1 43 09 PM" src="https://github.com/user-attachments/assets/64d7ac20-3fee-41a3-8046-c15c7d16f09a" />

## **2\. Se tiene la fecha de nacimiento de los pacientes. Se desea calcular la edad de los pacientes y almacenarla de forma dinámica en el sistema ya que es un valor típicamente consultado, junto con otra información relevante del paciente.**

Para realizar lo pedido se utilizó la siguiente query:  
```sql
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
```
Los resultados obtenidos son los siguientes:   
<img width="602" height="439" alt="Screenshot 2025-10-27 at 1 44 13 PM" src="https://github.com/user-attachments/assets/d58128b1-e0fd-4243-877f-a428bfe9b1a4" />

Aclaración: la tabla está truncada ya que es muy larga.

## **3\. La paciente, “Luciana Gómez”, ha cambiado de dirección. Antes vivía en “Avenida Las Heras 121” en “Buenos Aires”, pero ahora vive en “Calle Corrientes 500” en “Buenos Aires”. Actualizar la dirección de este paciente en la base de datos.**

Query para actualizar la dirección:  
```sql
UPDATE pacientes
set calle='Calle Corrientes', numero=500
WHERE nombre='Luciana Gómez';
```
En la vista creada en el punto 2 podemos ver la actualización de la dirección:  
<img width="673" height="24" alt="Screenshot 2025-10-27 at 1 44 44 PM" src="https://github.com/user-attachments/assets/e5cd85e0-c002-494b-9dbf-5bab65bdf3bd" />


## **4\. Seleccionar el nombre y la matrícula de cada médico cuya especialidad sea identificada por el id 4\.**

Query utilizada:  
```sql
SELECT nombre, matricula 
from medicos 
where especialidad_id=4;
```
Resultado:  
<img width="400" height="86" alt="Screenshot 2025-10-27 at 1 45 02 PM" src="https://github.com/user-attachments/assets/9627bcc6-9aba-452f-98e2-e8453b83fd54" />


## **5\. Puede pasar que haya inconsistencias en la forma en la que están escritos los nombres de las ciudades, ¿cómo se corrige esto? Agregar la query correspondiente.**

Query utilizada para corregir las inconsistencias:  
```sql
update pacientes set ciudad = case
WHEN lower (SUBSTRING(trim(ciudad),1,1)) = 'b' then 'Buenos Aires' --trim le saca los espacios, primer letra, cantidad de caracteres que me quedo
WHEN lower (SUBSTRING(trim(ciudad),1,1)) = 'c' THEN 'Córdoba'
WHEN lower (SUBSTRING(trim(ciudad),1,1)) = 'm' then 'Mendoza'
when lower (SUBSTRING(trim(ciudad),1,1)) = 's' THEN 'Santa Fe'
else 'Rosario'
END;
```
Podemos ver que en la tabla pacientes las ciudades ahora son todas consistentes (tabla presentada truncada):  
<img width="674" height="269" alt="Screenshot 2025-10-27 at 1 45 20 PM" src="https://github.com/user-attachments/assets/23721029-6c3d-4d67-8bc8-e422f4d81567" />


## **6\. Obtener el nombre y la dirección de los pacientes que viven en Buenos Aires.**

Query utilizada:  
```sql
Select nombre, calle, numero 
from pacientes 
where ciudad='Buenos Aires';
```
Resultado:  
<img width="462" height="236" alt="Screenshot 2025-10-27 at 1 45 40 PM" src="https://github.com/user-attachments/assets/4bb9bd33-7f71-48db-978c-0298a8c762fe" />


## **7\. Cantidad de pacientes que viven en cada ciudad.**

Query utilizada:  
```sql
select ciudad, count(id_paciente) as "Cantidad de pacientes" 
from pacientes
GROUP by ciudad;
```
Resultados:  
<img width="455" height="170" alt="Screenshot 2025-10-27 at 1 45 57 PM" src="https://github.com/user-attachments/assets/c575ca9d-606d-4347-90ef-90b64d0ffdc0" />


## **8\. Cantidad de pacientes por sexo que viven en cada ciudad.**

Query utilizada:  
```sql
SELECT 
	pacientes.ciudad, 
    sexobiologico.descripcion as "Sexo Biológico", 
	COUNT(pacientes.id_paciente) as "Cantidad de pacientes"
from pacientes
join sexobiologico on sexobiologico.id_sexo = pacientes.id_sexo
GROUP by pacientes.ciudad, sexobiologico.id_sexo
order by pacientes.ciudad, sexobiologico.id_sexo;
```
Resultados:  
<img width="612" height="306" alt="Screenshot 2025-10-27 at 1 46 18 PM" src="https://github.com/user-attachments/assets/1eeff80c-dae0-48f4-b64c-7b2da00f8a42" />


## **9\. Obtener la cantidad de recetas emitidas por cada médico.**

Query utilizada:  
```sql
select medicos.nombre as "Nombre del médico", count(recetas.id_receta) as "Cantidad de recetas" 
from medicos
left join recetas on medicos.id_medico = recetas.id_medico
Group By medicos.nombre
ORDER BY "Cantidad de recetas" DESC;
```
Resultado obtenido:  
<img width="502" height="347" alt="Screenshot 2025-10-27 at 1 46 35 PM" src="https://github.com/user-attachments/assets/d7a13ed6-8edf-4c26-9cd2-64fed1000c89" />

Aclaración: tabla truncada

## **10\. Obtener todas las consultas médicas realizadas por el médico con ID igual a 3 durante el mes de agosto de 2024\.**

Query utilizada:  
```sql
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
```
Resultados:  
<img width="614" height="112" alt="Screenshot 2025-10-27 at 1 46 54 PM" src="https://github.com/user-attachments/assets/5269e64b-d4eb-4f8b-a380-74d6ae748154" />


## **11\. Obtener el nombre de los pacientes junto con la fecha y el diagnóstico de todas las consultas médicas realizadas en agosto del 2024\.**

Query utilizada:  
```sql
SELECT pacientes.nombre as "Nombre del paciente", consultas.fecha, consultas.diagnostico
FROM consultas
join pacientes on consultas.id_paciente = pacientes.id_paciente
where fecha BETWEEN '2024-08-01' and '2024-08-31'
order by consultas.fecha;
``` 
Resultados:   
<img width="520" height="292" alt="Screenshot 2025-10-27 at 1 47 13 PM" src="https://github.com/user-attachments/assets/7a44a1b9-4ec4-43b7-a96f-36905921c1c4" />

Aclaración: tabla truncada

## **12\. Obtener el nombre de los medicamentos prescritos más de una vez por el médico con ID igual a 2\.**

Query utilizada:  
```sql
SELECT medicamentos.nombre as "Nombre del medicamento"
from medicamentos
join recetas on medicamentos.id_medicamento = recetas.id_medicamento
where recetas.id_medico=2
GROUP by medicamentos.nombre
HAVING count(recetas.id_medicamento)>1;
``` 
Resultado:  
<img width="147" height="56" alt="Screenshot 2025-10-27 at 1 47 34 PM" src="https://github.com/user-attachments/assets/4a8947f1-decc-449d-a6fd-858ad44492f1" />


## **13\. Obtener el nombre de los pacientes junto con la cantidad total de recetas que han recibido.**

Query utilizada:  
```sql
SELECT 
	pacientes.nombre as "Nombre del paciente",
    count(recetas.id_paciente) as "Cantidad de recetas"
from pacientes
join recetas on pacientes.id_paciente = recetas.id_paciente
GROUP by pacientes.id_paciente, pacientes.nombre
order by "Cantidad de recetas" desc;
``` 
Resultados:  
<img width="401" height="378" alt="Screenshot 2025-10-27 at 1 47 52 PM" src="https://github.com/user-attachments/assets/77d0c8fa-54ef-4ede-b2e8-c0c2af5d7469" />
  
Aclaración: tabla truncada

## **14\. Obtener el nombre del medicamento más recetado junto con la cantidad de recetas emitidas para ese medicamento.**

Query utilizada:  
```sql
select 
	medicamentos.nombre as "Nombre del medicamento",
    count(recetas.id_medicamento) as "Cantidad de recetas"
from medicamentos
join recetas on medicamentos.id_medicamento = recetas.id_medicamento
group by medicamentos.nombre
HAVING COUNT(recetas.id_medicamento) = (
  SELECT MAX(sub.cant)
  FROM (
    SELECT COUNT(r2.id_medicamento) AS cant
    FROM recetas r2
    GROUP BY r2.id_medicamento
  ) sub
);
``` 
Resultado:  
<img width="441" height="63" alt="Screenshot 2025-10-27 at 1 48 11 PM" src="https://github.com/user-attachments/assets/0e6fa8d3-21e0-4a65-807a-76c7e107c80d" />


## **15\. Obtener el nombre del paciente junto con la fecha de su última consulta y el diagnóstico asociado.**

Query utilizada:  
```sql
SELECT 
	pacientes.nombre as "Nombre del paciente",
    consultas.fecha as "Fecha consulta",
    consultas.diagnostico as "Diagnóstico"
from pacientes
join consultas on pacientes.id_paciente = consultas.id_paciente
where consultas.fecha = (SELECT max(c2.fecha) from consultas c2 where id_paciente = pacientes.id_paciente);
```
Resultados:  
<img width="676" height="582" alt="Screenshot 2025-10-27 at 1 48 31 PM" src="https://github.com/user-attachments/assets/8289d348-5751-4805-915e-52653b5085b5" />
 
Aclaración: tabla truncada

## **16\. Obtener el nombre del médico junto con el nombre del paciente y el número total de consultas realizadas por cada médico para cada paciente, ordenado por médico y paciente.**

Query utilizada:  
```sql
SELECT
	medicos.nombre as "Nombre del médico",
    pacientes.nombre as "Nombre del paciente",
    count(consultas.id_consulta) as "Cantidad de consultas"
from pacientes
join consultas on pacientes.id_paciente = consultas.id_paciente
join medicos on consultas.id_medico = medicos.id_medico
group by pacientes.nombre, medicos.nombre
order by medicos.nombre, pacientes.nombre;
``` 
Resultados:  
<img width="672" height="369" alt="Screenshot 2025-10-27 at 1 48 53 PM" src="https://github.com/user-attachments/assets/1bdd1e74-3d5b-4c5c-9090-61bca9a32074" />

Aclaración: tabla truncada

## **17\. Obtener el nombre del medicamento junto con el total de recetas prescritas para ese medicamento, el nombre del médico que lo recetó y el nombre del paciente al que se le recetó, ordenado por total de recetas en orden descendente.**

Query utilizada:  
```sql
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
```
Resultados:   
<img width="632" height="347" alt="Screenshot 2025-10-27 at 1 49 12 PM" src="https://github.com/user-attachments/assets/eb47c8b5-bb24-4848-8047-6da7497cdf77" />
  
Aclaración: tabla truncada

## **18\. Obtener el nombre del médico junto con el total de pacientes a los que ha atendido, ordenado por el total de pacientes en orden descendente.**

Query utilizada:  
```sql
select 
	medicos.nombre as "Nombre del médico",
    count(consultas.id_paciente) as "Pacientes atendidos"
from consultas
join medicos on consultas.id_medico = medicos.id_medico
group by medicos.id_medico, medicos.nombre
order by "Pacientes atendidos" DESC;
``` 
Resultados:  
<img width="446" height="248" alt="Screenshot 2025-10-27 at 1 49 34 PM" src="https://github.com/user-attachments/assets/e6bba625-064f-436a-9c7a-e6913e9f05e1" />
