-- Taller III - Parte 5.2 y 5.3: Transacciones y propiedades ACID
-- PostgreSQL 18 | Sistema hotelero
-- IMPORTANTE: Ejecutar por BLOQUES seleccionados (NO todo el archivo con F5).
-- Cada bloque contiene acciones para una etapa o sesion diferente.
-- No ejecutar los bloques de INSERT si los ids 9901 ya existen.
-- Datos usados: cliente 101, habitacion 210, reserva 9901 y pago 9901.

-- ================================================================
-- BLOQUE 1. Verificaciones previas (solo lectura)
-- Esperado antes de las pruebas: 30 reservas, 36 pagos, pruebas 0/0
-- y sin reservas superpuestas entre el 10 y el 12 de enero de 2027.
-- ================================================================
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

-- ================================================================
-- BLOQUE 2. Prueba ROLLBACK (UNA MISMA SESION de Query Tool)
-- Requiere que los ids 9901 no existan y no haya superposicion.
-- Ejecutar desde BEGIN hasta el SELECT siguiente; tomar evidencia.
-- NO ejecutar ROLLBACK hasta tener las capturas necesarias.
-- ================================================================
BEGIN;

INSERT INTO reserva (
    id_reserva, id_cliente, id_habitacion,
    fecha_entrada, fecha_salida, observaciones
)
VALUES (
    9901, 101, 210,
    DATE '2027-01-10', DATE '2027-01-12',
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
    p.id_pago,
    p.monto,
    p.metodo
FROM reserva r
INNER JOIN cliente c ON r.id_cliente = c.id_cliente
INNER JOIN habitacion h ON r.id_habitacion = h.id_habitacion
INNER JOIN pago p ON r.id_reserva = p.id_reserva
WHERE r.id_reserva = 9901;

-- ================================================================
-- BLOQUE 3. Revertir la prueba ROLLBACK (MISMA SESION del Bloque 2)
-- Ejecutar despues de guardar la evidencia anterior.
-- ================================================================
ROLLBACK;

SELECT
    (SELECT COUNT(*) FROM reserva WHERE id_reserva = 9901) AS reserva_prueba,
    (SELECT COUNT(*) FROM pago WHERE id_pago = 9901) AS pago_prueba,
    (SELECT COUNT(*) FROM reserva) AS total_reservas,
    (SELECT COUNT(*) FROM pago) AS total_pagos;

-- ================================================================
-- BLOQUE 4. Prueba COMMIT (MISMA SESION durante el BEGIN/COMMIT)
-- Iniciar SOLO cuando se haya verificado que los ids 9901 no existen.
-- Ejecutar las inserciones y consultar antes de ejecutar COMMIT.
-- ================================================================
BEGIN;

INSERT INTO reserva (
    id_reserva, id_cliente, id_habitacion,
    fecha_entrada, fecha_salida, observaciones
)
VALUES (
    9901, 101, 210,
    DATE '2027-01-10', DATE '2027-01-12',
    'Prueba de transaccion ACID'
)
RETURNING id_reserva;

INSERT INTO pago (id_pago, id_reserva, fecha_pago, monto, metodo)