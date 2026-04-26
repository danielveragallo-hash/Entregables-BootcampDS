
### Conexión
### USE sakila;
# Se selecciona el database a trabajar con "use"
use sakila;

### Parte 1 – SELECT y WHERE

### 1. Mostrar nombre y apellido de todos los clientes
# Se seleccionan las columnas "first_name" y "last_name" de la tabla "customer":
select first_name, last_name from customer;
# Esto nos muestra el primer nombre y apellido de todos los clientes

### 2. Películas con duración mayor a 120 minutos
# Se seleccionan específicamente las columnas "title" y "length" de la tabla "film" con el fin de no hacer una solicitud pesada
select title, length from film
# Con "where", filtramos la duración de las películas mayores a 120min. Con el comando anterior, solo se muestra el título
# y la duración de esas películas
where length > 120;

### Parte 2 – ORDER BY

### 3. Ordenar clientes por apellido --> Por orden alfabetico de la A a la Z
# Con una solicitud anterior
select first_name, last_name from customer
# Solicitamos ordenar con "order by" la columna "last_name" 
order by last_name desc;
###
# Si invertimos el orden de las columnas "first_name" y "last_name" podemos ver primero el apellido
# select last_name, first_name from customer
# order by last_name desc;
###

### 4. Top 5 películas más largas --> TIP: Use la palabra LIMIT
# Con el comando anterior podemos seleccionar el nombre de las películas y su duración
select title, length from film
# Con "order by" podemos ordenar las películas por duración de mayor a menor con "desc" 
# y limitar la solicitud a las primeras 5 películas con "limit 5"
order by length desc limit 5;

### Parte 3 – INNER JOIN

### 5. Cantidad pagada y fecha del pago con nombre y apellido del cliente (JOIN entre Payment - Customer)
# Seleccionamos las diferentes columnas de las diferentes tablas a trabajar
select payment.amount, payment.payment_date, customer.first_name, customer.last_name from payment
# con join, unimos las tablas seleccionadas para que nos muestre la información específica
join customer on payment.customer_id = customer.customer_id;

### 6. Películas alquiladas (JOIN entre Rental - Inventory - Film)
# De igual manera, seleccionamos las columnas a trabajar de la tabla rental
select film.film_id, film.title, inventory.inventory_id, rental.rental_id from rental
# Unimos la información de la tabla "inventory" a la tabla "rental" dejando "inventory" como la consulta resultado
join inventory on rental.inventory_id = inventory.inventory_id
# Y unimos a esta consulta la tabla "film"
join film on inventory.film_id = film.film_id;

### Parte 4 – LEFT JOIN

### 7. Nombre y apellido de clientes sin pagos (LEFT JOIN entre Payment - Customer pero usando WHERE)
# Seleccionamos las columnas de primer nombre y apellido de la tabla "customer"
select customer.first_name, customer.last_name from customer
# Unimos esta tabla con la tabla de pagos
left join payment on customer.customer_id = payment.customer_id
# Con "where" condicionamos los resultados a los que no tengan información ingresada "NULL"
where payment.payment_id is null;
# El resultado que arroja está vacío porque no hay clientes que no registren pagos

### 8. Listar los nombres de las peliculas y su duracion de aquellos titulos que no tienen actores
# Seleccionamos las columnas "title" y "length" de "film"
select film.title, film.length, actor.first_name, actor.last_name from film
# Unimos la columna "film_id" de la tabla "film" con la tabla "film_actor" y le damos el nombre de film_actor.film_id
left join film_actor on film.film_id = film_actor.film_id
# Con "where" condicionamos los resultados a los que no tengan ningún actor_id "NULL"
where film_actor.actor_id is null;

### Parte 5 – INSERT, UPDATE, DELETE (Data Definition Language )

### 9. Insertar actor temporal
# Vamos a traer todos los datos de la tabla actor para ver cuál es el último actor_id 
select * from actor
# con order by lo ponemos de mayor a menor
order by actor_id desc;
# con insert, vamos a insertar mi nombre y apellido con el id 201
insert into actor (first_name, last_name)
values ('DANIEL', 'VERA');

### 10. Actualizar actor
# Con update vamos a cambiar el nombre y apellido para el actor_id 201 a "HERNANDO CASANOVA"
update actor
set first_name = 'HERNANDO', last_name = 'CASANOVA'
where actor_id = 201;

### 11. Eliminar actor
# Vamos a borrar el registro 201, que creamos recientemente, directamente con el delete
delete from actor
where actor_id = 201;

### Parte 6 - Consultas Avanzadas

### 12. Top 5 clientes con mayor cantidad de dinero pagado al servicio de rentas
# Seleccionamos las columnas "first_name" y "last_name" de la tabla customer
select customer.first_name, customer.last_name,
sum(payment.amount) as total_pagado
# Unimos con JOIN la tabla payment a la tabla customer usando la columna "customer_id"
from customer join payment on customer.customer_id = payment.customer_id
# Agrupamos los resultados por "customer_id" (para evitar que sume dos clientes distintos que puedan tener el mismo nombre)
# y nombre (first_name) y apellido (last_name) para que nos muestre nombre y no solo el ID.
group by customer.customer_id, customer.first_name, customer.last_name
# Y ordenamos por "total_pagado" en orden de mayor a menor y mostramos solo 5 con "LIMIT"
order by total_pagado desc limit 5;

### 13. Top 5 Películas más alquiladas (JOIN entre Rental - Inventory - Film) --> Agrupar los datos con conteo y tomar las mejores 5
# Seleccionamos la columna "title" de la tabla "film".
# Con count contamos los datos de la columna "rental_id" en la tabla "rental" y le ponemos el alias "total_alquileres"
select film.title, count(rental.rental_id) as total_alquileres
# Unimos "inventory" a "rental" desde la columna "inventory_id" y le damos el nombre "inventory.inventory_id" a la consulta
from rental join inventory on rental.inventory_id = inventory.inventory_id
# Y unimos la columna "film_id" de la tabla "inventory" a la tabla "film" y le damos el nombre "film.film_id" a la consulta
join film on inventory.film_id = film.film_id
# Agrupamos por film_id (para evitar que duplicados) y title
group by film.film_id, film.title
# Ordenamos la consulta de mayor a menor por la suma de alquileres "total_alquileres" y mostramos los primeros 5 con "LIMIT"
order by total_alquileres desc limit 5;