
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
    
