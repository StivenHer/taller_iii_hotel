-- Parte 3: Datos sinteticos generados con IA
-- Version 06: Carga de datos

-- Etapa 3.1: Insercion de 20 clientes
-- Correos ficticios del dominio example.com

BEGIN;

INSERT INTO cliente (
  id_cliente,
  nombre,
  correo,
  telefono,
  nacionalidad
)
VALUES
  (101, 'Carlos Ramirez', 'carlos.ramirez@example.com', '3000000101', 'Colombia'),
  (102, 'Maria Gonzalez', 'maria.gonzalez@example.com', '3000000102', 'Colombia'),
  (103, 'Juan Martinez', 'juan.martinez@example.com', '3000000103', 'Mexico'),
  (104, 'Laura Fernandez', 'laura.fernandez@example.com', '3000000104', 'Colombia'),
  (105, 'Pedro Sanchez', 'pedro.sanchez@example.com', '3000000105', 'Argentina'),
  (106, 'Ana Rodriguez', 'ana.rodriguez@example.com', '3000000106', 'Colombia'),
  (107, 'Diego Torres', 'diego.torres@example.com', '3000000107', 'Chile'),
  (108, 'Sofia Herrera', 'sofia.herrera@example.com', '3000000108', 'Colombia'),
  (109, 'Andres Castro', 'andres.castro@example.com', '3000000109', 'Peru'),
  (110, 'Valentina Lopez', 'valentina.lopez@example.com', '3000000110', 'Colombia'),
  (111, 'Miguel Vargas', 'miguel.vargas@example.com', '3000000111', 'Ecuador'),
  (112, 'Camila Morales', 'camila.morales@example.com', '3000000112', 'Colombia'),
  (113, 'Daniel Rojas', 'daniel.rojas@example.com', '3000000113', 'Mexico'),
  (114, 'Isabella Perez', 'isabella.perez@example.com', '3000000114', 'Colombia'),
  (115, 'Sebastian Diaz', 'sebastian.diaz@example.com', '3000000115', 'Argentina'),
  (116, 'Natalia Romero', 'natalia.romero@example.com', '3000000116', 'Colombia'),
  (117, 'Felipe Mendoza', 'felipe.mendoza@example.com', NULL, 'Chile'),
  (118, 'Paula Jimenez', 'paula.jimenez@example.com', '3000000118', 'Colombia'),
  (119, 'Jorge Silva', 'jorge.silva@example.com', NULL, 'Peru'),
  (120, 'Lucia Navarro', 'lucia.navarro@example.com', '3000000120', 'Colombia');

-- Actualizar la secuencia del identificador
-- para evitar futuros conflictos con SERIAL.

SELECT setval(
  pg_get_serial_sequence('cliente', 'id_cliente'),
  (SELECT MAX(id_cliente) FROM cliente),
  true
);

COMMIT;
-- Etapa 3.2: Insercion de 10 habitaciones

BEGIN;

INSERT INTO habitacion (
  id_habitacion,
  numero,
  tipo,
  precio_noche,
  estado
)
VALUES
  (201, '101', 'Sencilla', 120000, 'Disponible'),
  (202, '102', 'Sencilla', 135000, 'Disponible'),
  (203, '103', 'Doble', 190000, 'Ocupada'),
  (204, '104', 'Doble', 210000, 'Disponible'),
  (205, '105', 'Suite', 350000, 'Disponible'),
  (206, '106', 'Sencilla', 145000, 'Disponible'),
  (207, '107', 'Doble', 225000, 'Disponible'),
  (208, '108', 'Suite', 420000, 'Disponible'),
  (209, '109', 'Doble', 240000, 'Disponible'),
  (210, '110', 'Sencilla', 125000, 'Mantenimiento');

-- Actualizar la secuencia de habitaciones

SELECT setval(
  pg_get_serial_sequence(
    'habitacion',
    'id_habitacion'
  ),
  (SELECT MAX(id_habitacion) FROM habitacion),
  true
);

COMMIT;

BEGIN;

INSERT INTO reserva (
  id_reserva,
  id_cliente,
  id_habitacion,
  fecha_entrada,
  fecha_salida
)
VALUES

-- Habitacion 201: 7 reservas
(301, 101, 201, TO_DATE('02/10/2026', 'DD/MM/YYYY'), TO_DATE('05/10/2026', 'DD/MM/YYYY')),
(302, 102, 201, TO_DATE('09/10/2026', 'DD/MM/YYYY'), TO_DATE('13/10/2026', 'DD/MM/YYYY')),
(303, 103, 201, TO_DATE('20/10/2026', 'DD/MM/YYYY'), TO_DATE('24/10/2026', 'DD/MM/YYYY')),
(304, 104, 201, TO_DATE('10/11/2026', 'DD/MM/YYYY'), TO_DATE('13/11/2026', 'DD/MM/YYYY')),
(305, 105, 201, TO_DATE('20/11/2026', 'DD/MM/YYYY'), TO_DATE('25/11/2026', 'DD/MM/YYYY')),
(306, 106, 201, TO_DATE('03/12/2026', 'DD/MM/YYYY'), TO_DATE('09/12/2026', 'DD/MM/YYYY')),
(307, 107, 201, TO_DATE('18/12/2026', 'DD/MM/YYYY'), TO_DATE('20/12/2026', 'DD/MM/YYYY')),

