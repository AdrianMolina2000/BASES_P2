LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/departamentos.csv'
INTO TABLE departamento
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/municipios.csv'
INTO TABLE municipio
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

insert into proyecto2.estado_civil (estado) values ('soltero'), ('casado'), ('divorsiado'), ('viudo');

insert into persona (cui, nombre1, nombre2, apellido1, apellido2, fecha_nacimiento, genero, estado_civil, codigo_municipio)
values  (3020721280101, 'José', 'Alberto', 'López', 'Pérez', STR_TO_DATE('1980-1-10', '%Y-%m-%d'), 'M', 1, 101),
        (3020721290101, 'Juan', 'Carlos', 'García', 'Hernández', STR_TO_DATE('1978-9-11', '%Y-%m-%d'), 'M', 1, 108),
        (3020721300101, 'Miguel', 'Ángel', 'Morales', 'Ramírez', STR_TO_DATE('1979-8-16', '%Y-%m-%d'), 'M', 1, 101),
        (3020721310101, 'Jorge', 'Luis', 'Gómez', 'González', STR_TO_DATE('1982-5-10', '%Y-%m-%d'), 'M', 1, 1601),
        (3020721320101, 'José', 'Antonio', 'Martínez', 'Vásquez', STR_TO_DATE('1988-3-12', '%Y-%m-%d'), 'M', 1, 1228),
        (3020721330101, 'Sofía', 'Camila', 'Velasquez', 'de la Rosa', STR_TO_DATE('1990-4-2', '%Y-%m-%d'), 'F', 1, 101),
        (3020721340101, 'Valentina', 'Isabella', 'Ramos', 'de Leon', STR_TO_DATE('1988-2-7', '%Y-%m-%d'), 'F', 1, 2102),
        (3020721350101, 'Sara', 'Victoria', 'Méndez', 'Rodríguez', STR_TO_DATE('1990-5-12', '%Y-%m-%d'), 'F', 1, 101),
        (3020721360101, 'Gabriela', 'Ximena', 'Diaz', 'Castillo', STR_TO_DATE('1985-6-21', '%Y-%m-%d'), 'F', 1, 2102),
        (3020721370101, 'Adriana', 'Sofía', 'Cruz', 'Aguilar', STR_TO_DATE('1998-12-22', '%Y-%m-%d'), 'F', 1, 108);

insert into tipo (estado)
values ('A'), ('B'), ('C'), ('M'), ('E');