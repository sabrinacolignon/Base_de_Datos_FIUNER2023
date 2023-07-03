--1) Mostrar los pedidos ordenados según la fecha de recepción.
select * from Pedidos order by fecha_recepcion;

--2) Mostrar todos los vendedores cuyo apellido sea “Díaz”.

select * from vendedores where apellidos = 'Díaz'

--3) Mostrar la clave de identificación y el apellido de todos los vendedores que ingresaron a la
--empresa después de 1998 ordenados por fecha de ingreso.

select id_vend, apellidos from vendedores
where fecha_ingreso > '1998/01/01'

--4) Mostrar los renglones de pedidos cuyos importes (cantidad * precio unitario) están entre $200
--y $300.

select cantidad, precio_unitario, cantidad*precio_unitario as importe from renglones_pdo where cantidad*precio_unitario between 200 and 300

--5) Mostrar toda la información de los clientes cuyo apellido comience con la letra “R”. 

select * from clientes where apellidos like 'R%'

-- 6) Mostrar el código de los productos cuyo stock sea inferior o igual al punto de repedido y sean
--abastecidos por el proveedor 1.

select sl.id_producto from stock_local sl join productos p  on sl.id_producto = p.id_producto
where stock <= punto_repedido and id_proveedor =1

--7) Mostrar los productos cuyo precio unitario sea mayor a 10 o el proveedor sea el 3.

select * from productos p join proveedores pr on p.id_proveedor = pr.id_proveedor
where p.precio_unitario >10 or p.id_proveedor =3

--8) Mostrar los vendedores que no tienen establecido a quién responden.

select id_vend from vendedores where id_vend_responde_a is null

--9) Mostrar el nombre de las oficinas y los apellidos de los vendedores que dependen de cada
--una de ellas. Ordenar la consulta por oficina y vendedor.

select ov.nombre, v.apellidos from vendedores v join oficinas_vtas ov on v.id_oficina = ov.id_oficina
order by ov.id_oficina, v.id_vend

--10) Mostrar los pedidos presentados en la primera quincena de Marzo de 2000, incluyendo el
--apellido del vendedor que recibió el pedido y el apellido del cliente.

select *
from pedidos p join vendedores v on p.id_vend = v.id_vend
join clientes c on p.id_cliente = c.id_cliente
where fecha_entrega between '2000-03-01' and '2000-03-15'

--11) Mostrar los pedidos realizados por el cliente “DANIEL DELPONTE” y recibidos por la
--empresa durante el año 2000. 

select *
from pedidos p join clientes c on p.id_cliente = c.id_cliente
where c.nombres = 'DANIEL' and c.apellidos= 'DELPONTE' and p.fecha_recepcion between '2000-01-01' and '2000-12-31'

-- 12) Mostrar la cantidad de productos distintos que comercializa la empresa, del proveedor 2.

select count (p.id_producto)
from productos p join proveedores pr on p.id_proveedor = pr.id_proveedor
where pr.id_proveedor =2

--13) Mostrar el promedio de los importes (cantidad * precio unitario) de los renglones del pedido 111.

select avg(cantidad * precio_unitario)
from renglones_pdo
where id_pedido=111

--14) Mostrar la cantidad de pedidos recibidos de los clientes, clasificados por oficina y localidad
--del cliente. Ordenar la consulta por localidad del cliente.

select v.id_oficina, l.nombre, count(*) cantidad_pedidos 

from pedidos p join clientes c on p.id_cliente=c.id_cliente
join localidades l on c.cod_post = l.cod_post
join vendedores v on c.id_vend = v.id_vend

group by v.id_oficina, l.nombre

order by l.nombre

--15) Mostrar el máximo, el mínimo y el promedio del importe de los renglones de pedidos
--realizados por cada cliente.

select max(cantidad * precio_unitario), min (cantidad * precio_unitario), avg (cantidad * precio_unitario)
from renglones_pdo
								

--16) Ídem anterior pero de cada vendedor. Ordenar la consulta por vendedor en forma descendente. 

select max(cantidad * precio_unitario), min (cantidad * precio_unitario), avg (cantidad * precio_unitario)
from renglones_pdo rp join pedidos p on rp.id_pedido = p.id_pedido
join vendedores v on p.id_vend = v.id_vend
group by p.id_vend, v.id_vend
order by v.id_vend

-- 17) Mostrar el importe total de los renglones de pedidos, para aquellos pedidos en donde la suma
-- de los renglones supere los $ 800.

select id_pedido, sum(cantidad * precio_unitario) as importe
from renglones_pdo
group by id_pedido
having sum(cantidad * precio_unitario) > 800
order by importe desc

--18) Mostrar el cargo, la oficina y el total de ventas efectuadas por los vendedores que no son
--Senior, clasificados por cargo y oficina de ventas. Ordenar la consulta en forma decreciente por ventas.

select v.cargo, o.nombre, v.ventas
from vendedores v join oficinas_vtas o on v.id_oficina = o.id_oficina
where v.cargo not like '%Senior%' 
order by v.ventas desc

--19) Mostrar el monto total promedio de todos los pedidos, para los clientes que realizaron más de
--2 pedidos.
select avg(total)
from pedidos as p join

(select c.id_cliente
from pedidos p join clientes c on p.id_cliente = c.id_cliente
group by c.id_cliente
having count(id_pedido) > 2) as tabla_pedidos

on p.id_cliente = tabla_pedidos.id_cliente

--20) Ídem anterior pero para los clientes que realizaron 2 pedidos o menos. 
select avg(total)
from pedidos as p join

(select c.id_cliente
from pedidos p join clientes c on p.id_cliente = c.id_cliente
group by c.id_cliente
having count(id_pedido) < 2) as tabla_pedidos

on p.id_cliente = tabla_pedidos.id_cliente
