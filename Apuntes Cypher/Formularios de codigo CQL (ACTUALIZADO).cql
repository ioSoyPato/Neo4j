Prueba
Dataprueba1
//Limpia la pantalla
:clear


Representación de los grafos
//Nodos
()
:Producto (label, es un nodo)
:producto (nodo diferente porque es sensible a mayúsculas)
:produCTO
(:Producto) //nodo tipo producto


//Relaciones
--
--> <-- //dirigidas
-[:BUSCO]-> //relación tipo busco
-[:busco]-> //diferente por las mayúsculas 

//Atributo
{}
{nombre:'Juan'} 
{NOMBRE: 'Pedro'}
(:Estudiante{nombre:'Luis'}) // nodo tipo estudiante con relación Luis 
(:Estudiante{nombre:'Luis'})-[:AMIGO]->(:Estudiante{nombre:'Lupita'})
//Estudiante Nombre:luis


//SQL   //QUERYS EN CYPHER
SELECT  RETURN      MATCH
FROM    MATCH       WHERE
WHERE   WHERE       RETURN

//crear nodos CREATE
CREATE create Create //es lo mismo
CREATE (:Estudiante)
CREATE (:Profesor)

CREATE (p:Profesor)
RETURN p //crear variable p

CREATE (e:Estudiante{nombre:'Luis'}) RETURN e //nodo tipo Luis 

CREATE
(e:Estudiante{nombre:'Gabriel'})-[r:AMIGO]->(oe:Estudiante{nombre:'Lupita'})
RETURN e,r,oe

MATCH (p:Profesor) RETURN p //regresa nodos tipo profesor 
MATCH (e:Estudiante) RETURN e.nombre

//contar número de estudiantes
SELECT COUNT(idEstudiante) FROM Estudiante //SQL
MATCH (e:Estudiante) RETURN COUNT(e) AS NumEstudiantes //alias numestudiantes

//
CREATE
(c:Computadora{nombre:'hp'})-[re:tiene]->(t:Computadora{nombre:'Lovitek'})
RETURN c,re,t

//ESTUDIANTE DUEÑO DE ESTA COMPU
CREATE
(e:Estudiante{nombre:'Gabriel'})-[r:Es_dueño]->(c:Computadora{nombre:'hp'})-[et:tiene]->(t:Computadora{nombre:'Lovitek'})
RETURN e,r,c,et,t


//CLASE 2//////////
:play movies
//ESQUEMA DEL GRAFO
call db.schema.vi

//CONTAR NODOS
MATCH (m:Movie)
RETURN COUNT (m)

//CONTAR LAS RELACIONES (FOLLOWS,ACTED_IN,REVIEWED,PRODUCED,WROTE,DIRECTED)
MATCH(p:Person)-[r:FOLLOWS]->()
RETURN COUNT(r)

//SUMAR LAS RELACIONES
RETURN 172+9+15+10+44+3

//Muestra las etiquetas
//person y movie
call db.labels

//relaciones
call db.relationshipTypes

//atributos
call db.propertyKeys

//nodos y atributos en una tabla
call db.schema.nodeTypeProperties

//relaciones y atributos
call db.schema.relTypeProperties

//info de la base de datos
:sysinfo
call dbms.info
call dbms.components //version
call dbms.showCurrentUser

//nodo,atributo,relación
//sale el nodo
MATCH(p:Person{name:'Tom Hanks'})-[r:ACTED_IN]->(m:Movie)
RETURN p,r,m

//sale como tabla, renombrar la columna
MATCH(p:Person{name:'Tom Hanks'})-[r:ACTED_IN]->(m:Movie)
RETURN p.name AS Name_Actor, m.title AS Movie_name

