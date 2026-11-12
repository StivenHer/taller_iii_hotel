

-- CONSULTA 16
-- Habitaciones con precio superior al promedio

SELECT
  h.id_habitacion,
  h.numero AS habitacion,
  h.tipo,
  h.precio_noche
FROM habitacion h
WHERE h.precio_noche > (
  SELECT AVG(h2.precio_noche)
  FROM habitacion h2
)
ORDER BY h.precio_noche DESC, h.numero ASC;


-- CONSULTA 17
-- Cliente que realizo la reserva mas costosa

SELECT
  r.id_reserva,
  c.id_cliente,
  c.nombre AS cliente,
  h.numero AS habitacion,
  h.tipo,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  (r.fecha_salida - r.fecha_entrada) AS total_noches,
  (
    (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche
  ) AS valor_total_reserva
FROM reserva r
INNER JOIN cliente c
  ON r.id_cliente = c.id_cliente
INNER JOIN habitacion h
  ON r.id_habitacion = h.id_habitacion
WHERE (
  (r.fecha_salida - r.fecha_entrada)
  * h.precio_noche
) = (
  SELECT MAX(
    (r2.fecha_salida - r2.fecha_entrada)
    * h2.precio_noche
  )
  FROM reserva r2
  INNER JOIN habitacion h2
    ON r2.id_habitacion = h2.id_habitacion
)
ORDER BY r.id_reserva ASC
LIMIT 1;


-- CONSULTA 18
-- Habitaciones que nunca han sido reservadas

SELECT
  h.id_habitacion,
  h.numero AS habitacion,
  h.tipo,
  h.precio_noche,
  h.estado
FROM habitacion h
WHERE NOT EXISTS (
  SELECT 1
  FROM reserva r
  WHERE r.id_habitacion = h.id_habitacion
)
ORDER BY h.numero ASC;


-- CONSULTA 19
-- Reservas sin pagos registrados

SELECT
  r.id_reserva,
  c.nombre AS cliente,
  h.numero AS habitacion,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  (
    (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche
  ) AS valor_total_reserva
FROM reserva r
INNER JOIN cliente c
  ON r.id_cliente = c.id_cliente
INNER JOIN habitacion h
  ON r.id_habitacion = h.id_habitacion
WHERE NOT EXISTS (
  SELECT 1
  FROM pago p
  WHERE p.id_reserva = r.id_reserva
)
ORDER BY r.id_reserva ASC;


-- CONSULTA 20
-- Habitacion mas cara reservada por cada cliente

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  h.id_habitacion,
  h.numero AS habitacion,
  h.tipo,
  h.precio_noche
FROM cliente c
INNER JOIN habitacion h
  ON h.id_habitacion = (
    SELECT h2.id_habitacion
    FROM reserva r2
    INNER JOIN habitacion h2
      ON r2.id_habitacion = h2.id_habitacion
    WHERE r2.id_cliente = c.id_cliente
    ORDER BY
      h2.precio_noche DESC,
      h2.id_habitacion ASC
    LIMIT 1
  )
ORDER BY c.id_cliente ASC;
