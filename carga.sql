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
values  (3020721280101, 'Adrian', 'Samuel', 'Molina', 'Cabrera', STR_TO_DATE('2000-12-20', '%Y-%m-%d'), 'M', 1, 101),
        (3020721290101, 'Natalia', 'Alejandra', 'Pineda', 'Zuniga', STR_TO_DATE('2001-9-11', '%Y-%m-%d'), 'F', 1, 108),
        (3020721300101, 'Daniel', 'Alejandro', 'Perez', 'Martinez', STR_TO_DATE('2000-8-16', '%Y-%m-%d'), 'M', 1, 1201),
        (3020721310101, 'Keily', 'Elizabeth', 'Ruiz', 'Mendoza', STR_TO_DATE('2000-5-10', '%Y-%m-%d'), 'F', 1, 301),
        (3020721320101, 'Kabek', 'Armando', 'Herrera', 'Mando', STR_TO_DATE('2000-3-12', '%Y-%m-%d'), 'M', 1, 2201),
        (3020721330101, 'Dian', 'Gabriela', 'Santos', 'de la Rosa', STR_TO_DATE('2000-4-2', '%Y-%m-%d'), 'F', 1, 2102);

insert into dpi (fecha_emision, id_persona, codigo_municipio)
values  (STR_TO_DATE('2018-12-21', '%Y-%m-%d'), 1, 101),
        (STR_TO_DATE('2019-9-13', '%Y-%m-%d'), 2, 108),
        (STR_TO_DATE('2019-9-13', '%Y-%m-%d'), 3, 1201),
        (STR_TO_DATE('2019-9-13', '%Y-%m-%d'), 4, 301),
        (STR_TO_DATE('2019-9-13', '%Y-%m-%d'), 5, 2201),
        (STR_TO_DATE('2019-9-13', '%Y-%m-%d'), 6, 2102);