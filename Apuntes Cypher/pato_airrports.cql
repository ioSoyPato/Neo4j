//loading nodes
LOAD CSV WITH HEADERS FROM "file://enlacesOpenFlight.csv" AS row
WITH row
CREATE (n:Airport {
    Id: row.Id,
    Label: row.Label,
    Country: row.country,
    Latitude: row.latitude,
    Longitude: row.longitude
})

//loading relationships
LOAD CSV WITH HEADERS FROM "file://enlacesOpenFlight.csv" AS row
MATCH (n:Airport), (m:Airport)
WHERE n.Id = toInteger(row.Source) AND m.Id = toInteger(row.Target)
MERGE (n)-[:CONNECTED_TO]->(m)