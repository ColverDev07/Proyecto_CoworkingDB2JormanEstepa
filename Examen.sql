-- funcion  membresia activa
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
    AND m.fecha_fin >= CURDATE(); -- esta verifica si que este entre fecha inicio y fin 
    RETURN activa;
END;

-- Validar (hora_fin > hora_inicio)
    IF p_hora_fin <= p_hora_inicio THEN
        SET p_result = 'ERROR: hora_fin debe ser mayor que hora_inicio';
        LEAVE proc_body;
    END IF;
    
  -- indice para usuarios con 5 reservas en el mes
   CREATE INDEX idx_usuario_reservas_activas ON usuarios (id_usuario, nombre, nit, contacto, id_empresa);
  
  -- Mostrar usuarios con más de 5 reservas activas en el mes
SELECT u.id_usuario, u.nombre, COUNT(r.id_reserva) as total_reservas
FROM usuarios u
JOIN reservas r ON u.id_usuario = r.id_usuario
WHERE r.fecha BETWEEN '2025-09-01' AND '2025-09-30' -- Ajustar rango de fechas
AND r.id_estado_reserva IN (1,2)
GROUP BY u.id_usuario
HAVING total_reservas > 5;


-- evento

-- Evento: backup diario de pagos (02:00 AM)
CREATE TABLE IF NOT EXISTS Backup_pagos(
    id_backup INT AUTO_INCREMENT PRIMARY KEY,
    fecha_corte DATE,
    pagos_diarios DECIMAL(14,2),
    accion INT,
    pagos_diarios  JSON,
    fecha_backup TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP EVENT IF EXISTS Backup_pagos;

CREATE EVENT Backup_pagos;
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL ((8 - DAYOFWEEK(CURRENT_DATE)) % 7) DAY + INTERVAL '02:00:00' HOUR_SECOND
DO
BEGIN
    DECLARE v_ingresos DECIMAL(14,2);
    DECLARE v_accion INT;
    DECLARE v_pagos_diarios JSON;

    
    SELECT COALESCE(SUM(f.total),0) INTO v_ingresos
    FROM facturas f
    WHERE f.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 DAY) AND DATE_SUB(CURDATE(), INTERVAL 1 DAY)
      AND f.id_estado_factura = (SELECT id_estado_factura FROM estados_factura WHERE nombre = 'Pagada' LIMIT 1);

    SELECT COUNT(DISTINCT id_usuario) INTO v_usuarios
    FROM accesos
    WHERE fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 DAY) AND DATE_SUB(CURDATE(), INTERVAL 1 DAY)
      AND hora_entrada IS NOT NULL;

    SELECT JSON_OBJECTAGG(tipo, total) INTO v_pagos_diarios
    FROM (
        SELECT te.nombre AS tipo, COUNT(r.id_reserva) AS total
        FROM reservas r
        JOIN espacios e ON r.id_espacio = e.id_espacio
        JOIN tipos_espacios te ON e.id_tipo_espacio = te.id_tipo_espacio
        WHERE r.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 DAY) AND DATE_SUB(CURDATE(), INTERVAL 1 DAY)
          AND r.id_estado_reserva = (SELECT id_estado_reserva FROM estados_reserva WHERE nombre = 'Confirmada' LIMIT 1)
        GROUP BY te.nombre
    ) q;

    INSERT INTO Backup_pagos (fecha_corte, pagos_diarios, ingresos_semana, accion)
    VALUES (DATE_SUB(CURDATE(), INTERVAL 1 DAY), pagos_diarios, COALESCE(v_ingresos,0), COALESCE(v_accion,0));
END;

