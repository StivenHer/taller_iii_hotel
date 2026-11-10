-- Parte 4.2: Consultas basicas, filtros y ordenamiento
-- Consulta 1: Listar todas las habitaciones disponibles

SELECT
  id_habitacion,
  numero,
  tipo,
  precio_noche,
  estado
FROM habitacion
WHERE estado = 'Disponible'
ORDER BY numero ASC;


-- Consulta 2: Mostrar las reservas activas
-- segun la fecha actual

SELECT
  r.id_reserva,
  c.nombre AS cliente,
  h.numero AS habitacion,
  h.tipo,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  (r.fecha_salida - r.fecha_entrada) AS total_noches
FROM reserva r
JOIN cliente c
  ON r.id_cliente = c.id_cliente
JOIN habitacion h
  ON r.id_habitacion = h.id_habitacion
WHERE r.fecha_entrada <= CURRENT_DATE
  AND r.fecha_salida > CURRENT_DATE
ORDER BY r.fecha_entrada ASC, r.id_reserva;


-- Consulta 3: Reservas con mas de 3 noches de estadia

SELECT
  r.id_reserva,
  c.nombre AS cliente,
  h.numero AS habitacion,
  h.tipo,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  (r.fecha_salida - r.fecha_entrada) AS total_noches,
  h.precio_noche,
  (
    (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche
  ) AS valor_total
FROM reserva r
JOIN cliente c
  ON r.id_cliente = c.id_cliente
JOIN habitacion h
  ON r.id_habitacion = h.id_habitacion
WHERE (r.fecha_salida - r.fecha_entrada) > 3
ORDER BY total_noches DESC, r.id_reserva;
