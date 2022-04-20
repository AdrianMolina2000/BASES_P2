DROP FUNCTION IF EXISTS generarCui;
CREATE FUNCTION generarCui(municipio int) returns BIGINT
DETERMINISTIC
begin
    declare newCui BIGINT;
    declare conteo int;

    set newCui = 302072128;

    select count(*) into conteo
    from persona;

    set newCui = newCui + conteo;

    IF LENGTH(municipio) = 3 THEN
        set newCui = concat(newCui, 0, municipio);
    ELSE
        set newCui = concat(newCui, municipio);
    END IF;

    return newCui;
end;


DROP PROCEDURE IF EXISTS addNacimiento;
CREATE PROCEDURE addNacimiento( dpi_P BIGINT, dpi_M BIGINT, primerN varchar(50), segundoN varchar(50), tercerN varchar(50),
                                fechaNac VARCHAR(20), municipio int, gen char(1))
begin
    declare id_P int;
    declare id_M int;
    declare apellidoP varchar(50);
    declare apellidoM varchar(50);
    declare genP char(1);
    declare genM char(1);

    select d.id, p.apellido1, p.genero into id_P, apellidoP, genP
    from persona p
    inner join dpi d on d.id_persona = p.id
    where p.cui = dpi_P;

    select d.id, p.apellido1, p.genero into id_M, apellidoM, genM
    from persona p
    inner join dpi d on d.id_persona = p.id
    where p.cui = dpi_M;

    IF genM = 'F' and genP = 'M' THEN
        insert into persona (cui, dpi_padre, dpi_madre, nombre1, nombre2, nombre3, apellido1, apellido2, fecha_nacimiento,
                             genero, estado_civil, codigo_municipio)
        values (generarCui(municipio), id_P, id_M, primerN, segundoN, tercerN, apellidoP, apellidoM,
                STR_TO_DATE(fechaNac, '%Y-%m-%d'), gen, 1, municipio);
    END IF;
end;


DROP PROCEDURE IF EXISTS AddDefuncion;
CREATE PROCEDURE AddDefuncion( dpi_D BIGINT, fecha_d varchar(20), motivo_m varchar(200))
begin
    declare id_per int;
    declare gene char(1);
    declare nombre_m varchar(50);
    declare casado int;
    declare divorciado int;
    declare dpi_mujer_div int;
    declare id_mujer_div int;
    declare nombre_d varchar(50);
    declare casada int;
    declare divorciada int;
    declare dpi_hombre_div int;
    declare id_hombre_div int;

    select p.id, p.genero, p.nombre1 into id_per, gene, nombre_m
    from persona p
    where p.cui = dpi_D;


    insert into defuncion (fecha_fallecimiento, motivo, id_persona)
    values (STR_TO_DATE(fecha_d, '%Y-%m-%d'), motivo_m, id_per);


    IF gene = 'M' THEN
        select count(*) into casado
        from matrimonio m
            inner join dpi d on d.id = m.dpi_hombre
            inner join persona p on p.id = d.id_persona
        where p.cui = dpi_D;

        select count(*) into divorciado
        from divorcio di
            inner join matrimonio m on m.id = di.id_matrimonio
            inner join dpi d on d.id_persona = m.dpi_hombre
            inner join persona p on p.id = d.id_persona
        where p.cui = dpi_D;

        IF casado - divorciado = 1 THEN
            select dpi_mujer into dpi_mujer_div
            from matrimonio m
            order by fecha_matrimonio DESC
            LIMIT 1;

            select p.id, p.nombre1 into id_mujer_div, nombre_d
            from dpi d
                inner join persona p on p.id = d.id_persona
            where d.id = dpi_mujer_div;

            update persona
            set estado_civil = 4
            where id = id_mujer_div;

            select CONCAT('Murio ', nombre_m, ' y ', nombre_d, ' quedo viud@') DEFUNCION;
        end if;
    end if;
end;

call AddDefuncion(3020721280101, '2030-12-24', 'Desaparecio');
select * from persona;


DROP PROCEDURE IF EXISTS addMatrimonio;
CREATE PROCEDURE addMatrimonio( dpi_H BIGINT, dpi_M BIGINT, fecha_m varchar(20))
begin
    declare id_dpi_h int;
    declare id_h int;
    declare e_h int;
    declare id_dpi_m int;
    declare id_m int;
    declare e_m int;

    select d.id, p.id, p.estado_civil into id_dpi_h, id_h, e_h
    from dpi d
    inner join persona p on p.id = d.id_persona
    where p.cui = dpi_H;

    select d.id, p.id, p.estado_civil into id_dpi_m, id_m, e_m
    from dpi d
    inner join persona p on p.id = d.id_persona
    where p.cui = dpi_M;

    IF e_h = 2 or e_m = 2 THEN
        select 'Ambos deben estar solteros antes de casarse';
    ELSE
        insert into matrimonio (fecha_matrimonio, dpi_hombre, dpi_mujer)
        values (STR_TO_DATE(fecha_m, '%Y-%m-%d'), id_dpi_h, id_dpi_m);

        update persona p
        set p.estado_civil = 2
        where p.id = id_h or p.id = id_m;
    END IF;
end;

DROP PROCEDURE IF EXISTS addDivorcio;
CREATE PROCEDURE addDivorcio(fecha_m varchar(20),  id_ma INT)
begin

    declare id_h INT;
    declare id_m INT;

    insert into divorcio (fecha_divorcio, id_matrimonio)
    values (STR_TO_DATE(fecha_m, '%Y-%m-%d'), id_ma);

    select d.id into id_h
    from matrimonio m
    inner join dpi d on d.id = m.dpi_hombre
    inner join persona p on p.id = d.id_persona
    where m.id = id_ma;

    select d.id into id_m
    from matrimonio m
    inner join dpi d on d.id = m.dpi_mujer
    inner join persona p on p.id = d.id_persona
    where m.id = id_ma;

    update persona
    set estado_civil = 3
    where id = id_h or id = id_m;
end;

call AddMatrimonio(3020721280101, 3020721330101, '2026-12-12');
call addDivorcio('2026-12-14', 2);

select * from persona;
select * from defuncion;
select * from estado_civil;
select * from matrimonio;
select * from divorcio;
