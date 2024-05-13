//Articulo
LOAD CSV FROM "file:///Articulo.csv" AS row
WITH row
CREATE (n:Articulo {
    Clave: row[0], 
    Descripcion: row[1],
    ArticuloTipo: row[2],
    ArticuloGrupo: row[3],
    ArticuloClase: row[4],
    Almacenable: row[5],
    Identificacion: row[6],
    UMedniv: row[7],
    UMedVta: row[8],
    UMedCpa: row[9],
    Moneda: row[10],
    Precio: row[11],
    pctDescuento: row[12],
    UbicacionAlmacen: row[13],
    UbicacionClave: row[14]
})

//ArticuloClase
LOAD CSV FROM "file:///ArticuloClase.csv" AS row
WITH row
CREATE (n:ArticuloClase {
    Clave: row[0], 
    Descripcion: row[1]
})


//ArticuloGrupo
LOAD CSV FROM "file:///ArticuloGrupo.csv" AS row
WITH row
CREATE (n:ArticuloGrupo {
    Clave: row[0], 
    Descripcion: row[1]
})


//ArticuloTipo
LOAD CSV FROM "file:///ArticuloTipo.csv" AS row
WITH row
CREATE (n:ArticuloTipo {
    Clave: row[0], 
    Descripcion: row[1]
})

//Cliente

LOAD CSV FROM "file:///Cliente.csv" AS row
WITH row
CREATE (n:Cliente {
    Clave: row[0],
    RazónSocial: row[1],
    CalleNumero: row[2],
    Colonia: row[3],
    Ciudad: row[4],
    Estado: row[5],
    Pais: row[6],
    CodigoPostal: row[7],
    ClienteTipo: row[8],
    ClienteGrupo: row[9],
    Vendedor: row[10],
    Moneda: row[11],
    CondicionPago: row[12],
    ZonaVenta: row[13]
})


//CondicionPago
LOAD CSV FROM "file:///CondicionPago.csv" AS row
WITH row
CREATE (n:CondicionPago {
    Clave: row[0], 
    Descripcion: row[1]
})



//FacturaDetalle
LOAD CSV WITH HEADERS FROM "file:///FacturaDetalle0.csv" AS row
WITH row
CREATE (n:FacturaDetalle {
    Empresa: row.Empresa,
    Folio: row.Folio,
    Partida: row.Partida,
    Articulo: row.Articulo,
    DescripcionArticulo: row.DescripcionArticulo,
    Cantidad: toFloat(row.Cantidad),
    UMedPartida: row.UMedPartida,
    CantidadUMedinv: toFloat(row.CantidadUMedinv),
    Precio: toFloat(row.Precio),
    pctDescuento: toFloat(row.pctDescuento),
    pctImpuesto: toFloat(row.pctImpuesto),
    TotalImporte: toFloat(row.TotalImporte),
    TotalDescuento: toFloat(row.TotalDescuento),
    TotalImpuesto: toFloat(row.TotalImpuesto),
    Total: toFloat(row.Total),
    Almacen: row.Almacen
})

RETURN n



//FacturaEncabezado
LOAD CSV FROM "file:///FacturaEncabezado.csv" AS row
WITH row
CREATE (n:FacturaEncabezado {
    Empresa: row[0],
    Folio: row[1],
    Fecha: row[2],
    Cliente: row[3],
    Moneda: row[4],
    CondicionPago: row[5],
    MedioEmbarque: row[6],
    Vendedor: row[7],
    pctDescuentoGlobal: row[8],
    RacIVA: row[9],
    TotalImporte: row[10],
    TotalDescuento: row[11],
    TotalRetencion: row[12],
    Total: row[13]
})

//MedioEmbarque
LOAD CSV FROM "file:///MedioEmbarque.csv" AS row
WITH row
CREATE (n:MedioEmbarque {
    Clave: row[0], 
    Descripcion: row[1]
})

//Moneda
LOAD CSV FROM "file:///Moneda.csv" AS row
WITH row
CREATE (n:Moneda {
    Clave: row[0], 
    Descripcion: row[1],
    Tipo: row[2]
})

//Vendedor
LOAD CSV FROM "file:///Vendedor.csv" AS row
WITH row
CREATE (n:Vendedor {
    Clave: row[0], 
    Nombre: row[1]
})



//RELACIONES-------------------------------------------------------------------------------
// Relaciones de Articulo
MATCH (ac:ArticuloClase), (a:Articulo)
WHERE a.ArticuloClase = ac.Clave
CREATE (ac)-[:POSEE]->(a)
RETURN ac, a

MATCH (ag:ArticuloGrupo), (a:Articulo)
WHERE a.ArticuloGrupo = ag.Clave

