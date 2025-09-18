create database if not exists CoworkingDB2;
use CoworkingDB2;

-- Tablas de catálogos
CREATE TABLE estados_membresia (
    id_estado_membresia INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE tipos_membresia (
    id_tipo_membresia INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE tipos_espacios (
    id_tipo_espacio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE estados_reserva (
    id_estado_reserva INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE metodos_pago (
    id_metodo_pago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE estados_pago (
    id_estado_pago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE metodos_acceso (
    id_metodo_acceso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE estados_factura (
    id_estado_factura INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE tipos_soporte (
    id_tipo_soporte INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tablas principales
CREATE TABLE empresas (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    nit VARCHAR(50) UNIQUE,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    identificacion VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    id_empresa INT NULL,
    FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa)
);
ALTER TABLE usuarios ADD COLUMN activo BOOLEAN DEFAULT TRUE;

CREATE TABLE membresias (
    id_membresia INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_tipo_membresia INT NOT NULL,
    id_estado_membresia INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_tipo_membresia) REFERENCES tipos_membresia(id_tipo_membresia),
    FOREIGN KEY (id_estado_membresia) REFERENCES estados_membresia(id_estado_membresia)
);

CREATE TABLE renovaciones (
    id_renovacion INT AUTO_INCREMENT PRIMARY KEY,
    id_membresia INT NOT NULL,
    fecha_renovacion DATE NOT NULL,
    FOREIGN KEY (id_membresia) REFERENCES membresias(id_membresia)
);

CREATE TABLE espacios (
    id_espacio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_tipo_espacio INT NOT NULL,
    capacidad INT NOT NULL,
    horario_disponible VARCHAR(100),
    FOREIGN KEY (id_tipo_espacio) REFERENCES tipos_espacios(id_tipo_espacio)
);

CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_espacio INT NOT NULL,
    id_estado_reserva INT NOT NULL,
    numero_asistentes INT DEFAULT 1,
    asistio BOOLEAN DEFAULT false,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_espacio) REFERENCES espacios(id_espacio),
    FOREIGN KEY (id_estado_reserva) REFERENCES estados_reserva(id_estado_reserva)
);

CREATE TABLE reserva_asistentes (
    id_asistente INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    nombre_asistente VARCHAR(100),
    identificacion VARCHAR(50),
    hora_ingreso TIME,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
);

CREATE TABLE servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE usuario_servicio (
    id_usuario_servicio INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_servicio INT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
);

CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    concepto VARCHAR(100),
    id_metodo_pago INT NOT NULL,
    id_estado_pago INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_metodo_pago) REFERENCES metodos_pago(id_metodo_pago),
    FOREIGN KEY (id_estado_pago) REFERENCES estados_pago(id_estado_pago)
);

CREATE TABLE facturas (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_reserva INT NULL,
    id_membresia INT NULL,
    id_pago INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_pago_oportuno DATETIME,
    total DECIMAL(10,2) NOT NULL,
    id_estado_factura INT NOT NULL,
    motivo_cancelacion VARCHAR(255) NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva),
    FOREIGN KEY (id_membresia) REFERENCES membresias(id_membresia),
    FOREIGN KEY (id_pago) REFERENCES pagos(id_pago),
    FOREIGN KEY (id_estado_factura) REFERENCES estados_factura(id_estado_factura)
);

CREATE TABLE accesos (
    id_acceso INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha DATE NOT NULL,
    hora_entrada TIME,
    hora_salida TIME,
    id_metodo_acceso INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_metodo_acceso) REFERENCES metodos_acceso(id_metodo_acceso)
);

CREATE TABLE reserva_servicio (
    id_reserva_servicio INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_servicio INT NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva),
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
);

-- Tablas de logs
CREATE TABLE log_membresias (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    accion VARCHAR(100) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE log_reservas (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    accion VARCHAR(100) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
);

CREATE TABLE log_pagos (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_pago INT NOT NULL,
    accion VARCHAR(100) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pago) REFERENCES pagos(id_pago)
);

CREATE TABLE log_accesos (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    accion VARCHAR(100) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);
CREATE TABLE reporte_ocupacion (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    total_reservas INT NOT NULL,
    total_usuarios INT NOT NULL,
    ocupacion_promedio DECIMAL(5,2) NOT NULL
);

CREATE TABLE estadisticas_espacios (
    id_estadistica INT AUTO_INCREMENT PRIMARY KEY,
    id_espacio INT NOT NULL,
    semana INT NOT NULL,
    total_reservas INT NOT NULL,
    horas_uso INT NOT NULL,
    FOREIGN KEY (id_espacio) REFERENCES espacios(id_espacio)
);
