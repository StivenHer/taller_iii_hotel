BEGIN;

-- Prueba 1: Registrar un cliente valido
INSERT INTO cliente (
  id_cliente,
  nombre,
  correo,
  telefono,
  nacionalidad
)
VALUES (
  9001,
  'Ana Prueba',
  'ana.prueba@example.com',
  '3000000000',
  'Colombia'
);

-- Prueba 2: Registrar una habitacion valida
INSERT INTO habitacion (
  id_habitacion,
  numero,
  tipo,
  precio_noche,
  estado
)
VALUES (
  9001,
  'T9001',
  'Sencilla',
  180000,
  'Disponible'
);

-- Prueba 3: Registrar una reserva valida
INSERT INTO reserva (
  id_reserva,
  id_cliente,
  id_habitacion,
  fecha_entrada,
  fecha_salida,
  observaciones
)
VALUES (
  9001,
  9001,
  9001,
  TO_DATE('10/11/2026', 'DD/MM/YYYY'),
  TO_DATE('11/11/2026', 'DD/MM/YYYY'),
  'Habitacion de prueba'
);

-- Prueba 4: Registrar un pago valido
INSERT INTO pago (
  id_pago,
  id_reserva,
  fecha_pago,
  monto,
  metodo
)
VALUES (
  9001,
  9001,
  TO_DATE('05/11/2026', 'DD/MM/YYYY'),
  180000,
  'Tarjeta'
);

-- Verificar los datos insertados
SELECT
  c.nombre AS cliente,
  h.numero AS habitacion,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY')
    AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY')
    AS fecha_salida,
  p.monto,
  p.metodo
FROM reserva r
JOIN cliente c
  ON r.id_cliente = c.id_cliente
JOIN habitacion h
  ON r.id_habitacion = h.id_habitacion
JOIN pago p
  ON r.id_reserva = p.id_reserva
WHERE r.id_reserva = 9001;

-- Ejecutar solo despues de capturar el resultado
ROLLBACK;