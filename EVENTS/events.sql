
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
