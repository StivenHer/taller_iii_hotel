-- Prueba negativa 1
-- Verificar que no se permita un tipo
-- de habitacion diferente a los autorizados.

INSERT INTO habitacion (
  numero,
  tipo,
  precio_noche,
  estado
)
VALUES (
  'T9002',
  'Triple',
  180000,
  'Disponible'
);


-- Prueba negativa 2
-- Reserva con un cliente inexistente.
-- Debe rechazarse por la clave foranea.

INSERT INTO reserva (
  id_cliente,
  id_habitacion,
  fecha_entrada,
  fecha_salida
)
VALUES (
  999999,
  999999,
  TO_DATE('15/11/2026', 'DD/MM/YYYY'),
  TO_DATE('17/11/2026', 'DD/MM/YYYY')
);

-- Prueba negativa 3
-- Intentar registrar dos habitaciones
-- con el mismo numero.
-- Debe rechazarse por la restriccion UNIQUE.

INSERT INTO habitacion (
  numero,
  tipo,
  precio_noche,
  estado
)
VALUES
  ('T9003', 'Sencilla', 180000, 'Disponible'),
  ('T9003', 'Doble', 240000, 'Disponible');


  
  
-- Prueba negativa 4
-- Verificar reservas superpuestas


BEGIN;

INSERT INTO cliente (
  id_cliente, nombre, correo,
  telefono, nacionalidad
)
VALUES (
  9201, 'Cliente Exclude',
  'exclude9201@example.com',
  '3000000001', 'Colombia'
);

INSERT INTO habitacion (
  id_habitacion, numero, tipo,
  precio_noche, estado
)
VALUES (
  9201, 'T9201', 'Doble',
  250000, 'Disponible'
);

INSERT INTO reserva (
  id_cliente, id_habitacion,
  fecha_entrada, fecha_salida
)
VALUES (
  9201, 9201,
  TO_DATE('20/11/2026', 'DD/MM/YYYY'),
  TO_DATE('25/11/2026', 'DD/MM/YYYY')
);