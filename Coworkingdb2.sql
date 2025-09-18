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


-- Insercion de datos

-- Estados Membresias 
INSERT INTO estados_membresia (nombre) VALUES 
('Activa'), 
('Suspendida'), 
('Vencida');

-- Tipos de membresias 
INSERT INTO tipos_membresia (nombre, descripcion, precio) VALUES
('Diaria', 'Acceso por un día completo', 20000),
('Mensual', 'Acceso ilimitado por 30 días', 300000),
('Corporativa', 'Plan empresarial con múltiples empleados', 1000000),
('Premium', 'Acceso 24/7 con servicios incluidos', 500000);

-- Tipos de espacios 
INSERT INTO tipos_espacios (nombre) VALUES
('Escritorio'),
('Oficina Privada'),
('Sala Reuniones'),
('Sala Eventos');

-- Estados de reserva
INSERT INTO estados_reserva (nombre) VALUES
('Pendiente'),
('Confirmada'),
('Cancelada');

-- Metodo de pago 
INSERT INTO metodos_pago (nombre) VALUES
('Efectivo'),
('Tarjeta'),
('Transferencia'),
('PayPal');

-- Estado de pago
INSERT INTO estados_pago (nombre) VALUES
('Pagado'),
('Pendiente'),
('Cancelado');

-- Metodos de acceso
INSERT INTO metodos_acceso (nombre) VALUES
('RFID'),
('QR');

-- Estados de factura 
INSERT INTO estados_factura (nombre) VALUES
('Pagada'),
('Pendiente'),
('Cancelada'),
('Vencida');

-- Tipos de soporte 
INSERT INTO tipos_soporte (nombre) VALUES
('General'),
('Técnico'),
('Facturación');

-- Empresas 
INSERT INTO empresas (nombre, direccion, nit, contacto, telefono, email) VALUES
('Tech Solutions SAS', 'Calle 123 #45-67, Bogotá', '900123456-1', 'Juan Pérez', '3101234567', 'contacto@techsolutions.com'),
('Marketing Group LTDA', 'Cra 45 #12-34, Medellín', '901987654-2', 'Ana Gómez', '3119876543', 'info@marketinggroup.com'),
('InnovaCorp', 'Av. Siempre Viva 742, Cali', '902555333-3', 'Carlos Ruiz', '3005553333', 'hola@innovacorp.co'),
('SoftDev S.A.', 'Cra 50 #80-12, Barranquilla', '903111444-4', 'Luis Mendoza', '3204445566', 'ventas@softdev.com'),
('EcoEnergy LTDA', 'Calle 10 #20-30, Bogotá', '904222555-5', 'Paula Silva', '3106667788', 'info@ecoenergy.com'),
('AgroFuturo SAS', 'Km 5 vía Palmira, Cali', '905333666-6', 'David Rojas', '3017778899', 'contacto@agrofuturo.co'),
('FinanzasPlus', 'Carrera 12 #45-78, Medellín', '906444777-7', 'Marta Díaz', '3028889900', 'soporte@finanzasplus.com'),
('LogistiCo', 'Av. del Puerto 123, Cartagena', '907555888-8', 'Felipe Torres', '3009991122', 'info@logistico.com'),
('Digital World SAS', 'Cl. 34 #7-98, Bogotá', '908666999-9', 'Lucía Moreno', '3121239876', 'contacto@digitalworld.co'),
('Meditech LTDA', 'Cra 20 #34-12, Cali', '909777111-0', 'Javier Castillo', '3103216547', 'ventas@meditech.co'),
('Construcciones Andinas', 'Av. 68 #45-20, Bogotá', '910888222-1', 'Andrés Jiménez', '3134567890', 'info@andinas.com'),
('Viajes Global', 'Calle 45 #10-23, Medellín', '911999333-2', 'Carolina López', '3149876543', 'contacto@viajesglobal.com'),
('ElectroMax', 'Cra 70 #80-90, Barranquilla', '912111444-3', 'Daniel Ortiz', '3151112233', 'ventas@electromax.com'),
('ModaUrbana', 'Cl. 56 #23-45, Bogotá', '913222555-4', 'Sofía Ramírez', '3164445566', 'info@modaurbana.com'),
('GreenTech', 'Av. 15 #33-12, Cali', '914333666-5', 'Fernando Álvarez', '3177778899', 'contacto@greentech.co'),
('DataCorp Solutions', 'Calle 85 #15-25, Bogotá', '915444777-6', 'Ricardo Valle', '3201234567', 'info@datacorp.com'),
('StartUp Hub', 'Cra 11 #93-45, Bogotá', '916555888-7', 'Camila Torres', '3212345678', 'hello@startuphub.co'),
('Creative Agency', 'Cl 67 #5-23, Medellín', '917666999-8', 'Diego Morales', '3223456789', 'contact@creative.com'),
('Tech Unicorn', 'Av 19 #104-35, Bogotá', '918777000-9', 'Valentina Cruz', '3234567890', 'team@techunicorn.com'),
('Global Consulting', 'Cra 15 #72-18, Medellín', '919888111-0', 'Andrés Patiño', '3245678901', 'info@global.com');

-- Usuarios coorporativos 
INSERT INTO usuarios (identificacion, nombre, apellidos, fecha_nacimiento, telefono, email, id_empresa) VALUES
('1001', 'Andrés', 'García', '1985-05-12', '3100000001', 'andres.garcia@mail.com', 1),
('1002', 'María', 'López', '1990-08-25', '3100000002', 'maria.lopez@mail.com', 2),
('1003', 'Carlos', 'Pérez', '1982-01-15', '3100000003', 'carlos.perez@mail.com', 3),
('1004', 'Luisa', 'Martínez', '1995-11-20', '3100000004', 'luisa.martinez@mail.com', 4),
('1005', 'Jorge', 'Ramírez', '1988-07-08', '3100000005', 'jorge.ramirez@mail.com', 5),
('1006', 'Ana', 'Torres', '1992-03-03', '3100000006', 'ana.torres@mail.com', 6),
('1007', 'Felipe', 'Moreno', '1980-12-01', '3100000007', 'felipe.moreno@mail.com', 7),
('1008', 'Camila', 'Hernández', '1993-09-09', '3100000008', 'camila.hernandez@mail.com', 8),
('1009', 'Daniel', 'Castro', '1986-06-18', '3100000009', 'daniel.castro@mail.com', 9),
('1010', 'Paola', 'Vargas', '1991-04-27', '3100000010', 'paola.vargas@mail.com', 10),
('1011', 'Santiago', 'Jiménez', '1984-10-10', '3100000011', 'santiago.jimenez@mail.com', 11),
('1012', 'Valentina', 'Ríos', '1996-01-22', '3100000012', 'valentina.rios@mail.com', 12),
('1013', 'Ricardo', 'Méndez', '1989-05-05', '3100000013', 'ricardo.mendez@mail.com', 13),
('1014', 'Diana', 'Suárez', '1994-07-19', '3100000014', 'diana.suarez@mail.com', 14),
('1015', 'Sebastián', 'Ortiz', '1983-02-14', '3100000015', 'sebastian.ortiz@mail.com', 15),
('1016', 'Natalia', 'Ruiz', '1992-06-30', '3100000016', 'natalia.ruiz@mail.com', 16),
('1017', 'David', 'Cortés', '1987-09-25', '3100000017', 'david.cortes@mail.com', 17),
('1018', 'Carolina', 'Reyes', '1991-11-11', '3100000018', 'carolina.reyes@mail.com', 18),
('1019', 'Julián', 'Álvarez', '1985-03-28', '3100000019', 'julian.alvarez@mail.com', 19),
('1020', 'Laura', 'Gómez', '1990-12-12', '3100000020', 'laura.gomez@mail.com', 20),
('1021', 'Martín', 'Delgado', '1988-08-16', '3100000021', 'martin.delgado@mail.com', 1),
('1022', 'Tatiana', 'Cruz', '1993-07-21', '3100000022', 'tatiana.cruz@mail.com', 2),
('1023', 'Óscar', 'Molina', '1981-02-02', '3100000023', 'oscar.molina@mail.com', 3),
('1024', 'Viviana', 'Ramírez', '1995-05-14', '3100000024', 'viviana.ramirez@mail.com', 4),
('1025', 'Mauricio', 'Cardona', '1986-06-06', '3100000025', 'mauricio.cardona@mail.com', 5);


-- Usuarios independientes 
INSERT INTO usuarios (identificacion, nombre, apellidos, fecha_nacimiento, telefono, email, id_empresa) VALUES
('2001', 'Andrea', 'Silva', '1992-02-02', '3200000001', 'andrea.silva@mail.com', NULL),
('2002', 'Fernando', 'Gutiérrez', '1987-03-15', '3200000002', 'fernando.gutierrez@mail.com', NULL),
('2003', 'Marcela', 'Duarte', '1995-06-30', '3200000003', 'marcela.duarte@mail.com', NULL),
('2004', 'Iván', 'Sánchez', '1984-01-10', '3200000004', 'ivan.sanchez@mail.com', NULL),
('2005', 'Claudia', 'Peña', '1991-12-20', '3200000005', 'claudia.pena@mail.com', NULL),
('2006', 'Andrés', 'Muñoz', '1986-08-08', '3200000006', 'andres.munoz@mail.com', NULL),
('2007', 'Marisol', 'Castaño', '1990-11-25', '3200000007', 'marisol.castano@mail.com', NULL),
('2008', 'Jhon', 'Perdomo', '1983-05-05', '3200000008', 'jhon.perdomo@mail.com', NULL),
('2009', 'Sofía', 'Morales', '1994-09-19', '3200000009', 'sofia.morales@mail.com', NULL),
('2010', 'Esteban', 'Vargas', '1989-07-07', '3200000010', 'esteban.vargas@mail.com', NULL),
('2011', 'Ángela', 'Londoño', '1993-03-03', '3200000011', 'angela.londono@mail.com', NULL),
('2012', 'Henry', 'Serrano', '1985-04-18', '3200000012', 'henry.serrano@mail.com', NULL),
('2013', 'Camilo', 'Pardo', '1990-02-22', '3200000013', 'camilo.pardo@mail.com', NULL),
('2014', 'Liliana', 'Mora', '1988-06-06', '3200000014', 'liliana.mora@mail.com', NULL),
('2015', 'Rafael', 'Cifuentes', '1982-10-10', '3200000015', 'rafael.cifuentes@mail.com', NULL),
('2016', 'Juliana', 'Martínez', '1996-08-08', '3200000016', 'juliana.martinez@mail.com', NULL),
('2017', 'Diego', 'Salazar', '1987-09-09', '3200000017', 'diego.salazar@mail.com', NULL),
('2018', 'Isabel', 'Ardila', '1991-01-01', '3200000018', 'isabel.ardila@mail.com', NULL),
('2019', 'Mateo', 'Quiroga', '1989-02-14', '3200000019', 'mateo.quiroga@mail.com', NULL),
('2020', 'Patricia', 'Forero', '1986-04-04', '3200000020', 'patricia.forero@mail.com', NULL),
('2021', 'Harold', 'Soto', '1992-09-21', '3200000021', 'harold.soto@mail.com', NULL),
('2022', 'Yolanda', 'Mejía', '1984-07-17', '3200000022', 'yolanda.mejia@mail.com', NULL),
('2023', 'César', 'Beltrán', '1995-11-11', '3200000023', 'cesar.beltran@mail.com', NULL),
('2024', 'Gloria', 'Castillo', '1983-12-31', '3200000024', 'gloria.castillo@mail.com', NULL),
('2025', 'Wilson', 'Prada', '1988-05-15', '3200000025', 'wilson.prada@mail.com', NULL);

-- Membresias activas 
INSERT INTO membresias (id_usuario, id_tipo_membresia, id_estado_membresia, fecha_inicio, fecha_fin) VALUES
(1, 2, 1, '2025-08-01', '2025-08-31'),
(2, 4, 1, '2025-08-15', '2025-09-15'),
(3, 3, 1, '2025-07-01', '2025-10-01'),
(4, 1, 1, '2025-09-10', '2025-09-10'),
(5, 2, 1, '2025-08-01', '2025-08-31'),
(6, 2, 1, '2025-08-01', '2025-08-31'),
(7, 4, 1, '2025-07-15', '2025-09-15'),
(8, 3, 1, '2025-06-01', '2025-09-01'),
(9, 1, 1, '2025-09-05', '2025-09-05'),
(10, 4, 1, '2025-08-20', '2025-09-20');

-- Membresias suspendidas 
INSERT INTO membresias (id_usuario, id_tipo_membresia, id_estado_membresia, fecha_inicio, fecha_fin) VALUES
(11, 2, 2, '2025-06-01', '2025-06-30'),
(12, 4, 2, '2025-07-01', '2025-07-31'),
(13, 1, 2, '2025-08-15', '2025-08-15'),
(14, 3, 2, '2025-05-01', '2025-08-01'),
(15, 2, 2, '2025-09-01', '2025-09-30');

-- Membresias Vencidas
INSERT INTO membresias (id_usuario, id_tipo_membresia, id_estado_membresia, fecha_inicio, fecha_fin) VALUES
(16, 4, 3, '2024-01-01', '2024-12-31'),
(17, 2, 3, '2024-06-01', '2024-06-30'),
(18, 1, 3, '2024-07-15', '2024-07-15'),
(19, 3, 3, '2023-09-01', '2024-03-01'),
(20, 2, 3, '2024-11-01', '2024-11-30');

-- Membresisas que vencen en 7 dias 
INSERT INTO membresias (id_usuario, id_tipo_membresia, id_estado_membresia, fecha_inicio, fecha_fin) VALUES
(21, 2, 1, '2025-08-20', '2025-09-19'),
(22, 3, 1, '2025-07-20', '2025-09-18'),
(23, 4, 1, '2025-08-01', '2025-09-19');

-- Usuario con multiples renovaciones 
INSERT INTO membresias (id_usuario, id_tipo_membresia, id_estado_membresia, fecha_inicio, fecha_fin) VALUES
(24, 1, 1, '2025-09-01', '2025-09-01'),
(24, 1, 3, '2025-08-31', '2025-08-31'),
(24, 1, 3, '2025-08-30', '2025-08-30'),
(24, 1, 3, '2025-08-29', '2025-08-29'),
(24, 1, 3, '2025-08-28', '2025-08-28'),
(24, 1, 3, '2025-08-27', '2025-08-27'),
(24, 1, 3, '2025-08-26', '2025-08-26'),
(24, 1, 3, '2025-08-25', '2025-08-25'),
(24, 1, 3, '2025-08-24', '2025-08-24'),
(24, 1, 3, '2025-08-23', '2025-08-23'),
(24, 1, 3, '2025-08-22', '2025-08-22');

-- Membresias variadas
INSERT INTO membresias (id_usuario, id_tipo_membresia, id_estado_membresia, fecha_inicio, fecha_fin) VALUES
(25, 2, 1, '2025-07-01', '2025-07-31'),
(26, 3, 1, '2025-06-01', '2025-09-01'),
(27, 4, 1, '2025-08-01', '2025-10-01'),
(28, 2, 1, '2025-08-01', '2025-08-31'),
(29, 2, 1, '2025-08-01', '2025-08-31'),
(30, 3, 1, '2025-07-15', '2025-10-15'),
(31, 4, 1, '2025-08-10', '2025-09-10'),
(32, 1, 1, '2025-09-05', '2025-09-05'),
(33, 2, 1, '2025-07-01', '2025-07-31'),
(34, 3, 1, '2025-06-15', '2025-09-15'),
(35, 4, 1, '2025-08-20', '2025-10-20'),
(36, 2, 1, '2025-08-01', '2025-08-31'),
(37, 1, 1, '2025-09-02', '2025-09-02'),
(38, 4, 1, '2025-07-10', '2025-09-10'),
(39, 3, 1, '2025-06-01', '2025-09-01'),
(40, 2, 1, '2025-08-05', '2025-09-05'),
(41, 4, 1, '2025-08-01', '2025-10-01'),
(42, 1, 1, '2025-09-01', '2025-09-01'),
(43, 3, 1, '2025-07-01', '2025-10-01'),
(44, 2, 1, '2025-08-01', '2025-08-31'),
(45, 4, 1, '2025-08-15', '2025-09-15'),
(46, 2, 1, '2025-07-20', '2025-08-20'),
(47, 3, 1, '2025-06-01', '2025-09-01'),
(48, 2, 1, '2025-08-01', '2025-08-31'),
(49, 4, 1, '2025-08-10', '2025-09-10'),
(50, 1, 1, '2025-09-05', '2025-09-05');


-- Espacios 
-- Escritorios 
INSERT INTO espacios (nombre, id_tipo_espacio, capacidad, horario_disponible) VALUES
('Escritorio A1', 1, 1, '08:00-20:00'),
('Escritorio A2', 1, 1, '08:00-20:00'),
('Escritorio A3', 1, 1, '08:00-20:00'),
('Escritorio B1', 1, 1, '08:00-20:00'),
('Escritorio B2', 1, 1, '08:00-20:00'),
('Escritorio B3', 1, 1, '08:00-20:00'),
('Escritorio C1', 1, 1, '07:00-19:00'),
('Escritorio C2', 1, 1, '07:00-19:00'),
('Escritorio C3', 1, 1, '07:00-19:00'),
('Escritorio D1', 1, 1, '09:00-21:00'),
('Escritorio D2', 1, 1, '09:00-21:00'),
('Escritorio Libre 1', 1, 10, '07:00-20:00'),
('Escritorio Libre 2', 1, 15, '07:00-20:00'),
('Escritorio VIP', 1, 5, '24/7'),
('Escritorio Olvidado', 1, 1, '08:00-20:00');

