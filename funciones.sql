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

        select CONCAT('Ha nacido ', primerN, ' ', segundoN, ' ', apellidoP, ' ', apellidoM) AVISO;
    ELSE
        select 'SOLO PUEDEN TENER HIJOS ENTRE GENEROS OPUESTOS' AVISO;
    END IF;
end;


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
    declare muertes int;

    select p.id, p.genero, p.nombre1 into id_per, gene, nombre_m
    from persona p
    where p.cui = dpi_D;

    select d.id into dpi_per
    from dpi d
    inner join persona p on p.id = d.id_persona
    where p.cui = dpi_D;

    select count(*) into muertes
    from defuncion d
    where d.id_persona = id_per;

    IF muertes > 0 THEN
        select 'Solo se puede morir una vez...' AVISO;
    ELSE
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
            ELSE
                select CONCAT('Murio ', nombre_m) DEFUNCION;
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

            ELSE
                select CONCAT('Murio ', nombre_m) DEFUNCION;

            end if;
        END IF;
    END IF;
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
    declare nombre1 varchar(50);
    declare nombre2 varchar(50);
    declare divorcios int;
    declare casados int;


    select count(*) into divorcios
    from divorcio d
    where d.id_matrimonio = id_ma;

    select count(*) into casados
    from matrimonio m
    where m.id = id_ma;

    IF casados = 0 THEN
        select 'ESTE MATRIMONIO NO EXISTE' AVISO;
    ELSE
        IF divorcios > 0 THEN
            select 'YA SE HAN DIVORCIADO DE ESTE MATRIMONIO' AVISO;
        ELSE
            select d.id, p.nombre1 into id_h, nombre1
            from matrimonio m
                inner join dpi d on d.id = m.dpi_hombre
                inner join persona p on p.id = d.id_persona
            where m.id = id_ma;

            select d.id, p.nombre1 into id_m, nombre2
            from matrimonio m
                inner join dpi d on d.id = m.dpi_mujer
                inner join persona p on p.id = d.id_persona
            where m.id = id_ma;

            insert into divorcio (fecha_divorcio, id_matrimonio)
            values (STR_TO_DATE(fecha_m, '%Y-%m-%d'), id_ma);

            update persona
            set estado_civil = 3
            where id = id_h or id = id_m;

            select CONCAT('Se han divorciado ', nombre1, ' y ', nombre2) AVISO;
        END IF;
    END IF;
end;


DROP PROCEDURE IF EXISTS generarDPI;
CREATE PROCEDURE generarDPI(dpi_g BIGINT, fecha_e varchar(50), mun int)
begin

    declare dpis INT;
    declare fecha_n DATE;
    declare lapso INT;
    declare muni INT;
    declare nombre VARCHAR(50);
    declare id_p INT;


    select count(*) into dpis
    from dpi d
    inner join persona p on p.id = d.id_persona
    where p.cui = dpi_g;

    select p.id, p.fecha_nacimiento, p.nombre1 into id_p, fecha_n, nombre
    from persona p
    where cui = dpi_g;

    select TIMESTAMPDIFF(YEAR, fecha_n, fecha_e) into lapso;

    select count(*) into muni
    from municipio m
    where m.id = mun;

    IF dpis > 0 THEN
        select 'Ya existe este DPI' AVISO;
    ELSE
        IF lapso < 18 THEN
            select 'DEBES SER MAYOR DE EDAD PARA TENER DPI' AVISO;
        ELSE
            IF muni = 0 THEN
                select 'ESTE MUNICIPIO NO EXISTE' AVISO;
            ELSE
                insert into dpi (fecha_emision, id_persona, codigo_municipio)
                values (STR_TO_DATE(fecha_e, '%Y-%m-%d'), id_p, mun);

                select CONCAT('Se ha creado el dpi ', dpi_g) AVISO;
            END IF;
        END IF;
    END IF;
end;