LOAD CSV FROM "file:///Cliente.csv" AS row
WITH row
CREATE (n:Cliente {
    Clave: row[0],
    RazónSocial: row[1],
    CalleNumero: row[2],
    Colonia: row[3],
    Ciudad: row[4],
    Estado: row[5],
    Pais: row[6],
    CodigoPostal: row[7],
    ClienteTipo: row[8],
    ClienteGrupo: row[9],
    Vendedor: row[10],
    Moneda: row[11],
    CondicionPago: row[12],
    ZonaVenta: row[13]
})


//CondicionPago
LOAD CSV FROM "file:///CondicionPago.csv" AS row
WITH row
CREATE (n:CondicionPago {
    Clave: row[0], 
    Descripcion: row[1]
})



//FacturaDetalle
LOAD CSV WITH HEADERS FROM "file:///FacturaDetalle0.csv" AS row
WITH row
CREATE (n:FacturaDetalle {
    Empresa: row.Empresa,
    Folio: row.Folio,
    Partida: row.Partida,
    Articulo: row.Articulo,
    DescripcionArticulo: row.DescripcionArticulo,
    Cantidad: toFloat(row.Cantidad),
    UMedPartida: row.UMedPartida,
    CantidadUMedinv: toFloat(row.CantidadUMedinv),
    Precio: toFloat(row.Precio),
    pctDescuento: toFloat(row.pctDescuento),
    pctImpuesto: toFloat(row.pctImpuesto),
    TotalImporte: toFloat(row.TotalImporte),
    TotalDescuento: toFloat(row.TotalDescuento),
    TotalImpuesto: toFloat(row.TotalImpuesto),
    Total: toFloat(row.Total),
    Almacen: row.Almacen
})

RETURN n



//FacturaEncabezado
LOAD CSV FROM "file:///FacturaEncabezado.csv" AS row
WITH row
CREATE (n:FacturaEncabezado {
    Empresa: row[0],
    Folio: row[1],
    Fecha: row[2],
    Cliente: row[3],
    Moneda: row[4],
    CondicionPago: row[5],
    MedioEmbarque: row[6],
    Vendedor: row[7],
    pctDescuentoGlobal: row[8],
    RacIVA: row[9],
    TotalImporte: row[10],
    TotalDescuento: row[11],
    TotalRetencion: row[12],
    Total: row[13]
})

//MedioEmbarque
LOAD CSV FROM "file:///MedioEmbarque.csv" AS row
WITH row
CREATE (n:MedioEmbarque {
    Clave: row[0], 
    Descripcion: row[1]
})

//Moneda
LOAD CSV FROM "file:///Moneda.csv" AS row
WITH row
CREATE (n:Moneda {
    Clave: row[0], 
    Descripcion: row[1],
    Tipo: row[2]
})

//Vendedor
LOAD CSV FROM "file:///Vendedor.csv" AS row
WITH row
CREATE (n:Vendedor {
    Clave: row[0], 
    Nombre: row[1]
})



//RELACIONES-------------------------------------------------------------------------------
// Relaciones de Articulo
MATCH (ac:ArticuloClase), (a:Articulo)
WHERE a.ArticuloClase = ac.Clave
CREATE (ac)-[:POSEE]->(a)
RETURN ac, a

MATCH (ag:ArticuloGrupo), (a:Articulo)
WHERE a.ArticuloGrupo = ag.Clave
CREATE (ag)-[:INCLUYE]->(a)
RETURN ag, a

MATCH (at:ArticuloTipo), (a:Articulo)
WHERE a.ArticuloTipo = at.Clave
CREATE (at)-[:CATEGORIZA]->(a)
RETURN at, a

MATCH (m:Moneda), (a:Articulo)
WHERE a.Moneda = m.Clave
CREATE (m)-[:SE_UTILIZA_PARA_PAGO_DE]->(a)
RETURN m, a

// Relaciones de Cliente
MATCH (m:Moneda), (c:Cliente)
WHERE c.Moneda = m.Clave
CREATE (m)-[:MONEDA_PREFERIDA_DE]->(c)
RETURN m, c

MATCH (cp:CondicionPago), (c:Cliente)
WHERE c.CondicionPago = cp.Clave
CREATE (cp)-[:APLICA_A]->(c)
RETURN cp, c

MATCH (v:Vendedor), (c:Cliente)
WHERE c.Vendedor = v.Clave
CREATE (v)-[:ATIENDE_A]->(c)
RETURN v, c

// Relaciones de FacturaDetalle
MATCH (fe:FacturaEncabezado), (fd:FacturaDetalle)
WHERE fd.Folio = fe.Folio
CREATE (fe)-[:PERTENECE_A_FACTURA]->(fd)
RETURN fe, fd

