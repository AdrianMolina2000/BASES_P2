DROP TABLE IF EXISTS proyecto2.anular;
DROP TABLE IF EXISTS proyecto2.licencia;
DROP TABLE IF EXISTS proyecto2.tipo;
DROP TABLE IF EXISTS proyecto2.divorcio;
DROP TABLE IF EXISTS proyecto2.matrimonio;
ALTER TABLE proyecto2.persona DROP FOREIGN KEY FK_dpi_padre;
ALTER TABLE proyecto2.persona DROP FOREIGN KEY FK_dpi_madre;
DROP TABLE IF EXISTS proyecto2.dpi;
DROP TABLE IF EXISTS proyecto2.defuncion;
DROP TABLE IF EXISTS proyecto2.persona;
DROP TABLE IF EXISTS proyecto2.municipio;
DROP TABLE IF EXISTS proyecto2.departamento;
DROP TABLE IF EXISTS proyecto2.estado_civil;