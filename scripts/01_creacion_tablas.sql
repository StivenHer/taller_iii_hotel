-- Tabla 1: cliente
CREATE TABLE cliente (
  id_cliente SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(120),
  telefono VARCHAR(20),
  nacionalidad VARCHAR(50)
);

-- Tabla 2: habitacion
CREATE TABLE habitacion (
  id_habitacion SERIAL PRIMARY KEY,
  numero VARCHAR(10) NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  precio_noche NUMERIC(10,2) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'Disponible'
);

-- Tabla 3: reserva
CREATE TABLE reserva (
  id_reserva SERIAL PRIMARY KEY,
  id_cliente INTEGER NOT NULL,
  id_habitacion INTEGER NOT NULL,
  fecha_entrada DATE NOT NULL,
  fecha_salida DATE NOT NULL
);

-- Tabla 4: pago
CREATE TABLE pago (
  id_pago SERIAL PRIMARY KEY,
  id_reserva INTEGER NOT NULL,
  fecha_pago DATE NOT NULL,
  monto NUMERIC(12,2) NOT NULL,
  metodo VARCHAR(20) NOT NULL
);