

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