-- Habitacion 202: 3 reservas
(308, 108, 202, TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('10/10/2026', 'DD/MM/YYYY')),
(309, 101, 202, TO_DATE('15/11/2026', 'DD/MM/YYYY'), TO_DATE('19/11/2026', 'DD/MM/YYYY')),
(310, 109, 202, TO_DATE('10/12/2026', 'DD/MM/YYYY'), TO_DATE('14/12/2026', 'DD/MM/YYYY')),

-- Habitacion 203: 3 reservas
(311, 110, 203, TO_DATE('15/10/2026', 'DD/MM/YYYY'), TO_DATE('18/10/2026', 'DD/MM/YYYY')),
(312, 111, 203, TO_DATE('04/11/2026', 'DD/MM/YYYY'), TO_DATE('07/11/2026', 'DD/MM/YYYY')),
(313, 112, 203, TO_DATE('15/12/2026', 'DD/MM/YYYY'), TO_DATE('20/12/2026', 'DD/MM/YYYY')),

-- Habitacion 204: 3 reservas
(314, 113, 204, TO_DATE('01/10/2026', 'DD/MM/YYYY'), TO_DATE('04/10/2026', 'DD/MM/YYYY')),
(315, 114, 204, TO_DATE('13/11/2026', 'DD/MM/YYYY'), TO_DATE('18/11/2026', 'DD/MM/YYYY')),
(316, 115, 204, TO_DATE('04/12/2026', 'DD/MM/YYYY'), TO_DATE('07/12/2026', 'DD/MM/YYYY')),

-- Habitacion 205: 3 reservas
(317, 116, 205, TO_DATE('15/10/2026', 'DD/MM/YYYY'), TO_DATE('20/10/2026', 'DD/MM/YYYY')),
(318, 101, 205, TO_DATE('26/11/2026', 'DD/MM/YYYY'), TO_DATE('30/11/2026', 'DD/MM/YYYY')),
(319, 117, 205, TO_DATE('22/12/2026', 'DD/MM/YYYY'), TO_DATE('28/12/2026', 'DD/MM/YYYY')),

-- Habitacion 206: 3 reservas
(320, 118, 206, TO_DATE('08/10/2026', 'DD/MM/YYYY'), TO_DATE('12/10/2026', 'DD/MM/YYYY')),
(321, 119, 206, TO_DATE('08/11/2026', 'DD/MM/YYYY'), TO_DATE('12/11/2026', 'DD/MM/YYYY')),
(322, 120, 206, TO_DATE('01/12/2026', 'DD/MM/YYYY'), TO_DATE('05/12/2026', 'DD/MM/YYYY')),

-- Habitacion 207: 3 reservas
(323, 103, 207, TO_DATE('18/10/2026', 'DD/MM/YYYY'), TO_DATE('22/10/2026', 'DD/MM/YYYY')),
(324, 104, 207, TO_DATE('22/11/2026', 'DD/MM/YYYY'), TO_DATE('25/11/2026', 'DD/MM/YYYY')),
(325, 105, 207, TO_DATE('19/12/2026', 'DD/MM/YYYY'), TO_DATE('23/12/2026', 'DD/MM/YYYY')),

-- Habitacion 208: 3 reservas
(326, 106, 208, TO_DATE('23/10/2026', 'DD/MM/YYYY'), TO_DATE('27/10/2026', 'DD/MM/YYYY')),
(327, 107, 208, TO_DATE('26/11/2026', 'DD/MM/YYYY'), TO_DATE('29/11/2026', 'DD/MM/YYYY')),
(328, 108, 208, TO_DATE('07/12/2026', 'DD/MM/YYYY'), TO_DATE('13/12/2026', 'DD/MM/YYYY')),

-- Habitacion 209: 2 reservas
(329, 109, 209, TO_DATE('28/10/2026', 'DD/MM/YYYY'), TO_DATE('01/11/2026', 'DD/MM/YYYY')),
(330, 110, 209, TO_DATE('02/12/2026', 'DD/MM/YYYY'), TO_DATE('07/12/2026', 'DD/MM/YYYY'));

-- Registrar una observacion de ejemplo
UPDATE reserva
SET observaciones = 'Llegada despues de las 20:00'
WHERE id_reserva = 312;

-- Actualizar la secuencia de reserva
SELECT setval(
  pg_get_serial_sequence('reserva', 'id_reserva'),
  (SELECT MAX(id_reserva) FROM reserva),
  true
);

