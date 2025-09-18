
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