DROP PROCEDURE IF EXISTS addLicencia;
CREATE PROCEDURE addLicencia(Cui_g BIGINT, fecha_e varchar(50), tipo_l char(1))
begin

    declare fecha_n DATE;
    declare id_p INT;
    declare nombre VARCHAR(50);
    declare lapso INT;
    declare licen1 INT;
    declare licen2 INT;


    select p.fecha_nacimiento, p.id, p.nombre1 into fecha_n, id_p, nombre
    from persona p
    where p.cui = Cui_g;

    select TIMESTAMPDIFF(YEAR, fecha_n, fecha_e) into lapso;

    select count(*) into licen1
    from licencia l
    inner join persona p on p.id = l.id_persona
    where p.cui = Cui_g and l.tipo_licencia != 5;


    select count(*) into licen2
    from licencia l
    inner join persona p on p.id = l.id_persona
    where p.cui = Cui_g and l.tipo_licencia = 5;

    IF lapso < 16 THEN
        select 'DEBES SER MAYOR A 16 AÑOS PARA OBTENER LICENCIA' AVISO;
    ELSE
        IF licen1 = 0 and tipo_l != 'E' THEN
            IF tipo_l = 'C' THEN
                insert into licencia (fecha_emision, fecha_vencimiento, estado, tipo_licencia, id_persona)
                values (fecha_e, DATE(DATE_ADD(fecha_e, INTERVAL 1 YEAR)), 'C1', 3, id_p);

                select CONCAT('Se ha generado una licencia C para ', nombre) AVISO;

            ELSEIF tipo_l = 'M' THEN
                insert into licencia (fecha_emision, fecha_vencimiento, estado, tipo_licencia, id_persona)
                values (fecha_e, DATE(DATE_ADD(fecha_e, INTERVAL 1 YEAR)), '0', 4, id_p);

                select CONCAT('Se ha generado una licencia M para ', nombre) AVISO;

            ELSEIF tipo_l = 'A' or tipo_l = 'B' THEN
                select 'TU PRIMERA LICENCIA NO PUEDE SER A o B' AVISO;
            ELSE
                select 'ERROR' AVISO;
            END IF;
        ELSEIF tipo_l = 'E' THEN
            IF licen2 = 1 THEN
                select 'NO PUEDES TENER 2 LICENCIAS DEL TIPOS E' AVISO;
            ELSE
                insert into licencia (fecha_emision, fecha_vencimiento, estado, tipo_licencia, id_persona)
                values (fecha_e, DATE(DATE_ADD(fecha_e, INTERVAL 1 YEAR)), '0', 5, id_p);

                select CONCAT('Se ha generado una licencia E para ', nombre) AVISO;
            END IF;
        ELSEIF licen1 > 0 THEN
            select 'NO PUEDES TENER 2 LICENCIAS DEL TIPO C O M' AVISO;
        ELSE
            select 'ERROR' AVISO;
        END IF;
    END IF;
end;


