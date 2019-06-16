#!/bin/bash
##Create a Mongo API Cosmos DB account, DB in it, collection################
az='/home/buntu/anaconda3/envs/env34/bin/az'
resourceGroupName='mongorg'
location='eastus'
name='lenamongodbdemo'  
databaseName='test-mongodb'
collectionName='mongodbcollection1'
originalThroughput=400 
newThroughput=700


echo "Creating a resource group..."
	$az group create --name $resourceGroupName --location $location >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "ERROR: Resource Group creation failed."
		exit 1
	fi
	$az group list | grep -i $resourceGroupName
echo "Success."
echo "_________________________________________________"
echo ""


echo "Creating a MongoDB API Cosmos DB account..."
	$az cosmosdb create \
	    --name $name \
	    --kind MongoDB \
	    --resource-group $resourceGroupName \
	    --max-interval 10 \
	    --max-staleness-prefix 200 >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "ERROR: Account creation failed. Check parameters."
		exit 1
	fi
	$az cosmosdb show --name $name --resource-group $resourceGroupName | grep provisioningState
echo "Success."
echo "_________________________________________________"
echo ""


echo "Creating a database in it..."
	$az cosmosdb database create \
	    --name $name \
	    --db-name $databaseName \
	    --resource-group $resourceGroupName >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "ERROR: Database creation failed."
		exit 1
	fi
	$az cosmosdb database show \
		--db-name $databaseName \
	    --name $name \
	    --resource-group-name $resourceGroupName \
	    | grep -w 'id' | awk '{print $2}'
echo "Success."
echo "_________________________________________________"
echo ""


echo "Creating a collection within the database..."
	$az cosmosdb collection create \
	    --collection-name $collectionName \
	    --name $name \
	    --db-name $databaseName \
	    --resource-group $resourceGroupName \
	    --throughput $originalThroughput >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "ERROR: Collection creation failed."
		exit 1
	fi
	$az cosmosdb collection show --collection-name $collectionName \
	        --db-name $databaseName \
	        --name $name \
	        --resource-group-name $resourceGroupName \
	        | grep -w 'id' | head -n1
echo "Success."
echo "_________________________________________________"
echo ""


echo "Updating this collection's throughput to a new value..."
	$az cosmosdb collection update \
	    --collection-name $collectionName \
	    --name $name \
	    --db-name $databaseName \
	    --resource-group $resourceGroupName \
	    --throughput $newThroughput >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "ERROR: Throughput update failed."
		exit 1
	fi
echo "Success."
echo "_________________________________________________"	
echo ""


#Get an Azure Cosmos DB connection string for MongoDB apps
echo "This MongoAPICosmosDBAccount connection string is: "
	$az cosmosdb list-connection-strings \
	    --name $name \
	    --resource-group $resourceGroupName | grep -w 'connectionString'
echo "_________________________________________________"
echo "Done."
echo ""
