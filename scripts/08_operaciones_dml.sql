-- Taller III - Parte 4.1. Operaciones DML
-- PostgreSQL 18 | Ejecutar cada escenario por pasos en Query Tool.
-- IMPORTANTE: despues de las capturas, ejecutar su ROLLBACK.

-- ESCENARIO 1. Cambio temporal de estado de habitacion.
-- Precondicion: la habitacion 210 debe estar en estado 'Disponible'.
-- NOTA: 06_datos_sinteticos.sql la carga como 'Mantenimiento'.
-- Si el estado real NO es 'Disponible', no ejecutar la prueba hasta
-- conciliar los datos de PostgreSQL con las evidencias del documento.
SELECT id_habitacion, numero, tipo, estado
FROM habitacion
WHERE id_habitacion = 210;

-- Escenario 1: inicio y actualizacion (una sola sesion).
BEGIN;

UPDATE habitacion
SET estado = 'Mantenimiento'
WHERE id_habitacion = 210
  AND estado = 'Disponible'
RETURNING id_habitacion, numero, tipo, estado;
-- Debe devolver exactamente una fila; de otro modo ejecutar ROLLBACK.

-- Escenario 1: cierre, EJECUTAR DESPUES de capturar el resultado.
ROLLBACK;

SELECT id_habitacion, numero, tipo, estado
FROM habitacion
WHERE id_habitacion = 210;


-- ESCENARIO 2. Cambio temporal de telefono NULL a un valor ficticio.
SELECT id_cliente, nombre, telefono
FROM cliente
WHERE id_cliente = 117;

BEGIN;

UPDATE cliente
SET telefono = '3001234567'
WHERE id_cliente = 117
  AND telefono IS NULL
RETURNING id_cliente, nombre, telefono;
-- Debe devolver una fila si telefono estaba en NULL.

-- Escenario 2: cierre en la misma sesion, tras guardar la evidencia.
ROLLBACK;

SELECT id_cliente, nombre, telefono
FROM cliente
WHERE id_cliente = 117;


-- ESCENARIO 3. Registro temporal de un nuevo pago.
-- Al comenzar, se esperan 36 pagos en el conjunto original.
SELECT COUNT(*) AS total_pagos FROM pago;

BEGIN;

INSERT INTO pago (id_reserva, fecha_pago, monto, metodo)
SELECT
    r.id_reserva,
    DATE '2026-11-08',
    50000.00,
    'Transferencia'
FROM reserva r
INNER JOIN habitacion h ON r.id_habitacion = h.id_habitacion
WHERE NOT EXISTS (
    SELECT 1 FROM pago p WHERE p.id_reserva = r.id_reserva
)
  AND (r.fecha_salida - r.fecha_entrada) * h.precio_noche >= 50000
ORDER BY r.id_reserva
LIMIT 1
RETURNING id_pago, id_reserva,
          TO_CHAR(fecha_pago, 'DD/MM/YYYY') AS fecha_pago,
          monto, metodo;
-- Debe devolver una fila. Comprobar antes de seguir.

SELECT COUNT(*) AS total_pagos FROM pago;
-- Esperado durante la transaccion: 37.

-- Escenario 3: deshacer en la misma sesion tras guardar las capturas.
ROLLBACK;

SELECT COUNT(*) AS total_pagos FROM pago;
-- Esperado tras ROLLBACK: 36.
