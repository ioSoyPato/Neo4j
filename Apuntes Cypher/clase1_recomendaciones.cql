:play Northwind


LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/products.csv" AS row
CREATE (n:Product)
SET n = row,
n.unitPrice = toFloat(row.unitPrice),
n.unitsInStock = toInteger(row.unitsInStock), n.unitsOnOrder = toInteger(row.unitsOnOrder),
n.reorderLevel = toInteger(row.reorderLevel), n.discontinued = (row.discontinued <> "0")


LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/categories.csv" AS row
CREATE (n:Category)
SET n = row

LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/suppliers.csv" AS row
CREATE (n:Supplier)
SET n = row

MATCH (p:Product),(c:Category)
WHERE p.categoryID = c.categoryID
CREATE (p)-[:PART_OF]->(c)

MATCH (p:Product),(s:Supplier)
WHERE p.supplierID = s.supplierID
CREATE (s)-[:SUPPLIES]->(p)

LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/customers.csv" AS row
CREATE (n:Customer)
SET n = row

LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/orders.csv" AS row
CREATE (n:Order)
SET n = row

CREATE INDEX FOR (n:Customer) ON (n.customerID)

CREATE INDEX FOR (o:Order) ON (o.orderID)

MATCH (c:Customer),(o:Order)
WHERE c.customerID = o.customerID
CREATE (c)-[:PURCHASED]->(o)

LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/order-details.csv" AS row
MATCH (p:Product), (o:Order)
WHERE p.productID = row.productID AND o.orderID = row.orderID
CREATE (o)-[details:ORDERS]->(p)
SET details = row,
details.quantity = toInteger(row.quantity)

MATCH (cust:Customer)-[:PURCHASED]->(:Order)-[o:ORDERS]->(p:Product),
  (p)-[:PART_OF]->(c:Category {categoryName:"Produce"})
RETURN DISTINCT cust.contactName as CustomerName, SUM(o.quantity) AS TotalProductsPurchased

//orden 10575
MATCH(o:Order)-[r:ORDERS]->(op:Product) WHERE o.orderID = "10575" RETURN o,r,op 

// Chai
MATCH(p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)
WHERE p.productName = 'Chai'
RETURN p.productName, op.productName, COUNT(o.orderID) as Tickets
ORDER BY Tickets DESC
LIMIT 3

//Limitar a que regrese recomendaciones de la misma categoría

MATCH(p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)
WHERE p.productName = 'Chai' AND op.categoryID = p.categoryID
RETURN p.productName, op.productName, COUNT(o.orderID) as Tickets
ORDER BY Tickets DESC
LIMIT 3

// Mas detalles del mismo query
MATCH (cat1:Category)<-[:PART_OF]-(p:Product{productName:"Mozzarella di Giovanni"})<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)-[:PART_OF]->(cat2:Category)
WHERE op<>p AND (op)-[:PART_OF]->(cat1)
RETURN
cat1.categoryName, p.productName, op.productName, cat2.categoryName, COUNT(o.orderID)
ORDER BY COUNT(o.orderID) DESC
LIMIT 5


// Que sean del mimso supplier
MATCH (s1:Supplier)-[:SUPPLIES]->(p:Product{productName:"Chai"})<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)<-[:SUPPLIES]-(s2:Supplier)
WHERE op<>p AND (op)<-[:SUPPLIES]-(s1)
RETURN s1.companyName, p.productName, op.productName, s2.companyName, COUNT(o.orderID)
ORDER BY COUNT(o.orderID) DESC
LIMIT 5


// dado el supplier
MATCH (s:Supplier{companyName: "Exotic Liquids"})-[:SUPPLIES]->(p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)<-[:SUPPLIES]-(s2:Supplier)
WHERE op<>p AND (op)<-[:SUPPLIES]-(s1)
RETURN s1.companyName, p.productName, op.productName, s2.companyName, COUNT(o.orderID)
ORDER BY COUNT(o.orderID) DESC
LIMIT 5

//
MATCH (c:Customer)-[:PURCHASED]->(o:Order{orderID: "10248"})-[:ORDERS]->(p:Product{})<-[:ORDERS]-(op:Product)
WHERE op<>p AND (op)-[:ORDERS]



MATCH (c:Customer {customerID: "ALFKI"})-[:PURCHASED]->(o1:Order)-[:ORDERS]->(p:Product)
MATCH (p)-[:PART_OF]->(:Category)<-[:PART_OF]-(similarProduct:Product)
MATCH (similarProduct)<-[:ORDERS]-(similarOrder:Order)<-[:PURCHASED]-(similarCust:Customer)
WHERE similarCust.customerID <> c.customerID 
AND NOT EXISTS {  // que no estén ya comprados
    MATCH (c)-[:PURCHASED]->(:Order)-[:ORDERS]->(p2:Product)
    WHERE p2 = similarProduct
}
RETURN DISTINCT similarProduct.productName AS RecommendedProduct

//Construir la relacion de producto con producto
MATCH (p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)
WITH p, op, COUNT(o.orderID) as qty
MERGE (p)-[:BOUGHT_TOGETHER{quantity:qty}]->(op)


//Ahora podemos añadir comunidad
//PAGE_RANK
Call gds.graph.project(
    "Grafito",
    "Product",
    "BOUGHT_TOGETHER",
    {relationshipProperties:toInteger('quantity')}
)

CALL gds.pageRank.stream('Grafito')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Id as Name, score
ORDER BY score DESC, Name ASC

//write 
CALL gds.pageRank.write(
    'Grafito',
    {
        maxIterations: 20,
        dampingFactor: 0.85,
        writeProperty: 'pageRank'
    }
)
YIELD nodePropertiesWritten, ranIterations


