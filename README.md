# MongoDBScaling
Building blocks for replication/sharding of MongoDB to be used in distributed systems development + MongoDB Java client

Project includes:
- `mongodb-replicated/mongo-cluster-initialization.sh` - bash script to initialize Docker-based MongoDB cluster with replication factor = 3
- `mongodb-replicated/mongo-reader` - Java client for MongoDB to connect to Docker-based cluster
- `mongodb-sharded-replicated/mongo-cluster-initialization.sh` - bash script to initialize Docker-based MongoDB cluster with replication factor = 3 & 2 MongoDB shards
- `mongo-stop.sh` - bash script (utility) to kill & remove all containers that include `mongo` in their names