MATCH(p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN p,r,m

//cuantas peliculas
MATCH(p:Person{name:'Tom Hanks'})-[r:ACTED_IN]->(m:Movie)
RETURN p.name, COUNT(r) AS Numpeliculas

//COLLECT función de agregación, todos los elementos como una lista 
MATCH(p:Person{name:'Tom Hanks'})-[r:ACTED_IN]->(m:Movie)
RETURN p.name, COUNT(r) AS Numpeliculas, COLLECT (m.title)

//ORDEN
MATCH(p:Person{name:'Tom Hanks'})-[r:ACTED_IN]->(m:Movie)
RETURN p.name, COUNT(r) AS Numpeliculas,
COLLECT (m.title)
ORDER BY 

//todas las personas que hicieron una REVIEWED de una pelicula
//nombre de la persona y el numero de REVIEWED que hizo
MATCH(p:Person)-[r:REVIEWED]->(m:Movie)
RETURN p.name , COUNT(r), COLLECT (m.title)

//dado un actor Keanu Reeves mostrar las peliculas y los actores que han coincidido grafo
//actor peliculas actores
MATCH(p:Person{name:'Keanu Reeves'})-[r:ACTED_IN]->(m:Movie)<-[re:ACTED_IN]-(op:Person)
RETURN p,r,m, re, op

MATCH(p:Person{name:'Keanu Reeves'})-[r:ACTED_IN]->(m:Movie)<-[re:ACTED_IN]-(op:Person)
RETURN p.name,m.title, COLLECT(op.name)

//grafo muestre personas REVIEWED o WROTE una pelicula 
MATCH(p:Person)-[r:REVIEWED | WROTE]->(m:Movie)
RETURN p,r,m


//muestre el grafo keanu reeves a un salto, dos saltos, tres saltos
//Hubo que castear
MATCH saltos = (p:Person {name: "Keanu Reeves"})-[*2]-(arround)
RETURN saltos



//CLASE 3
MATCH(p:Person{name:'Keanu Reeves'})-[r]->(m)//NO IMPORTA LA DIRECCIÓN NI EL TIPO DE NODO
RETURN p,r,m








//Clase del 25 de enero 
 MATCH (p:Person{name:'Keanu Reeves'})-[r:ACTED_IN]->(m:Movie)
 RETURN p, r, m

 MATCH (p:Person{name:'Keanu Reeves'})-[r]-(m)
 RETURN p, r, m

 //Un salto
 MATCH (p:Person{name:'Keanu Reeves'})-[*1..1]-(m)
 RETURN p, m
 MATCH (p:Person{name:'Keanu Reeves'})-[*1]-(m)
 RETURN p, m

 //Dos saltos
 //Muestra todos los nodos 
 MATCH (p:Person{name:'Keanu Reeves'})-[*1..2]-(m)
 RETURN p, m
//Muestra los nodos alcanzables a dos altos 
 MATCH (p:Person{name:'Keanu Reeves'})-[*2]-(m)
 RETURN p, m

 MATCH (p:Person{name:'Keanu Reeves'})-[*1..2]-(m)
 RETURN p, COUNT (m) //da 45/

 MATCH (p:Person{name:'Keanu Reeves'})-[*2]-(m)
 RETURN p.name, COUNT(m)//da 38//

 MATCH (p:Person{name:'Keanu Reeves'})-[*2]-(m)
 RETURN p.name, COUNT(distinct m)//24 nodos finales

 MATCH (p:Person{name:'Keanu Reeves'})-[*1..2]-(m)
 RETURN p.name, COUNT(distinct m)//31 nodos finales

 MATCH (p:Person{name:'Keanu Reeves'})-[*1..3]-(m)
 RETURN p.name, COUNT(distinct m)//45 nodos finales 

 MATCH (p:Person{name:'Keanu Reeves'})-[*3]-(m)
 RETURN p.name, COUNT(distinct m)


 MATCH (p:Person{name:'Tom Hanks'})-[*1]-(m)
 RETURN p.name, COUNT(distinct m)


 MATCH (p:Person{name:'Tom Cruise'})-[*1]-(m)
 RETURN p.name, COUNT(distinct m)


// Solo las preguntas
// Ayuda con Cypher
// -1. Hola Mundo
// 0. Todas las personas que hicieron review a una película. Mostrar el
//grado con las personas, relaciones y películas.
MATCH(p:Person)-[r:REVIEWED]->(m:Movie)
RETURN p, r, m


// 1. Dado Keanu Reeves, mostrar los actores que han compartido películas
//con él. Mostrar el grafo.
MATCH(p:Person{name:'Keanu Reeves'})-[r:ACTED_IN]->(m:Movie)<-[re:ACTED_IN]-(op:Person)
RETURN p,r,m,re,op

// 2. Dado Keanu Reeves, mostrar los actores que han compartido películas
// con él. Mostrar como tabla los resultados
MATCH(p:Person{name:'Keanu Reeves'})-[r:ACTED_IN]->(m:Movie)<-[re:ACTED_IN]-(op:Person)
RETURN p.name,m.title, COLLECT(op.name)

// 3. Grafo que muestre las personas que REVIEW or WROTE una película
MATCH(p:Person)-[r:REVIEWED | WROTE]->(m:Movie)
RETURN p,r,m

// 4. Grafo que muestre las personas que REVIEW or WROTE una película con
//released <2001
MATCH(p:Person)-[r:REVIEWED | WROTE]->(m:Movie)
WHERE m.released < 2001
RETURN p,r,m


// 5. Grafo que muestre las personas que REVIEW or WROTE una película con
//released <2001 y no sea Top Gun
MATCH(p:Person)-[r:REVIEWED | WROTE]->(m:Movie)
WHERE m.released < 2001 and m.title <> 'Top Gun'
RETURN p,r,m

// 6. Grafo de los actores actuaron en la misma película que Keanu Reeves
//y su lista de películas ()
MATCH(p:Person{name:'Keanu Reeves'})-[r:ACTED_IN]->(m:Movie)<-[re:ACTED_IN]-(op:Person)
RETURN name, COLLECT(m.title)

// 7. Tabla de los actores actuaron en la misma película que Keanu Reeves
//y su lista de películas. Mostrar los nombres de las películas como
//colección
MATCH(p:Person{name:'Keanu Reeves'})-[r:ACTED_IN]->(m:Movie)<-[re:ACTED_IN]-(op:Person)
RETURN p.name, COLLECT(m.title)

// 8. Tabla de los actores actuaron en la misma película que Keanu Reeves
//y su lista de películas. Contar las películas
MATCH(p:Person{name:'Keanu Reeves'})-[r:ACTED_IN]->(m:Movie)<-[re:ACTED_IN]-(op:Person)
RETURN p.name,COUNT(r) AS Numpeliculas, COLLECT(m.title)


// 9. Todas las películas que contengan la palabra Matrix en el título
MATCH(m:Movie) WHERE m.title = '.*Matrix*.'
RETURN m.title
CONTAINS
// 10. Todas las películas que contengan la palabra All o all en el título

// 11. Nombre de las personas que nacieron en 1964, 1965 y 1967. Mostrar
los años y los nombres de las personas como colección.
// 12. Muestra todas las personas, opcionalmente a las que hicieron un
review. Primero deben aparecer las que hicieron una review
// 13. Muestra las personas que hicieron una review, los rating que uso
como colección, el promedio de las calificaciones y el total de películas
que calificó
// 14. Muestra las personas que hicieron una review, los rating que uso
como colección, el promedio de las calificaciones y el total de películas
que calificó
// Añadimos un CASE
// 15. un ejemplo con WITH. Solo quiero los buenos evaluadores
// 16. Número de personas y número de películas utilizando UNION ALL y
UNION (quita duplicados)
// 17. Los tipos de relaciones que tiene el grafo
// 18. Cuantas relaciones de cada tipo hay





//29 enero

MATCH (start:Person), (end:Person)
WHERE start<>end
WITH start, end, shortestPath((start)-[*]-(end)) AS PATH
RETURN start.name, end.name, length(PATH) as Diametro
ORDER BY Diametro DESC
LIMIT 1


MATCH (start), (end)
WHERE start<>end
WITH start, end, shortestPath((start)-[*]-(end)) AS PATH
RETURN length(PATH) as Diametro
ORDER BY Diametro DESC
LIMIT 1

//consulta que muestre todos los nodos y las relaciones

MATCH (n)-[r]->(m)
RETURN n,r,m

CALL db.schema.visualization

//esquema, atributos, cantidad



//CLASE 8 FEBRERO//////////////////////////////////////////////////////////////////////////////////////////////////
//CENTRALIDAD
// Pagerank: importancia de un nodo, trabaja con grafos ditigidos y no dirigidos, heterogeneos y no heterogeneos

MATCH (v:Villian) RETURN v

//Muestra las etiquetas
//person y movie
call db.labels

//relaciones
call db.relationshipTypes

//atributos
call db.propertyKeys

//nodos y atributos en una tabla
call db.schema.nodeTypeProperties

//relaciones y atributos
call db.schema.relTypeProperties





//PAGERANK VILLANO: los nodos con mayor importancia
//1. crear un subgrafo
CALL gds.graph.project(
    'myGraph',
    'Villian',
    'COMPANION',
    {relationshipProperties: 'Weight'}

)

//2. calcular la memoria requerida
CALL gds.pageRank.write.estimate(
    'myGraph',
    {
        writeProperty: 'pageRank',
        maxIterations: 20,
        dampingFactor: 0.85 //BRINCA DE UNA RED A OTRA DE FORMA ALEATORIA
    }
)

YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

//3. ejecutar el algoritmo en turno
CALL gds.pageRank.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score
ORDER BY score DESC

//4. añadir un atributo nodos/relaciones con el valor del algoritmo
CALL gds.pageRank.write(
    'myGraph',
    {
        maxIterations: 20,
        dampingFactor: 0.85,
        writeProperty: 'pageRank'
    }
)
YIELD nodePropertiesWritten, ranIterations




//PAGERANK SUPERHERO
//1. crear un subgrafo
CALL gds.graph.project(
    'myGraph2',
    'SuperHero',
    'FRIEND_OF',
    {relationshipProperties: 'Weight'}

)

//2. calcular la memoria requerida
CALL gds.pageRank.write.estimate(
    'myGraph2',
    {
        writeProperty: 'pageRank',
        maxIterations: 20,
        dampingFactor: 0.85 //BRINCA DE UNA RED A OTRA DE FORMA ALEATORIA
    }
)

YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

//3. ejecutar el algoritmo en turno
CALL gds.pageRank.stream('myGraph2')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score
ORDER BY score DESC

//4. añadir un atributo nodos/relaciones con el valor del algoritmo
CALL gds.pageRank.write(
    'myGraph2',
    {
        maxIterations: 20,
        dampingFactor: 0.85,
        writeProperty: 'pageRank'
    }
)
YIELD nodePropertiesWritten, ranIterations




//CLASE 12 FEBRERO/////////////////////////////////////////////////////////////////////////////////////

//betweenness centrality
//mide la importancia de un nodo en un grafo mediante el número de caminos más cortos que pasan por él

//BETWEENNESS CENTRALITY VILLIAN: camino
//1. crear un subgrafo
CALL gds.graph.project(
    'myGraph',
    'Villian',
    'COMPANION',
    {relationshipProperties: 'Weight'} //peso de la relación

)

//2. calcular la memoria requerida
CALL gds.pageRank.write.estimate(
    'myGraph',
    {
        writeProperty: 'Weight'
    }
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

//3. ejecutar el algoritmo en turno
CALL gds.betweenness.stream('myGraph') // stream para ver los resultados
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score
ORDER BY score DESC, Name ASC



//4. añadir un atributo nodos/relaciones con el valor del algoritmo
CALL gds.betweenness.write(
    'myGraph',
    {
        writeProperty: 'betweenness' //nombre del atributo
    }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

MATCH (v:Villian) RETURN v.Name, v.betweenness, v.pageRank ORDER BY 


//BETWEENNESS CENTRALITY SUPERHERO
//1. crear un subgrafo
CALL gds.graph.project(
    'myGraph0',
    'SuperHero',
    'FRIEND_OF',
    {relationshipProperties: 'Weight'} //peso de la relación

)

//2. calcular la memoria requerida
CALL gds.pageRank.write.estimate(
    'myGraph0',
    {
        writeProperty: 'Weight'
    }
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

//3. ejecutar el algoritmo en turno
CALL gds.betweenness.stream('myGraph0') // stream para ver los resultados
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score
ORDER BY score DESC, Name ASC



//4. añadir un atributo nodos/relaciones con el valor del algoritmo
CALL gds.betweenness.write(
    'myGraph0',
    {
        writeProperty: 'betweenness' //nombre del atributo
    }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

//ponerlo en bloom como rule based

//DEGREE VILLIAN : vecinos inmediatos de un nodo

//1. crear un subgrafo

//IN_Degree
CALL gds.graph.project(
    'myINDegreeGraph',
    'Villian',
    {COMPANION:
        {orientation: 'REVERSE', Properties: 'Weight'}
    }
)

//OUT_Degree
CALL gds.graph.project(
    'myOUTDegreeGraph',
    'Villian',
    {COMPANION:
        {orientation: 'NATURAL', Properties: 'Weight'}
    }
)


//Degree
CALL gds.graph.project(
    'myDegreeGraph',
    'Villian',
    {COMPANION:
        {orientation: 'UNDIRECTED', Properties: 'Weight'}
    }
)

//4. añadir un atributo nodos/relaciones con el valor del algoritmo
//IN_Degree
CALL gds.degree.write(
    'myINDegreeGraph',
    {
        writeProperty: 'InDegree' 
        
    }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min, centralityDistribution.max, centralityDistribution.mean, nodePropertiesWritten

//OUT_Degree
CALL gds.degree.write(
    'myOUTDegreeGraph',
    {
        writeProperty: 'OutDegree' 
        
    }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min, centralityDistribution.max, centralityDistribution.mean, nodePropertiesWritten

//Degree
CALL gds.degree.write(
    'myDegreeGraph',
    {
        writeProperty: 'Degree' 
        
    }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min, centralityDistribution.max, centralityDistribution.mean, nodePropertiesWritten





//DEGREE SUPERHERO

//1. crear un subgrafo

//IN_Degree
CALL gds.graph.project(
    'myINDegreeGraph0',
    'SuperHero',
    {FRIEND_OF:
        {orientation: 'REVERSE', Properties: 'Weight'}
    }
)

//OUT_Degree
CALL gds.graph.project(
    'myOUTDegreeGraph0',
    'SuperHero',
    {FRIEND_OF:
        {orientation: 'NATURAL', Properties: 'Weight'}
    }
)


//Degree
CALL gds.graph.project(
    'myDegreeGraph0',
    'SuperHero',
    {FRIEND_OF:
        {orientation: 'UNDIRECTED', Properties: 'Weight'}
    }
)

//4. añadir un atributo nodos/relaciones con el valor del algoritmo
//IN_Degree
CALL gds.degree.write(
    'myINDegreeGraph0',
    {
        writeProperty: 'InDegree' 
        
    }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min, centralityDistribution.max, centralityDistribution.mean, nodePropertiesWritten

//OUT_Degree
CALL gds.degree.write(
    'myOUTDegreeGraph0',
    {
        writeProperty: 'OutDegree' 
        
    }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min, centralityDistribution.max, centralityDistribution.mean, nodePropertiesWritten

//Degree
CALL gds.degree.write(
    'myDegreeGraph0',
    {
        writeProperty: 'Degree' 
        
    }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min, centralityDistribution.max, centralityDistribution.mean, nodePropertiesWritten

//TABLA
MATCH (s:SuperHero) 
RETURN s.Name, s.Degree, s.InDegree, s.OutDegree 
ORDER BY s.Degree DESC, s.InDegree, s.OutDegree


//CLOSENESS CENTRALITY VILLIAN

//1. crear un subgrafo
CALL gds.graph.project('myClosenessGraph', 'Villian', 'COMPANION', {relationshipProperties: 'Weight'})

//2. calcular la memoria requerida




//CLASE 15 FEBRERO/////////////////////////////////////////////////////////////////////////////////////

//NEODASH!!
//consulta para el gráfico de barras 
MATCH(n)
RETURN labels(n) AS Nodes,
 COUNT (n) AS Total
ORDER BY Total DESC


//consulta subgrafo de villanos
MATCH (v:Villian)-[r:COMPANION]->(ov:Villian)
RETURN v,r,ov

//degree, cuantos villanos
MATCH (v:Villian)
RETURN v.Degree as degree, COUNT (DISTINCT v) AS cuantos_Villanos
ORDER BY degree DESC

//pagerank villian
MATCH (v:Villian)
RETURN v.pageRank as pagerank, COUNT (DISTINCT v) AS cuantos_Villanos
ORDER BY pagerank DESC

//betweenness villian
MATCH (v:Villian)
RETURN v.betweenness as betweenness, COUNT (DISTINCT v) AS cuantos_Villanos
ORDER BY betweenness DESC


MATCH (v:Villian)
WHERE v.Name = 'Lobo'
RETURN v.Name, v.pageRank, v.betweenness, v.Degree

//otra forma 
MATCH (v:Villian)
WHERE v.Name = $neodash_villian_name
RETURN v.Name, v.pageRank, v.betweenness, v.Degree




//SUPERHERO

//consulta de subgrafo de superheroes
MATCH (s:SuperHero)-[r:FRIEND_OF]->(os:SuperHero)
RETURN s,r,os

//DEGREE SUPERHERO
MATCH (s:SuperHero)
RETURN s.Degree as degree, COUNT (DISTINCT s) AS cuantos_SuperHero
ORDER BY degree DESC

//PAGERANK SUPERHERO
MATCH (s:SuperHero)
RETURN s.pageRank as pagerank, COUNT (DISTINCT s) AS cuantos_SuperHero
ORDER BY pagerank DESC

//BETWEENNESS SUPERHERO
MATCH (s:SuperHero)
RETURN s.betweenness as betweenness, COUNT (DISTINCT s) AS cuantos_SuperHero
ORDER BY betweenness DESC

MATCH (s:SuperHero)
WHERE s.Name = 'IronMan'
RETURN s.Name, s.pageRank, s.betweenness, s.Degree


MATCH (s:SuperHero)-[r:FRIEND_OF]->(s:SuperHero)
WHERE s.Name = 'Batman'
RETURN s, r


//CLASE 19 FEBRERO/////////////////////////////////////////////////////////////////////////////////////

// Para importar un archivo CSV a NEO4J utlizando cypher
//  Página de ayuda de NEO4J https://neo4j.com/developer/guide-import-csv/
//  Solo archivos CSV https://neo4j.com/docs/cypher-manual/current/clauses/load-csv/ 
//  Otra fuente de apoyo https://www.quackit.com/neo4j/tutorial/neo4j_import_data_from_csv_file_using_cypher.cfm 

//Paso 1. 
//Crea una base de datos local nueva

//Paso 2.
//Antes de iniciar la base de datos abre la carpeta import

//Paso 3.
//Pega los archivos CSV en la carpeta import

//Paso 4.
// Inicia la base de datos y abre el browser

//Paso 5. 
//Carga los datos de los nodos usando cypher     FB_Nodos_Toy.csv (nodos)    FB_Relaciones_Toy.csv (relaciones)
LOAD CSV WITH HEADERS FROM "file:///FB_Nodos_Toy.csv" AS row
CREATE (n:Pages)
SET n = row

//Paso 6.
//Crea un índice para cada nodo
CREATE INDEX index_Page FOR (n:Pages) ON (n.id);

//Crea un índice de búsqueda para bloom
CREATE INDEX index_PageType FOR (n:Pages) ON (n.page_type);


//Paso 7. 
//Carga los datos de las relaciones usando cypher     FB_Nodos_Toy.csv (nodos)    FB_Relaciones_Toy.csv (relaciones) (id_1,id_2)
LOAD CSV FROM "file:///FB_Relaciones_Toy.csv" AS row
MATCH (n:Pages), (m:Pages)
WHERE n.id=row[0] and m.id=row[1]
MERGE (n)-[:RELATED_TO]->(m)


//PRACTICA 1


//FINAL

LOAD CSV WITH HEADERS FROM "file:///nodos.csv" AS row
CREATE (a:Airports)
SET a = row

CREATE INDEX index_Airport FOR (a:Airports) ON (a.Id);

CREATE INDEX index_Label FOR (a:Airports) ON (a.Label);

LOAD CSV FROM "file:///enlaces.csv" AS row
MATCH (a:Airports), (b:Airports)
WHERE a.Id=row[0] and b.Id=row[1]
MERGE (a)-[:CONNECTED_TO]->(b)

//contar nodos 
MATCH (a:Airports)
RETURN COUNT (a)

//contar atributos
MATCH (a:Airports)
RETURN COUNT (a.Id)

//contar relaciones
MATCH (a:Airports)-[r:CONNECTED_TO]->(b:Airports)
RETURN COUNT (r)

CALL db.scehma.relTypeProperties


MATCH (start :Airports), (end:Airports)
WHERE start<>end
WITH start, end, shortestath((start)-[*]- (end)) AS PATH
RETURN start length(PATH) as Diametro
ORDER BY Diametro DESC
LIMIT 1

MATCH saltos = (a:Airports {Label: ""})-[*1]-(arround)
RETURN saltos

MATCH (a:Airports)-[r:CONNECTED_TO *1]->(b)
WHERE a.Label = $Name
RETURN a,r,b


//CLASE 26 DE FEBRERO/////////////////////////////////////////////////////////////////////////////////////

//1. crear un subgrafo
CALL gds.graph.project(
    'myGraph',
    'Villian', //nodo
    {COMPANION: //relación
        {orientation: 'UNDIRECTED', Properties: 'Weight'}
    }
)


//2. calcular la memoria requerida

//3. ejecutar el algoritmo en turno

//4. alterar la estructura del grafo
// añadir un atributo nodos/relaciones con el valor del algoritmo
CALL gds.louvain.write('myGraph', {writeProperty: 'communitylouvain'})
YIELD communityCount, modularity, modularities

//CONSULTA
MATCH (v:Villian)
RETURN v.communitylouvain, COUNT (v.Name), COLLECT (v.Name)
ORDER BY COUNT (v.Name) DESC



//SUPERHERO
//1. crear un subgrafo SUPERHERO
CALL gds.graph.project(
    'myGraphUndirected',
    'SuperHero', 
    {FRIEND_OF:
        {orientation: 'UNDIRECTED', Properties: 'Weight'}
    }
)

//4. alterar la estructura del grafo SUPERHERO

CALL gds.louvain.write('myGraphUndirected', {writeProperty: 'communitylouvain'})
YIELD communityCount, modularity, modularities

//CONSULTA
MATCH (s:SuperHero)
RETURN s.communitylouvain, COUNT (s.Name), COLLECT (s.Name)
ORDER BY COUNT (s.Name) DESC


//LabelPropagation
// use the LabelPropagation algorithm to detect communities in the subgraph of the graph myGraph.
CALL gds.labelPropagation.write('myGraph', {writeProperty: 'community_label'})
YIELD communityCount, ranIterations, didConverge 

CALL gds.labelPropagation.write('myGraphUndirected', {writeProperty: 'community2_label'})
YIELD communityCount, ranIterations, didConverge

// Query
MATCH (v:Villian)
RETURN v.community_label AS community, count(v.Name) AS amount, collect(v.Name) AS members
ORDER BY amount DESC

// Query
MATCH (s:SuperHero)
RETURN s.community2_label AS community, count(s.Name) AS amount, collect(s.Name) AS members
ORDER BY amount DESC


//WeaklyConnectedComponents
// use the WeaklyConnectedComponents algorithm to detect communities in the subgraph of the graph myGraph.
CALL gds.wcc.write('myGraph', {writeProperty: 'community_wcc'})
YIELD componentCount, componentDistribution

CALL gds.wcc.write('myGraphUndirected', {writeProperty: 'community2_wcc'})
YIELD componentCount, componentDistribution

// Query
MATCH (v:Villian)
RETURN v.community_wcc AS community, count(v.Name) AS amount, collect(v.Name) AS members
ORDER BY amount DESC

// Query
MATCH (s:SuperHero)
RETURN s.community2_wcc AS community, count(s.Name) AS amount, collect(s.Name) AS members
ORDER BY amount DESC

//KMEANS
// use the KMeans algorithm to detect communities in the subgraph of the graph myGraph.
//1. Crear un subgrafo

CALL gds.beta.kmeans.write('myGraph', {writeProperty: 'community_kmeans', k: 3})
YIELD writeProperty, writeRelationshipType, writeType, nodePropertiesWritten, ranIterations, didConverge

CALL gds.kmeans.stream(
  graphName: String,
  configuration: Map
)
YIELD
  nodeId: Integer,
  communityId: Integer,
  distanceFromCentroid: Float,
  silhouette: Float


//2 PREGUNTAS POR CADA ALGORITMMO



//pagerank, a un salto, mayor degree, mayor peso CENTRALIDAD
//WCC,SCC
//MEAN IN_DEGREE



//CLASE 1 ABRIL COMO ESTAN? Y YA NO TENGO COPILOT

:play northwind

// RUN

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

MATCH (s:Supplier)-->(:Product)-->(c:Category)
RETURN s.companyName as Company, collect(distinct c.categoryName) as Categories

MATCH (c:Category {categoryName:"Produce"})<--(:Product)<--(s:Supplier)
RETURN DISTINCT s.companyName as ProduceSuppliers

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


// Diagrama de la orden 10575
match(o:Order)-[r:ORDERS]->(p:Product)
where o.orderID = "10575"
return o,r,p


match(p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)
where p.productName = "Chai"
return p.productName,op.productName,count(o.orderID) as Tickets
order by Tickets desc
limit 4


WITH range(1,10) AS nums
UNWIND nums AS num
WITH sum(nums) as SUM
return SUM

MATCH (p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)
WITH p,op, COUNT (o.orderID) as qty
MERGE (p)-[:BUY_TOGETHER{quantity:qty}]->(op)


//NETFLIX

//crear nodos tipo profile
CREATE (p:Profile{id:1,name:"Juan"})
RETURN p

//crear nueva lista de favoritos del profile 1
MATCH (p:Profile{id:1}), (m:Movie{id:'s8769'})
MERGE (p)-[:ADD]->(m)

MATCH (p:Profile{id:1}), (m:Movie{id:'s626'})
MERGE (p)-[:ADD]->(m)

MATCH (p:Profile{id:1}), (m:Movie{id:'s2418'})
MERGE (p)-[:ADD]->(m)

//crear más perfiles
//ejecuta uno por linea

CREATE (p:Profile{id:2})
CREATE (p:Profile{id:3})
CREATE (p:Profile{id:4})
CREATE (p:Profile{id:5})


MATCH (m:Movie)
Where m.id = 's2418'
return m

MATCH (m:Movie)
Return COLLECT(m.id)


// CLASE 15 DE ABRIL///////////////////////////////////
//crear los nodos artículo

LOAD CSV WITH HEADERS FROM "file:///Articulo.csv" AS row
CREATE (n:Articulo)
SET n = row

//creo indie para los nodos tipo articulo en el campo id_articulo
CREATE INDEX FOR (n:Articulo) ON (n.id_articulo)

//crear los nodos tipo ArticuloGrupo
LOAD CSV WITH HEADERS FROM "file:///ArticuloGrupo.csv" AS row
CREATE (n:ArticuloGrupo)
SET n = row

CREATE INDEX index_ArticuloGrupo FOR (n:ArticuloGrupo) ON (n.id_articulogrupo)

//crear la relacion entre articulo y articulogrupo
MATCH (a:Articulo),(ag:ArticuloGrupo)
WHERE a.id_articulogrupo = ag.id_articulogrupo
MERGE (ag)-[:CONTIENE_GRUPOS_DE]->(a)


//proyecto 

