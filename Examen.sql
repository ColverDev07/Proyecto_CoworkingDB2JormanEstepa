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
