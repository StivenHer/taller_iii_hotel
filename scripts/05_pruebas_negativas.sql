-- Taller III - Parte 2.4. Pruebas negativas de integridad
-- PostgreSQL 18
-- IMPORTANTE: EJECUTAR LAS PRUEBAS POR SEPARADO EN QUERY TOOL.
-- Los errores SQLSTATE son esperados: se capturan como evidencias.
-- Si queda una transaccion abortada, ejecutar ROLLBACK en esa sesion.

-- PRUEBA 1. CHECK: tipo de habitacion no permitido. Error 23514.
INSERT INTO habitacion (numero, tipo, precio_noche, estado)
VALUES ('T9002', 'Triple', 180000, 'Disponible');


-- PRUEBA 2. FOREIGN KEY: cliente inexistente. Error 23503.
-- El identificador 999999 no debe existir en cliente.
INSERT INTO reserva (id_cliente, id_habitacion, fecha_entrada, fecha_salida)
VALUES (999999, 201, DATE '2026-11-15', DATE '2026-11-17');


-- PRUEBA 3. UNIQUE: numero de habitacion repetido. Error 23505.
-- El INSERT completo debe rechazarse sin dejar ninguna fila T9003.
INSERT INTO habitacion (numero, tipo, precio_noche, estado)
VALUES
    ('T9003', 'Sencilla', 180000, 'Disponible'),
    ('T9003', 'Doble', 240000, 'Disponible');


-- PRUEBA 4. EXCLUDE: reservas con fechas superpuestas. Error 23P01.
-- Ejecutar los pasos 4A, 4B y 4C en la MISMA sesion de Query Tool.
-- Antes de iniciar, confirmar que los ids 9201 y 9202 no existen.

-- PASO 4A. Preparar registros de prueba (BEGIN abierto).
BEGIN;

INSERT INTO cliente (id_cliente, nombre, correo, telefono, nacionalidad)
VALUES (9201, 'Cliente Exclude', 'exclude9201@example.com',
        '3000000001', 'Colombia');

INSERT INTO habitacion (id_habitacion, numero, tipo, precio_noche, estado)
VALUES (9201, 'T9201', 'Doble', 250000, 'Disponible');

INSERT INTO reserva (
    id_reserva, id_cliente, id_habitacion, fecha_entrada, fecha_salida
)
VALUES (9201, 9201, 9201, DATE '2026-11-20', DATE '2026-11-25');

-- PASO 4B. Ejecutar por separado; debe generar SQLSTATE 23P01.
INSERT INTO reserva (
    id_reserva, id_cliente, id_habitacion, fecha_entrada, fecha_salida
)
VALUES (9202, 9201, 9201, DATE '2026-11-23', DATE '2026-11-27');

-- PASO 4C. Tras capturar el error, ejecutar SOLO esta sentencia
-- en la MISMA sesion para descartar todos los registros de prueba:
ROLLBACK;

-- Comprobacion posterior (se puede ejecutar una vez finalizada la prueba).
SELECT
    (SELECT COUNT(*) FROM cliente WHERE id_cliente = 9201) AS cliente_prueba,
    (SELECT COUNT(*) FROM habitacion WHERE id_habitacion = 9201) AS habitacion_prueba,
    (SELECT COUNT(*) FROM reserva WHERE id_reserva IN (9201, 9202)) AS reservas_prueba;
-- Resultado esperado: 0, 0, 0.
