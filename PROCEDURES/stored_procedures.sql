
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
