-- 1) Mostrar la información de los renglones de los pedidos con identificador 110 o superior,
-- cuyos precios unitarios son mayores al del producto “Chocolate Garoto con Nougat”. Ordenar
-- la consulta por precio unitario y producto.

select * 
from renglones_pdo
where precio_unitario >

(select p.precio_unitario
 from productos p 
 join renglones_pdo as rp
 on p.id_producto=rp.id_producto
 where p.descripcion like 'Chocolate Garoto con Nougat' and rp.id_pedido > 110
 limit 1) 

--2) Mostrar apellidos y nombres de los clientes que se relacionan con la empresa a través de la
--oficina de “Santa Fe”.
-- todos los pedidos que esten en esta oficina de ventas y despues el cliente que haya hecho cada pedido
--usar subconsultas

select * from 
		(select * from
		(select c.id_vend, v.id_oficina from clientes c
		join vendedores v
			on c.id_vend = v.id_vend ) as t1
			join oficinas_vtas ov on
			t1.id_oficina = ov.id_oficina ) as t2
join localidades l 
on l.cod_post = t2.cod_post
where l.nombre like 'SANTA FE' 


--3) Mostrar todos los pedidos para los cuales el total de los renglones de pedido supere al total de
--los renglones del pedido número 113.

select id_pedido from renglones_pdo
where id_renglon >
	(select count(id_renglon)
	from renglones_pdo
	where id_pedido=113)
group by id_pedido

--4) Mostrar el cargo que tiene, en promedio, el monto más bajo de ventas.

select cargo, avg(ventas)
from vendedores
where ventas is not null
group by cargo 
order by avg(ventas)
limit 1 

--5) Mostrar el apellido y nombre de los vendedores cuyo cargo tiene, en promedio, el monto más bajo de ventas.

select nombres, apellidos from vendedores
where cargo =
 (select cargo
	from vendedores
	where ventas is not null
	group by cargo 
	order by avg(ventas)
	limit 1)

--6) Mostrar el apellido de los clientes a los cuales se les han entregado (cumplido) todos sus pedidos.

select c.apellidos
from clientes c join pedidos p
on c.id_cliente = p.id_cliente
where p.pedido_cumplido = 'V'
group by c.apellidos

--7) Realizar las siguientes consultas:
--a) Mostrar el identificador y nombre de las oficinas que tienen en stock todos los productos.
--b) Haga lo mismo pero utilizando la cláusula NOT EXISTS.

select ov.id_oficina, ov.nombre from oficinas_vtas ov
join stock_local sl on
ov.id_oficina =sl.id_oficina
where sl.stock>0
group by ov.nombre, ov.id_oficina

select ov.id_oficina, ov.nombre from oficinas_vtas ov
join stock_local sl on
ov.id_oficina =sl.id_oficina
where not exists
(
select sl.id_producto from stock_local sl join productos as prod
	on sl.id_producto = prod.id_producto
)
group by ov.nombre, ov.id_oficina


--8) Mostrar, para cada oficina de ventas, su nombre, los apellidos de los clientes que realizaron
--pedidos en ella y la cantidad de pedidos efectuados por cada uno de ellos, siempre que esta
--cantidad sea mayor a 1 y los clientes vivan en la localidad de “ROSARIO”.



--9) Mostrar la identificación del cliente, su apellido, domicilio, código postal, y el nombre de la
--oficina donde realiza sus pedidos, de todos los clientes que vivan en la provincia de “SANTA
--FE”, o estén asignados a un vendedor de la oficina de Misiones. Ordenar la consulta por apellido del cliente.



--10) Mostrar el Id_producto, la descripción y precio unitario del producto que fue pedido por todos los clientes.



--11) Mostrar Id_producto, la descripción y el nombre del proveedor de los productos que no fueron
--pedidos por ningún cliente.



--12) Hacer un ranking de los productos (del menos pedido al más pedido): 
--a) en cantidad, 
--b) en monto. 
--Mostrar Id_producto, descripción, nombre del proveedor.
--Hágalo de dos formas:
--c) Con una sola consulta SQL
--d) Genere una vista y luego úsela en la consulta