-- Oficinas Privadas 
INSERT INTO espacios (nombre, id_tipo_espacio, capacidad, horario_disponible) VALUES
('Oficina 101', 2, 4, '08:00-18:00'),
('Oficina 102', 2, 6, '08:00-18:00'),
('Oficina 103', 2, 8, '08:00-18:00'),
('Oficina 104', 2, 3, '08:00-18:00'),
('Oficina 105', 2, 2, '08:00-18:00'),
('Oficina Ejecutiva', 2, 3, '09:00-17:00'),
('Oficina VIP', 2, 1, '24/7'),
('Oficina Sin Usar', 2, 4, '09:00-18:00'),
('Oficina Startup A', 2, 5, '07:00-19:00'),
('Oficina Startup B', 2, 5, '07:00-19:00'),
('Oficina Premium 1', 2, 6, '08:00-20:00'),
('Oficina Premium 2', 2, 8, '08:00-20:00'),
('Oficina Coworking 1', 2, 10, '07:00-21:00'),
('Oficina Coworking 2', 2, 12, '07:00-21:00'),
('Oficina Board Room', 2, 15, '09:00-21:00');

-- Sala de reuniones 
INSERT INTO espacios (nombre, id_tipo_espacio, capacidad, horario_disponible) VALUES
('Sala Reuniones 1', 3, 10, '09:00-21:00'),
('Sala Reuniones 2', 3, 12, '09:00-21:00'),
('Sala Reuniones 3', 3, 8, '09:00-21:00'),
('Sala Reuniones 4', 3, 15, '08:00-20:00'),
('Sala Creativa', 3, 8, '10:00-18:00'),
('Sala Capacitación', 3, 25, '09:00-18:00'),
('Sala Board Room', 3, 20, '08:00-20:00'),
('Sala Videoconferencia', 3, 6, '08:00-20:00'),
('Sala Brainstorming', 3, 5, '10:00-19:00'),
('Sala Sin Reservar', 3, 12, '09:00-21:00');

-- Sala de eventos 
INSERT INTO espacios (nombre, id_tipo_espacio, capacidad, horario_disponible) VALUES
('Sala Eventos A', 4, 50, '08:00-22:00'),
('Sala Eventos B', 4, 100, '08:00-23:00'),
('Sala de Conferencias', 4, 200, '07:00-23:00'),
('Auditorio Principal', 4, 300, '08:00-23:00'),
('Sala Expo', 4, 150, '08:00-22:00'),
('Sala Startup Pitch', 4, 80, '09:00-18:00'),
('Sala Networking', 4, 60, '10:00-20:00'),
('Sala Seminarios', 4, 90, '09:00-21:00'),
('Sala VIP Eventos', 4, 40, '24/7'),
('Sala Fantasma', 4, 120, '08:00-23:00');

-- Servicios 
INSERT INTO servicios (nombre, descripcion, precio) VALUES
('Café ilimitado', 'Acceso a café y bebidas calientes todo el día', 5.00),
('Locker pequeño', 'Almacenamiento personal seguro', 10.00),
('Locker grande', 'Almacenamiento amplio con candado', 15.00),
('Impresión B/N', 'Paquete de 100 impresiones en blanco y negro', 8.00),
('Impresión Color', 'Paquete de 50 impresiones a color', 12.00),
('Proyector', 'Uso de proyector para presentaciones', 20.00),
('Pantalla LED', 'Pantalla de apoyo para reuniones', 18.00),
('Cabina Telefónica', 'Espacio privado para llamadas', 6.00),
('Cabina Grabación', 'Cabina insonorizada para grabación de audio', 25.00),
('Cafetería VIP', 'Servicio premium de barista', 30.00),
('Estacionamiento Diario', 'Uso de parqueadero por un día', 12.00),
('Estacionamiento Mensual', 'Parqueadero exclusivo por mes', 100.00),
('Networking Pro', 'Acceso a eventos de networking', 40.00),
('Mentoría Startup', 'Sesión de asesoría con mentor', 50.00),
('Asesoría Legal', 'Consulta legal básica', 70.00),
('Asesoría Contable', 'Consulta contable y financiera', 60.00),
('Soporte Técnico', 'Soporte TI en sitio', 15.00),
('Wifi Premium', 'Internet de alta velocidad garantizado', 20.00),
('Locker Digital', 'Acceso a locker electrónico', 18.00),
('Sala de Juegos', 'Acceso a zona recreativa', 25.00),
('Catering Básico', 'Refrigerios para reuniones pequeñas', 30.00),
('Catering Premium', 'Almuerzo ejecutivo para eventos', 80.00),
('Traducción Simultánea', 'Servicio de intérprete', 150.00),
('Diseño Gráfico Express', 'Apoyo en material visual', 40.00),
('Marketing Digital', 'Campaña en redes sociales', 200.00),
('Coworking 24/7', 'Acceso ilimitado al espacio', 300.00),
('Paquete Eventos', 'Reserva de espacio para eventos', 500.00),
('Taller Innovación', 'Workshop de innovación empresarial', 100.00),
('Capacitación Scrum', 'Curso intensivo metodologías ágiles', 120.00),
('Certificación TI', 'Curso y examen de certificación', 250.00),
('Tour Virtual 360', 'Servicio de realidad virtual', 60.00),
('Seguridad Extra', 'Guardaespaldas/seguridad privada', 180.00),
('Consultoría RH', 'Apoyo en selección de personal', 90.00),
('Consultoría Financiera', 'Optimización financiera empresarial', 200.00),
('Publicidad Interna', 'Promoción de marca dentro del coworking', 50.00),
('Podcast Studio', 'Acceso a estudio de grabación profesional', 150.00),
('Streaming Pro', 'Equipo y soporte para transmisiones', 180.00),
('Equipo Fotografía', 'Cámara + luces profesionales', 70.00),
('Espacio Virtual', 'Acceso remoto a salas VR', 90.00),
('Academia Coworking', 'Cursos internos de formación', 75.00),
('Zona Relax', 'Masajes y meditación', 30.00),
('Gimnasio', 'Acceso al gimnasio coworking', 60.00),
('Piscina', 'Acceso a piscina en convenio', 80.00),
('Locker Premium', 'Locker con refrigeración', 25.00),
('Café Orgánico', 'Bebidas orgánicas ilimitadas', 15.00),
('Bicicleta Coworking', 'Bicicletas compartidas', 10.00),
('Transporte Corporativo', 'Shuttle empresa-coworking', 50.00),
('Soporte Avanzado', 'Soporte TI avanzado y servidores', 100.00),
('Publicidad Externa', 'Promoción en medios aliados', 300.00),
('Sala VIP Networking', 'Acceso privado a contactos de alto nivel', 500.00);

-- Usuario-Servicio
INSERT INTO usuario_servicio (id_usuario, id_servicio, fecha) VALUES
(1, 1, '2025-07-01'),
(2, 2, '2025-07-02'),
(3, 3, '2025-07-03'),
(4, 4, '2025-07-04'),
(5, 5, '2025-07-05'),
(6, 6, '2025-07-06'),
(7, 7, '2025-07-07'),
(8, 8, '2025-07-08'),
(9, 9, '2025-07-09'),
(10, 10, '2025-07-10'),
(11, 11, '2025-07-11'),
(12, 12, '2025-07-12'),
(13, 13, '2025-07-13'),
(14, 14, '2025-07-14'),
(15, 15, '2025-07-15'),
(16, 16, '2025-07-16'),
(17, 17, '2025-07-17'),
(18, 18, '2025-07-18'),
(19, 19, '2025-07-19'),
(20, 20, '2025-07-20'),
(21, 21, '2025-07-21'),
(22, 22, '2025-07-22'),
(23, 23, '2025-07-23'),
(24, 24, '2025-07-24'),
(25, 25, '2025-07-25'),
(26, 26, '2025-07-26'),
(27, 27, '2025-07-27'),
(28, 28, '2025-07-28'),
(29, 29, '2025-07-29'),
(30, 30, '2025-07-30'),
(31, 31, '2025-07-31'),
(32, 32, '2025-08-01'),
(33, 33, '2025-08-02'),
(34, 34, '2025-08-03'),
(35, 35, '2025-08-04'),
(36, 36, '2025-08-05'),
(37, 37, '2025-08-06'),
(38, 38, '2025-08-07'),
(39, 39, '2025-08-08'),
(40, 40, '2025-08-09'),
(41, 41, '2025-08-10'),
(42, 42, '2025-08-11'),
(43, 43, '2025-08-12'),
(44, 44, '2025-08-13'),
(45, 45, '2025-08-14'),
(46, 46, '2025-08-15'),
(47, 47, '2025-08-16'),
(48, 48, '2025-08-17'),
(49, 49, '2025-08-18'),
(50, 50, '2025-08-19');

-- Reservas - Normales, Masivas y especiales 
-- Reserva individual
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(1, 1, 2, 1, TRUE, '2025-09-01', '09:00:00', '12:00:00');

-- Reserva oficina privada
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(2, 16, 2, 3, TRUE, '2025-09-02', '10:00:00', '15:00:00');

-- Reserva sala reuniones
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(3, 31, 2, 5, TRUE, '2025-09-03', '09:30:00', '11:30:00');

-- Reserva masiva de evento (25 personas)
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(4, 41, 2, 25, TRUE, '2025-09-05', '14:00:00', '20:00:00');

-- Reserva pendiente
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(5, 2, 1, 1, FALSE, '2025-09-06', '08:00:00', '12:00:00');

-- Reserva cancelada
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(6, 17, 3, 4, FALSE, '2025-09-07', '13:00:00', '18:00:00');

-- Reserva confirmada pero no asistió (No Show)
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(8, 3, 2, 1, FALSE, '2025-09-09', '09:00:00', '12:00:00');

-- Reserva cancelada
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(9, 32, 3, 6, FALSE, '2025-09-10', '11:00:00', '13:00:00');

-- Reserva masiva de coworking libre
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(10, 12, 2, 10, TRUE, '2025-09-11', '08:00:00', '14:00:00');

-- Reserva de capacitación (20 personas)
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(11, 35, 2, 20, TRUE, '2025-09-12', '09:00:00', '17:00:00');

-- Reserva masiva de evento (100 personas)
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(12, 42, 2, 100, TRUE, '2025-09-14', '10:00:00', '20:00:00');

-- Reserva cancelada
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(13, 4, 3, 1, FALSE, '2025-09-15', '08:00:00', '10:00:00');

-- Reserva confirmada
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(14, 24, 2, 5, TRUE, '2025-09-16', '09:00:00', '17:00:00');

-- Reserva pendiente
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(15, 40, 1, 12, FALSE, '2025-09-17', '15:00:00', '18:00:00');

-- Reserva confirmada
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(16, 21, 2, 2, TRUE, '2025-09-18', '08:00:00', '12:00:00');

-- Reserva VIP 24/7
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(17, 14, 2, 1, TRUE, '2025-09-19', '21:00:00', '23:59:00');

-- Reserva cancelada
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(18, 47, 3, 30, FALSE, '2025-09-20', '18:00:00', '22:00:00');

-- Reserva confirmada
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(19, 48, 2, 40, TRUE, '2025-09-21', '09:00:00', '15:00:00');

-- Reserva masiva de conferencias (200 personas)
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(20, 43, 2, 200, TRUE, '2025-09-22', '08:00:00', '18:00:00');

-- Más reservas variadas
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin) VALUES
(21, 25, 2, 8, TRUE, '2025-09-23', '10:00:00', '16:00:00'),
(22, 13, 2, 12, TRUE, '2025-09-24', '08:00:00', '12:00:00'),
(23, 49, 2, 40, TRUE, '2025-09-25', '19:00:00', '23:59:00'),
(24, 7, 3, 1, FALSE, '2025-09-26', '09:00:00', '12:00:00'),
(25, 39, 1, 5, FALSE, '2025-09-27', '11:00:00', '13:00:00'),
(26, 44, 2, 300, TRUE, '2025-09-28', '08:00:00', '20:00:00'),
(27, 45, 2, 120, TRUE, '2025-09-29', '09:00:00', '18:00:00'),
(28, 46, 2, 80, TRUE, '2025-09-30', '10:00:00', '17:00:00'),
(29, 5, 1, 1, FALSE, '2025-10-01', '09:00:00', '11:00:00'),
(30, 28, 2, 6, TRUE, '2025-10-02', '08:00:00', '18:00:00'),
(31, 38, 2, 4, TRUE, '2025-10-03', '14:00:00', '16:00:00'),
(32, 15, 1, 1, FALSE, '2025-10-04', '08:00:00', '11:00:00'),
(33, 37, 2, 15, TRUE, '2025-10-05', '09:00:00', '12:00:00'),
(34, 30, 3, 12, FALSE, '2025-10-06', '10:00:00', '15:00:00'),
(35, 6, 2, 1, TRUE, '2025-10-07', '08:00:00', '12:00:00'),
(36, 25, 2, 7, TRUE, '2025-10-08', '09:00:00', '18:00:00'),
(37, 41, 2, 50, TRUE, '2025-10-09', '10:00:00', '18:00:00'),
(38, 22, 2, 1, TRUE, '2025-10-10', '22:00:00', '23:59:00'),
(39, 3, 1, 1, FALSE, '2025-10-11', '09:00:00', '11:00:00'),
(40, 34, 2, 6, TRUE, '2025-10-12', '10:00:00', '13:00:00'),
(41, 29, 2, 10, TRUE, '2025-10-13', '09:00:00', '18:00:00'),
(42, 11, 2, 1, TRUE, '2025-10-14', '08:00:00', '12:00:00'),
(43, 37, 2, 18, TRUE, '2025-10-15', '09:00:00', '12:00:00'),
(44, 39, 3, 6, FALSE, '2025-10-16', '14:00:00', '16:00:00'),
(45, 45, 2, 100, TRUE, '2025-10-17', '10:00:00', '20:00:00'),
(46, 23, 2, 4, TRUE, '2025-10-18', '09:00:00', '17:00:00'),
(47, 42, 2, 80, TRUE, '2025-10-19', '09:00:00', '22:00:00'),
(48, 44, 2, 250, FALSE, '2025-10-20', '08:00:00', '18:00:00'),
(49, 47, 2, 40, TRUE, '2025-10-21', '17:00:00', '21:00:00'),
(50, 10, 1, 1, FALSE, '2025-10-22', '08:00:00', '12:00:00');

-- Reserva-Asistentes - Reservas Masivas 
-- Asistentes para reserva masiva de evento 
INSERT INTO reserva_asistentes (id_reserva, nombre_asistente, identificacion, hora_ingreso) VALUES
(4, 'Asistente 1 Evento', 'A1001', '14:00:00'),
(4, 'Asistente 2 Evento', 'A1002', '14:05:00'),
(4, 'Asistente 3 Evento', 'A1003', '14:10:00'),
(4, 'Asistente 4 Evento', 'A1004', '14:15:00'),
(4, 'Asistente 5 Evento', 'A1005', '14:20:00');

-- Asistentes para reserva de capacitación
INSERT INTO reserva_asistentes (id_reserva, nombre_asistente, identificacion, hora_ingreso) VALUES
(11, 'Asistente 1 Capacitación', 'C1001', '09:00:00'),
(11, 'Asistente 2 Capacitación', 'C1002', '09:05:00'),
(11, 'Asistente 3 Capacitación', 'C1003', '09:10:00');

-- Asistentes para reserva masiva de evento 
INSERT INTO reserva_asistentes (id_reserva, nombre_asistente, identificacion, hora_ingreso) VALUES
(12, 'Asistente 1 Evento B', 'E1001', '10:00:00'),
(12, 'Asistente 2 Evento B', 'E1002', '10:05:00'),
(12, 'Asistente 3 Evento B', 'E1003', '10:10:00');

-- Asistentes para reserva de conferencias 
INSERT INTO reserva_asistentes (id_reserva, nombre_asistente, identificacion, hora_ingreso) VALUES
(20, 'Asistente 1 Conferencia', 'F1001', '08:00:00'),
(20, 'Asistente 2 Conferencia', 'F1002', '08:05:00'),
(20, 'Asistente 3 Conferencia', 'F1003', '08:10:00');

-- Datos de pago
-- Pagos por membresías
INSERT INTO pagos (id_usuario, monto, concepto, id_metodo_pago, id_estado_pago, fecha) VALUES
(1, 300000, 'Membresía Mensual', 2, 1, '2025-09-01 09:00:00'),
(2, 900000, 'Membresía Corporativa', 3, 1, '2025-09-02 10:00:00'),
(3, 20000, 'Membresía Diaria', 1, 1, '2025-09-03 08:00:00'),
(4, 600000, 'Membresía Premium', 2, 1, '2025-09-04 11:00:00'),
(5, 300000, 'Membresía Mensual', 4, 2, '2025-09-05 12:00:00');

-- Pagos por reservas
INSERT INTO pagos (id_usuario, monto, concepto, id_metodo_pago, id_estado_pago, fecha) VALUES
(6, 150000, 'Reserva Sala Reuniones', 2, 1, '2025-09-06 14:00:00'),
(7, 300000, 'Reserva Sala Eventos', 3, 1, '2025-09-07 15:00:00'),
(8, 50000, 'Reserva Escritorio', 1, 3, '2025-09-08 09:00:00'),
(9, 100000, 'Reserva Oficina Privada', 2, 1, '2025-09-09 16:00:00'),
(10, 200000, 'Reserva Coworking Libre', 4, 1, '2025-09-10 08:00:00');

-- Pagos por servicios adicionales
INSERT INTO pagos (id_usuario, monto, concepto, id_metodo_pago, id_estado_pago, fecha) VALUES
(11, 15000, 'Servicio Cafetería VIP', 1, 1, '2025-09-11 09:30:00'),
(12, 50000, 'Servicio Lockers', 2, 1, '2025-09-12 10:00:00'),
(13, 75000, 'Servicio Catering', 3, 1, '2025-09-13 12:00:00'),
(14, 100000, 'Servicio Proyector', 4, 2, '2025-09-14 14:00:00'),
(15, 25000, 'Servicio Coffee Break', 2, 1, '2025-09-15 15:00:00');

