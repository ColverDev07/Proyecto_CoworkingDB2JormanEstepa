
    
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