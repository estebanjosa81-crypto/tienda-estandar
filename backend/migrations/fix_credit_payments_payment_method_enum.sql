-- Ampliar ENUM de payment_method en credit_payments para incluir metodos adicionales
-- que ya estan permitidos por la validacion de rutas (addi, sistecredito, mercadopago)

ALTER TABLE credit_payments
  MODIFY COLUMN payment_method
    ENUM('efectivo', 'tarjeta', 'transferencia', 'addi', 'sistecredito', 'mercadopago') NOT NULL;