-- Más pagos variados para completar 
INSERT INTO pagos (id_usuario, monto, concepto, id_metodo_pago, id_estado_pago, fecha) VALUES
(16, 300000, 'Membresía Mensual', 2, 1, '2025-09-16 09:00:00'),
(17, 1000000, 'Membresía Corporativa', 3, 1, '2025-09-17 10:00:00'),
(18, 150000, 'Reserva Sala Networking', 4, 1, '2025-09-18 11:00:00'),
(19, 200000, 'Reserva Sala Seminarios', 2, 1, '2025-09-19 12:00:00'),
(20, 250000, 'Reserva Sala Conferencias', 2, 1, '2025-09-20 13:00:00'),
(21, 30000, 'Servicio Cafetería VIP', 1, 1, '2025-09-21 09:00:00'),
(21, 30000, 'Servicio Cafetería VIP', 1, 1, '2025-09-21 11:00:00'),
(22, 1200000, 'Reserva Auditorio Principal', 3, 2, '2025-09-22 09:00:00'),
(23, 2000000, 'Reserva Sala Conferencias', 2, 1, '2025-09-23 10:00:00'),
(24, 800000, 'Membresía Premium', 2, 1, '2025-09-24 09:30:00'),
(25, 250000, 'Reserva Sala Creativa', 4, 1, '2025-09-25 08:00:00'),
(26, 20000, 'Membresía Diaria', 1, 3, '2025-09-26 07:30:00'),
(27, 50000, 'Servicio Lockers', 2, 3, '2025-09-27 09:00:00'),
(28, 90000, 'Servicio Coffee Break', 4, 3, '2025-09-28 10:00:00'),
(29, 300000, 'Membresía Mensual', 2, 1, '2025-09-29 11:00:00'),
(30, 20000, 'Membresía Diaria', 1, 1, '2025-09-30 12:00:00'),
(31, 600000, 'Membresía Premium', 3, 1, '2025-10-01 10:00:00'),
(32, 900000, 'Membresía Corporativa', 4, 1, '2025-10-02 09:00:00'),
(33, 300000, 'Membresía Mensual', 2, 1, '2025-10-03 11:00:00'),
(34, 200000, 'Reserva Sala Reuniones', 3, 1, '2025-10-04 08:00:00'),
(35, 250000, 'Reserva Oficina Privada', 2, 2, '2025-10-05 09:00:00'),
(36, 300000, 'Reserva Sala Eventos', 1, 1, '2025-10-06 12:00:00'),
(37, 180000, 'Reserva Sala Capacitación', 2, 1, '2025-10-07 14:00:00'),
(38, 220000, 'Reserva Sala Videoconferencia', 3, 1, '2025-10-08 15:00:00'),
(39, 75000, 'Servicio Catering', 2, 1, '2025-10-09 16:00:00'),
(40, 100000, 'Servicio Proyector', 4, 1, '2025-10-10 09:00:00'),
(41, 20000, 'Servicio Lockers', 1, 1, '2025-10-11 10:00:00'),
(42, 50000, 'Servicio Coffee Break', 2, 1, '2025-10-12 11:00:00'),
(43, 25000, 'Servicio Cafetería VIP', 3, 1, '2025-10-13 12:00:00'),
(44, 2000000, 'Reserva Sala Eventos B', 4, 1, '2025-10-14 09:00:00'),
(45, 100000, 'Reserva Sala Networking', 2, 1, '2025-10-15 10:00:00'),
(46, 120000, 'Servicio Catering', 3, 2, '2025-10-16 11:00:00'),
(47, 600000, 'Membresía Premium', 2, 1, '2025-10-17 12:00:00'),
(48, 150000, 'Reserva Sala Reuniones', 4, 1, '2025-10-18 13:00:00'),
(49, 250000, 'Reserva Oficina Privada', 3, 1, '2025-10-19 14:00:00'),
(50, 20000, 'Membresía Diaria', 1, 1, '2025-10-20 15:00:00');

-- Datos de facturas 
-- Facturas por membresías
INSERT INTO facturas (id_usuario, id_reserva, id_membresia, id_pago, fecha, fecha_pago_oportuno, total, id_estado_factura, motivo_cancelacion) VALUES
(1, NULL, 1, 1, '2025-09-01 09:05:00', '2025-09-06 23:59:59', 300000, 1, NULL),
(2, NULL, 2, 2, '2025-09-02 10:05:00', '2025-09-07 23:59:59', 900000, 1, NULL),
(3, NULL, 3, 3, '2025-09-03 08:05:00', '2025-09-08 23:59:59', 20000, 1, NULL),
(4, NULL, 4, 4, '2025-09-04 11:05:00', '2025-09-09 23:59:59', 600000, 1, NULL),
(5, NULL, 5, 5, '2025-09-05 12:05:00', '2025-09-10 23:59:59', 300000, 2, NULL);

-- Facturas por reservas
INSERT INTO facturas (id_usuario, id_reserva, id_membresia, id_pago, fecha, fecha_pago_oportuno, total, id_estado_factura, motivo_cancelacion) VALUES
(6, 3, NULL, 6, '2025-09-06 14:05:00', '2025-09-11 23:59:59', 150000, 1, NULL),
(7, 4, NULL, 7, '2025-09-07 15:05:00', '2025-09-12 23:59:59', 300000, 1, NULL),
(8, 8, NULL, 8, '2025-09-08 09:05:00', '2025-09-13 23:59:59', 50000, 3, 'Reserva cancelada por usuario'),
(9, 9, NULL, 9, '2025-09-09 16:05:00', '2025-09-14 23:59:59', 100000, 1, NULL),
(10, 10, NULL, 10, '2025-09-10 08:05:00', '2025-09-15 23:59:59', 200000, 1, NULL);

-- Facturas por servicios
INSERT INTO facturas (id_usuario, id_reserva, id_membresia, id_pago, fecha, fecha_pago_oportuno, total, id_estado_factura, motivo_cancelacion) VALUES
(11, NULL, NULL, 11, '2025-09-11 09:35:00', '2025-09-16 23:59:59', 15000, 1, NULL),
(12, NULL, NULL, 12, '2025-09-12 10:05:00', '2025-09-17 23:59:59', 50000, 1, NULL),
(13, NULL, NULL, 13, '2025-09-13 12:05:00', '2025-09-18 23:59:59', 75000, 1, NULL),
(14, NULL, NULL, 14, '2025-09-14 14:05:00', '2025-09-19 23:59:59', 100000, 2, NULL),
(15, NULL, NULL, 15, '2025-09-15 15:05:00', '2025-09-20 23:59:59', 25000, 1, NULL);

-- Más facturas variadas para completar 
INSERT INTO facturas (id_usuario, id_reserva, id_membresia, id_pago, fecha, fecha_pago_oportuno, total, id_estado_factura, motivo_cancelacion) VALUES
(16, NULL, 16, 16, '2025-09-16 09:05:00', '2025-09-21 23:59:59', 300000, 1, NULL),
(17, NULL, 17, 17, '2025-09-17 10:05:00', '2025-09-22 23:59:59', 1000000, 1, NULL),
(18, 18, NULL, 18, '2025-09-18 11:05:00', '2025-09-23 23:59:59', 150000, 1, NULL),
(19, 19, NULL, 19, '2025-09-19 12:05:00', '2025-09-24 23:59:59', 200000, 1, NULL),
(20, 20, NULL, 20, '2025-09-20 13:05:00', '2025-09-25 23:59:59', 250000, 1, NULL),
(21, NULL, NULL, 21, '2025-09-21 09:05:00', '2025-09-26 23:59:59', 30000, 1, NULL),
(21, NULL, NULL, 22, '2025-09-21 11:05:00', '2025-09-26 23:59:59', 30000, 1, NULL),
(22, 26, NULL, 23, '2025-09-23 10:05:00', '2025-09-28 23:59:59', 2000000, 1, NULL),
(23, NULL, 24, 24, '2025-09-24 09:35:00', '2025-09-29 23:59:59', 800000, 1, NULL),
(24, 25, NULL, 25, '2025-09-25 08:05:00', '2025-09-30 23:59:59', 250000, 1, NULL),
(25, NULL, 26, 26, '2025-09-26 07:35:00', '2025-10-01 23:59:59', 20000, 3, 'Membresía anulada por falta de pago'),
(26, NULL, NULL, 27, '2025-09-27 09:05:00', '2025-10-02 23:59:59', 50000, 1, NULL),
(27, NULL, NULL, 28, '2025-09-28 10:05:00', '2025-10-03 23:59:59', 90000, 1, NULL),
(28, NULL, 29, 29, '2025-09-29 11:05:00', '2025-10-04 23:59:59', 300000, 1, NULL),
(29, NULL, 30, 30, '2025-09-30 12:05:00', '2025-10-05 23:59:59', 20000, 1, NULL),
(30, NULL, 31, 31, '2025-10-01 10:05:00', '2025-10-06 23:59:59', 600000, 1, NULL),
(31, NULL, 32, 32, '2025-10-02 09:05:00', '2025-10-07 23:59:59', 900000, 1, NULL),
(32, NULL, 33, 33, '2025-10-03 11:05:00', '2025-10-08 23:59:59', 300000, 1, NULL),
(33, 31, NULL, 34, '2025-10-04 08:05:00', '2025-10-09 23:59:59', 200000, 1, NULL),
(34, 30, NULL, 35, '2025-10-05 09:05:00', '2025-10-10 23:59:59', 250000, 2, NULL),
(35, 37, NULL, 36, '2025-10-06 12:05:00', '2025-10-11 23:59:59', 300000, 1, NULL),
(36, 11, NULL, 37, '2025-10-07 14:05:00', '2025-10-12 23:59:59', 180000, 1, NULL),
(37, 38, NULL, 38, '2025-10-08 15:05:00', '2025-10-13 23:59:59', 220000, 1, NULL),
(38, NULL, NULL, 39, '2025-10-09 16:05:00', '2025-10-14 23:59:59', 75000, 1, NULL),
(39, NULL, NULL, 40, '2025-10-10 09:05:00', '2025-10-15 23:59:59', 100000, 1, NULL),
(40, NULL, NULL, 41, '2025-10-11 10:05:00', '2025-10-16 23:59:59', 20000, 1, NULL),
(41, NULL, NULL, 42, '2025-10-12 11:05:00', '2025-10-17 23:59:59', 50000, 1, NULL),
(42, NULL, NULL, 43, '2025-10-13 12:05:00', '2025-10-18 23:59:59', 25000, 1, NULL),
(43, 47, NULL, 44, '2025-10-14 09:05:00', '2025-10-19 23:59:59', 2000000, 1, NULL),
(44, 49, NULL, 45, '2025-10-15 10:05:00', '2025-10-20 23:59:59', 100000, 1, NULL),
(45, NULL, NULL, 46, '2025-10-16 11:05:00', '2025-10-21 23:59:59', 120000, 2, NULL),
(46, NULL, 47, 47, '2025-10-17 12:05:00', '2025-10-22 23:59:59', 600000, 1, NULL),
(47, 31, NULL, 48, '2025-10-18 13:05:00', '2025-10-23 23:59:59', 150000, 1, NULL),
(48, 34, NULL, 49, '2025-10-19 14:05:00', '2025-10-24 23:59:59', 250000, 1, NULL),
(49, NULL, 50, 50, '2025-10-20 15:05:00', '2025-10-25 23:59:59', 20000, 1, NULL);

-- Datos Reserva - Servicio
INSERT INTO reserva_servicio (id_reserva, id_servicio) VALUES
(1, 1), -- Café ilimitado
(1, 2), -- Locker pequeño
(2, 3), -- Locker grande
(2, 4), -- Impresión B/N
(3, 5), -- Impresión Color
(3, 6), -- Proyector
(4, 7), -- Pantalla LED
(4, 8), -- Cabina Telefónica
(4, 9), -- Cabina Grabación
(5, 10), -- Cafetería VIP
(6, 11), -- Estacionamiento Diario
(7, 12), -- Estacionamiento Mensual
(8, 13), -- Networking Pro
(9, 14), -- Mentoría Startup
(10, 15), -- Asesoría Legal
(11, 16), -- Asesoría Contable
(12, 17), -- Soporte Técnico
(13, 18), -- Wifi Premium
(14, 19), -- Locker Digital
(15, 20), -- Sala de Juegos
(16, 21), -- Catering Básico
(17, 22), -- Catering Premium
(18, 23), -- Traducción Simultánea
(19, 24), -- Diseño Gráfico Express
(20, 25), -- Marketing Digital
(21, 26), -- Coworking 24/7
(22, 27), -- Paquete Eventos
(23, 28), -- Taller Innovación
(24, 29), -- Capacitación Scrum
(25, 30), -- Certificación TI
(26, 31), -- Tour Virtual 360
(27, 32), -- Seguridad Extra
(28, 33), -- Consultoría RH
(29, 34), -- Consultoría Financiera
(30, 35), -- Publicidad Interna
(31, 36), -- Podcast Studio
(32, 37), -- Streaming Pro
(33, 38), -- Equipo Fotografía
(34, 39), -- Espacio Virtual
(35, 40), -- Academia Coworking
(36, 41), -- Zona Relax
(37, 42), -- Gimnasio
(38, 43), -- Piscina
(39, 44), -- Locker Premium
(40, 45), -- Café Orgánico
(41, 46), -- Bicicleta Coworking
(42, 47), -- Transporte Corporativo
(43, 48), -- Soporte Avanzado
(44, 49), -- Publicidad Externa
(45, 50); -- Sala VIP Networking

-- Renovaciones 
INSERT INTO renovaciones (id_membresia, fecha_renovacion) VALUES
(1, '2025-08-01'),
(2, '2025-08-15'),
(3, '2025-07-01'),
(4, '2025-09-10'),
(5, '2025-08-01'),
(6, '2025-08-01'),
(7, '2025-07-15'),
(8, '2025-06-01'),
(9, '2025-09-05'),
(10, '2025-08-20'),
(11, '2025-06-01'),
(12, '2025-07-01'),
(13, '2025-08-15'),
(14, '2025-05-01'),
(15, '2025-09-01'),
(16, '2024-01-01'),
(17, '2024-06-01'),
(18, '2024-07-15'),
(19, '2023-09-01'),
(20, '2024-11-01'),
(21, '2025-08-20'),
(22, '2025-07-20'),
(23, '2025-08-01'),
(24, '2025-09-01'),
(24, '2025-08-31'),
(24, '2025-08-30'),
(24, '2025-08-29'),
(24, '2025-08-28'),
(24, '2025-08-27'),
(24, '2025-08-26'),
(24, '2025-08-25'),
(24, '2025-08-24'),
(24, '2025-08-23'),
(24, '2025-08-22');

-- Tablas Log 
INSERT INTO log_membresias (id_usuario, accion, fecha) VALUES
(1, 'Membresía activada', '2025-08-01 09:00:00'),
(2, 'Membresía activada', '2025-08-15 10:00:00'),
(3, 'Membresía activada', '2025-07-01 08:00:00'),
(4, 'Membresía diaria utilizada', '2025-09-10 09:00:00'),
(5, 'Membresía activada', '2025-08-01 12:00:00');

INSERT INTO log_reservas (id_reserva, accion, fecha) VALUES
(1, 'Reserva confirmada', '2025-09-01 09:00:00'),
(2, 'Reserva confirmada', '2025-09-02 10:00:00'),
(3, 'Reserva confirmada', '2025-09-03 09:30:00'),
(4, 'Reserva masiva confirmada', '2025-09-05 14:00:00'),
(5, 'Reserva pendiente de pago', '2025-09-06 08:00:00');

INSERT INTO log_pagos (id_pago, accion, fecha) VALUES
(1, 'Pago procesado exitosamente', '2025-09-01 09:00:00'),
(2, 'Pago procesado exitosamente', '2025-09-02 10:00:00'),
(3, 'Pago procesado exitosamente', '2025-09-03 08:00:00'),
(4, 'Pago procesado exitosamente', '2025-09-04 11:00:00'),
(5, 'Pago pendiente de confirmación', '2025-09-05 12:00:00');

INSERT INTO log_accesos (id_usuario, accion, fecha) VALUES
(1, 'Acceso permitido', '2025-09-01 09:00:00'),
(2, 'Acceso permitido', '2025-09-02 14:00:00'),
(3, 'Acceso denegado - Membresía vencida', '2025-09-03 08:30:00'),
(4, 'Acceso permitido para evento', '2025-09-05 13:30:00'),
(5, 'Acceso fuera de horario permitido', '2025-09-06 23:30:00');

-- Datos especiales 
-- Usuario independiente sin empresa
INSERT INTO usuarios (identificacion, nombre, apellidos, fecha_nacimiento, telefono, email, id_empresa) VALUES
('900100200', 'María', 'Independiente', '1995-06-10', '3001234567', 'maria.ind@correo.com', NULL);

-- Membresía activa de María
INSERT INTO membresias (id_usuario, id_tipo_membresia, id_estado_membresia, fecha_inicio, fecha_fin) VALUES
(51, 4, 1, '2025-08-01', '2025-09-01');

-- Usuario con facturas impagas
INSERT INTO usuarios (identificacion, nombre, apellidos, fecha_nacimiento, telefono, email, id_empresa) VALUES
('900100201', 'Carlos', 'Deudor', '1980-03-15', '3017654321', 'carlos.deudor@correo.com', NULL);

INSERT INTO membresias (id_usuario, id_tipo_membresia, id_estado_membresia, fecha_inicio, fecha_fin) VALUES
(52, 2, 1, '2025-07-01', '2025-08-01');