DROP PROCEDURE IF EXISTS renewLicencia;
CREATE PROCEDURE renewLicencia(no_lic INT, fecha_r varchar(50), tipo_l char(1))
begin

    declare fecha_ven DATE;
    declare fecha_anul DATE;
    declare estado_lic CHAR(2);
    declare tip_lic INT;
    declare id_p INT;
    declare lic INT;

    select l.fecha_vencimiento, l.fecha_anulada, l.estado, l.id_persona, l.tipo_licencia into fecha_ven, fecha_anul, estado_lic, id_p, tip_lic
    from licencia l
    where l.id = no_lic;

    select count(*) into lic
    from licencia
    where licencia.id = no_lic;

    IF lic = 0 THEN
        select 'ESTA LICENCIA NO EXISTE' AVISO;
    ELSE
        IF fecha_r > fecha_anul or fecha_anul is null THEN
            IF tipo_l = 'M' THEN
                IF fecha_ven > STR_TO_DATE(fecha_r, '%Y-%m-%d') THEN
                    update licencia
                    set licencia.fecha_vencimiento = DATE_ADD(fecha_vencimiento, INTERVAL 1 YEAR),
                    tipo_licencia = 4
                    where licencia.id = no_lic;
                ELSE
                    update licencia
                    set licencia.fecha_vencimiento = DATE_ADD(STR_TO_DATE(fecha_r, '%Y-%m-%d'), INTERVAL 1 YEAR),
                    tipo_licencia = 4
                    where licencia.id = no_lic;
                END IF;
                select 'Se ha renovado a la licencia M' AVISO;
            ELSEIF tipo_l = 'E' THEN
                IF tip_lic = 5 THEN
                    IF fecha_ven > STR_TO_DATE(fecha_r, '%Y-%m-%d') THEN
                        update licencia
                        set licencia.fecha_vencimiento = DATE_ADD(fecha_vencimiento, INTERVAL 1 YEAR),
                        tipo_licencia = 5
                        where licencia.id = no_lic;
                    ELSE
                        update licencia
                        set licencia.fecha_vencimiento = DATE_ADD(STR_TO_DATE(fecha_r, '%Y-%m-%d'), INTERVAL 1 YEAR),
                        tipo_licencia = 5
                        where licencia.id = no_lic;
                    END IF;
                    select 'Se ha renovado a la licencia E' AVISO;
                ELSE
                    select 'SOLO SE PUEDE RENOVAR UNA LICENCIA E POR UNA DE LA MISMA CLASE' AVISO;
                END IF;
            ELSEIF tipo_l = 'C' THEN
                IF estado_lic = 'C1' THEN
                    IF fecha_ven > STR_TO_DATE(fecha_r, '%Y-%m-%d') THEN
                        update licencia
                        set licencia.fecha_vencimiento = DATE_ADD(fecha_vencimiento, INTERVAL 1 YEAR),
                            estado = 'C2',
                            tipo_licencia = 3
                        where licencia.id = no_lic;
                    ELSE
                        update licencia
                        set licencia.fecha_vencimiento = DATE_ADD(STR_TO_DATE(fecha_r, '%Y-%m-%d'), INTERVAL 1 YEAR),
                            estado = 'C2',
                            tipo_licencia = 3
                        where licencia.id = no_lic;
                    END IF;
                ELSEIF estado_lic = 'C2' THEN
                    IF fecha_ven > STR_TO_DATE(fecha_r, '%Y-%m-%d') THEN
                        update licencia
                        set licencia.fecha_vencimiento = DATE_ADD(fecha_vencimiento, INTERVAL 1 YEAR),
                            estado = 'C3',
                            tipo_licencia = 3
                        where licencia.id = no_lic;
                    ELSE
                        update licencia
                        set licencia.fecha_vencimiento = DATE_ADD(STR_TO_DATE(fecha_r, '%Y-%m-%d'), INTERVAL 1 YEAR),
                            estado = 'C3',
                            tipo_licencia = 3
                        where licencia.id = no_lic;
                    END IF;
                ELSEIF estado_lic = 'C3' THEN
                    IF fecha_ven > STR_TO_DATE(fecha_r, '%Y-%m-%d') THEN
                        update licencia
                        set licencia.fecha_vencimiento = DATE_ADD(fecha_vencimiento, INTERVAL 1 YEAR),
                            estado = 'C4',
                            tipo_licencia = 3
                        where licencia.id = no_lic;
                    ELSE
                        update licencia
                        set licencia.fecha_vencimiento = DATE_ADD(STR_TO_DATE(fecha_r, '%Y-%m-%d'), INTERVAL 1 YEAR),
                            estado = 'C4',
                            tipo_licencia = 3
                        where licencia.id = no_lic;
                    END IF;
                ELSE
                    IF fecha_ven > STR_TO_DATE(fecha_r, '%Y-%m-%d') THEN
                        update licencia
                        set licencia.fecha_vencimiento = DATE_ADD(fecha_vencimiento, INTERVAL 1 YEAR),
                            estado = 'C3',
                            tipo_licencia = 3
                        where licencia.id = no_lic;
                    ELSE
                        update licencia
                        set licencia.fecha_vencimiento = DATE_ADD(STR_TO_DATE(fecha_r, '%Y-%m-%d'), INTERVAL 1 YEAR),
                            estado = 'C3',
                            tipo_licencia = 3
                        where licencia.id = no_lic;
                    END IF;
                END IF;
                select 'Se ha renovado a la licencia C' AVISO;
            ELSEIF tipo_l = 'B' THEN
                IF estado_lic = 'C3' or estado_lic = 'A' THEN
                    update licencia
                    set licencia.fecha_vencimiento = DATE_ADD(STR_TO_DATE(fecha_r, '%Y-%m-%d'), INTERVAL 1 YEAR),
                        estado = 'B',
                        tipo_licencia = 2
                    where licencia.id = no_lic;

                    select 'Se ha renovado la licencia B' AVISO;
                ELSE
                    select 'AUN NO SE PUEDE CREAR UNA LICENCIA TIPO B' AVISO;
                END IF;
            ELSEIF tipo_l = 'A' THEN
                IF estado_lic = 'C4' or estado_lic = 'B' THEN
                    update licencia
                    set licencia.fecha_vencimiento = DATE_ADD(STR_TO_DATE(fecha_r, '%Y-%m-%d'), INTERVAL 1 YEAR),
                        estado = 'A',
                        tipo_licencia = 1
                    where licencia.id = no_lic;

                    select 'Se ha renovado la licencia A' AVISO;
                ELSE
                    select 'AUN NO SE PUEDE CREAR UNA LICENCIA TIPO A' AVISO;
                END IF;
            ELSE
                select 'LICENCIA NO VALIDA' AVISO;
            END IF;
        ELSE
            select 'NO SE PUEDE RENOVAR MIENTRAS ESTA ANULADA' AVISO;
        END IF;
    END IF;
end;


DROP PROCEDURE IF EXISTS anularLicencia;
CREATE PROCEDURE anularLicencia(no_lic INT, fecha_a varchar(50), motivo varchar(200))
begin
    declare lic INT;
    declare anu INT;

    select count(*) into lic
    from licencia l
    where l.id = no_lic;

    select count(*) into anu
    from anular a
    where a.id_licencia = no_lic;

    IF lic = 0 THEN
        select 'ESTA LICENCIA NO EXISTE' AVISO;
    ELSE
        IF anu > 0 THEN
            insert into anular (fecha_anulacion, motivo, id_licencia)
            values (STR_TO_DATE(fecha_a, '%Y-%m-%d'), motivo, no_lic);

            update licencia
            set fecha_anulada =  DATE(DATE_ADD(fecha_a, INTERVAL 2 YEAR))
            where licencia.id = no_lic;

            select CONCAT('Se anulo de nuevo la licencia NO.', no_lic) AVISO;
        ELSE
            insert into anular (fecha_anulacion, motivo, id_licencia)
            values (STR_TO_DATE(fecha_a, '%Y-%m-%d'), motivo, no_lic);

            update licencia
            set fecha_anulada =  DATE(DATE_ADD(fecha_a, INTERVAL 2 YEAR))
            where licencia.id = no_lic;

            select CONCAT('Se anulo la licencia NO.', no_lic) AVISO;
        END IF;
    END IF;
end;


