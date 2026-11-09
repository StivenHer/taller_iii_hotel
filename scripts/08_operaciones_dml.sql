
-- Parte 4 - Operaciones DML
-- Escenario 1: Actualizar el estado de una habitacion

BEGIN;

-- Consultar el estado original
SELECT
  id_habitacion,
  numero,
  tipo,
  estado
FROM habitacion
WHERE id_habitacion = 210;

-- Actualizar el estado de la habitacion
UPDATE habitacion
SET estado = 'Matenimiento'
WHERE id_habitacion = 210
RETURNING
  id_habitacion,
  numero,
  tipo,
  estado;

-- Revertir el cambio de prueba
ROLLBACK;

-- Comprobar que se recupero el estado original
SELECT
  id_habitacion,
  numero,
  tipo,
  estado
FROM habitacion
WHERE id_habitacion = 210;

-- Escenario 2: Actualizar un telefono NULL

BEGIN;

UPDATE cliente
SET telefono = '3001234567'
WHERE id_cliente = 117
  AND telefono IS NULL
RETURNING
  id_cliente,
  nombre,
  telefono;

-- Escenario 3: Registrar un nuevo pago
-- Prueba de insercion mediante INSERT INTO
-- Iniciar transaccion
BEGIN;

-- Registrar un pago ficticio
INSERT INTO pago (
  id_reserva,
  fecha_pago,
  monto,
  metodo
)
SELECT
  r.id_reserva,
  TO_DATE('08/11/2026', 'DD/MM/YYYY'),
  50000.00,
  'Transferencia'
FROM reserva r
JOIN habitacion h
  ON r.id_habitacion = h.id_habitacion
WHERE NOT EXISTS (
  SELECT 1
  FROM pago p
  WHERE p.id_reserva = r.id_reserva
)
AND (
  (r.fecha_salida - r.fecha_entrada)
  * h.precio_noche
) >= 50000
ORDER BY r.id_reserva
LIMIT 1
RETURNING
  id_pago,
  id_reserva,
  TO_CHAR(fecha_pago, 'DD/MM/YYYY') AS fecha_pago,
  monto,
  metodo;