-- Pago pendiente
INSERT INTO pagos (id_usuario, monto, concepto, id_metodo_pago, id_estado_pago, fecha) VALUES
(52, 300000, 'Membresía Mensual Julio', 2, 2, '2025-07-01');

-- Factura pendiente asociada
INSERT INTO facturas (id_usuario, id_membresia, id_pago, fecha, fecha_pago_oportuno, total, id_estado_factura) VALUES
(52, 52, 51, '2025-07-01 12:00:00', '2025-07-06 23:59:59', 300000, 2);

-- Usuario con más de 10 renovaciones diarias
INSERT INTO usuarios (identificacion, nombre, apellidos, fecha_nacimiento, telefono, email, id_empresa) VALUES
('900100202', 'Pedro', 'Renovador', '1992-11-20', '3029876543', 'pedro.renovador@correo.com', NULL);

-- 11 membresías diarias seguidas
INSERT INTO membresias (id_usuario, id_tipo_membresia, id_estado_membresia, fecha_inicio, fecha_fin) VALUES
(53, 1, 1, '2025-07-01', '2025-07-01'),
(53, 1, 1, '2025-07-02', '2025-07-02'),
(53, 1, 1, '2025-07-03', '2025-07-03'),
(53, 1, 1, '2025-07-04', '2025-07-04'),
(53, 1, 1, '2025-07-05', '2025-07-05'),
(53, 1, 1, '2025-07-06', '2025-07-06'),
(53, 1, 1, '2025-07-07', '2025-07-07'),
(53, 1, 1, '2025-07-08', '2025-07-08'),
(53, 1, 1, '2025-07-09', '2025-07-09'),
(53, 1, 1, '2025-07-10', '2025-07-10'),
(53, 1, 1, '2025-07-11', '2025-07-11');

-- Renovaciones para Pedro
INSERT INTO renovaciones (id_membresia, fecha_renovacion) VALUES
(54, '2025-07-01'),
(55, '2025-07-02'),
(56, '2025-07-03'),
(57, '2025-07-04'),
(58, '2025-07-05'),
(59, '2025-07-06'),
(60, '2025-07-07'),
(61, '2025-07-08'),
(62, '2025-07-09'),
(63, '2025-07-10'),
(64, '2025-07-11');


-- Triggers
-- tigres de membresias 
-- 1. Trigger para actualizar estado de membresía automáticamente

CREATE TRIGGER tr_membresia_actualizar_estado
BEFORE UPDATE ON membresias
FOR EACH ROW
BEGIN
    IF NEW.fecha_fin < CURDATE() AND OLD.id_estado_membresia != 3 THEN
        SET NEW.id_estado_membresia = 3; -- Vencida
    END IF;
END;


-- 2. Trigger para registrar renovación automática

CREATE TRIGGER tr_membresia_renovacion
AFTER UPDATE ON membresias
FOR EACH ROW
BEGIN
    IF OLD.fecha_fin != NEW.fecha_fin AND NEW.id_estado_membresia = 1 THEN
        INSERT INTO renovaciones (id_membresia, fecha_renovacion)
        VALUES (NEW.id_membresia, CURDATE());
    END IF;
END;


-- 3. Trigger para log de cambios en membresías

CREATE TRIGGER tr_log_membresias
AFTER UPDATE ON membresias
FOR EACH ROW
BEGIN
    IF OLD.id_estado_membresia != NEW.id_estado_membresia THEN
        INSERT INTO log_membresias (id_usuario, accion, fecha)
        VALUES (NEW.id_usuario, 
                CONCAT('Cambio estado: ', 
                      (SELECT nombre FROM estados_membresia WHERE id_estado_membresia = OLD.id_estado_membresia),
                      ' → ',
                      (SELECT nombre FROM estados_membresia WHERE id_estado_membresia = NEW.id_estado_membresia)),
                NOW());
    END IF;
END;

-- Reservas 

-- 4. Trigger para validar disponibilidad de espacio
CREATE TRIGGER tr_reserva_validar_disponibilidad
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    DECLARE espacio_ocupado INT DEFAULT 0;
    
    SELECT COUNT(*) INTO espacio_ocupado
    FROM reservas 
    WHERE id_espacio = NEW.id_espacio 
    AND fecha = NEW.fecha
    AND id_estado_reserva IN (1, 2) -- Pendiente o Confirmada
    AND (
        (NEW.hora_inicio BETWEEN hora_inicio AND hora_fin) OR
        (NEW.hora_fin BETWEEN hora_inicio AND hora_fin) OR
        (hora_inicio BETWEEN NEW.hora_inicio AND NEW.hora_fin)
    );
    
    IF espacio_ocupado > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El espacio no está disponible en el horario seleccionado';
    END IF;
END;

-- 5. Trigger para validar capacidad del espacio
CREATE TRIGGER tr_reserva_validar_capacidad
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    DECLARE capacidad_maxima INT;
    
    SELECT capacidad INTO capacidad_maxima
    FROM espacios 
    WHERE id_espacio = NEW.id_espacio;
    
    IF NEW.numero_asistentes > capacidad_maxima THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Número de asistentes excede la capacidad del espacio';
    END IF;
END;

-- 6. Trigger para log de reservas
CREATE TRIGGER tr_log_reservas
AFTER INSERT ON reservas
FOR EACH ROW
BEGIN
    INSERT INTO log_reservas (id_reserva, accion, fecha)
    VALUES (NEW.id_reserva, 
            CONCAT('Reserva creada - Estado: ', 
                  (SELECT nombre FROM estados_reserva WHERE id_estado_reserva = NEW.id_estado_reserva)),
            NOW());
END;

-- Facturas y Pagos
-- 7. Trigger para actualizar estado de reserva al confirmar pago
CREATE TRIGGER tr_pago_confirmar_reserva
AFTER UPDATE ON pagos
FOR EACH ROW
BEGIN
    IF NEW.id_estado_pago = 1 AND OLD.id_estado_pago != 1 THEN -- Pagado
        UPDATE reservas 
        SET id_estado_reserva = 2 -- Confirmada
        WHERE id_reserva IN (
            SELECT id_reserva FROM facturas 
            WHERE id_pago = NEW.id_pago
        );
    END IF;
END;

-- 8. Trigger para crear factura automáticamente
CREATE TRIGGER tr_pago_crear_factura
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
    INSERT INTO facturas (id_usuario, id_pago, fecha, total, id_estado_factura)
    VALUES (NEW.id_usuario, NEW.id_pago, NOW(), NEW.monto, 
           CASE WHEN NEW.id_estado_pago = 1 THEN 1 ELSE 2 END);
END;

-- 9. Trigger para log de pagos
CREATE TRIGGER tr_log_pagos
AFTER UPDATE ON pagos
FOR EACH ROW
BEGIN
    IF OLD.id_estado_pago != NEW.id_estado_pago THEN
        INSERT INTO log_pagos (id_pago, accion, fecha)
        VALUES (NEW.id_pago, 
                CONCAT('Cambio estado: ', 
                      (SELECT nombre FROM estados_pago WHERE id_estado_pago = OLD.id_estado_pago),
                      ' → ',
                      (SELECT nombre FROM estados_pago WHERE id_estado_pago = NEW.id_estado_pago)),
                NOW());
    END IF;
END;

-- Accesos
-- 10. Trigger para validar membresía activa al acceder
CREATE TRIGGER tr_acceso_validar_membresia
BEFORE INSERT ON accesos
FOR EACH ROW
BEGIN
    DECLARE membresia_activa INT DEFAULT 0;
    
    SELECT COUNT(*) INTO membresia_activa
    FROM membresias 
    WHERE id_usuario = NEW.id_usuario
    AND id_estado_membresia = 1 -- Activa
    AND fecha_fin >= CURDATE();
    
    IF membresia_activa = 0 THEN
        INSERT INTO log_accesos (id_usuario, accion, fecha)
        VALUES (NEW.id_usuario, 'Intento de acceso sin membresía activa', NOW());
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario no tiene membresía activa';
    END IF;
END;

-- 11. Trigger para registrar hora de salida automática
CREATE TRIGGER tr_acceso_registrar_salida
BEFORE UPDATE ON accesos
FOR EACH ROW
BEGIN
    IF NEW.hora_salida IS NULL AND OLD.hora_entrada IS NOT NULL THEN
        SET NEW.hora_salida = CURTIME();
    END IF;
END;

-- 12. Trigger para log de accesos
CREATE TRIGGER tr_log_accesos
AFTER INSERT ON accesos
FOR EACH ROW
BEGIN
    IF NEW.hora_entrada IS NOT NULL THEN
        INSERT INTO log_accesos (id_usuario, accion, fecha)
        VALUES (NEW.id_usuario, 'Acceso registrado exitosamente', NOW());
    ELSE
        INSERT INTO log_accesos (id_usuario, accion, fecha)
        VALUES (NEW.id_usuario, 'Intento de acceso fallido', NOW());
    END IF;
END;

-- Trigers adicionales 
-- 13. Trigger para actualizar fecha_pago_oportuno en facturas
CREATE TRIGGER tr_factura_fecha_pago_oportuno
BEFORE INSERT ON facturas
FOR EACH ROW
BEGIN
    IF NEW.fecha_pago_oportuno IS NULL THEN
        SET NEW.fecha_pago_oportuno = DATE_ADD(NEW.fecha, INTERVAL 5 DAY);
    END IF;
END;

-- 14. Trigger para evitar eliminación de usuarios con reservas activas
CREATE TRIGGER tr_proteger_usuario_reservas
BEFORE DELETE ON usuarios
FOR EACH ROW
BEGIN
    DECLARE reservas_activas INT DEFAULT 0;
    
    SELECT COUNT(*) INTO reservas_activas
    FROM reservas 
    WHERE id_usuario = OLD.id_usuario
    AND fecha >= CURDATE()
    AND id_estado_reserva IN (1, 2); -- Pendiente o Confirmada
    
    IF reservas_activas > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar usuario con reservas activas';
    END IF;
END;

-- 15. Trigger para actualizar estado de facturas vencidas
CREATE TRIGGER tr_actualizar_facturas_vencidas
BEFORE UPDATE ON facturas
FOR EACH ROW
BEGIN
    IF NEW.fecha_pago_oportuno < CURDATE() AND NEW.id_estado_factura = 2 THEN
        SET NEW.id_estado_factura = 4; -- Vencida
    END IF;
END;


-- Eventos 
-- Agregar tablas
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

SET GLOBAL event_scheduler = ON;

-- 1. Evento para actualizar estados de membresías vencidas diariamente
CREATE EVENT ev_actualizar_membresias_vencidas
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE membresias 
    SET id_estado_membresia = 3 
    WHERE fecha_fin < CURDATE() 
    AND id_estado_membresia != 3;
END;

-- 2. Evento para cancelar reservas pendientes no confirmadas después de 2 horas
CREATE EVENT ev_cancelar_reservas_pendientes
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE reservas 
    SET id_estado_reserva = 3 
    WHERE id_estado_reserva = 1 
    AND TIMESTAMPDIFF(HOUR, CONCAT(fecha, ' ', hora_inicio), NOW()) > 2;
END;

-- 3. Evento para marcar facturas vencidas diariamente
CREATE EVENT ev_marcar_facturas_vencidas
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE facturas 
    SET id_estado_factura = 4 
    WHERE fecha_pago_oportuno < CURDATE() 
    AND id_estado_factura = 2;
END;

-- 4. Evento para suspender membresías con facturas vencidas (ejecución semanal)
CREATE EVENT ev_suspender_membresias_impagas
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE membresias m
    JOIN usuarios u ON m.id_usuario = u.id_usuario
    JOIN facturas f ON u.id_usuario = f.id_usuario
    SET m.id_estado_membresia = 2
    WHERE f.id_estado_factura = 4
    AND f.fecha_pago_oportuno < DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    AND m.id_estado_membresia = 1;
END;

-- 5. Evento para limpiar logs antiguos (ejecución mensual)
CREATE EVENT ev_limpiar_logs_antiguos
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Eliminar logs con más de 6 meses de antigüedad
    DELETE FROM log_membresias WHERE fecha < DATE_SUB(NOW(), INTERVAL 6 MONTH);
    DELETE FROM log_reservas WHERE fecha < DATE_SUB(NOW(), INTERVAL 6 MONTH);
    DELETE FROM log_pagos WHERE fecha < DATE_SUB(NOW(), INTERVAL 6 MONTH);
    DELETE FROM log_accesos WHERE fecha < DATE_SUB(NOW(), INTERVAL 6 MONTH);
END;

-- 6. Evento para generar reporte de ocupación diaria
CREATE EVENT ev_reporte_ocupacion_diaria
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY
DO
BEGIN
    -- Insertar estadísticas de ocupación diaria en una tabla de reportes
    INSERT INTO reporte_ocupacion (fecha, total_reservas, total_usuarios, ocupacion_promedio)
    SELECT 
        CURDATE() as fecha,
        COUNT(*) as total_reservas,
        COUNT(DISTINCT id_usuario) as total_usuarios,
        ROUND(AVG(TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin)), 2) as ocupacion_promedio
    FROM reservas 
    WHERE fecha = CURDATE() 
    AND id_estado_reserva = 2;
END;

-- 7. Evento para recordatorio de renovación de membresías (3 días antes de vencer)
CREATE EVENT ev_recordatorio_renovacion
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Aquí se podría implementar el envío de emails o notificaciones
    -- Por ahora solo registramos en log
    INSERT INTO log_membresias (id_usuario, accion, fecha)
    SELECT 
        m.id_usuario,
        'Recordatorio: Membresía vence en 3 días',
        NOW()
    FROM membresias m
    WHERE m.fecha_fin = DATE_ADD(CURDATE(), INTERVAL 3 DAY)
    AND m.id_estado_membresia = 1;
END;

-- 8. Evento para actualizar estadísticas de uso de espacios (semanal)
CREATE EVENT ev_estadisticas_espacios
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Calcular y almacenar estadísticas de uso de espacios
    INSERT INTO estadisticas_espacios (id_espacio, semana, total_reservas, horas_uso)
    SELECT 
        id_espacio,
        YEARWEEK(CURDATE()),
        COUNT(*) as total_reservas,
        SUM(TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin)) as horas_uso
    FROM reservas
    WHERE fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE()
    AND id_estado_reserva = 2
    GROUP BY id_espacio;
END;

-- 9. Evento para verificar accesos sin salida registrada (diario)
CREATE EVENT ev_verificar_accesos_abiertos
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Marcar accesos sin salida del día anterior
    UPDATE accesos 
    SET hora_salida = '23:59:59'
    WHERE fecha = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
    AND hora_salida IS NULL
    AND hora_entrada IS NOT NULL;
END;

-- 10. Evento para backup de datos importantes (mensual)
CREATE EVENT ev_backup_datos_importantes
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Crear tabla de backup de membresías activas
    CREATE TABLE IF NOT EXISTS backup_membresias LIKE membresias;
    TRUNCATE TABLE backup_membresias;
    INSERT INTO backup_membresias SELECT * FROM membresias WHERE id_estado_membresia = 1;
    
    -- Crear tabla de backup de reservas del mes
    CREATE TABLE IF NOT EXISTS backup_reservas_mensual LIKE reservas;
    TRUNCATE TABLE backup_reservas_mensual;
    INSERT INTO backup_reservas_mensual 
    SELECT * FROM reservas 
    WHERE fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE();
END;

