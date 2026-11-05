BEGIN;

-- Restricciones de cliente
ALTER TABLE cliente
ADD CONSTRAINT uq_cliente_correo
UNIQUE (correo);

-- Restricciones de habitacion
ALTER TABLE habitacion
ADD CONSTRAINT uq_habitacion_numero
UNIQUE (numero);

ALTER TABLE habitacion
ADD CONSTRAINT ck_habitacion_tipo
CHECK (tipo IN ('Sencilla', 'Doble', 'Suite'));

ALTER TABLE habitacion
ADD CONSTRAINT ck_habitacion_estado
CHECK (estado IN ('Disponible', 'Ocupada', 'Mantenimiento'));

ALTER TABLE habitacion
ADD CONSTRAINT ck_habitacion_precio
CHECK (precio_noche > 0);

-- Relaciones de reserva
ALTER TABLE reserva
ADD CONSTRAINT fk_reserva_cliente
FOREIGN KEY (id_cliente)
REFERENCES cliente(id_cliente)
ON UPDATE RESTRICT
ON DELETE RESTRICT;

ALTER TABLE reserva
ADD CONSTRAINT fk_reserva_habitacion
FOREIGN KEY (id_habitacion)
REFERENCES habitacion(id_habitacion)
ON UPDATE RESTRICT
ON DELETE RESTRICT;

ALTER TABLE reserva
ADD CONSTRAINT ck_reserva_fechas
CHECK (fecha_salida > fecha_entrada);

-- Restricciones de pago
ALTER TABLE pago
ADD CONSTRAINT fk_pago_reserva
FOREIGN KEY (id_reserva)
REFERENCES reserva(id_reserva)
ON UPDATE RESTRICT
ON DELETE RESTRICT;

ALTER TABLE pago
ADD CONSTRAINT ck_pago_monto
CHECK (monto > 0);

ALTER TABLE pago
ADD CONSTRAINT ck_pago_metodo
CHECK (metodo IN (
  'Tarjeta', 'Efectivo', 'Transferencia'
));

-- Evitar reservas superpuestas
CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE reserva
ADD CONSTRAINT ex_reserva_sin_superposicion
EXCLUDE USING gist (
  id_habitacion WITH =,
  daterange(
    fecha_entrada,
    fecha_salida,
    '[)'
  ) WITH &&
);

COMMIT;