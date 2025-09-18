CoworkingDB: Sistema de Gestión de Espacios y Oficinas Compartidas
Este proyecto es una solución de base de datos integral, robusta y escalable diseñada para la gestión eficiente de un espacio de coworking. El sistema permite administrar a los usuarios, diferentes tipos de membresías, reservas de espacios de trabajo (salas privadas, escritorios), pagos, control de acceso, y servicios adicionales. La estructura de la base de datos ha sido cuidadosamente diseñada para reflejar las operaciones diarias de un coworking moderno.

Requisitos del Sistema
Para la correcta instalación y ejecución de los scripts de este proyecto, se requiere el siguiente software:

MySQL Server (versión 8.0 o superior recomendada).

MySQL Workbench o cualquier otro cliente SQL compatible (por ejemplo, DBeaver, DataGrip).

Un editor de texto o IDE para visualizar y modificar los archivos .sql.

Instalación y Configuración
El proyecto está organizado en directorios para una mejor claridad y gestión. Sigue estos pasos para configurar el entorno de la base de datos:

Clona el repositorio de GitHub en tu máquina local.

Abre MySQL Workbench y conéctate a tu instancia de MySQL.

Ejecuta el script DDL: Abre el archivo ddl.sql ubicado en el directorio ddl/ y ejecútalo para crear la base de datos y todas las tablas.

Carga los datos iniciales: Abre el archivo dml.sql del directorio dml/ y ejecútalo para poblar las tablas con datos de prueba.

Crea los componentes avanzados: Ejecuta los scripts en el siguiente orden para crear todas las funcionalidades:

Abre y ejecuta los scripts dentro de procedimientos/.

Abre y ejecuta los scripts dentro de funciones/.

Abre y ejecuta los scripts dentro de triggers/.

Abre y ejecuta los scripts dentro de eventos/.

Abre y ejecuta los scripts dentro de roles/.

Activa el planificador de eventos: Para que los eventos programados se ejecuten, debes asegurarte de que el planificador de eventos de MySQL esté activado. Puedes hacerlo con el siguiente comando:

SET GLOBAL event_scheduler = ON;

Ejecuta las consultas: Explora los archivos .sql dentro del directorio consultas/ para ver ejemplos de uso y reportes.

Estructura de la Base de Datos
La base de datos se compone de un conjunto de tablas interrelacionadas que organizan la información de manera lógica:

usuarios: Almacena la información personal y de contacto de los miembros.

membresias: Registra los detalles de las membresías adquiridas por los usuarios.

tipos_membresia: Catálogo de los diferentes planes de membresía disponibles.

espacios: Inventario de los escritorios, oficinas y salas del coworking.

reservas: Almacena las reservas de los usuarios para un espacio y período específicos.

servicios_adicionales: Catálogo de servicios extras (café, impresiones, etc.).

pagos: Registra cada transacción monetaria.

facturas: Vincula los pagos a una factura detallada.

accesos: Log de entradas y salidas de los usuarios al espacio.

Ejemplos de Consultas SQL
Los archivos en el directorio consultas/ proporcionan 100 ejemplos de cómo obtener información de la base de datos.

Ejemplo de Consulta Básica
1. Listar los usuarios con membresía activa:

SELECT u.nombre, u.apellidos, m.fecha_inicio, m.fecha_fin
FROM usuarios u
JOIN membresias m ON u.id_usuario = m.id_usuario
WHERE m.id_estado_membresia = (SELECT id_estado_membresia FROM estados_membresia WHERE nombre = 'Activa');

Esta consulta es fundamental para el seguimiento de la base de clientes y los miembros activos del coworking.

Ejemplo de Consulta Avanzada
81. Mostrar los usuarios con el mayor gasto acumulado:

SELECT
    u.id_usuario,
    u.nombre,
    u.apellidos,
    COALESCE(SUM(f.total), 0) AS gasto_total
FROM
    usuarios u
LEFT JOIN
    facturas f ON u.id_usuario = f.id_usuario AND f.id_estado_factura = (SELECT id_estado_factura FROM estados_factura WHERE nombre = 'Pagada')
GROUP BY
    u.id_usuario, u.nombre, u.apellidos
ORDER BY
    gasto_total DESC
LIMIT 5;

Esta consulta utiliza una subconsulta para identificar a los clientes más valiosos, lo cual es útil para estrategias de marketing y programas de lealtad.

Componentes de la Base de Datos
Procedimientos Almacenados: Los archivos en procedimientos/ contienen scripts para ejecutar tareas complejas como verificar la disponibilidad de un espacio o generar facturas.

Funciones: En funciones/, encontrarás funciones reutilizables para realizar cálculos complejos, como obtener los días restantes de una membresía o los ingresos por un mes específico.

Triggers: Los archivos en triggers/ contienen acciones automáticas que se activan ante eventos específicos, por ejemplo, actualizar el estado de una membresía cuando se confirma un pago.

Eventos: En el directorio eventos/ se encuentran tareas programadas que se ejecutan periódicamente, como revisar y actualizar el estado de las membresías vencidas.

Roles de Usuario y Permisos
Los roles de usuario están definidos en el script del directorio roles/ para garantizar que cada tipo de usuario solo tenga acceso a la información y las funcionalidades necesarias. Se han creado cinco roles:

admin_coworking: Acceso total para la gestión completa.

recepcionista: Permisos para registrar usuarios, gestionar membresías y reservas.

usuario: Permisos restringidos para ver su propio historial y reservar espacios.

gerente_corporativo: Permisos para gestionar a los empleados de su empresa y su facturación.

contador: Acceso exclusivo a las tablas de pagos y facturas para la gestión financiera.

Contribuciones
Jormman Estepa: Modelado de la base de datos, implementación de consultas, procedimientos almacenados, funciones, triggers, eventos y control de acceso.



Si tienes alguna pregunta o encuentras algún problema con la implementación, puedes contactarme en [jorman343xd@gmail.com].