COMMIT;

-- Etapa 3.4: Insercion de 36 pagos sinteticos
-- Formato de fechas: DD/MM/YYYY
-- Metodos: Tarjeta, Efectivo, Transferencia
-- Se incluyen pagos completos y parciales

BEGIN;

INSERT INTO pago (
  id_pago,
  id_reserva,
  fecha_pago,
  monto,
  metodo
)
VALUES

-- Pagos iniciales de las reservas
(401, 301, TO_DATE('02/10/2026', 'DD/MM/YYYY'), 360000, 'Efectivo'),
(402, 302, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 200000, 'Efectivo'),
(403, 303, TO_DATE('20/10/2026', 'DD/MM/YYYY'), 180000, 'Tarjeta'),
(404, 304, TO_DATE('10/11/2026', 'DD/MM/YYYY'), 360000, 'Tarjeta'),
(405, 305, TO_DATE('20/11/2026', 'DD/MM/YYYY'), 250000, 'Transferencia'),
(406, 307, TO_DATE('18/12/2026', 'DD/MM/YYYY'), 240000, 'Efectivo'),
(407, 308, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 540000, 'Tarjeta'),
(408, 309, TO_DATE('15/11/2026', 'DD/MM/YYYY'), 200000, 'Tarjeta'),
(409, 310, TO_DATE('10/12/2026', 'DD/MM/YYYY'), 540000, 'Transferencia'),
(410, 311, TO_DATE('15/10/2026', 'DD/MM/YYYY'), 570000, 'Efectivo'),
(411, 312, TO_DATE('04/11/2026', 'DD/MM/YYYY'), 300000, 'Tarjeta'),
(412, 313, TO_DATE('15/12/2026', 'DD/MM/YYYY'), 950000, 'Transferencia'),
(413, 314, TO_DATE('01/10/2026', 'DD/MM/YYYY'), 630000, 'Efectivo'),
(414, 315, TO_DATE('13/11/2026', 'DD/MM/YYYY'), 1050000, 'Transferencia'),
(415, 316, TO_DATE('04/12/2026', 'DD/MM/YYYY'), 630000, 'Tarjeta'),
(416, 317, TO_DATE('15/10/2026', 'DD/MM/YYYY'), 1750000, 'Transferencia'),
(417, 318, TO_DATE('26/11/2026', 'DD/MM/YYYY'), 500000, 'Efectivo'),
(418, 320, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 580000, 'Transferencia'),
(419, 321, TO_DATE('08/11/2026', 'DD/MM/YYYY'), 580000, 'Efectivo'),
(420, 322, TO_DATE('01/12/2026', 'DD/MM/YYYY'), 580000, 'Tarjeta'),
(421, 323, TO_DATE('18/10/2026', 'DD/MM/YYYY'), 400000, 'Efectivo'),
(422, 324, TO_DATE('22/11/2026', 'DD/MM/YYYY'), 675000, 'Efectivo'),
(423, 325, TO_DATE('19/12/2026', 'DD/MM/YYYY'), 900000, 'Transferencia'),
(424, 326, TO_DATE('23/10/2026', 'DD/MM/YYYY'), 1680000, 'Tarjeta'),
(425, 327, TO_DATE('26/11/2026', 'DD/MM/YYYY'), 300000, 'Transferencia'),
(426, 329, TO_DATE('28/10/2026', 'DD/MM/YYYY'), 960000, 'Tarjeta'),
(427, 330, TO_DATE('02/12/2026', 'DD/MM/YYYY'), 400000, 'Efectivo'),

-- Pagos adicionales de reservas con varias cuotas
(428, 302, TO_DATE('10/10/2026', 'DD/MM/YYYY'), 280000, 'Tarjeta'),
(429, 303, TO_DATE('21/10/2026', 'DD/MM/YYYY'), 300000, 'Transferencia'),
(430, 305, TO_DATE('21/11/2026', 'DD/MM/YYYY'), 200000, 'Efectivo'),
(431, 309, TO_DATE('16/11/2026', 'DD/MM/YYYY'), 340000, 'Transferencia'),
(432, 312, TO_DATE('05/11/2026', 'DD/MM/YYYY'), 270000, 'Efectivo'),
(433, 318, TO_DATE('27/11/2026', 'DD/MM/YYYY'), 700000, 'Tarjeta'),
(434, 323, TO_DATE('19/10/2026', 'DD/MM/YYYY'), 500000, 'Transferencia'),
(435, 327, TO_DATE('27/11/2026', 'DD/MM/YYYY'), 700000, 'Efectivo'),
(436, 330, TO_DATE('03/12/2026', 'DD/MM/YYYY'), 600000, 'Transferencia');

-- Actualizar la secuencia de pagos

SELECT setval(
  pg_get_serial_sequence('pago', 'id_pago'),
  (SELECT MAX(id_pago) FROM pago),
  true
);

COMMIT;