-- Funciones 
-- Membresias 
-- 1. Función para verificar membresía activa
CREATE FUNCTION fn_membresia_activa(usuario_id INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE activa BOOLEAN DEFAULT FALSE;
    
    SELECT COUNT(*) > 0 INTO activa
    FROM membresias m
    INNER JOIN estados_membresia em ON m.id_estado_membresia = em.id_estado_membresia
    WHERE m.id_usuario = usuario_id 
    AND em.nombre = 'Activa'
    AND m.fecha_fin >= CURDATE();

    RETURN activa;
END;

-- 2. Función para días restantes de membresía
CREATE FUNCTION fn_dias_restantes_membresia(usuario_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE dias_restantes INT DEFAULT 0;
    
    SELECT DATEDIFF(m.fecha_fin, CURDATE()) INTO dias_restantes
    FROM membresias m
    INNER JOIN estados_membresia em ON m.id_estado_membresia = em.id_estado_membresia
    WHERE m.id_usuario = usuario_id 
    AND em.nombre = 'Activa'
    ORDER BY m.fecha_inicio DESC
    LIMIT 1;
    
    RETURN IFNULL(dias_restantes, 0);
END;

-- 3. Función para obtener tipo de membresía
CREATE FUNCTION fn_tipo_membresia(usuario_id INT)
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE tipo VARCHAR(50) DEFAULT 'Sin membresía';
    
    SELECT tm.nombre INTO tipo
    FROM membresias m
    INNER JOIN tipos_membresia tm ON m.id_tipo_membresia = tm.id_tipo_membresia
    INNER JOIN estados_membresia em ON m.id_estado_membresia = em.id_estado_membresia
    WHERE m.id_usuario = usuario_id 
    AND em.nombre = 'Activa'
    ORDER BY m.fecha_inicio DESC
    LIMIT 1;
    
    RETURN IFNULL(tipo, 'Sin membresía');
END;

-- 4. Función para contar renovaciones de membresía
CREATE FUNCTION fn_renovaciones_membresia(usuario_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE renovaciones INT DEFAULT 0;
    
    SELECT COUNT(*) INTO renovaciones
    FROM renovaciones r
    INNER JOIN membresias m ON r.id_membresia = m.id_membresia
    WHERE m.id_usuario = usuario_id;
    
    RETURN renovaciones;
END;

-- 5. Función para obtener estado de membresía
CREATE FUNCTION fn_estado_membresia(usuario_id INT)
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE estado VARCHAR(50) DEFAULT 'Sin membresía';
    
    SELECT em.nombre INTO estado
    FROM membresias m
    INNER JOIN estados_membresia em ON m.id_estado_membresia = em.id_estado_membresia
    WHERE m.id_usuario = usuario_id
    ORDER BY m.fecha_inicio DESC
    LIMIT 1;
    
    RETURN IFNULL(estado, 'Sin membresía');
END;

-- Reservas 
-- 6. Función para contar total de reservas por usuario
CREATE FUNCTION fn_total_reservas(usuario_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT DEFAULT 0;
    
    SELECT COUNT(*) INTO total
    FROM reservas
    WHERE id_usuario = usuario_id;
    
    RETURN total;
END;

-- 7. Función para calcular horas reservadas en un período
CREATE FUNCTION fn_horas_reservadas(usuario_id INT, mes INT, año INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE total_horas DECIMAL(10,2) DEFAULT 0;
    
    SELECT COALESCE(SUM(TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin)), 0) INTO total_horas
    FROM reservas
    WHERE id_usuario = usuario_id
    AND MONTH(fecha) = mes
    AND YEAR(fecha) = año;
    
    RETURN total_horas;
END;

-- 8. Función para obtener el espacio más reservado
CREATE FUNCTION fn_espacio_mas_reservado()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE espacio_id INT DEFAULT 0;
    
    SELECT id_espacio INTO espacio_id
    FROM reservas
    GROUP BY id_espacio
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    
    RETURN COALESCE(espacio_id, 0);
END;

-- 9. Función para contar reservas activas de un usuario
CREATE FUNCTION fn_reservas_activas(usuario_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE activas INT DEFAULT 0;
    
    SELECT COUNT(*) INTO activas
    FROM reservas r
    INNER JOIN estados_reserva er ON r.id_estado_reserva = er.id_estado_reserva
    WHERE r.id_usuario = usuario_id
    AND er.nombre IN ('Pendiente', 'Confirmada')
    AND r.fecha >= CURDATE();
    
    RETURN activas;
END;

-- 10. Función para duración promedio de reservas en un espacio
CREATE FUNCTION fn_duracion_promedio_reservas(espacio_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(10,2) DEFAULT 0;
    
    SELECT COALESCE(AVG(TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin)), 0) INTO promedio
    FROM reservas
    WHERE id_espacio = espacio_id;
    
    RETURN promedio;
END;

-- Pago y Facturacion 
-- 11. Función para calcular total pagado por usuario
CREATE FUNCTION fn_total_pagado(usuario_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2) DEFAULT 0;
    
    SELECT COALESCE(SUM(p.monto), 0) INTO total
    FROM pagos p
    WHERE p.id_usuario = usuario_id
    AND p.id_estado_pago = 1; -- Solo pagos confirmados
    
    RETURN total;
END;

-- 12. Función para ingresos por mes
CREATE FUNCTION fn_ingresos_por_mes(mes INT, año INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE ingresos DECIMAL(10,2) DEFAULT 0;
    
    SELECT COALESCE(SUM(p.monto), 0) INTO ingresos
    FROM pagos p
    WHERE MONTH(p.fecha) = mes
    AND YEAR(p.fecha) = año
    AND p.id_estado_pago = 1; -- Solo pagos confirmados
    
    RETURN ingresos;
END;

-- 13. Función para ingresos por membresías
CREATE FUNCTION fn_ingresos_por_membresias()
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE ingresos DECIMAL(10,2) DEFAULT 0;
    
    SELECT COALESCE(SUM(p.monto), 0) INTO ingresos
    FROM pagos p
    WHERE p.concepto LIKE '%Membresía%'
    AND p.id_estado_pago = 1; -- Solo pagos confirmados
    
    RETURN ingresos;
END;

-- 14. Función para ingresos por reservas
CREATE FUNCTION fn_ingresos_por_reservas()
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE ingresos DECIMAL(10,2) DEFAULT 0;
    
    SELECT COALESCE(SUM(p.monto), 0) INTO ingresos
    FROM pagos p
    WHERE p.concepto LIKE '%Reserva%'
    AND p.id_estado_pago = 1; -- Solo pagos confirmados
    
    RETURN ingresos;
END;

-- 15. Función para ingresos por empresa
CREATE FUNCTION fn_ingresos_por_empresa(empresa_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE ingresos DECIMAL(10,2) DEFAULT 0;
    
    SELECT COALESCE(SUM(p.monto), 0) INTO ingresos
    FROM pagos p
    INNER JOIN usuarios u ON p.id_usuario = u.id_usuario
    WHERE u.id_empresa = empresa_id
    AND p.id_estado_pago = 1; -- Solo pagos confirmados
    
    RETURN ingresos;
END;

-- Accesos y Asistencias 
-- 16. Función para contar total de asistencias
CREATE FUNCTION fn_total_asistencias(usuario_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT DEFAULT 0;
    
    SELECT COUNT(*) INTO total
    FROM accesos
    WHERE id_usuario = usuario_id
    AND hora_entrada IS NOT NULL;
    
    RETURN total;
END;

-- 17. Función para asistencias en un mes
CREATE FUNCTION fn_asistencias_mes(usuario_id INT, mes INT, año INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT DEFAULT 0;
    
    SELECT COUNT(*) INTO total
    FROM accesos
    WHERE id_usuario = usuario_id
    AND MONTH(fecha) = mes
    AND YEAR(fecha) = año
    AND hora_entrada IS NOT NULL;
    
    RETURN total;
END;

-- 18. Función para obtener usuario con más asistencias
CREATE FUNCTION fn_top_usuario_asistencias()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE usuario_id INT DEFAULT 0;
    
    SELECT id_usuario INTO usuario_id
    FROM accesos
    WHERE hora_entrada IS NOT NULL
    GROUP BY id_usuario
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    
    RETURN COALESCE(usuario_id, 0);
END;

-- 19. Función para obtener última asistencia
CREATE FUNCTION fn_ultima_asistencia(usuario_id INT)
RETURNS DATE
READS SQL DATA
BEGIN
    DECLARE ultima_fecha DATE;
    
    SELECT MAX(fecha) INTO ultima_fecha
    FROM accesos
    WHERE id_usuario = usuario_id
    AND hora_entrada IS NOT NULL;
    
    RETURN ultima_fecha;
END;

-- 20. Función para promedio de asistencias por usuario
CREATE FUNCTION fn_promedio_asistencias()
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(10,2) DEFAULT 0;
    
    SELECT AVG(total_usuario) INTO promedio
    FROM (
        SELECT COUNT(*) as total_usuario
        FROM accesos
        WHERE hora_entrada IS NOT NULL
        GROUP BY id_usuario
    ) as subquery;
    
    RETURN COALESCE(promedio, 0);
END;

-- Uso de las funciones 
-- 1. Verificar si un usuario tiene membresía activa
SELECT fn_membresia_activa(1) as tiene_membresia_activa;

-- 2. Obtener días restantes de membresía
SELECT fn_dias_restantes_membresia(1) as dias_restantes;

-- 3. Saber el tipo de membresía de un usuario
SELECT fn_tipo_membresia(1) as tipo_membresia;

-- 4. Contar renovaciones de un usuario
SELECT fn_renovaciones_membresia(1) as total_renovaciones;

-- 5. Ver el estado de la membresía
SELECT fn_estado_membresia(1) as estado_membresia;

-- 6. Total de reservas de un usuario
SELECT fn_total_reservas(1) as total_reservas;

-- 7. Horas reservadas por un usuario en septiembre 2025
SELECT fn_horas_reservadas(1, 9, 2025) as horas_reservadas;

-- 8. ID del espacio más reservado
SELECT fn_espacio_mas_reservado() as espacio_popular;

-- 9. Reservas activas de un usuario
SELECT fn_reservas_activas(1) as reservas_activas;

-- 10. Duración promedio de reservas en un espacio
SELECT fn_duracion_promedio_reservas(1) as duracion_promedio;

-- 11. Total pagado por un usuario
SELECT fn_total_pagado(1) as total_pagado;

-- 12. Ingresos en septiembre 2025
SELECT fn_ingresos_por_mes(9, 2025) as ingresos_septiembre;

-- 13. Ingresos por membresías
SELECT fn_ingresos_por_membresias() as ingresos_membresias;

-- 14. Ingresos por reservas
SELECT fn_ingresos_por_reservas() as ingresos_reservas;

-- 15. Ingresos por empresa
SELECT fn_ingresos_por_empresa(1) as ingresos_empresa;

-- 16. Total de asistencias de un usuario
SELECT fn_total_asistencias(1) as total_asistencias;

-- 17. Asistencias en septiembre 2025
SELECT fn_asistencias_mes(1, 9, 2025) as asistencias_septiembre;

-- 18. Usuario con más asistencias
SELECT fn_top_usuario_asistencias() as usuario_top;

-- 19. Última asistencia de un usuario
SELECT fn_ultima_asistencia(1) as ultima_asistencia;

-- 20. Promedio de asistencias por usuario
SELECT fn_promedio_asistencias() as promedio_asistencias;


-- Procedimientos Almacenados
-- Membresias 
-- 1. Registrar nueva membresía
CREATE PROCEDURE sp_registrar_membresia(
    IN p_id_usuario INT,
    IN p_id_tipo_membresia INT,
    IN p_fecha_inicio DATE
)
BEGIN
    DECLARE v_duracion INT;
    DECLARE v_fecha_fin DATE;
    
    -- Obtener duración según tipo de membresía
    SELECT 
        CASE nombre
            WHEN 'Diaria' THEN 1
            WHEN 'Mensual' THEN 30
            WHEN 'Corporativa' THEN 90
            WHEN 'Premium' THEN 60
            ELSE 30
        END INTO v_duracion
    FROM tipos_membresia 
    WHERE id_tipo_membresia = p_id_tipo_membresia;
    
    SET v_fecha_fin = DATE_ADD(p_fecha_inicio, INTERVAL v_duracion DAY);
    
    INSERT INTO membresias (id_usuario, id_tipo_membresia, id_estado_membresia, fecha_inicio, fecha_fin)
    VALUES (p_id_usuario, p_id_tipo_membresia, 1, p_fecha_inicio, v_fecha_fin);
END;

-- 2. Renovar membresía existente
CREATE PROCEDURE sp_renovar_membresia(IN p_id_membresia INT)
BEGIN
    DECLARE v_duracion INT;
    DECLARE v_id_tipo_membresia INT;
    
    SELECT id_tipo_membresia INTO v_id_tipo_membresia
    FROM membresias WHERE id_membresia = p_id_membresia;
    
    SELECT 
        CASE nombre
            WHEN 'Diaria' THEN 1
            WHEN 'Mensual' THEN 30
            WHEN 'Corporativa' THEN 90
            WHEN 'Premium' THEN 60
            ELSE 30
        END INTO v_duracion
    FROM tipos_membresia 
    WHERE id_tipo_membresia = v_id_tipo_membresia;
    
    UPDATE membresias
    SET fecha_fin = DATE_ADD(fecha_fin, INTERVAL v_duracion DAY),
        id_estado_membresia = 1
    WHERE id_membresia = p_id_membresia;
    
    INSERT INTO renovaciones (id_membresia, fecha_renovacion)
    VALUES (p_id_membresia, CURDATE());
END;

-- 3. Actualizar membresías vencidas
CREATE PROCEDURE sp_actualizar_membresias_vencidas()
BEGIN
    UPDATE membresias
    SET id_estado_membresia = 3
    WHERE fecha_fin < CURDATE()
    AND id_estado_membresia != 3;
END;

-- 4. Suspender membresías con facturas impagas
CREATE PROCEDURE sp_suspender_membresias_impagas(IN p_dias_impago INT)
BEGIN
    UPDATE membresias m
    JOIN usuarios u ON m.id_usuario = u.id_usuario
    JOIN facturas f ON u.id_usuario = f.id_usuario
    SET m.id_estado_membresia = 2
    WHERE f.id_estado_factura IN (2, 4) -- Pendiente o Vencida
    AND DATEDIFF(CURDATE(), f.fecha_pago_oportuno) > p_dias_impago
    AND m.id_estado_membresia = 1;
END;

-- 5. Verificar disponibilidad de espacio
CREATE PROCEDURE sp_verificar_disponibilidad(
    IN p_id_espacio INT,
    IN p_fecha DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME,
    OUT p_disponible BOOLEAN
)
BEGIN
    DECLARE v_ocupado INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_ocupado
    FROM reservas
    WHERE id_espacio = p_id_espacio
    AND fecha = p_fecha
    AND id_estado_reserva IN (1, 2)
    AND (
        (p_hora_inicio BETWEEN hora_inicio AND hora_fin) OR
        (p_hora_fin BETWEEN hora_inicio AND hora_fin) OR
        (hora_inicio BETWEEN p_hora_inicio AND p_hora_fin)
    );
    
    SET p_disponible = (v_ocupado = 0);
END;

-- 6. Crear nueva reserva
CREATE PROCEDURE sp_crear_reserva(
    IN p_id_usuario INT,
    IN p_id_espacio INT,
    IN p_fecha DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME,
    IN p_numero_asistentes INT
)
BEGIN
    DECLARE v_disponible BOOLEAN;
    
    CALL sp_verificar_disponibilidad(p_id_espacio, p_fecha, p_hora_inicio, p_hora_fin, v_disponible);
    
    IF v_disponible THEN
        INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, fecha, hora_inicio, hora_fin, numero_asistentes)
        VALUES (p_id_usuario, p_id_espacio, 1, p_fecha, p_hora_inicio, p_hora_fin, p_numero_asistentes);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Espacio no disponible en el horario seleccionado';
    END IF;
END;

-- 7. Confirmar reserva con pago
CREATE PROCEDURE sp_confirmar_reserva(IN p_id_reserva INT, IN p_id_pago INT)
BEGIN
    UPDATE reservas
    SET id_estado_reserva = 2
    WHERE id_reserva = p_id_reserva;
    
    UPDATE facturas 
    SET id_reserva = p_id_reserva 
    WHERE id_pago = p_id_pago;
END;

-- 8. Cancelar reserva con reembolso
CREATE PROCEDURE sp_cancelar_reserva(IN p_id_reserva INT, IN p_porcentaje_reembolso DECIMAL(5,2))
BEGIN
    DECLARE v_monto_total DECIMAL(10,2);
    DECLARE v_id_usuario INT;
    
    SELECT total, id_usuario INTO v_monto_total, v_id_usuario
    FROM facturas f
    JOIN reservas r ON f.id_reserva = r.id_reserva
    WHERE r.id_reserva = p_id_reserva;
    
    UPDATE reservas
    SET id_estado_reserva = 3
    WHERE id_reserva = p_id_reserva;
    
    IF p_porcentaje_reembolso > 0 THEN
        INSERT INTO pagos (id_usuario, monto, concepto, id_metodo_pago, id_estado_pago)
        VALUES (v_id_usuario, -(v_monto_total * p_porcentaje_reembolso / 100), 
                'Reembolso por cancelación', 1, 1);
    END IF;
END;

-- 9. Liberar reservas no confirmadas
CREATE PROCEDURE sp_liberar_reservas_pendientes(IN p_horas_limite INT)
BEGIN
    UPDATE reservas
    SET id_estado_reserva = 3
    WHERE id_estado_reserva = 1
    AND TIMESTAMPDIFF(HOUR, NOW(), CONCAT(fecha, ' ', hora_inicio)) < -p_horas_limite;
END;

-- 10. Generar factura por membresía
CREATE PROCEDURE sp_generar_factura_membresia(IN p_id_membresia INT, IN p_id_pago INT)
BEGIN
    DECLARE v_id_usuario INT;
    DECLARE v_monto DECIMAL(10,2);
    
    SELECT m.id_usuario, tm.precio INTO v_id_usuario, v_monto
    FROM membresias m
    JOIN tipos_membresia tm ON m.id_tipo_membresia = tm.id_tipo_membresia
    WHERE m.id_membresia = p_id_membresia;
    
    INSERT INTO facturas (id_usuario, id_membresia, id_pago, fecha, total, id_estado_factura)
    VALUES (v_id_usuario, p_id_membresia, p_id_pago, NOW(), v_monto, 
           CASE WHEN p_id_pago IS NOT NULL THEN 1 ELSE 2 END);
END;

-- 11. Generar factura consolidada para empresa
CREATE PROCEDURE sp_generar_factura_empresa(IN p_id_empresa INT)
BEGIN
    INSERT INTO facturas (id_usuario, fecha, total, id_estado_factura)
    SELECT u.id_usuario, NOW(), SUM(p.monto), 1
    FROM usuarios u
    JOIN pagos p ON u.id_usuario = p.id_usuario
    WHERE u.id_empresa = p_id_empresa
    AND p.id_estado_pago = 1
    GROUP BY u.id_usuario;
END;

-- 12. Aplicar recargos a facturas vencidas
CREATE PROCEDURE sp_aplicar_recargos(IN p_dias_retraso INT, IN p_porcentaje_recargo DECIMAL(5,2))
BEGIN
    UPDATE facturas
    SET total = total * (1 + p_porcentaje_recargo / 100)
    WHERE id_estado_factura = 4
    AND DATEDIFF(CURDATE(), fecha_pago_oportuno) > p_dias_retraso;
END;

-- 13. Bloquear servicios por falta de pago
CREATE PROCEDURE sp_bloquear_servicios_impagos()
BEGIN
    UPDATE usuarios u
    SET activo = FALSE
    WHERE EXISTS (
        SELECT 1 FROM facturas f
        WHERE f.id_usuario = u.id_usuario
        AND f.id_estado_factura IN (2, 4)
        AND DATEDIFF(CURDATE(), f.fecha_pago_oportuno) > 30
    );
END;

-- 14. Registrar acceso de usuario
CREATE PROCEDURE sp_registrar_acceso(IN p_id_usuario INT, IN p_id_metodo_acceso INT)
BEGIN
    IF fn_membresia_activa(p_id_usuario) THEN
        INSERT INTO accesos (id_usuario, fecha, hora_entrada, id_metodo_acceso)
        VALUES (p_id_usuario, CURDATE(), CURTIME(), p_id_metodo_acceso);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario no tiene membresía activa';
    END IF;
END;

-- 15. Registrar salida de usuario
CREATE PROCEDURE sp_registrar_salida(IN p_id_usuario INT)
BEGIN
    UPDATE accesos
    SET hora_salida = CURTIME()
    WHERE id_usuario = p_id_usuario
    AND fecha = CURDATE()
    AND hora_salida IS NULL
    ORDER BY hora_entrada DESC
    LIMIT 1;
END;

-- 16. Generar reporte diario de asistencias
CREATE PROCEDURE sp_reporte_asistencias_diario(IN p_fecha DATE)
BEGIN
    SELECT 
        COUNT(*) as total_accesos,
        COUNT(DISTINCT id_usuario) as usuarios_unicos,
        MIN(hora_entrada) as primer_ingreso,
        MAX(hora_entrada) as ultimo_ingreso
    FROM accesos
    WHERE fecha = p_fecha;
END;

-- 17. Marcar No Show y generar penalización
CREATE PROCEDURE sp_marcar_no_show()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id_reserva INT;
    DECLARE v_id_usuario INT;
    DECLARE cur CURSOR FOR 
        SELECT id_reserva, id_usuario
        FROM reservas
        WHERE fecha = CURDATE()
        AND id_estado_reserva = 2
        AND asistio = FALSE;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_id_reserva, v_id_usuario;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Insertar penalización
        INSERT INTO pagos (id_usuario, monto, concepto, id_metodo_pago, id_estado_pago)
        VALUES (v_id_usuario, 50.00, 'Penalización por No Show', 1, 2);
    END LOOP;
    CLOSE cur;
END;

-- 18. Registrar lote de empleados corporativos
CREATE PROCEDURE sp_registrar_empleados_corporativos(
    IN p_id_empresa INT,
    IN p_csv_empleados TEXT
)
BEGIN
    DECLARE v_nombre VARCHAR(100);
    DECLARE v_apellidos VARCHAR(100);
    DECLARE v_email VARCHAR(100);
    DECLARE v_rest TEXT;
    
    WHILE LENGTH(p_csv_empleados) > 0 DO
        SET v_nombre = SUBSTRING_INDEX(SUBSTRING_INDEX(p_csv_empleados, ',', 1), ',', -1);
        SET p_csv_empleados = SUBSTRING(p_csv_empleados, LENGTH(v_nombre) + 2);
        SET v_apellidos = SUBSTRING_INDEX(SUBSTRING_INDEX(p_csv_empleados, ',', 1), ',', -1);
        SET p_csv_empleados = SUBSTRING(p_csv_empleados, LENGTH(v_apellidos) + 2);
        SET v_email = SUBSTRING_INDEX(SUBSTRING_INDEX(p_csv_empleados, ';', 1), ';', -1);
        SET p_csv_empleados = SUBSTRING(p_csv_empleados, LENGTH(v_email) + 2);
        
        INSERT INTO usuarios (nombre, apellidos, email, id_empresa)
        VALUES (v_nombre, v_apellidos, v_email, p_id_empresa);
        
        SET @v_id_usuario = LAST_INSERT_ID();
        
        CALL sp_registrar_membresia(@v_id_usuario, 3, CURDATE());
    END WHILE;
END;

-- 19. Cancelar reservas al eliminar membresía
CREATE PROCEDURE sp_cancelar_reservas_membresia(IN p_id_usuario INT)
BEGIN
    UPDATE reservas
    SET id_estado_reserva = 3
    WHERE id_usuario = p_id_usuario
    AND fecha >= CURDATE()
    AND id_estado_reserva IN (1, 2);
END;

-- 20. Generar reporte de ingresos mensuales
CREATE PROCEDURE sp_reporte_ingresos_mensuales(IN p_anio INT)
BEGIN
    SELECT 
        MONTH(fecha) as mes,
        SUM(total) as ingresos_mes,
        SUM(SUM(total)) OVER (ORDER BY MONTH(fecha)) as acumulado
    FROM facturas
    WHERE YEAR(fecha) = p_anio
    AND id_estado_factura = 1
    GROUP BY MONTH(fecha)
    ORDER BY mes;
END;

-- pruebas 

-- 1. Registrar nueva membresía
CALL sp_registrar_membresia(1, 2, '2025-09-01');

-- 2. Renovar membresía
CALL sp_renovar_membresia(1);

-- 3. Actualizar membresías vencidas (ejecutar diariamente)
CALL sp_actualizar_membresias_vencidas();

-- 4. Verificar disponibilidad
SET @disponible = FALSE;
CALL sp_verificar_disponibilidad(1, '2025-09-01', '09:00:00', '12:00:00', @disponible);
SELECT @disponible;

-- 5. Crear reserva
CALL sp_crear_reserva(1, 1, '2025-09-01', '09:00:00', '12:00:00', 2);

-- 6. Generar reporte de asistencias
CALL sp_reporte_asistencias_diario('2025-09-01');

-- 7. Generar reporte de ingresos
CALL sp_reporte_ingresos_mensuales(2025);

SHOW EVENTS;


-- Consultas 



-- Datos para algunas consultas 
-- Insertar accesos para el mes actual
INSERT INTO accesos (id_usuario, fecha, hora_entrada, hora_salida, id_metodo_acceso)
VALUES
(1, CURDATE(), '08:00:00', '17:00:00', 1),
(1, CURDATE(), '18:00:00', '20:00:00', 1), -- mismo día dos veces
(2, CURDATE(), '09:00:00', '18:00:00', 2),
(3, CURDATE(), '10:00:00', '15:00:00', 1),
(4, CURDATE(), '07:00:00', '19:00:00', 2), -- fuera de horario para membresía no premium
(5, '2025-09-01', '08:00:00', '17:00:00', 1),
(5, '2025-09-02', '08:00:00', '17:00:00', 1),
(5, '2025-09-03', '08:00:00', '17:00:00', 1),
(5, '2025-09-04', '08:00:00', '17:00:00', 1),
(5, '2025-09-05', '08:00:00', '17:00:00', 1),
(5, '2025-09-06', '08:00:00', '17:00:00', 1), -- fin de semana
(5, '2025-09-07', '08:00:00', '17:00:00', 1), -- fin de semana
(5, '2025-09-08', '08:00:00', '17:00:00', 1),
(5, '2025-09-09', '08:00:00', '17:00:00', 1),
(5, '2025-09-10', '08:00:00', '17:00:00', 1),
(5, '2025-09-11', '08:00:00', '17:00:00', 1),
(5, '2025-09-12', '08:00:00', '17:00:00', 1),
(5, '2025-09-13', '08:00:00', '17:00:00', 1), -- fin de semana
(5, '2025-09-14', '08:00:00', '17:00:00', 1), -- fin de semana
(5, '2025-09-15', '08:00:00', '17:00:00', 1),
(5, '2025-09-16', '08:00:00', '17:00:00', 1),
(5, '2025-09-17', '08:00:00', '17:00:00', 1),
(5, '2025-09-18', '08:00:00', '17:00:00', 1),
(5, '2025-09-19', '08:00:00', '17:00:00', 1),
(5, '2025-09-20', '08:00:00', '17:00:00', 1),
(5, '2025-09-21', '08:00:00', '17:00:00', 1), -- fin de semana
(5, '2025-09-22', '08:00:00', '17:00:00', 1),
(5, '2025-09-23', '08:00:00', '17:00:00', 1),
(5, '2025-09-24', '08:00:00', '17:00:00', 1),
(5, '2025-09-25', '08:00:00', '17:00:00', 1),
(5, '2025-09-26', '08:00:00', '17:00:00', 1),
(5, '2025-09-27', '08:00:00', '17:00:00', 1), -- fin de semana
(5, '2025-09-28', '08:00:00', '17:00:00', 1), -- fin de semana
(5, '2025-09-29', '08:00:00', '17:00:00', 1),
(5, '2025-09-30', '08:00:00', '17:00:00', 1); -- 30 accesos en septiembre para el usuario 5

-- Insertar accesos para usuarios con membresía vencida
INSERT INTO accesos (id_usuario, fecha, hora_entrada, hora_salida, id_metodo_acceso)
VALUES
(1, CURDATE(), '08:00:00', '17:00:00', 1); -- usuario 1 tiene membresía vencida

-- Insertar accesos rechazados (hora_entrada NULL) con QR
INSERT INTO accesos (id_usuario, fecha, hora_entrada, hora_salida, id_metodo_acceso)
VALUES
(1, CURDATE(), NULL, NULL, 2); -- QR inválido

-- Reservas 
-- Insertar reservas para el día actual
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin)
VALUES
(1, 1, 2, 1, TRUE, CURDATE(), '09:00:00', '12:00:00'),
(2, 2, 2, 1, TRUE, CURDATE(), '10:00:00', '14:00:00'),
(3, 3, 1, 1, FALSE, CURDATE(), '11:00:00', '13:00:00');

-- Insertar muchas reservas para el usuario 5 (más de 20)
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin)
SELECT 
  5, 
  1, 
  2, 
  1, 
  TRUE, 
  DATE_ADD('2025-09-01', INTERVAL (n-1) DAY),
  '09:00:00', 
  '12:00:00'
FROM 
  (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
   UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
   UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30) numbers
WHERE n <= 30;

-- Insertar reservas que se solapan
INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, numero_asistentes, asistio, fecha, hora_inicio, hora_fin)
VALUES
(1, 1, 2, 1, TRUE, '2025-09-01', '09:00:00', '11:00:00'),
(2, 1, 2, 1, TRUE, '2025-09-01', '10:00:00', '12:00:00'); -- Solapamiento

-- Insertar reservas con servicios adicionales
INSERT INTO reserva_servicio (id_reserva, id_servicio)
VALUES
(1, 1),
(1, 2),
(2, 3);

-- Insertar facturas para el usuario 5 con total alto
INSERT INTO facturas (id_usuario, id_reserva, id_membresia, id_pago, fecha, fecha_pago_oportuno, total, id_estado_factura)
SELECT 
  5, 
  NULL, 
  NULL, 
  NULL, 
  DATE_ADD('2025-09-01', INTERVAL (n-1) DAY),
  DATE_ADD(DATE_ADD('2025-09-01', INTERVAL (n-1) DAY), INTERVAL 5 DAY),
  1000,
  1
FROM 
  (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
   UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
   UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30) numbers
WHERE n <= 30;

-- Actualizar membresía del usuario 5 a activa
UPDATE membresias SET id_estado_membresia = 1, fecha_fin = '2025-12-31' WHERE id_usuario = 5;

-- Usuarios y Membresias 
-- 1. Listar todos los usuarios con su información básica
SELECT id_usuario, identificacion, nombre, apellidos, fecha_nacimiento, telefono, email, id_empresa 
FROM usuarios;

-- 2. Listar los usuarios con membresía activa
SELECT u.* 
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
JOIN estados_membresia em ON m.id_estado_membresia = em.id_estado_membresia
WHERE em.nombre = 'Activa' AND m.fecha_fin >= CURDATE();

-- 3. Listar los usuarios cuya membresía está vencida
SELECT u.* 
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
JOIN estados_membresia em ON m.id_estado_membresia = em.id_estado_membresia
WHERE em.nombre = 'Vencida';

-- 4. Listar los usuarios con membresía suspendida
SELECT u.* 
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
JOIN estados_membresia em ON m.id_estado_membresia = em.id_estado_membresia
WHERE em.nombre = 'Suspendida';

-- 5. Contar cuántos usuarios tienen cada tipo de membresía
SELECT tm.nombre, COUNT(*) as total_usuarios
FROM membresias m
JOIN tipos_membresia tm ON m.id_tipo_membresia = tm.id_tipo_membresia
GROUP BY tm.nombre;

-- 6. Mostrar el top 10 de usuarios con más antigüedad en el coworking
SELECT u.*, MIN(m.fecha_inicio) as fecha_inicio_membresia
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
GROUP BY u.id_usuario
ORDER BY fecha_inicio_membresia ASC
LIMIT 10;

-- 7. Listar usuarios que pertenecen a una empresa específica
SELECT u.* 
FROM usuarios u
WHERE u.id_empresa = 1; -- Reemplazar con ID de empresa deseado

-- 8. Contar cuántos usuarios están asociados a cada empresa
SELECT e.nombre, COUNT(u.id_usuario) as total_usuarios
FROM empresas e
LEFT JOIN usuarios u ON e.id_empresa = u.id_empresa
GROUP BY e.id_empresa;

-- 9. Mostrar usuarios que nunca han hecho una reserva
SELECT u.*
FROM usuarios u
LEFT JOIN reservas r ON u.id_usuario = r.id_usuario
WHERE r.id_reserva IS NULL;

-- 10. Mostrar usuarios con más de 5 reservas activas en el mes
SELECT u.id_usuario, u.nombre, COUNT(r.id_reserva) as total_reservas
FROM usuarios u
JOIN reservas r ON u.id_usuario = r.id_usuario
WHERE r.fecha BETWEEN '2025-09-01' AND '2025-09-30' -- Ajustar rango de fechas
AND r.id_estado_reserva IN (1,2)
GROUP BY u.id_usuario
HAVING total_reservas > 5;

-- 11. Calcular el promedio de edad de los usuarios
SELECT AVG(TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE())) as edad_promedio
FROM usuarios;

-- 12. Listar usuarios que han cambiado de membresía más de 2 veces
SELECT u.id_usuario, u.nombre, COUNT(DISTINCT m.id_tipo_membresia) as cambios_membresia
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
GROUP BY u.id_usuario
HAVING cambios_membresia > 0; -- no hay dato con 2 cambios

-- 13. Listar usuarios que han gastado más de $500 en reservas
SELECT u.id_usuario, u.nombre, SUM(p.monto) as total_gastado
FROM usuarios u
JOIN pagos p ON u.id_usuario = p.id_usuario
WHERE p.concepto LIKE '%Reserva%' AND p.id_estado_pago = 1
GROUP BY u.id_usuario
HAVING total_gastado > 500;

-- 14. Mostrar usuarios que tienen tanto membresía como servicios adicionales
SELECT DISTINCT u.*
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
JOIN usuario_servicio us ON u.id_usuario = us.id_usuario;

-- 15. Listar usuarios con membresía Premium y reservas activas
SELECT u.*
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
JOIN tipos_membresia tm ON m.id_tipo_membresia = tm.id_tipo_membresia
JOIN reservas r ON u.id_usuario = r.id_usuario
WHERE tm.nombre = 'Premium' AND r.id_estado_reserva IN (1,2);

-- 16. Mostrar usuarios con membresía Corporativa y su empresa
SELECT u.*, e.nombre as empresa
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
JOIN tipos_membresia tm ON m.id_tipo_membresia = tm.id_tipo_membresia
JOIN empresas e ON u.id_empresa = e.id_empresa
WHERE tm.nombre = 'Corporativa';

-- 17. Identificar usuarios con membresía diaria que la han renovado más de 10 veces
SELECT u.id_usuario, u.nombre, COUNT(r.id_renovacion) as total_renovaciones
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
JOIN tipos_membresia tm ON m.id_tipo_membresia = tm.id_tipo_membresia
JOIN renovaciones r ON m.id_membresia = r.id_membresia
WHERE tm.nombre = 'Diaria'
GROUP BY u.id_usuario
HAVING total_renovaciones > 10;

-- 18. Mostrar usuarios cuya membresía vence en los próximos 7 días
SELECT u.*, m.fecha_fin
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
WHERE m.fecha_fin BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
AND m.id_estado_membresia = 1;

-- 19. Listar usuarios que se registraron en el último mes
SELECT *
FROM usuarios
WHERE fecha_registro >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 20. Mostrar usuarios que nunca han asistido al coworking (0 accesos)
SELECT u.*
FROM usuarios u
LEFT JOIN accesos a ON u.id_usuario = a.id_usuario
WHERE a.id_acceso IS NULL;

-- Espacios y Reservas 
-- 21. Listar todos los espacios disponibles con su capacidad
SELECT id_espacio, nombre, capacidad, horario_disponible
FROM espacios;

-- 22. Listar reservas activas en el día actual
SELECT *
FROM reservas
WHERE fecha = CURDATE() AND id_estado_reserva IN (1,2);

-- 23. Mostrar reservas canceladas en el último mes
SELECT *
FROM reservas
WHERE id_estado_reserva = 3
AND fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE();

-- 24. Listar reservas de salas de reuniones en horario pico (9 am – 11 am)
SELECT r.*
FROM reservas r
JOIN espacios e ON r.id_espacio = e.id_espacio
JOIN tipos_espacios te ON e.id_tipo_espacio = te.id_tipo_espacio
WHERE te.nombre = 'Sala Reuniones'
AND TIME(r.hora_inicio) BETWEEN '09:00:00' AND '11:00:00';

-- 25. Contar cuántas reservas se hacen por cada tipo de espacio
SELECT te.nombre, COUNT(r.id_reserva) as total_reservas
FROM reservas r
JOIN espacios e ON r.id_espacio = e.id_espacio
JOIN tipos_espacios te ON e.id_tipo_espacio = te.id_tipo_espacio
GROUP BY te.nombre;

-- 26. Mostrar el espacio más reservado del último mes
SELECT e.nombre, COUNT(r.id_reserva) as total_reservas
FROM reservas r
JOIN espacios e ON r.id_espacio = e.id_espacio
WHERE r.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE()
GROUP BY e.id_espacio
ORDER BY total_reservas DESC
LIMIT 1;

-- 27. Listar usuarios que más han reservado salas privadas
SELECT u.id_usuario, u.nombre, COUNT(r.id_reserva) as total_reservas
FROM usuarios u
JOIN reservas r ON u.id_usuario = r.id_usuario
JOIN espacios e ON r.id_espacio = e.id_espacio
JOIN tipos_espacios te ON e.id_tipo_espacio = te.id_tipo_espacio
WHERE te.nombre = 'Oficina Privada'
GROUP BY u.id_usuario
ORDER BY total_reservas DESC;

-- 28. Mostrar reservas que exceden la capacidad máxima del espacio
SELECT r.*, e.capacidad
FROM reservas r
JOIN espacios e ON r.id_espacio = e.id_espacio
WHERE r.numero_asistentes > e.capacidad;

-- 29. Listar espacios que no se han reservado en la última semana
SELECT e.*
FROM espacios e
LEFT JOIN reservas r ON e.id_espacio = r.id_espacio
AND r.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE()
WHERE r.id_reserva IS NULL;

-- 30. Calcular la tasa de ocupación promedio de cada espacio
SELECT e.id_espacio, e.nombre,
    AVG(TIMESTAMPDIFF(HOUR, r.hora_inicio, r.hora_fin)) as ocupacion_promedio
FROM espacios e
LEFT JOIN reservas r ON e.id_espacio = r.id_espacio
GROUP BY e.id_espacio;

-- 31. Mostrar reservas de más de 8 horas
SELECT *
FROM reservas
WHERE TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin) > 8;

-- 32. Identificar usuarios con más de 20 reservas en total
SELECT u.id_usuario, u.nombre, COUNT(r.id_reserva) as total_reservas
FROM usuarios u
JOIN reservas r ON u.id_usuario = r.id_usuario
GROUP BY u.id_usuario
HAVING total_reservas > 20; -- en blanco 

-- 33. Mostrar reservas realizadas por empresas con más de 10 empleados
SELECT r.*
FROM reservas r
JOIN usuarios u ON r.id_usuario = u.id_usuario
JOIN empresas e ON u.id_empresa = e.id_empresa
WHERE e.id_empresa IN (
    SELECT id_empresa
    FROM usuarios
    GROUP BY id_empresa
    HAVING COUNT(*) > 10
); -- no hay dato

-- 34. Listar reservas que se solapan en horario
SELECT r1.*, r2.*
FROM reservas r1
JOIN reservas r2 ON r1.id_espacio = r2.id_espacio
AND r1.fecha = r2.fecha
AND r1.id_reserva != r2.id_reserva
AND (
    (r1.hora_inicio BETWEEN r2.hora_inicio AND r2.hora_fin) OR
    (r1.hora_fin BETWEEN r2.hora_inicio AND r2.hora_fin) OR
    (r2.hora_inicio BETWEEN r1.hora_inicio AND r1.hora_fin)
); -- sin dato 
-- 35. Listar reservas de fin de semana
SELECT *
FROM reservas
WHERE DAYOFWEEK(fecha) IN (1,7);

-- 36. Mostrar el porcentaje de ocupación por cada tipo de espacio
SELECT te.nombre,
    (SUM(TIMESTAMPDIFF(HOUR, r.hora_inicio, r.hora_fin)) / (COUNT(DISTINCT e.id_espacio) * 12)) * 100 as porcentaje_ocupacion
FROM tipos_espacios te
JOIN espacios e ON te.id_tipo_espacio = e.id_tipo_espacio
LEFT JOIN reservas r ON e.id_espacio = r.id_espacio
GROUP BY te.id_tipo_espacio;

-- 37. Mostrar la duración promedio de reservas por tipo de espacio
SELECT te.nombre, AVG(TIMESTAMPDIFF(HOUR, r.hora_inicio, r.hora_fin)) as duracion_promedio
FROM tipos_espacios te
JOIN espacios e ON te.id_tipo_espacio = e.id_tipo_espacio
LEFT JOIN reservas r ON e.id_espacio = r.id_espacio
GROUP BY te.id_tipo_espacio;

-- 38. Mostrar reservas con servicios adicionales incluidos
SELECT DISTINCT r.*
FROM reservas r
JOIN reserva_servicio rs ON r.id_reserva = rs.id_reserva;

-- 39. Listar usuarios que reservaron sala de eventos en los últimos 6 meses
SELECT DISTINCT u.*
FROM usuarios u
JOIN reservas r ON u.id_usuario = r.id_usuario
JOIN espacios e ON r.id_espacio = e.id_espacio
JOIN tipos_espacios te ON e.id_tipo_espacio = te.id_tipo_espacio
WHERE te.nombre = 'Sala Eventos'
AND r.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 6 MONTH) AND CURDATE();

-- 40. Identificar reservas realizadas y nunca asistidas
SELECT *
FROM reservas
WHERE asistio = FALSE AND id_estado_reserva = 2;

-- Pagos y Facturacion 
-- 41. Listar todos los pagos realizados con método tarjeta
SELECT p.*
FROM pagos p
JOIN metodos_pago mp ON p.id_metodo_pago = mp.id_metodo_pago
WHERE mp.nombre = 'Tarjeta';

-- 42. Listar pagos pendientes de usuarios
SELECT p.*, u.nombre
FROM pagos p
JOIN usuarios u ON p.id_usuario = u.id_usuario
WHERE p.id_estado_pago = 2;

-- 43. Mostrar pagos cancelados en los últimos 3 meses
SELECT p.*
FROM pagos p
WHERE p.id_estado_pago = 3
AND p.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 3 MONTH) AND CURDATE();

-- 44. Listar facturas generadas por membresías
SELECT f.*
FROM facturas f
WHERE f.id_membresia IS NOT NULL;

-- 45. Listar facturas generadas por reservas
SELECT f.*
FROM facturas f
WHERE f.id_reserva IS NOT NULL;

-- 46. Mostrar el total de ingresos por membresías en el último mes
SELECT SUM(p.monto) as ingresos_membresias
FROM pagos p
WHERE p.concepto LIKE '%Membresía%'
AND p.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE()
AND p.id_estado_pago = 1;

-- 47. Mostrar el total de ingresos por reservas en el último mes
SELECT SUM(p.monto) as ingresos_reservas
FROM pagos p
WHERE p.concepto LIKE '%Reserva%'
AND p.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE()
AND p.id_estado_pago = 1;

-- 48. Mostrar el total de ingresos por servicios adicionales
SELECT SUM(p.monto) as ingresos_servicios
FROM pagos p
WHERE p.concepto LIKE '%Servicio%'
AND p.id_estado_pago = 1;

-- 49. Identificar usuarios que nunca han pagado con PayPal
SELECT u.*
FROM usuarios u
WHERE u.id_usuario NOT IN (
    SELECT DISTINCT p.id_usuario
    FROM pagos p
    JOIN metodos_pago mp ON p.id_metodo_pago = mp.id_metodo_pago
    WHERE mp.nombre = 'PayPal'
);

-- 50. Calcular el promedio de gasto por usuario
SELECT AVG(total_gastado) as gasto_promedio
FROM (
    SELECT id_usuario, SUM(monto) as total_gastado
    FROM pagos
    WHERE id_estado_pago = 1
    GROUP BY id_usuario
) as gastos_usuarios;

-- 51. Mostrar el top 5 de usuarios que más han pagado en total
SELECT u.id_usuario, u.nombre, SUM(p.monto) as total_pagado
FROM usuarios u
JOIN pagos p ON u.id_usuario = p.id_usuario
WHERE p.id_estado_pago = 1
GROUP BY u.id_usuario
ORDER BY total_pagado DESC
LIMIT 5;

-- 52. Mostrar facturas con monto mayor a $1000
SELECT *
FROM facturas
WHERE total > 1000;

-- 53. Listar pagos realizados después de la fecha de vencimiento
SELECT p.*
FROM pagos p
JOIN facturas f ON p.id_pago = f.id_pago
WHERE p.fecha > f.fecha_pago_oportuno;

-- 54. Calcular el total recaudado en el año actual
SELECT SUM(total) as total_recaudado
FROM facturas
WHERE YEAR(fecha) = YEAR(CURDATE())
AND id_estado_factura = 1;

-- 55. Mostrar facturas anuladas y su motivo
SELECT *, motivo_cancelacion
FROM facturas
WHERE id_estado_factura = 3;

-- 56. Mostrar usuarios con facturas pendientes mayores a $200
SELECT u.*, f.total
FROM usuarios u
JOIN facturas f ON u.id_usuario = f.id_usuario
WHERE f.id_estado_factura = 2
AND f.total > 200;

-- 57. Mostrar usuarios que han pagado más de una vez el mismo servicio
SELECT u.id_usuario, u.nombre, s.nombre, COUNT(*) as veces_pagado
FROM usuarios u
JOIN pagos p ON u.id_usuario = p.id_usuario
JOIN servicios s ON p.concepto LIKE CONCAT('%', s.nombre, '%')
GROUP BY u.id_usuario, s.id_servicio
HAVING veces_pagado > 1;

-- 58. Listar ingresos por cada método de pago
SELECT mp.nombre, SUM(p.monto) as total_ingresos
FROM pagos p
JOIN metodos_pago mp ON p.id_metodo_pago = mp.id_metodo_pago
WHERE p.id_estado_pago = 1
GROUP BY mp.nombre;

-- 59. Mostrar facturación acumulada por empresa
SELECT e.nombre, SUM(f.total) as facturacion_total
FROM empresas e
JOIN usuarios u ON e.id_empresa = u.id_empresa
JOIN facturas f ON u.id_usuario = f.id_usuario
WHERE f.id_estado_factura = 1
GROUP BY e.id_empresa;

-- 60. Mostrar ingresos netos por mes del último año
SELECT YEAR(fecha) as año, MONTH(fecha) as mes, SUM(total) as ingresos
FROM facturas
WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
AND id_estado_factura = 1
GROUP BY YEAR(fecha), MONTH(fecha)
ORDER BY año, mes;

-- Accesos y Asisitencias
-- 61. Listar todos los accesos registrados hoy
SELECT *
FROM accesos
WHERE fecha = CURDATE(); -- no hay dato 


-- 62. Mostrar usuarios con más de 20 asistencias en el mes
SELECT u.id_usuario, u.nombre, COUNT(a.id_acceso) as total_asistencias
FROM usuarios u
JOIN accesos a ON u.id_usuario = a.id_usuario
WHERE MONTH(a.fecha) = MONTH(CURDATE())
AND YEAR(a.fecha) = YEAR(CURDATE())
AND a.hora_entrada IS NOT NULL
GROUP BY u.id_usuario
HAVING total_asistencias > 20; -- sin dato

-- 63. Mostrar usuarios que no asistieron en la última semana
SELECT u.*
FROM usuarios u
LEFT JOIN accesos a ON u.id_usuario = a.id_usuario
AND a.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE()
WHERE a.id_acceso IS NULL;

-- 64. Calcular la asistencia promedio por día de la semana 
SELECT 
    DAYNAME(fecha) as dia_semana, 
    AVG(total_asistencias) as promedio_asistencias
FROM (
    SELECT 
        fecha, 
        COUNT(*) as total_asistencias
    FROM accesos
    WHERE hora_entrada IS NOT NULL
    GROUP BY fecha
) as asistencias_diarias
GROUP BY DAYOFWEEK(fecha), DAYNAME(fecha)
ORDER BY DAYOFWEEK(fecha);
-- 65. Mostrar los 10 usuarios más constantes (más asistencias)
SELECT u.id_usuario, u.nombre, COUNT(a.id_acceso) as total_asistencias
FROM usuarios u
JOIN accesos a ON u.id_usuario = a.id_usuario
WHERE a.hora_entrada IS NOT NULL
GROUP BY u.id_usuario
ORDER BY total_asistencias DESC
LIMIT 10;

-- 66. Mostrar accesos fuera del horario permitido
SELECT a.*
FROM accesos a
JOIN usuarios u ON a.id_usuario = u.id_usuario
JOIN membresias m ON u.id_usuario = m.id_usuario
JOIN tipos_membresia tm ON m.id_tipo_membresia = tm.id_tipo_membresia
WHERE TIME(a.hora_entrada) NOT BETWEEN '08:00:00' AND '20:00:00'
AND tm.nombre != 'Premium'
AND a.hora_entrada IS NOT NULL; -- sin dato

-- 67. Mostrar usuarios que accedieron sin membresía activa (rechazados)
SELECT u.*, a.fecha, a.hora_entrada
FROM usuarios u
JOIN accesos a ON u.id_usuario = a.id_usuario
WHERE a.hora_entrada IS NULL;  

-- 68. Listar usuarios que solo acceden los fines de semana
SELECT u.id_usuario, u.nombre
FROM usuarios u
JOIN accesos a ON u.id_usuario = a.id_usuario
WHERE DAYOFWEEK(a.fecha) IN (1,7)
AND u.id_usuario NOT IN (
    SELECT DISTINCT u2.id_usuario
    FROM usuarios u2
    JOIN accesos a2 ON u2.id_usuario = a2.id_usuario
    WHERE DAYOFWEEK(a2.fecha) BETWEEN 2 AND 6
); 


-- 69. Mostrar usuarios que accedieron más de 2 veces en el mismo día
SELECT u.id_usuario, u.nombre, a.fecha, COUNT(*) as accesos_dia
FROM usuarios u
JOIN accesos a ON u.id_usuario = a.id_usuario
WHERE a.hora_entrada IS NOT NULL
GROUP BY u.id_usuario, a.fecha
HAVING accesos_dia > 2; -- sin dato 

-- 70. Mostrar el total de accesos diarios en el último mes
SELECT fecha, COUNT(*) as total_accesos
FROM accesos
WHERE fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE()
GROUP BY fecha
ORDER BY fecha;

-- 71. Mostrar usuarios que han accedido pero no tienen reservas
SELECT DISTINCT u.*
FROM usuarios u
JOIN accesos a ON u.id_usuario = a.id_usuario
LEFT JOIN reservas r ON u.id_usuario = r.id_usuario
WHERE a.hora_entrada IS NOT NULL
AND r.id_reserva IS NULL; -- sin dato

-- 72. Mostrar los días con más concurrencia en el coworking
SELECT fecha, COUNT(*) as total_accesos
FROM accesos
GROUP BY fecha
ORDER BY total_accesos DESC
LIMIT 10; 

-- 73. Mostrar usuarios que entraron pero no registraron salida
SELECT u.*, a.fecha, a.hora_entrada
FROM usuarios u
JOIN accesos a ON u.id_usuario = a.id_usuario
WHERE a.hora_salida IS NULL; 

-- 74. Mostrar accesos de usuarios con membresía vencida
SELECT a.*
FROM accesos a
JOIN usuarios u ON a.id_usuario = u.id_usuario
JOIN membresias m ON u.id_usuario = m.id_usuario
WHERE m.id_estado_membresia = 3; -- sin dato

-- 75. Mostrar accesos de usuarios corporativos por empresa
SELECT e.nombre as empresa, COUNT(a.id_acceso) as total_accesos
FROM empresas e
JOIN usuarios u ON e.id_empresa = u.id_empresa
JOIN accesos a ON u.id_usuario = a.id_usuario
GROUP BY e.id_empresa; 

-- 76. Mostrar clientes que nunca han usado el coworking a pesar de pagar membresía
SELECT u.*
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
LEFT JOIN accesos a ON u.id_usuario = a.id_usuario
WHERE a.id_acceso IS NULL
AND m.id_estado_membresia = 1;

-- 77. Mostrar accesos rechazados por intentos con QR inválido
SELECT a.*
FROM accesos a
JOIN metodos_acceso ma ON a.id_metodo_acceso = ma.id_metodo_acceso
WHERE ma.nombre = 'QR'
AND a.hora_entrada IS NULL; 

-- 78. Mostrar accesos promedio por usuario
SELECT AVG(total_accesos) as promedio_accesos
FROM (
    SELECT id_usuario, COUNT(*) as total_accesos
    FROM accesos
    GROUP BY id_usuario
) as accesos_usuarios; 

-- 79. Identificar usuarios que asisten más en la mañana
SELECT u.id_usuario, u.nombre, AVG(TIME_TO_SEC(a.hora_entrada)) as hora_promedio
FROM usuarios u
JOIN accesos a ON u.id_usuario = a.id_usuario
GROUP BY u.id_usuario
HAVING hora_promedio < TIME_TO_SEC('12:00:00')
ORDER BY hora_promedio;

-- 80. Identificar usuarios que asisten más en la noche
SELECT u.id_usuario, u.nombre, AVG(TIME_TO_SEC(a.hora_entrada)) as hora_promedio
FROM usuarios u
JOIN accesos a ON u.id_usuario = a.id_usuario
GROUP BY u.id_usuario
HAVING hora_promedio > TIME_TO_SEC('18:00:00')
ORDER BY hora_promedio DESC; -- sin dato 

-- Consultas con subconsultas 
-- 81. Mostrar los usuarios con el mayor gasto acumulado
SELECT u.id_usuario, u.nombre, SUM(p.monto) as gasto_total
FROM usuarios u
JOIN pagos p ON u.id_usuario = p.id_usuario
WHERE p.id_estado_pago = 1
GROUP BY u.id_usuario
ORDER BY gasto_total DESC;

-- 82. Mostrar los espacios más ocupados considerando reservas confirmadas y asistencias reales
SELECT e.id_espacio, e.nombre, 
    COUNT(r.id_reserva) as total_reservas,
    SUM(r.asistio) as asistencias_reales
FROM espacios e
JOIN reservas r ON e.id_espacio = r.id_espacio
WHERE r.id_estado_reserva = 2
GROUP BY e.id_espacio
ORDER BY asistencias_reales DESC;

-- 83. Calcular el promedio de ingresos por usuario usando subconsultas
SELECT AVG(gasto_total) as promedio_ingresos
FROM (
    SELECT u.id_usuario, SUM(p.monto) as gasto_total
    FROM usuarios u
    JOIN pagos p ON u.id_usuario = p.id_usuario
    WHERE p.id_estado_pago = 1
    GROUP BY u.id_usuario
) as gastos_usuarios;

-- 84. Listar usuarios que tienen reservas activas y facturas pendientes
SELECT DISTINCT u.*
FROM usuarios u
JOIN reservas r ON u.id_usuario = r.id_usuario
JOIN facturas f ON u.id_usuario = f.id_usuario
WHERE r.id_estado_reserva IN (1,2)
AND f.id_estado_factura = 2;

-- 85. Mostrar empresas cuyos empleados generan más del 20% de los ingresos totales
SELECT e.nombre, SUM(f.total) as facturacion_empresa,
    (SUM(f.total) / (SELECT SUM(total) FROM facturas WHERE id_estado_factura = 1)) * 100 as porcentaje
FROM empresas e
JOIN usuarios u ON e.id_empresa = u.id_empresa
JOIN facturas f ON u.id_usuario = f.id_usuario
WHERE f.id_estado_factura = 1
GROUP BY e.id_empresa
HAVING porcentaje > 20;

-- 86. Mostrar el top 5 de usuarios que más usan servicios adicionales
SELECT u.id_usuario, u.nombre, COUNT(us.id_usuario_servicio) as total_servicios
FROM usuarios u
JOIN usuario_servicio us ON u.id_usuario = us.id_usuario
GROUP BY u.id_usuario
ORDER BY total_servicios DESC
LIMIT 5;

-- 87. Mostrar reservas que generaron facturas mayores al promedio
SELECT r.*, f.total
FROM reservas r
JOIN facturas f ON r.id_reserva = f.id_reserva
WHERE f.total > (SELECT AVG(total) FROM facturas WHERE id_reserva IS NOT NULL);

-- 88. Calcular el porcentaje de ocupación global del coworking por mes
SELECT YEAR(fecha) as año, MONTH(fecha) as mes,
    (SUM(TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin)) / (COUNT(DISTINCT id_espacio) * 12 * 30)) * 100 as porcentaje_ocupacion
