
-- Taller III - Bases de Datos I
-- Parte 3: Validacion de datos sinteticos

-- 1. Cantidad de registros
SELECT 'cliente' AS tabla, COUNT(*) AS total
FROM cliente
UNION ALL
SELECT 'habitacion', COUNT(*)
FROM habitacion
UNION ALL
SELECT 'reserva', COUNT(*)
FROM reserva
UNION ALL
SELECT 'pago', COUNT(*)
FROM pago;

-- 2. Reservas superpuestas
SELECT
  r1.id_reserva AS reserva_1,
  r2.id_reserva AS reserva_2,
  r1.id_habitacion
FROM reserva r1
JOIN reserva r2
  ON r1.id_habitacion = r2.id_habitacion
  AND r1.id_reserva < r2.id_reserva
WHERE r1.fecha_entrada < r2.fecha_salida
  AND r2.fecha_entrada < r1.fecha_salida;

-- 3. Distribucion de reservas
SELECT
  h.numero AS habitacion,
  COUNT(r.id_reserva) AS total_reservas
FROM habitacion h
LEFT JOIN reserva r
  ON h.id_habitacion = r.id_habitacion
GROUP BY h.id_habitacion, h.numero
ORDER BY h.numero;

-- 4. Pagos que superan el valor de la reserva
SELECT
  r.id_reserva,
  (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche AS total_reserva,
  COALESCE(SUM(p.monto), 0) AS total_pagado
FROM reserva r
JOIN habitacion h
  ON r.id_habitacion = h.id_habitacion
LEFT JOIN pago p
  ON r.id_reserva = p.id_reserva
GROUP BY
  r.id_reserva,
  r.fecha_entrada,
  r.fecha_salida,
  h.precio_noche
HAVING COALESCE(SUM(p.monto), 0)
  > (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche;

-- 5. Resumen de estados de pago
WITH resumen_pagos AS (
  SELECT
    r.id_reserva,
    (r.fecha_salida - r.fecha_entrada)
      * h.precio_noche AS total_reserva,
    COALESCE(SUM(p.monto), 0) AS total_pagado,
    COUNT(p.id_pago) AS cantidad_pagos
  FROM reserva r
  JOIN habitacion h
    ON r.id_habitacion = h.id_habitacion
  LEFT JOIN pago p
    ON r.id_reserva = p.id_reserva
  GROUP BY
    r.id_reserva,
    r.fecha_entrada,
    r.fecha_salida,
    h.precio_noche
)
SELECT
  COUNT(*) FILTER (
    WHERE cantidad_pagos = 0
  ) AS sin_pagos,
  COUNT(*) FILTER (
    WHERE cantidad_pagos > 0
      AND total_pagado < total_reserva
  ) AS pagos_parciales,
  COUNT(*) FILTER (
    WHERE total_pagado = total_reserva
  ) AS pagadas,
  COUNT(*) FILTER (
    WHERE total_pagado > total_reserva
  ) AS pagos_excedidos
FROM resumen_pagos;

-- 6. Validacion de fechas
SELECT COUNT(*) AS fechas_invalidas
FROM reserva
WHERE fecha_salida <= fecha_entrada;
