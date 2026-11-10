-- Parte 4.3: Consultas con JOIN
-- Consulta 4: Clientes que han reservado habitaciones Suite

SELECT DISTINCT
  c.id_cliente,
  c.nombre AS cliente,
  c.nacionalidad,
  c.correo
FROM cliente c
INNER JOIN reserva r
  ON c.id_cliente = r.id_cliente
INNER JOIN habitacion h
  ON r.id_habitacion = h.id_habitacion
WHERE h.tipo = 'Suite'
ORDER BY c.nombre ASC;

-- Consulta 5: Clientes de nacionalidad Colombia
-- que hayan realizado reservas

SELECT DISTINCT
  c.id_cliente,
  c.nombre AS cliente,
  c.nacionalidad,
  c.correo
FROM cliente c
INNER JOIN reserva r
  ON c.id_cliente = r.id_cliente
WHERE c.nacionalidad = 'Colombia'
ORDER BY c.nombre ASC, c.id_cliente;
