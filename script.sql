--Prueba Final: Sixto Guerra U.
--Modulo 5 Base de datos.

--1) Importar Base de Datos
--1.A) Crear base de datos en motor base de datos PostgreSQL 
--1.A.1) postgres=# CREATE DATABASE dvdrental;
--1.A.2) CREATE DATABASE
--1.A.3) postgres=# exit

--2) Utilizar pg_restore para cargar datos.
--2.A)  $ pg_restore -U sixtolio -d dvdrental dvdrental.tar

\c dvdrental

-- 4. Construye las siguientes consultas: 
-- 4.A • Aquellas usadas para insertar, modificar y eliminar un Customer, Staff y Actor.

-- insertar, modificar y eliminar un Customer
BEGIN TRANSACTION;

    -- Insert Nuevo Customer  (para una dirección en oarticular)
    \echo 'Agregamos la ciudad de Santiago'
    INSERT INTO city(country_id, city) VALUES ((SELECT max(country_id) FROM country WHERE country = 'Chile'), 'Santiago');

    \echo 'Agregamos una nueva dirección'
    INSERT INTO address(address, city_id, phone, postal_code, district) VALUES 
                        ('Pasaje uno #1088', 
                        (SELECT max(city_id) FROM city WHERE city = 'Santiago'),
                        '123456789','55555555', 'Maipú');

    \echo 'Agregar Nuevo Cliente'
    INSERT INTO customer(store_id, first_name, last_name, email, address_id, active)
    VALUES
        (1,'Sixto', 'Guerra', 'sixto.guerra1982@gmail.com',
        (SELECT max(address_id) from address WHERE address='Pasaje uno #1088' AND district = 'Maipú' ), 1 );

    -- Verificar Inserción
    \echo 'Verificar Nuevo Registro'
    SELECT customer.activebool, customer.customer_id, customer.email FROM customer WHERE email = 'sixto.guerra1982@gmail.com';
    --Modificar Customer 
    \echo 'Modificar Customer'
    UPDATE customer SET activebool = false WHERE email = 'sixto.guerra1982@gmail.com';
    \echo 'Verificar Modificacion (activebool)'
    SELECT activebool, first_name, last_name, customer_id, email FROM customer WHERE email = 'sixto.guerra1982@gmail.com';
    \echo 'Eliminar Customer'
    DELETE FROM customer WHERE email = 'sixto.guerra1982@gmail.com';
    \echo 'Verificar Eliminación'
    SELECT activebool, first_name, last_name, email FROM customer WHERE email = 'sixto.guerra1982@gmail.com';

COMMIT;


--insertar, modificar y eliminar un Staff

BEGIN TRANSACTION;

    \echo 'Agregar Nuevo Staff'
    
    INSERT INTO staff(first_name,last_name,address_id,email, store_id, username, password)
    VALUES
    ('Juan','Perez',605, 'juan.perez@sakilastaff.com',1,'Juan', '8cb2237d0679ca88db6464eac60da96345513964');

    \echo 'Verificar Nuevo Registro'
    SELECT staff.staff_id, staff.first_name, staff.last_name FROM staff WHERE staff_id = (SELECT max(staff_id) FROM staff);

    -- Cambiar Apellido
    UPDATE staff SET last_name = 'Osorio' WHERE staff_id = (SELECT max(staff_id) FROM staff);
    
    \echo 'Verificar Actualización'
    SELECT staff.staff_id, staff.first_name, staff.last_name FROM staff WHERE staff_id = (SELECT max(staff_id) FROM staff);

    \echo 'Eliminar Registro'
    DELETE FROM staff WHERE staff_id = (SELECT max(staff_id) FROM staff);

    \echo 'Verificar Eliminación'
    SELECT staff.staff_id, staff.first_name, staff.last_name FROM staff WHERE first_name = 'Juan';

COMMIT;

-- insertar, modificar y eliminar un Actor
BEGIN TRANSACTION;
    \echo 'Agregar Nuevo Actor'
    
    INSERT INTO Actor(first_name,last_name) VALUES ('Michael','Costner');

    SELECT * from Actor where actor_id = (SELECT max(actor_id) FROM actor);

    \echo 'Modificar Nuevo Actor (nombre)'
    UPDATE actor SET first_name = 'Kevin' WHERE actor_id = (SELECT max(actor_id) FROM actor);

    SELECT * from Actor where actor_id = (SELECT max(actor_id) FROM actor);

    \echo 'Eliminar Nuevo Actor'
    DELETE FROM actor WHERE actor_id = (SELECT max(actor_id) FROM actor);

    \echo 'Comprobar Eliminacion'
    SELECT * from Actor where first_name = 'Michael' and last_name = 'Costner';

COMMIT;

-- 4.B • Listar todas las “rental” con los datos del “customer” dado un año y mes.
\echo '-------------------------------------------------------------------------------'
\echo '4.B • Listar todas las “rental” con los datos del “customer” dado un año y mes.'
\echo '-------------------------------------------------------------------------------'

SELECT r.rental_id id ,r.rental_date fecha_arriendo, r.return_date fecha_devolucion, c.first_name nombre, c.last_name apellido, c.email 
FROM rental r LEFT JOIN customer c 
ON r.customer_id = c.customer_id WHERE EXTRACT(YEAR FROM rental_date) = 2005 AND EXTRACT(MONTH FROM rental_date) = 6;

-- 4.C • Listar Número, Fecha (payment_date) y Total (amount) de todas las “payment”. 
\echo '-------------------------------------------------------------------------------'
\echo '4.C • Listar Número, Fecha (payment_date) y Total (amount) de todas las “payment'
\echo '-------------------------------------------------------------------------------'

SELECT  p.payment_id, p.payment_date, p.amount FROM payment AS p;

-- 4.D • Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0
\echo '-------------------------------------------------------------------------------'
\echo '4.D • Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0'
\echo '-------------------------------------------------------------------------------'

SELECT film_id, title, description, release_year, rental_duration, rental_rate 
 FROM public.film WHERE rental_rate > 4 AND release_year = 2006 ORDER BY rental_rate DESC;
