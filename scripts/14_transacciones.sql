-- Taller III - Parte 5.2 y 5.3: Transacciones y propiedades ACID
-- PostgreSQL 18 | Sistema hotelero
-- IMPORTANTE: EJECUTAR LOS BLOQUES EN ORDEN, POR SEPARADO.
-- NUNCA ejecutar todo este archivo junto con F5.
-- Los bloques que abren BEGIN deben cerrarse en LA MISMA sesion.
-- Datos: cliente 101, habitacion 210, reserva 9901 y pago 9901.
-- La habitacion 210 debe ser elegible para nuevas reservas.

-- ==================================================================
-- BLOQUE 1. Verificaciones previas (solo lectura)
-- Esperado con el conjunto original: 30 reservas; 36 pagos; ids 9901 = 0
-- y 0 superposiciones para la habitacion 210 del 10 al 12/01/2027.
-- ==================================================================
SELECT
    (SELECT COUNT(*) FROM reserva) AS total_reservas,
    (SELECT COUNT(*) FROM pago) AS total_pagos,
    (SELECT COUNT(*) FROM reserva WHERE id_reserva = 9901) AS reserva_prueba,
    (SELECT COUNT(*) FROM pago WHERE id_pago = 9901) AS pago_prueba,
    (SELECT COUNT(*) FROM reserva
     WHERE id_habitacion = 210
       AND fecha_entrada < DATE '2027-01-12'
       AND fecha_salida > DATE '2027-01-10') AS reservas_superpuestas;

SELECT id_habitacion, numero, estado, precio_noche
FROM habitacion
WHERE id_habitacion = 210;
-- ATENCION: en 06_datos_sinteticos.sql, id 210 es 'Mantenimiento'.
-- Conciliar este estado con las pruebas antes de continuar.


-- ==================================================================
-- BLOQUE 2. ROLLBACK: insertar reserva y pago en una misma transaccion
-- Abrir UNA sola sesion de Query Tool, ejecutar y guardar capturas.
-- No avanzar si la reserva o el pago no se insertan correctamente.
-- ==================================================================
BEGIN;

INSERT INTO reserva (
    id_reserva, id_cliente, id_habitacion,
    fecha_entrada, fecha_salida, observaciones
)
VALUES (
    9901, 101, 210, DATE '2027-01-10', DATE '2027-01-12',
    'Prueba de transaccion ACID'
)
RETURNING id_reserva, id_cliente, id_habitacion,
          fecha_entrada, fecha_salida;

INSERT INTO pago (id_pago, id_reserva, fecha_pago, monto, metodo)
VALUES (9901, 9901, DATE '2027-01-08', 50000, 'Transferencia')
RETURNING id_pago, id_reserva, fecha_pago, monto, metodo;

