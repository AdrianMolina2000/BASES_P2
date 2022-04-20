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



/*
 CREO QUE LE FALTAN VALIDACIONES
 */
DROP PROCEDURE IF EXISTS AddDefuncion;
CREATE PROCEDURE AddDefuncion( dpi_D BIGINT, fecha_d varchar(20), motivo_m varchar(200))
begin
    declare id_per int;
    declare dpi_per int;
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

    select d.id into dpi_per
    from dpi d
    inner join persona p on p.id = d.id_persona
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
            where m.dpi_hombre = dpi_per
            order by fecha_matrimonio DESC
            LIMIT 1;

            select p.id, p.nombre1 into id_mujer_div, nombre_d
            from dpi d
                inner join persona p on p.id = d.id_persona
            where d.id = dpi_mujer_div;

            update persona
            set estado_civil = 4
            where id = id_mujer_div;

            select CONCAT('Murio ', nombre_m, ' y ', nombre_d, ' quedo viuda') DEFUNCION;
        end if;
    ELSEIF gene = 'F' THEN
        select count(*) into casada
        from matrimonio m
            inner join dpi d on d.id = m.dpi_mujer
            inner join persona p on p.id = d.id_persona
        where p.cui = dpi_D;

        select count(*) into divorciada
        from divorcio di
            inner join matrimonio m on m.id = di.id_matrimonio
            inner join dpi d on d.id_persona = m.dpi_mujer
            inner join persona p on p.id = d.id_persona
        where p.cui = dpi_D;

        IF casada - divorciada = 1 THEN
            select dpi_hombre into dpi_hombre_div
            from matrimonio m
            where m.dpi_mujer = dpi_per
            order by fecha_matrimonio DESC
            LIMIT 1;

            select p.id, p.nombre1 into id_hombre_div, nombre_d
            from dpi d
                inner join persona p on p.id = d.id_persona
            where d.id = dpi_hombre_div;

            update persona
            set estado_civil = 4
            where id = id_hombre_div;

            select CONCAT('Murio ', nombre_m, ' y ', nombre_d, ' quedo viudo') DEFUNCION;
        end if;
    end if;
end;


DROP PROCEDURE IF EXISTS addMatrimonio;
CREATE PROCEDURE addMatrimonio( dpi_H BIGINT, dpi_M BIGINT, fecha_m varchar(20))
begin
    declare id_dpi_h int;
    declare id_h int;
    declare e_h int;
    declare gen_h char(1);
    declare nombre1 varchar(50);
    declare id_dpi_m int;
    declare id_m int;
    declare e_m int;
    declare gen_m char(1);
    declare nombre2 varchar(50);
    declare dpi_exist1 int;
    declare dpi_exist2 int;
    declare muerto1 int;
    declare muerto2 int;

    select count(*) into dpi_exist1
    from dpi d
    inner join persona p on p.id = d.id_persona
    where p.cui = dpi_H;

    select count(*) into dpi_exist2
    from dpi d
    inner join persona p on p.id = d.id_persona
    where p.cui = dpi_M;

    select d.id, p.id, p.estado_civil, p.genero, p.nombre1 into id_dpi_h, id_h, e_h, gen_h, nombre1
    from dpi d
    inner join persona p on p.id = d.id_persona
    where p.cui = dpi_H;

    select d.id, p.id, p.estado_civil, p.genero, p.nombre1 into id_dpi_m, id_m, e_m, gen_m, nombre2
    from dpi d
    inner join persona p on p.id = d.id_persona
    where p.cui = dpi_M;

    select count(*) into muerto1
    from defuncion d
    where d.id_persona = id_h;

    select count(*) into muerto2
    from defuncion d
    where d.id_persona = id_m;

    IF dpi_exist1 > 0 and dpi_exist2 > 0 THEN
        IF e_h = 2 or e_m = 2 or e_h = 4 or e_m = 4 THEN
            select 'Ambos deben estar solteros antes de casarse' AVISO;
        ELSE
            IF gen_h = 'M' and gen_m = 'F' THEN
                IF muerto1 > 0 or muerto2 > 0 THEN
                    select 'NO PUEDES CASARTE CON UN MUERTO' AVISO;
                ELSE
                    insert into matrimonio (fecha_matrimonio, dpi_hombre, dpi_mujer)
                    values (STR_TO_DATE(fecha_m, '%Y-%m-%d'), id_dpi_h, id_dpi_m);

                    update persona p
                    set p.estado_civil = 2
                    where p.id = id_h or p.id = id_m;

                    select CONCAT('Se han casado ', nombre1, ' y ', nombre2) AVISO;
                END IF;
            ELSE
                select 'Deben ser del genero opuesto para poder casarse' AVISO;
            END IF;
        END IF;
    ELSE
        select 'Ambos deben poseer DPI para casarse' AVISO;
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