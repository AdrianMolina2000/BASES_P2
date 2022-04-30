-- Los fundadores crean el sistema DPI.
call generarDPI(3020721280101,'2000-01-10',101); -- obtiene dpi al cumplir 20 anios
call generarDPI(3020721330101,'2010-04-02',101); -- obtiene dpi al cumplir 20 anios

-- Los fundadores ahora tienen dpi y comienzan una familias.
call addMatrimonio(3020721280101,3020721330101, '2015-05-04');

-- Los fundadores tienen gemelos luego de casarse.
call addNacimiento(3020721280101,3020721330101,'Estuardo','Geovanni',null,'2015-12-21',101,'M');
call addNacimiento(3020721280101,3020721330101,'Emma','Isabella',null,'2015-12-21',101,'F');

-- Los fundadores mueren.
call AddDefuncion(3020721280101, '2035-10-02', 'Murio por una enfermedad');
call AddDefuncion(3020721330101, '2035-10-02', 'Murio de soledad');



-- Fundadores menos inteligentes
call generarDPI(3020721290101,'1998-09-11',108); -- obtiene dpi al cumplir 20 anios

-- Intentan tener hijos siendo menores de edad, pero la matrix lo impide
call addNacimiento(3020721290101,3020721340101,'Lucas',null,null,'2007-09-12',101,'M');

-- Intentan casarse siendo menores de edad, pero el sistema dpi no los deja.
call addMatrimonio(3020721290101,3020721340101, '2007-10-01');

call generarDPI(3020721340101,'2008-02-07',2102); -- obtiene dpi al cumplir 20 anios

-- Se divorcian un dia antes de casarse.
call addDivorcio('2008-02-07', 2);

-- Se casan luego de sacar el dpi de ella.
call addMatrimonio(3020721290101,3020721340101, '2008-02-08');

-- Nace un hijo pero no le ponen nombres y la matrix lo borra.
call addNacimiento(3020721290101,3020721340101,null,null,null,'2010-8-12',101,'M');

-- Nace un hijo con un solo nombre, ya que los padres no tienen imaginacion.
call addNacimiento(3020721290101,3020721340101,'Lucas',null,null,'2010-8-12',101,'M');

-- Se quieren volver a casar para tener otro hijo.
call addMatrimonio(3020721290101,3020721340101, '2008-02-08');

-- Se divorcian para volver a casarse.
call addDivorcio('2008-02-08', 2);

-- Se divorcian de nuevo para asegurarse.
call addDivorcio('2008-02-08', 2);

-- Se divorcian un dia antes de casarse.
call addDivorcio('2008-02-07', 2);

-- Crean un acta de defuncion equivocada porque se confundieron de cui
call AddDefuncion(30207221290101, '2035-10-02', 'Murio feliz');

-- Crean de nuevo un acta de defuncion equivocada porque se confundieron de fecha
call AddDefuncion(3020721290101, '1978-09-10', 'Murio feliz');

-- Esta vez si muere de verdad
call AddDefuncion(3020721290101, '2030-10-02', 'Murio por beber gasolina');

-- Crean el acta 2 veces para asegurarse
call AddDefuncion(3020721290101, '2030-10-02', 'Murio por beber gasolina');
call AddDefuncion(3020721340101, '2030-10-02', 'Murio por fumar en una gasolinera con su hijo');
call AddDefuncion(3020721400101, '2030-10-02', 'Tuvo la desgracia de tener a con poca inteligencia');





-- Los demas fundadores no quieren hijos.
call generarDPI(3020721300101, '1998-08-16', 101); -- Al cumplir 19 anios
call generarDPI(3020721350101, '2010-05-12', 101); -- Al cumplir 20 anios

-- Se Casan y se divorcian al mes siguiente
call addMatrimonio(3020721300101,3020721350101, '2015-02-08');
call addDivorcio('2015-03-08', 3);


call generarDPI(3020721310101, '2002-05-10', 1601); -- Al cumplir 20 anios
call generarDPI(3020721360101, '2005-06-21', 2102); -- Al cumplir 20 anios
call generarDPI(3020721360101, '2006-06-21', 2102); -- Al cumplir 21 intenta generarlo de nuevo

-- Se Casan y se divorcian al mes siguiente
call addMatrimonio(3020721310101,3020721360101, '2014-02-08');
call addDivorcio('2014-03-08', 4);

call generarDPI(3020721320101, '2008-03-12', 1228); -- Al cumplir 20 anios
call generarDPI(3020721370101, '2014-12-22', 108); -- Al cumplir 16 anios y no lo genera
call generarDPI(3020721370101, '2016-12-22', 108); -- Al cumplir 18 anios

-- Se Casan y se divorcian al mes siguiente
call addMatrimonio(3020721320101,3020721370101, '2014-02-08');
call addDivorcio('2014-03-08', 5);


-- intentan casarse con otras personas.
call addMatrimonio(3020721310101,3020721350101, '2025-02-08');
call addDivorcio('2025-03-08', 6);
call addMatrimonio(3020721300101,3020721360101, '2024-02-08');
call addDivorcio('2024-03-08', 7);
call addMatrimonio(3020721310101,3020721370101, '2024-02-08');
call addDivorcio('2024-03-08', 8);
call addMatrimonio(3020721300101,3020721360101, '2024-02-08');
call addDivorcio('2024-03-08', 9);
call addMatrimonio(3020721310101,3020721350101, '2025-02-08');
call addDivorcio('2025-03-08', 10);


select * from persona;
select * from defuncion;
select * from dpi;
select * from matrimonio;
select * from divorcio;
select * from licencia;
select * from anular;
select * from estado_civil;
