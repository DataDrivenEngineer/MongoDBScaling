#!/bin/bash
echo "Begin initialization of mongo-configsvrs..."
docker-compose -f ./docker-compose-configsvr-init.yml up -d
sleep 5
echo "mongo-configsvrs initialized successfully"

echo "Begin execution of rs.initiate() for mongo-configsvr1..." 
docker exec mongo-configsvr1 mongo --port 27020 --eval "

rs.initiate(
  {
    _id : 'config-rs',
    configsvr: true,
    members: [
      { _id : 0, host : \"mongo-configsvr1:27020\" },
      { _id : 1, host : \"mongo-configsvr2:27021\" },
      { _id : 2, host : \"mongo-configsvr3:27022\"}
    ]
  }
)
"
echo "Execution of rs.initiate() completed"

echo "Starting docker-compose for mongo-shardsvrs and mongo-router..."
docker-compose up -d
sleep 20
echo "mongo-shardsvrs and mongo-router containers launched successfully"

echo "Begin adding shards to mongo-router..."
docker exec mongo-router mongo --port 27023 --eval "

// Adding shards to the cluster
sh.addShard(\"mongo-shardsvr1:27017\");
sh.addShard(\"mongo-shardsvr2:27018\");

// Changing chunk size primarily for testing purposes. Feel free to remove it in production
db.getSiblingDB('config').settings.save( { _id : 'chunksize', value : 1 } );

// Adding test data
db.getSiblingDB('videodb');

sh.enableSharding('videodb');

db.getSiblingDB('videodb').movies.insertOne( { 'name': 'Pulp Fiction', 'directors': ['Quentin Tarantino'], 'year': 1994, 'cast': ['Amanda Plummer', 'Samuel L. Jackson', 'Bruce Willis', 'John Travolta', 'Uma Thurman'], 'rating': 10.0 } );

db.getSiblingDB('videodb').movies.insertOne( { 'name': 'Moana', 'directors': ['Ron Clements', 'John Musker', 'Don Hall', 'Chris Williams'], 'year': 2016, 'cast': ['Auli\'iwayne Johnson', 'Rachel House', 'Temuera Morrison', 'Jemaine Clement', 'Nicole Scherzinger', 'Alan Tudyk', 'Oscar Kightley', 'Troy Polamalu', 'Puanani Cravalho'], 'rating': 9.9 } );

db.getSiblingDB('videodb').movies.createIndex( { name: 1 } );

sh.shardCollection('videodb.movies', { name: 1 } );
"

echo "Shards added successfully"
echo "All operations completed successfully"

