CREATE TABLE proyecto2.estado_civil (
  id INT NOT NULL AUTO_INCREMENT,
  estado VARCHAR(12) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE proyecto2.departamento (
  id INT NOT NULL AUTO_INCREMENT,
  departamento VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE proyecto2.municipio (
  id INT NOT NULL,
  municipio VARCHAR(50) NOT NULL,
  id_departamento INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY(id_departamento) REFERENCES departamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE proyecto2.persona (
  id INT NOT NULL AUTO_INCREMENT,
  cui BIGINT NOT NULL UNIQUE,
  dpi_padre INT NULL,
  dpi_madre INT NULL,
  nombre1 VARCHAR(50) NOT NULL,
  nombre2 VARCHAR(50) NULL,
  nombre3 VARCHAR(50) NULL,
  apellido1 VARCHAR(50) NOT NULL,
  apellido2 VARCHAR(50) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  genero CHAR(1) NOT NULL,
  estado_civil INT NOT NULL,
  codigo_municipio INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY(estado_civil) REFERENCES estado_civil(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(codigo_municipio) REFERENCES municipio(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE proyecto2.defuncion (
  id INT NOT NULL AUTO_INCREMENT,
  fecha_fallecimiento DATE NOT NULL,
  motivo VARCHAR(200) NOT NULL,
  id_persona INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY(id_persona) REFERENCES persona(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE proyecto2.dpi (
  id INT NOT NULL AUTO_INCREMENT,
  fecha_emision DATE NOT NULL,
  id_persona INT NOT NULL,
  codigo_municipio INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY(id_persona) REFERENCES persona(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(codigo_municipio) REFERENCES municipio(id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE proyecto2.persona
ADD CONSTRAINT FK_dpi_padre FOREIGN KEY(dpi_padre) REFERENCES dpi(id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_dpi_madre FOREIGN KEY(dpi_madre) REFERENCES dpi(id) ON DELETE CASCADE ON UPDATE CASCADE
;

CREATE TABLE proyecto2.matrimonio (
  id INT NOT NULL AUTO_INCREMENT,
  fecha_matrimonio DATE NOT NULL,
  dpi_hombre INT NOT NULL,
  dpi_mujer INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY(dpi_hombre) REFERENCES persona(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(dpi_mujer) REFERENCES persona(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE proyecto2.divorcio (
  id INT NOT NULL AUTO_INCREMENT,
  fecha_divorcio DATE NOT NULL,
  id_matrimonio INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY(id_matrimonio) REFERENCES matrimonio(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE proyecto2.tipo (
  id INT NOT NULL AUTO_INCREMENT,
  estado CHAR(1) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE proyecto2.licencia (
  id INT NOT NULL AUTO_INCREMENT,
  fecha_emision DATE NOT NULL,
  fecha_vencimiento DATE NOT NULL,
  estado INT NOT NULL,
  tipo_licencia INT NOT NULL,
  id_persona INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY(tipo_licencia) REFERENCES tipo(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(id_persona) REFERENCES persona(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE proyecto2.anular (
  id INT NOT NULL AUTO_INCREMENT,
  fecha_anulacion DATE NOT NULL,
  motivo VARCHAR(200) NOT NULL,
  id_licencia INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY(id_licencia) REFERENCES licencia(id) ON DELETE CASCADE ON UPDATE CASCADE
);