SELECT
    r.id_reserva,
    c.nombre AS cliente,
    h.numero AS habitacion,
    TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
    TO_CHAR(r.fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
    p.id_pago, p.monto, p.metodo
FROM reserva r
INNER JOIN cliente c ON r.id_cliente = c.id_cliente
INNER JOIN habitacion h ON r.id_habitacion = h.id_habitacion
INNER JOIN pago p ON r.id_reserva = p.id_reserva
WHERE r.id_reserva = 9901;


-- ==================================================================
-- BLOQUE 3. ROLLBACK: ejecutar en la MISMA sesion del bloque 2
-- Solo despues de tomar las capturas.
-- ==================================================================
ROLLBACK;

SELECT
    (SELECT COUNT(*) FROM reserva WHERE id_reserva = 9901) AS reserva_prueba,
    (SELECT COUNT(*) FROM pago WHERE id_pago = 9901) AS pago_prueba,
    (SELECT COUNT(*) FROM reserva) AS total_reservas,
    (SELECT COUNT(*) FROM pago) AS total_pagos;
-- Esperado: 0 / 0 / 30 / 36.


-- ==================================================================
-- BLOQUE 4. COMMIT: nueva insercion en UNA misma sesion Query Tool
-- Iniciar solo si la verificacion previa confirma 0/0 para ids 9901.
-- ==================================================================
BEGIN;

INSERT INTO reserva (
    id_reserva, id_cliente, id_habitacion,
    fecha_entrada, fecha_salida, observaciones
)
VALUES (
    9901, 101, 210, DATE '2027-01-10', DATE '2027-01-12',
    'Prueba de transaccion ACID'
)
RETURNING id_reserva;

INSERT INTO pago (id_pago, id_reserva, fecha_pago, monto, metodo)
VALUES (9901, 9901, DATE '2027-01-08', 50000, 'Transferencia')
RETURNING id_pago, id_reserva, monto, metodo;

SELECT
    (SELECT COUNT(*) FROM reserva WHERE id_reserva = 9901) AS reserva_prueba,
    (SELECT COUNT(*) FROM pago WHERE id_pago = 9901 AND id_reserva = 9901) AS pago_prueba,
    (SELECT COUNT(*) FROM reserva) AS total_reservas,
    (SELECT COUNT(*) FROM pago) AS total_pagos;
-- Esperado ANTES de confirmar: 1 / 1 / 31 / 37.


-- ==================================================================
-- BLOQUE 5. COMMIT y verificacion de durabilidad
-- Ejecutar COMMIT en la MISMA sesion del bloque 4.
-- Abrir una NUEVA sesion para el SELECT posterior.
-- ==================================================================
COMMIT;

-- En OTRA sesion de Query Tool (misma base de datos):
SELECT
    r.id_reserva,
    c.nombre AS cliente,
    h.numero AS habitacion,
    TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
    TO_CHAR(r.fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
    p.id_pago, p.monto, p.metodo
FROM reserva r
INNER JOIN cliente c ON r.id_cliente = c.id_cliente
INNER JOIN habitacion h ON r.id_habitacion = h.id_habitacion
INNER JOIN pago p ON r.id_reserva = p.id_reserva
WHERE r.id_reserva = 9901;
-- Esperado: una fila con el pago 9901 de 50000.


-- ==================================================================
-- BLOQUE 6. Limpieza controlada de los registros de prueba COMMIT
-- EJECUTAR SOLO despues de guardar evidencia del bloque 5.
-- Verificar que ambos DELETE devuelven UNA fila antes de confirmar.
-- ==================================================================
BEGIN;

DELETE FROM pago
WHERE id_pago = 9901
  AND id_reserva = 9901
  AND monto = 50000
  AND metodo = 'Transferencia'
RETURNING id_pago, id_reserva;

DELETE FROM reserva
WHERE id_reserva = 9901
  AND id_cliente = 101
  AND id_habitacion = 210
  AND fecha_entrada = DATE '2027-01-10'
  AND fecha_salida = DATE '2027-01-12'
RETURNING id_reserva, id_cliente, id_habitacion;
-- Si alguna de estas sentencias NO devuelve una fila, ejecutar ROLLBACK.


-- ==================================================================
-- BLOQUE 7. Finalizar limpieza: en MISMA sesion del bloque 6
-- Solo si ambos DELETE fueron correctos.
-- ==================================================================
COMMIT;

SELECT
    (SELECT COUNT(*) FROM cliente) AS clientes,
    (SELECT COUNT(*) FROM habitacion) AS habitaciones,
    (SELECT COUNT(*) FROM reserva) AS reservas,
    (SELECT COUNT(*) FROM pago) AS pagos;
-- Esperado: 20 / 10 / 30 / 36.


-- ==================================================================
-- BLOQUE 8. AISLAMIENTO: SESION A (conexión independiente)
-- Precondicion: estado inicial de hab. 210 = 'Disponible'.
-- No ejecutar COMMIT ni cerrar esta sesion antes del bloque 9.
-- ==================================================================
SELECT pg_backend_pid() AS conexion_a;

BEGIN;

UPDATE habitacion
SET estado = 'Mantenimiento'
WHERE id_habitacion = 210
  AND estado = 'Disponible'
RETURNING id_habitacion, numero, estado;
-- Esperado: UNA fila con 'Mantenimiento'. Si 0, ejecutar ROLLBACK.


-- ==================================================================
-- BLOQUE 9. AISLAMIENTO: SESION B, ABIERTA EN OTRA CONEXION
-- Ejecutar mientras la transaccion de la SESION A sigue abierta.
-- ==================================================================
SELECT pg_backend_pid() AS conexion_b;

SELECT id_habitacion, numero, estado
FROM habitacion
WHERE id_habitacion = 210;
-- Con READ COMMITTED, la sesion B ve el valor CONFIRMADO 'Disponible'.


-- ==================================================================
-- BLOQUE 10. AISLAMIENTO: volver a la SESION A y revertir cambios
-- ==================================================================
ROLLBACK;

SELECT id_habitacion, numero, estado
FROM habitacion
WHERE id_habitacion = 210;
-- Esperado: 'Disponible'. Las dos sesiones deben tener backend_pid distinto.