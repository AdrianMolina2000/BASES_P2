call addNacimiento(3020721280101, 3020721290101, 'Adrian', 'Alejandro', null, '2028-10-20', 101, 'M');

call AddMatrimonio(3020721280101, 3020721290101, '2026-12-12');
call addDivorcio('2026-12-14', 1);
call AddMatrimonio(3020721280101, 3020721310101, '2026-12-15');
call AddMatrimonio(3020721320101, 3020721290101, '2026-12-18');

call AddDefuncion(3020721330101, '2030-12-24', 'Desaparecio');
call AddDefuncion(3020721320101, '2030-12-26', 'Desaparecio');

select * from persona;
select * from defuncion;
select * from estado_civil;
select * from matrimonio;
select * from divorcio;
select * from dpi;
select * from tipo;
select * from licencia;

call AddMatrimonio(3020721340101, 3020721310101, '2026-12-18');
call addDivorcio('2026-12-14', 4);

call generarDPI(3020721340101, '2046-10-20', 101);
call addLicencia(3020721280101, '2020-10-20', 'E');