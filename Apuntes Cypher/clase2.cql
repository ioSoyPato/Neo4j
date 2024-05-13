// NETFLIX_DB

//Crear nodos tipo profile
CREATE (p:Profile{id:1, name:"Juan"})
RETURN p
//Crear nueva lista de favoritos del profile 1

MATCH (p:Profile{id:1}), (m:Movie{id:'s8769'})
MERGE (p)-[:ADD]->(m)

MATCH (p:Profile{id:1}), (m:Movie{id:'s626'})
MERGE (p)-[:ADD]->(m)

MATCH (p:Profile{id:1}), (m:Movie{id:'s2418'})
MERGE (p)-[:ADD]->(m)

//Crear más perfiles

//Ejecuto uno linea por linea
MATCH(p:Profile{id:2})
MATCH(p:Profile{id:3})
MATCH(p:Profile{id:4})
MATCH(p:Profile{id:5})

//Ejecuto todos en una sola linea
CREATE
(:Profile{id:6}),
(:Profile{id:7}),
(:Profile{id:8}),
(:Profile{id:9})

//Crear nuevas relaciones

// Cinco nuevas relaciones ADD


MATCH (m:Movie)<-[:ADD]-(p:Profile)-[:ORDERS]->(om:Movie)
WITH m, om, COUNT(p.Profile) as qty
MERGE (p)-[:ADD{quantity:qty}]->(op)