// Undirected
CALL gds.graph.project(
    'UndirectedGraph',
    'SuperHero',
    {FRIEND_OF:
    {
        orientation:'UNDIRECTED',
        Properties:'Weight'
    }
    }
)

// Directed
CALL gds.graph.project(
    'DirectedGraph',
    'SuperHero',
    {FRIEND_OF:
    {
        orientation:'NATURAL',
        Properties:'Weight'
    }
    }
)


// Hulk Undirected
MATCH (source:SuperHero{Name:'Hulk'})
CALL
gds.allShortestPaths.delta.write('UndirectedGraph',
{
    sourceNode: source,
    relationshipWeightProperty: 'Weight',
    writeRelationshipType: 'PATH_Hulk_Undirected',
writeNodeIds: true,
writeCosts: true
})

YIELD relationshipsWritten
RETURN relationshipsWritten


// Hulk Directed
MATCH (source:SuperHero{Name:'Hulk'})
CALL gds.allShortestPaths.delta.write('DirectedGraph',
{
    sourceNode: source,
    relationshipWeightProperty: 'Weight',
    writeRelationshipType: 'PATH_Hulk_Directed',
    writeNodeIds: true,
    writeCosts: true
})
YIELD relationshipsWritten
RETURN relationshipsWritten


// Crea la nueva relación
MATCH (source:SuperHero{Name:'Thor'}),
(target:SuperHero{Name:'Hulk'})
CALL
gds.shortestPath.dijkstra.write('UndirectedGraph',
{
    sourceNode: source,
    targetNode: target,
    relationshipWeightProperty: 'Weight',
    writeRelationshipType: 'PATH_Und_Thor_Hulk',
    writeNodeIds: true,
    writeCosts: true
})
YIELD relationshipsWritten
RETURN relationshipsWritten


//Directed
MATCH (source:SuperHero{Name:'Thor'}),
(target:SuperHero{Name:'Hulk'})
CALL
gds.shortestPath.dijkstra.write('DirectedGraph',
{
    sourceNode: source,
    targetNode: target,
    relationshipWeightProperty: 'Weight',
    writeRelationshipType: 'PATH_D_Thor_Hulk',
    writeNodeIds: true,
    writeCosts: true
})
YIELD relationshipsWritten
RETURN relationshipsWritten


//Random walk///////////////////

MATCH (s:SuperHero)
WHERE s.Name IN ['Thor', 'Iron Man']
WITH COLLECT(s) as sourceNodes
CALL {
  WITH sourceNodes
  CALL gds.randomWalk.stream(
    'DirectedGraph',
    {
      sourceNodes: sourceNodes,
      walkLength: 4,
      walksPerNode: 1,
      randomSeed: 42,
      concurrency: 1
    }
  )
  YIELD nodeIds, path
  RETURN nodeIds, path
}
RETURN nodeIds, path