CALL apoc.periodic.iterate(
  "MATCH (fe:FacturaEncabezado), (fd:FacturaDetalle)
   WHERE fd.Folio = fe.Folio
   RETURN fe, fd",
  "CREATE (fe)-[:PERTENECE_A_FACTURA]->(fd)",
  { batchSize: 1000, parallel: true }
)

MATCH (a:Articulo), (fd:FacturaDetalle)
WHERE fd.Articulo = a.Clave
CREATE (a)-[:SE_ENCUENTRA_EN_FACTURA]->(fd)
RETURN a, fd

CALL apoc.periodic.iterate(
  "MATCH (a:Articulo), (fd:FacturaDetalle)
   WHERE fd.Articulo = a.Clave
   RETURN a, fd",
  "CREATE (a)-[:SE_ENCUENTRA_EN_FACTURA]->(fd)",
  { batchSize: 1000, parallel: true }
)

// Relaciones de FacturaEncabezado
MATCH (m:Moneda), (fe:FacturaEncabezado)
WHERE fe.Moneda = m.Clave
CREATE (m)-[:SE_UTILIZA_PARA_PAGO_DE]->(fe)
RETURN m, fe

MATCH (cp:CondicionPago), (fe:FacturaEncabezado)
WHERE fe.CondicionPago = cp.Clave
CREATE (cp)-[:APLICADA_A]->(fe)
RETURN cp, fe

MATCH (c:Cliente), (fe:FacturaEncabezado)
WHERE fe.Cliente = c.Clave
CREATE (c)-[:EMITIO]->(fe)
RETURN c, fe

MATCH (v:Vendedor), (fe:FacturaEncabezado)
WHERE fe.Vendedor = v.Clave
CREATE (v)-[:ATENDIO]->(fe)
RETURN v, fe

MATCH (me:MedioEmbarque), (fe:FacturaEncabezado)
WHERE fe.MedioEmbarque = me.Clave
CREATE (me)-[:UTILIZADO_PARA_ENVIO_DE]->(fe)
RETURN me, fe

// Relaciones de Articulo con contador de transacciones
MATCH (a1:Articulo)-[:SE_ENCUENTRA_EN_FACTURA]->(fd1:FacturaDetalle)<-[:PERTENECE_A_FACTURA]-(fe:FacturaEncabezado)-[:PERTENECE_A_FACTURA]->(fd2:FacturaDetalle)<-[:SE_ENCUENTRA_EN_FACTURA]-(a2:Articulo)
WITH a1, a2, fd1, fd2, COUNT(fe.Folio) as cantidad
MERGE (a2)-[:CUENTA_TRANSACCION {Cantidad:cantidad}]->(a1)

CALL apoc.periodic.iterate(
  "MATCH (a1:Articulo)-[:SE_ENCUENTRA_EN_FACTURA]->(fd1:FacturaDetalle)<-[:PERTENECE_A_FACTURA]-(fe:FacturaEncabezado)-[:PERTENECE_A_FACTURA]->(fd2:FacturaDetalle)<-[:SE_ENCUENTRA_EN_FACTURA]-(a2:Articulo)
   WITH a1, a2, fd1, fd2, COUNT(fe.Folio) as cantidad
   RETURN a1, a2, cantidad",
  "MERGE (a2)-[:CUENTA_TRANSACCION {Cantidad:cantidad}]->(a1)",
  { batchSize: 1000, parallel: true }
)


// Relaciones de Articulo con contador de unidades compradas
MATCH (a1:Articulo)-[:SE_ENCUENTRA_EN_FACTURA]->(fd1:FacturaDetalle)<-[:PERTENECE_A_FACTURA]-(fe:FacturaEncabezado)-[:PERTENECE_A_FACTURA]->(fd2:FacturaDetalle)<-[:SE_ENCUENTRA_EN_FACTURA]-(a2:Articulo)
WITH a1, a2, SUM(fd1.Cantidad) as totalUnidades
MATCH (a1)<-[r:CUENTA_TRANSACCION]-(a2)
SET r.Unidades_Compradas = totalUnidades

CALL apoc.periodic.iterate(
    "MATCH (a1:Articulo)-[:SE_ENCUENTRA_EN_FACTURA]->(fd1:FacturaDetalle)<-[:PERTENECE_A_FACTURA]-(fe:FacturaEncabezado)-[:PERTENECE_A_FACTURA]->(fd2:FacturaDetalle)<-[:SE_ENCUENTRA_EN_FACTURA]-(a2:Articulo)
    WITH a1, a2, SUM(toInteger(fd1.Cantidad)) as totalUnidades
    MATCH (a1)<-[r:CUENTA_TRANSACCION]-(a2)
    RETURN r, totalUnidades",
    "SET r.Unidades_Compradas = totalUnidades",
    { batchSize: 1000, parallel: true }
)





