-- Taller III - Parte 5.1: Vistas
-- PostgreSQL 18 | Sistema hotelero

-- 5.1.1. Vista 1: Reservas activas del hotel
CREATE OR REPLACE VIEW vw_reservas_activas AS
SELECT
    r.id_reserva,
    c.id_cliente,
    c.nombre AS cliente,
    h.numero AS habitacion,
    h.tipo AS tipo_habitacion,
    r.fecha_entrada,
    r.fecha_salida,
    (r.fecha_salida - r.fecha_entrada) AS total_noches
FROM reserva r
INNER JOIN cliente c ON r.id_cliente = c.id_cliente
INNER JOIN habitacion h ON r.id_habitacion = h.id_habitacion
WHERE r.fecha_entrada <= CURRENT_DATE
  AND r.fecha_salida > CURRENT_DATE;

-- 5.1.1. Verificacion de la vista 1
SELECT
    id_reserva,
    cliente,
    habitacion,
    tipo_habitacion,
    TO_CHAR(fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
    TO_CHAR(fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
    total_noches
FROM vw_reservas_activas
ORDER BY id_reserva;

-- 5.1.2. Vista 2: Ingresos mensuales del hotel
CREATE OR REPLACE VIEW vw_ingresos_mensuales AS
SELECT
    DATE_TRUNC('month', fecha_pago)::DATE AS periodo,
    COUNT(*) AS cantidad_pagos,
    SUM(monto) AS total_ingresos
FROM pago
GROUP BY DATE_TRUNC('month', fecha_pago);

-- 5.1.2. Verificacion de la vista 2
SELECT
    TO_CHAR(periodo, 'MM/YYYY') AS mes,
    cantidad_pagos,
    total_ingresos
FROM vw_ingresos_mensuales
ORDER BY periodo ASC;