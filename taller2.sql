--1.
USE AdventureWorks
GO

Select t1.*, t2.PurchaseOrderID
from HumanResources.Employee as t1 left join Purchasing.PurchaseOrderHeader as t2 on t1.BusinessEntityID = t2.EmployeeID
GO

SELECT t1.Name, t2.Name 
from Production.Product as t1 right join Production.ProductModel as t2 on t1.ProductModelID=t2.ProductModelID
GO

Select t1.ProductID
from Production.Product as t1 left join Production.ProductCostHistory as t2 on t1.ProductID=t2.ProductID

where t2.ProductID is null
GO

USE Norte
GO

SELECT t1.IdPedido, sum(t1.cantidad) as cantidad,t2.FPedido,t3.Nombre

from dbo.Pedidos_Detalles as t1 left join dbo.Pedidos as t2 on t1.IdPedido=t2.IdPedido left join dbo.Productos as t3 on t1.IdProducto=t3.IdProducto

group by t1.IdPedido,t2.FPedido,t3.Nombre having sum(t1.cantidad)>10

GO

Select top 5 t1.IdPedido,sum(t1.PrecioUnd*t1.Cantidad*(1-t1.Descuento)),t2.FPedido
from dbo.Pedidos_Detalles as t1 inner join dbo.Pedidos as t2 on t1.IdPedido=t2.IdPedido
where year(t2.FPedido)='1998'
group by t1.IdPedido,t2.FPedido
order by 3 ASC

with s as(Select distinct t2.IdProducto from dbo.Pedidos as t1 inner join dbo.Pedidos_Detalles as t2 on t1.IdPedido=t2.IdPedido 
where year(t1.FPedido) = 1997)
select t1.IdProducto,t1.Nombre
from dbo.Productos as t1 left join s as t2 on t1.IdProducto=t2.IdProducto where t1.IdProducto is null



--8. Algun cliente no realizo compras en el año 1997
with Ventas as
(Select distinct P.IdCliente from dbo.Pedidos P where year(P.FPedido)=1997
)

Select c.* from dbo.Clientes C left join Ventas V on C.IdCliente=V.IdCliente
where V.IdCliente is null