FROM reservas
WHERE id_estado_reserva = 2
GROUP BY YEAR(fecha), MONTH(fecha);

-- 89. Mostrar usuarios que tienen más horas de reserva que el promedio del sistema
SELECT u.id_usuario, u.nombre, SUM(TIMESTAMPDIFF(HOUR, r.hora_inicio, r.hora_fin)) as horas_totales
FROM usuarios u
JOIN reservas r ON u.id_usuario = r.id_usuario
GROUP BY u.id_usuario
HAVING horas_totales > (
    SELECT AVG(horas_usuario)
    FROM (
        SELECT SUM(TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin)) as horas_usuario
        FROM reservas
        GROUP BY id_usuario
    ) as horas_usuarios
);

-- 90. Mostrar el top 3 de salas más usadas en el último trimestre
SELECT e.id_espacio, e.nombre, COUNT(r.id_reserva) as total_reservas
FROM espacios e
JOIN reservas r ON e.id_espacio = r.id_espacio
WHERE r.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 3 MONTH) AND CURDATE()
GROUP BY e.id_espacio
ORDER BY total_reservas DESC
LIMIT 3;

-- 91. Calcular ingresos promedio por tipo de membresía
SELECT tm.nombre, AVG(p.monto) as ingreso_promedio
FROM tipos_membresia tm
JOIN membresias m ON tm.id_tipo_membresia = m.id_tipo_membresia
JOIN pagos p ON m.id_usuario = p.id_usuario
WHERE p.concepto LIKE '%Membresía%'
GROUP BY tm.nombre;

