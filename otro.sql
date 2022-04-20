call addNacimiento(3020721280101, 3020721290101, 'Adrian', 'Alejandro', null, '2028-10-20', 101, 'M');
call AddDefuncion(3020721290101, '2030-12-24', 'Desaparecio');

call AddMatrimonio(3020721280101, 3020721290101, '2026-12-12');
call addDivorcio('2026-12-14', 1);
call AddMatrimonio(3020721280101, 3020721310101, '2026-12-14');

select * from persona;
select * from defuncion;
select * from estado_civil;
select * from matrimonio;
select * from divorcio;