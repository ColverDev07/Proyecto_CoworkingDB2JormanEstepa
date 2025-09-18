
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