-- 92. Mostrar usuarios que pagan solo con un método de pago
SELECT u.id_usuario, u.nombre
FROM usuarios u
WHERE (
    SELECT COUNT(DISTINCT id_metodo_pago)
    FROM pagos
    WHERE id_usuario = u.id_usuario
) = 1;

-- 93. Mostrar reservas canceladas por usuarios que nunca asistieron
SELECT r.*
FROM reservas r
WHERE r.id_estado_reserva = 3
AND r.id_usuario NOT IN (
    SELECT DISTINCT id_usuario
    FROM accesos
    WHERE hora_entrada IS NOT NULL
);

-- 94. Mostrar facturas con pagos parciales y calcular saldo pendiente
SELECT f.*, f.total - COALESCE(SUM(p.monto), 0) as saldo_pendiente
FROM facturas f
LEFT JOIN pagos p ON f.id_pago = p.id_pago
WHERE f.id_estado_factura = 2
GROUP BY f.id_factura;

-- 95. Calcular la facturación total de cada empresa y ordenarla de mayor a menor
SELECT e.nombre, SUM(f.total) as facturacion_total
FROM empresas e
JOIN usuarios u ON e.id_empresa = u.id_empresa
JOIN facturas f ON u.id_usuario = f.id_usuario
WHERE f.id_estado_factura = 1
GROUP BY e.id_empresa
ORDER BY facturacion_total DESC;

