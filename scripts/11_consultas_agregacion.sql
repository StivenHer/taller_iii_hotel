
-- Parte 4.4: Consultas de agregacion y agrupamiento

-- CONSULTA 6
-- Total de ingresos generados por mes

SELECT
  TO_CHAR(
    DATE_TRUNC('month', fecha_pago),
    'MM/YYYY'
  ) AS mes,
  COUNT(*) AS cantidad_pagos,
  SUM(monto) AS total_ingresos
FROM pago
GROUP BY DATE_TRUNC('month', fecha_pago)
ORDER BY DATE_TRUNC('month', fecha_pago) ASC;


-- CONSULTA 7
-- Numero de reservas realizadas por cada cliente

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  COUNT(r.id_reserva) AS total_reservas
FROM cliente c
LEFT JOIN reserva r
  ON c.id_cliente = r.id_cliente
GROUP BY
  c.id_cliente,
  c.nombre
ORDER BY
  total_reservas DESC,
  c.nombre ASC;


-- CONSULTA 8
-- Habitaciones reservadas mas de cinco veces

SELECT
  h.id_habitacion,
  h.numero AS habitacion,
  h.tipo,
  COUNT(r.id_reserva) AS total_reservas
FROM habitacion h
INNER JOIN reserva r
  ON h.id_habitacion = r.id_habitacion
GROUP BY
  h.id_habitacion,
  h.numero,
  h.tipo
HAVING COUNT(r.id_reserva) > 5
ORDER BY total_reservas DESC, h.numero ASC;


-- CONSULTA 9
-- Clientes con mayor gasto total acumulado
-- Se calcula usando el valor total de sus estancias

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  COUNT(r.id_reserva) AS total_reservas,
  SUM(
    (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche
  ) AS gasto_total_acumulado
FROM cliente c
INNER JOIN reserva r
  ON c.id_cliente = r.id_cliente
INNER JOIN habitacion h
  ON r.id_habitacion = h.id_habitacion
GROUP BY
  c.id_cliente,
  c.nombre
ORDER BY
  gasto_total_acumulado DESC,
  c.id_cliente ASC;

-- CONSULTA 10
-- Clientes que han pagado usando mas de un metodo

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  COUNT(DISTINCT p.metodo) AS metodos_diferentes,
  STRING_AGG(
    DISTINCT p.metodo,
    ', ' ORDER BY p.metodo
  ) AS metodos_utilizados
FROM cliente c
INNER JOIN reserva r
  ON c.id_cliente = r.id_cliente
INNER JOIN pago p
  ON r.id_reserva = p.id_reserva
GROUP BY
  c.id_cliente,
  c.nombre
HAVING COUNT(DISTINCT p.metodo) > 1
ORDER BY
  metodos_diferentes DESC,
  c.nombre ASC;


-- CONSULTA 11
-- Promedio de noches reservadas por tipo de habitacion

SELECT
  h.tipo AS tipo_habitacion,
  COUNT(r.id_reserva) AS total_reservas,
  ROUND(
    AVG(
      (r.fecha_salida - r.fecha_entrada)::NUMERIC
    ),
    2
  ) AS promedio_noches
FROM habitacion h
INNER JOIN reserva r
  ON h.id_habitacion = r.id_habitacion
GROUP BY h.tipo
ORDER BY h.tipo ASC;


-- CONSULTA 12
-- Total de reservas y monto total por tipo de habitacion

SELECT
  h.tipo AS tipo_habitacion,
  COUNT(r.id_reserva) AS total_reservas,
  COALESCE(
    SUM(
      (r.fecha_salida - r.fecha_entrada)
      * h.precio_noche
    ),
    0
  ) AS monto_total_reservas
FROM habitacion h
LEFT JOIN reserva r
  ON h.id_habitacion = r.id_habitacion
GROUP BY h.tipo
ORDER BY monto_total_reservas DESC;



-- Consulta 13: Tres clientes con mas noches reservadas

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  COUNT(r.id_reserva) AS total_reservas,
  SUM(
    r.fecha_salida - r.fecha_entrada
  ) AS total_noches
FROM cliente c
INNER JOIN reserva r
  ON c.id_cliente = r.id_cliente
GROUP BY
  c.id_cliente,
  c.nombre
ORDER BY
  total_noches DESC,
  c.id_cliente ASC
LIMIT 3;


-- Consulta 14: Ingreso total por cada metodo de pago

SELECT
  p.metodo AS metodo_pago,
  COUNT(p.id_pago) AS cantidad_pagos,
  SUM(p.monto) AS total_ingresos
FROM pago p
GROUP BY p.metodo
ORDER BY
  total_ingresos DESC,
  p.metodo ASC;


-- Consulta 15: Clientes que han reservado
-- mas de una habitacion diferente

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  COUNT(DISTINCT r.id_habitacion)
    AS habitaciones_diferentes,
  COUNT(r.id_reserva) AS total_reservas
FROM cliente c
INNER JOIN reserva r
  ON c.id_cliente = r.id_cliente
GROUP BY
  c.id_cliente,
  c.nombre
HAVING COUNT(DISTINCT r.id_habitacion) > 1
ORDER BY
  habitaciones_diferentes DESC,
  c.nombre ASC;

