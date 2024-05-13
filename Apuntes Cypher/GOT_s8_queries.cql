// pregunta 1.1
MATCH (c1)-[r]-(c2)
RETURN c1.label AS Character, COUNT(r) AS InteractionCount
ORDER BY InteractionCount DESC
LIMIT 1

// pregunta 1.2
MATCH (c1)-[r]-(c2)
RETURN c1.label AS Character, COUNT(r) AS InteractionCount
ORDER BY InteractionCount DESC
LIMIT 10

//pregunta 1.3
MATCH (n)-[r]->()
RETURN COUNT(r)

//pregunta 1.4
MATCH ()-[r]->()
WITH COUNT(r) AS relaciones
MATCH (n)
WITH TOFLOAT(relaciones) AS relaciones, COUNT(n) AS nodos
RETURN relaciones / nodos AS average_relationships_per_node

//pregunta 1.5
MATCH (n)
RETURN COUNT(n)

//pregunta 1.6
MATCH (:Character {label: "Daenerys"})-[*1]-(connected)
RETURN *

//pregunta 1.7
MATCH (n)-[r]->()
WITH n, sum(r.weight) AS weightSum
ORDER BY weightSum DESC
LIMIT 1
RETURN n, weightSum


// pregunta 1.8
MATCH (n)-[]->(m)
WITH n, count(m) as interactions
WHERE interactions = 1
RETURN count(n) as loners

// pregunta 1.9
MATCH ()-[r]-()
WITH COUNT(r) AS totalInteractions

MATCH (c)
WITH totalInteractions, COUNT(DISTINCT c) AS totalNodes

RETURN totalInteractions / toFloat(totalNodes) AS AvgConnectedNodes

//pregunta 1.10
MATCH (:Character {label: "Sam"})-[*1]-(connected)
RETURN *

//pregunta 1.11
MATCH (:Character {label: $label})-[*2]-(connected)
RETURN *

//PREGUNTA 1.12
MATCH (c1)-[r]-(c2)
RETURN c1.label AS Character, COUNT(r) AS InteractionCount
ORDER BY InteractionCount DESC

//PREGUNTA 1.13
MATCH (c1)-[r]-(c2)
RETURN c1.label AS Character, COUNT(r) AS InteractionCount
ORDER BY InteractionCount DESC
LIMIT 5

//pregunta 1.14
MATCH (:Character {label: $label})-[*1]-(connected)
RETURN *


//pregunta 1.15
MATCH (n)-[r]->()
WITH n, sum(r.weight) AS weightSum
ORDER BY weightSum DESC
LIMIT 5
RETURN n, weightSum

////////////centrality

Call gds.graph.project(
    "Grafito",
    "Characters",
    "RELATED",
    {relationshipProperties:toInteger('weight')}
)
//indegree
CALL gds.graph.project(
    'GrafitoInDegree',
    'Characters',
    {RELATED:
        {
            Orientation:'REVERSE',
            Properties: 'weight'
        }
    }
)

CALL gds.degree.write('GrafitoInDegree',
    {writeProperty:'InDegree'}
)
YIELD centralityDistribution, nodePropertiesWritten

RETURN centralityDistribution.min, 
       centralityDistribution.max,
       centralityDistribution.mean,
nodePropertiesWritten 


//outdegree
CALL gds.graph.project(
    'GrafitoOutDegree',
    'Characters',
    {RELATED:
        {
            Orientation:'NATURAL',
            Properties: 'weight'
        }
    }
)




CALL gds.degree.write('GrafitoOutDegree',
    {writeProperty:'OutDegree'}
)
YIELD centralityDistribution, nodePropertiesWritten

RETURN centralityDistribution.min, 
       centralityDistribution.max,
       centralityDistribution.mean,
nodePropertiesWritten 



///// DEGREE
CALL gds.graph.project(
    'GrafitoDegree',
    'Characters',
    {RELATED:
        {
            Orientation:'UNDIRECTED',
            Properties: 'weight'
        }
    }
)

CALL gds.degree.write('GrafitoDegree',
    {writeProperty:'Degree'}
)
YIELD centralityDistribution, nodePropertiesWritten

RETURN centralityDistribution.min, 
       centralityDistribution.max,
       centralityDistribution.mean,
nodePropertiesWritten 



// closeness
/// CREAR EL SUBGRAFO
CALL gds.graph.project(
    "grafitocloss",
    "Characters",
    "RELATED",
    {relationshipProperties:'weight'}
)

CALL gds.closeness.stream("grafitocloss")
YIELD nodeId, score
RETURN nodeId, score
ORDER BY score DESC;

// page rank
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


// Betweenness
CALL gds.betweenness.stream('Grafito')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Id as Name, score
ORDER BY score DESC, Name ASC


CALL gds.betweenness.write('Grafito',{writeProperty: 'betweenness'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

//////////////////////// Community

////////// LOUVAIN
CALL gds.louvain.write('Grafito', {writeProperty:'communitylouvain'})
YIELD communityCount, modularity, modularities
// 4 comunidades

// Conteo de comunidades
MATCH(n:Characters)
RETURN COUNT(DISTINCT(n.communitylouvain)), COLLECT(DISTINCT(n.communitylouvain))

//ordenamiento
MATCH(n:Pages)
RETURN n.communitylouvain, COUNT(n.page_name), COLLECT(n.page_name)
ORDER BY COUNT(n.page_name) DESC

////////// LABEL PROPAGATION

CALL gds.labelPropagation.write('Grafito', {writeProperty:
'communityLabelPropagation'})
YIELD communityCount, ranIterations
// 11 COMUNIDADES 

MATCH(p:Page)
RETURN p.communityLabelPropagation as community, count(p.page_name) as conteo, COLLECT(p.page_name)
ORDER BY conteo DESC

////////// k1 - coloring
CALL gds.k1coloring.write('Grafito', {writeProperty:'communitk1'})
YIELD nodeCount, colorCount
// 10 colores

MATCH(n:Pages)
RETURN COUNT(DISTINCT(n.communitk1)), COLLECT(DISTINCT(n.communitk1))

////////// weakly connected components
CALL gds.wcc.write('Grafito', {writeProperty:'communitywcc'})
YIELD nodePropertiesWritten, componentCount
// 2 componentes

MATCH(n:Pages)
RETURN COUNT(DISTINCT(n.communitywcc)), COLLECT(DISTINCT(n.communitywcc))

MATCH(n:Pages)
RETURN n.communitywcc, COUNT(n.page_name), COLLECT(n.page_name)
ORDER BY COUNT(n.page_name) DESC

//////////strongly connected component
CALL gds.scc.write('Grafito', {writeProperty:'communityscc'})
YIELD nodePropertiesWritten, componentCount
//74 componentes???
MATCH(n:Pages)
RETURN COUNT(DISTINCT(n.communityscc)), COLLECT(DISTINCT(n.communityscc))

MATCH(n:Pages)
RETURN n.communityscc, COUNT(n.page_name), COLLECT(n.page_name)
ORDER BY COUNT(n.page_name) DESC



bin\neo4j-admin dump --verbose --database=GOTs8 --to=C:\Users\dosju\Downloads\dumpistis

neo4j-admin dump --database=GOTs8 --to=C:\Users\dosju\Downloads\dumpistis


cypher-shell -u <neo4j> -p <KEANUREEVES> -d <GOTs8> "MATCH (n) RETURN n;" > output.csv