-- 96. Identificar usuarios que superan en reservas al promedio de su empresa
SELECT u.id_usuario, u.nombre, COUNT(r.id_reserva) as total_reservas,
    (SELECT AVG(total_reservas_empresa)
     FROM (
         SELECT COUNT(r2.id_reserva) as total_reservas_empresa
         FROM usuarios u2
         JOIN reservas r2 ON u2.id_usuario = r2.id_usuario
         WHERE u2.id_empresa = u.id_empresa
         GROUP BY u2.id_usuario
     ) as reservas_empresa) as promedio_empresa
FROM usuarios u
JOIN reservas r ON u.id_usuario = r.id_usuario
GROUP BY u.id_usuario
HAVING total_reservas > promedio_empresa;  

-- 97. Mostrar las 3 empresas con más empleados activos en el coworking
SELECT e.nombre, COUNT(DISTINCT u.id_usuario) as empleados_activos
FROM empresas e
JOIN usuarios u ON e.id_empresa = u.id_empresa
JOIN membresias m ON u.id_usuario = m.id_usuario
WHERE m.id_estado_membresia = 1
GROUP BY e.id_empresa
ORDER BY empleados_activos DESC
LIMIT 3; 

-- 98. Calcular el porcentaje de usuarios activos frente al total de registrados
SELECT (COUNT(DISTINCT m.id_usuario) / COUNT(DISTINCT u.id_usuario)) * 100 as porcentaje_activos
FROM usuarios u
LEFT JOIN membresias m ON u.id_usuario = m.id_usuario
AND m.id_estado_membresia = 1
AND m.fecha_fin >= CURDATE();

-- 99. Mostrar ingresos mensuales acumulados con función de ventana
SELECT YEAR(fecha) as año, MONTH(fecha) as mes, SUM(total) as ingresos_mes,
    SUM(SUM(total)) OVER (ORDER BY YEAR(fecha), MONTH(fecha)) as acumulado
FROM facturas
WHERE id_estado_factura = 1
GROUP BY YEAR(fecha), MONTH(fecha)
ORDER BY año, mes;

-- 100. Mostrar usuarios con más de 10 reservas, más de $500 en facturación y membresía activa
SELECT 
    u.id_usuario, 
    u.nombre,
    COUNT(r.id_reserva) as total_reservas,
    COALESCE(SUM(f.total), 0) as total_facturado,
    MAX(CASE WHEN m.id_estado_membresia = 1 AND m.fecha_fin >= CURDATE() THEN 1 ELSE 0 END) as membresia_activa
FROM usuarios u
LEFT JOIN reservas r ON u.id_usuario = r.id_usuario
LEFT JOIN facturas f ON u.id_usuario = f.id_usuario
LEFT JOIN membresias m ON u.id_usuario = m.id_usuario
GROUP BY u.id_usuario
HAVING total_reservas > 10 
    AND total_facturado > 500 
    AND membresia_activa = 1; -- en blanco 
    

    
-- Roles 
    -- Creación de roles y permisos
CREATE ROLE IF NOT EXISTS 'admin_coworking', 'recepcionista', 'usuario', 'gerente_corporativo', 'contador';

-- Permisos para Administrador del Coworking (acceso total)
GRANT ALL PRIVILEGES ON CoworkingDB2.* TO 'admin_coworking';

-- Permisos para Recepcionista
GRANT SELECT, INSERT, UPDATE ON CoworkingDB2.usuarios TO 'recepcionista';
GRANT SELECT, INSERT, UPDATE ON CoworkingDB2.membresias TO 'recepcionista';
GRANT SELECT, INSERT, UPDATE ON CoworkingDB2.reservas TO 'recepcionista';
GRANT SELECT, INSERT, UPDATE ON CoworkingDB2.accesos TO 'recepcionista';
GRANT SELECT ON CoworkingDB2.espacios TO 'recepcionista';
GRANT SELECT ON CoworkingDB2.empresas TO 'recepcionista';
GRANT SELECT ON CoworkingDB2.tipos_espacios TO 'recepcionista';
GRANT SELECT ON CoworkingDB2.estados_reserva TO 'recepcionista';

-- Permisos para Usuario
GRANT SELECT ON CoworkingDB2.espacios TO 'usuario';
GRANT SELECT ON CoworkingDB2.tipos_espacios TO 'usuario';
GRANT SELECT, INSERT ON CoworkingDB2.reservas TO 'usuario';
GRANT SELECT ON CoworkingDB2.facturas TO 'usuario';
GRANT SELECT ON CoworkingDB2.pagos TO 'usuario';
GRANT SELECT ON CoworkingDB2.membresias TO 'usuario';

-- Permisos para Gerente Corporativo
GRANT SELECT ON CoworkingDB2.empresas TO 'gerente_corporativo';
GRANT SELECT ON CoworkingDB2.usuarios TO 'gerente_corporativo';
GRANT SELECT ON CoworkingDB2.facturas TO 'gerente_corporativo';
GRANT SELECT ON CoworkingDB2.pagos TO 'gerente_corporativo';
GRANT SELECT ON CoworkingDB2.membresias TO 'gerente_corporativo';

-- Crear procedimiento para que el gerente vea solo su empresa

CREATE PROCEDURE sp_empresa_gerente(IN p_id_empresa INT)
BEGIN
    SELECT * FROM empresas WHERE id_empresa = p_id_empresa;
    SELECT * FROM usuarios WHERE id_empresa = p_id_empresa;
    SELECT f.* FROM facturas f 
    JOIN usuarios u ON f.id_usuario = u.id_usuario 
    WHERE u.id_empresa = p_id_empresa;
end;

-- Permisos para Contador
GRANT SELECT ON CoworkingDB2.facturas TO 'contador';
GRANT SELECT ON CoworkingDB2.pagos TO 'contador';
GRANT SELECT ON CoworkingDB2.metodos_pago TO 'contador';
GRANT SELECT ON CoworkingDB2.estados_factura TO 'contador';
GRANT SELECT ON CoworkingDB2.estados_pago TO 'contador';
GRANT EXECUTE ON PROCEDURE CoworkingDB2.sp_reporte_ingresos_mensuales TO 'contador';

-- Creación de usuarios ejemplo
CREATE USER IF NOT EXISTS 'admin@coworking.com' IDENTIFIED BY 'Admin123!';
CREATE USER IF NOT EXISTS 'recepcion@coworking.com' IDENTIFIED BY 'Recepcion123!';
CREATE USER IF NOT EXISTS 'usuario@empresa.com' IDENTIFIED BY 'Usuario123!';
CREATE USER IF NOT EXISTS 'gerente@techsolutions.com' IDENTIFIED BY 'Gerente123!';
CREATE USER IF NOT EXISTS 'contador@coworking.com' IDENTIFIED BY 'Contador123!';

-- Asignación de roles a usuarios
GRANT 'admin_coworking' TO 'admin@coworking.com';
GRANT 'recepcionista' TO 'recepcion@coworking.com';
GRANT 'usuario' TO 'usuario@empresa.com';
GRANT 'gerente_corporativo' TO 'gerente@techsolutions.com';
GRANT 'contador' TO 'contador@coworking.com';

-- Establecer roles por defecto
SET DEFAULT ROLE ALL TO 'admin@coworking.com';
SET DEFAULT ROLE ALL TO 'recepcion@coworking.com';
SET DEFAULT ROLE ALL TO 'usuario@empresa.com';
SET DEFAULT ROLE ALL TO 'gerente@techsolutions.com';
SET DEFAULT ROLE ALL TO 'contador@coworking.com';

-- Otorgar ejecución de procedimientos específicos
GRANT EXECUTE ON PROCEDURE CoworkingDB2.sp_empresa_gerente TO 'gerente_corporativo';

-- El gerente de Tech Solutions (id_empresa = 1) ejecutaría:
CALL sp_empresa_gerente(1);







- 1. Crear la tabla ReservasExternas
CREATE TABLE IF NOT EXISTS ReservasExternas (
    id_reserva_externa INT AUTO_INCREMENT PRIMARY KEY,
    plataforma VARCHAR(50) NOT NULL,
    fecha_reserva DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    espacio_id INT,
    usuario_externo VARCHAR(255) NOT NULL,
    duracion_minutos INT AS (TIMESTAMPDIFF(MINUTE, CONCAT(fecha_reserva, ' ', hora_inicio), CONCAT(fecha_reserva, ' ', hora_fin))) VIRTUAL,
    CONSTRAINT chk_duracion_positiva CHECK (duracion_minutos > 0)
);

-- 2. Procedimiento Almacenado Simplificado
DROP PROCEDURE IF EXISTS sp_importar_reserva_externa;
CREATE PROCEDURE sp_importar_reserva_externa(
    IN p_plataforma VARCHAR(50),
    IN p_fecha DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME,
    IN p_nombre_usuario VARCHAR(100),
    IN p_email_usuario VARCHAR(100),
    IN p_id_espacio INT
)
BEGIN
    DECLARE v_id_usuario_interno INT;

    -- Validaciones: Combinar la validación de espacio y horario
    IF NOT EXISTS (SELECT 1 FROM espacios WHERE id_espacio = p_id_espacio) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El espacio especificado no existe.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM reservas
        WHERE id_espacio = p_id_espacio
          AND fecha = p_fecha
          AND id_estado_reserva IN (1, 2)
          AND (p_hora_inicio < hora_fin AND p_hora_fin > hora_inicio)
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflicto de horario: El espacio ya está reservado en ese momento.';
    END IF;

    -- Generar usuario temporal o encontrar existente
    SELECT id_usuario INTO v_id_usuario_interno FROM usuarios WHERE email = p_email_usuario;
    IF v_id_usuario_interno IS NULL THEN
        INSERT INTO usuarios (identificacion, nombre, apellidos, email, id_empresa)
        VALUES (
            CONCAT('EXT-', MD5(p_email_usuario)),
            p_nombre_usuario,
            'Externo',
            p_email_usuario,
            NULL
        );
        SET v_id_usuario_interno = LAST_INSERT_ID();
    END IF;

    -- Insertar la reserva en ambas tablas
    INSERT INTO reservas (id_usuario, id_espacio, id_estado_reserva, fecha, hora_inicio, hora_fin)
    VALUES (v_id_usuario_interno, p_id_espacio, 1, p_fecha, p_hora_inicio, p_hora_fin);

    INSERT INTO ReservasExternas (plataforma, fecha_reserva, hora_inicio, hora_fin, espacio_id, usuario_externo)
    VALUES (p_plataforma, p_fecha, p_hora_inicio, p_hora_fin, p_id_espacio, p_nombre_usuario);

    SELECT 'Reserva externa importada exitosamente.' AS Mensaje;
END;

-- 3. Datos de ejemplo para probar el procedimiento
SET @espacio_prueba_id = 1;

CALL sp_importar_reserva_externa('Airbnb', '2025-10-25', '10:00:00', '12:00:00', 'Juan Externo', 'juan.externo@mail.com', @espacio_prueba_id);
CALL sp_importar_reserva_externa('Meetup', '2025-10-26', '14:00:00', '16:00:00', 'María López', 'maria.lopez@mail.com', @espacio_prueba_id);

CALL sp_importar_reserva_externa('PlataformaX', '2025-10-25', '11:00:00', '13:00:00', 'Carlos Conflicto', 'carlos.conflicto@mail.com', @espacio_prueba_id);


CREATE FUNCTION fn_membresia_activa(usuario_id INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE activa BOOLEAN DEFAULT FALSE;

    SELECT COUNT(*) > 0 INTO activa
    FROM membresias m
    INNER JOIN estados_membresia em ON m.id_estado_membresia = em.id_estado_membresia
    WHERE m.id_usuario = usuario_id 
    AND em.nombre = 'Activa'
    AND CURDATE() BETWEEN m.fecha_inicio AND m.fecha_fin;

    RETURN activa;
END;

-- indice 
CREATE INDEX idx_reservas_filtradas ON reservas(fecha, id_estado_reserva, id_usuario);


-- evento 
CREATE TABLE IF NOT EXISTS Backup_pagos(
    id_backup INT AUTO_INCREMENT PRIMARY KEY,
    fecha_corte DATE,
    pagos_diarios DECIMAL(14,2),
    accion INT,
    pagos_diarios  JSON,
    fecha_backup TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE EVENT backup_diario_pagos
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_DATE + INTERVAL 1 DAY + INTERVAL '02:00:00' HOUR_SECOND)
DO
BEGIN
    -- Limpia la tabla de backup para evitar duplicados 
    TRUNCATE TABLE pagos_backup;
    
    -- Inserta una copia de todos los registros de la tabla 'pagos'
    INSERT INTO pagos_backup SELECT * FROM pagos;
    
    -- del dia anterior
    INSERT INTO pagos_backup SELECT * FROM pagos WHERE fecha_pago = CURDATE() - INTERVAL 1 DAY;
    
END;
